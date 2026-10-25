// Pure logic for the monitor Worker: uptime state transitions and email rendering.
// Kept free of Worker APIs so it runs under `node --test`.

/** Consecutive failed checks before the site is declared down. One blip is not an outage. */
export const FAILURES_BEFORE_DOWN = 2;

/** @typedef {{ status: 'up' | 'down', since: string, failures: number, firstFailureAt: string | null, lastError: string | null }} UptimeState */

/** @returns {UptimeState} */
export function initialState(now) {
  return { status: 'up', since: now, failures: 0, firstFailureAt: null, lastError: null };
}

/**
 * Applies one check result to the state.
 * Returns the next state and, when the site changed between up and down, the alert to send.
 *
 * @param {UptimeState} state
 * @param {{ ok: boolean, error?: string }} result
 * @param {string} now ISO timestamp
 * @returns {{ state: UptimeState, alert: null | { kind: 'down', since: string, error: string } | { kind: 'up', downSince: string, downtimeMs: number } }}
 */
export function applyCheck(state, result, now) {
  if (result.ok) {
    if (state.status === 'down') {
      return {
        state: initialState(now),
        alert: { kind: 'up', downSince: state.since, downtimeMs: Date.parse(now) - Date.parse(state.since) },
      };
    }
    return { state: { ...state, failures: 0, firstFailureAt: null, lastError: null }, alert: null };
  }

  const failures = state.failures + 1;
  const firstFailureAt = state.firstFailureAt ?? now;
  const error = result.error ?? 'Unknown error';
  if (state.status === 'up' && failures >= FAILURES_BEFORE_DOWN) {
    return {
      state: { status: 'down', since: firstFailureAt, failures, firstFailureAt, lastError: error },
      alert: { kind: 'down', since: firstFailureAt, error },
    };
  }
  return { state: { ...state, failures, firstFailureAt, lastError: error }, alert: null };
}

/** True when persisting [next] would change what is stored. Avoids a KV write on every healthy check. */
export function stateChanged(previous, next) {
  return JSON.stringify(previous) !== JSON.stringify(next);
}

export function formatDuration(ms) {
  const minutes = Math.max(1, Math.round(ms / 60000));
  if (minutes < 60) return `${minutes} min`;
  const hours = Math.floor(minutes / 60);
  const rest = minutes % 60;
  if (hours < 24) return rest ? `${hours} h ${rest} min` : `${hours} h`;
  const days = Math.floor(hours / 24);
  return `${days} d ${hours % 24} h`;
}

/** Formats an ISO timestamp in the site's time zone, e.g. "25 Oct 2026, 17:05". */
export function formatTime(iso, timeZone) {
  return new Intl.DateTimeFormat('en-GB', {
    timeZone, day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', hourCycle: 'h23',
  }).format(new Date(iso));
}

function formatDay(isoDate) {
  return new Intl.DateTimeFormat('en-GB', { timeZone: 'UTC', day: 'numeric', month: 'short' }).format(new Date(`${isoDate}T00:00:00Z`));
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
}

/** "+20%", "-5%", "no change" or "new" compared with the previous value. */
export function change(current, previous) {
  if (previous === 0) return current === 0 ? 'no change' : 'new';
  const pct = Math.round(((current - previous) / previous) * 100);
  if (pct === 0) return 'no change';
  return `${pct > 0 ? '+' : ''}${pct}%`;
}

/** Renders an outage or recovery email. */
export function renderAlert(alert, { siteUrl, timeZone }) {
  if (alert.kind === 'down') {
    const since = formatTime(alert.since, timeZone);
    const subject = `${hostOf(siteUrl)} is down`;
    const text = [
      `${siteUrl} has failed every check since ${since}.`,
      `Last error: ${alert.error}`,
      '',
      'You will get another email when it is back.',
    ].join('\n');
    const html = layout(subject, `
      <p style="margin:0 0 12px">${link(siteUrl)} has failed every check since <strong>${escapeHtml(since)}</strong>.</p>
      <p style="margin:0 0 12px;color:#57606a">Last error: ${escapeHtml(alert.error)}</p>
      <p style="margin:0;color:#57606a">You will get another email when it is back.</p>`);
    return { subject, text, html };
  }

  const duration = formatDuration(alert.downtimeMs);
  const subject = `${hostOf(siteUrl)} is back up after ${duration}`;
  const text = `${siteUrl} is responding again. It was down for ${duration}, since ${formatTime(alert.downSince, timeZone)}.`;
  const html = layout(subject, `
    <p style="margin:0">${link(siteUrl)} is responding again. It was down for <strong>${escapeHtml(duration)}</strong>, since ${escapeHtml(formatTime(alert.downSince, timeZone))}.</p>`);
  return { subject, text, html };
}

/**
 * Renders the weekly summary from the site's /stats.json.
 *
 * @param {any} stats Parsed /stats.json
 * @param {{ siteUrl: string, timeZone: string, uptime: UptimeState }} context
 */
export function renderSummary(stats, { siteUrl, timeZone, uptime }) {
  const { week, previousWeek } = stats;
  const range = `${formatDay(week.from)} to ${formatDay(week.to)}`;
  const rate = week.site === 0 ? 0 : Math.round((week.resume * 100) / week.site);
  const sources = week.sources.slice(0, 5);
  const links = stats.links.filter((l) => l.lastOpened.slice(0, 10) >= week.from);
  const status = uptime.status === 'up'
    ? `Up since ${formatTime(uptime.since, timeZone)}`
    : `Down since ${formatTime(uptime.since, timeZone)}`;

  const subject = `${hostOf(siteUrl)} this week: ${plural(week.site, 'visitor')}, ${plural(week.resume, 'CV open')}`;
  // Visits recorded before source tracking started have no source, so an empty list can mean "not tracked yet".
  const noSources = week.site === 0
    ? 'No visits this week.'
    : stats.sourcesSince
      ? `No sources recorded this week. Sources are tracked from ${stats.sourcesSince}.`
      : 'No sources recorded yet. Tracking starts with the next visit.';

  const text = [
    `${hostOf(siteUrl)}, ${range}`,
    '',
    `Visitors: ${week.site} (${change(week.site, previousWeek.site)} on the week before)`,
    `CV opens: ${week.resume} (${change(week.resume, previousWeek.resume)})`,
    `CV rate: ${rate}%`,
    `Site: ${status}`,
    '',
    'Top sources',
    ...(sources.length ? sources.map((s) => `  ${s.name}: ${plural(s.site, 'visitor')}, ${plural(s.resume, 'CV open')}`) : [`  ${noSources}`]),
    '',
    'Résumé links opened this week',
    ...(links.length ? links.map((l) => `  /r/${l.name}: last opened ${l.lastOpenedLabel}, ${plural(l.opens, 'open')} in total`) : ['  None.']),
    '',
    `Full dashboard: ${siteUrl}/stats`,
  ].join('\n');

  const cell = 'padding:10px 0;border-top:1px solid #eaeef2';
  const stat = (label, value, note) => `<tr>
      <td style="${cell};color:#57606a;width:96px">${label}</td>
      <td style="${cell};font-size:20px;font-weight:700;padding-left:8px">${value}</td>
      <td style="${cell};text-align:right;color:#57606a;font-size:13px;white-space:nowrap;padding-left:16px">${note}</td>
    </tr>`;
  const row = (cells) => `<tr>${cells.map((c, i) => `<td style="padding:8px 0;border-top:1px solid #eaeef2;${i ? 'text-align:right;white-space:nowrap;padding-left:16px' : 'word-break:break-word'}">${c}</td>`).join('')}</tr>`;
  const head = (cells) => `<tr>${cells.map((c, i) => `<th style="padding:0 0 8px;font-size:12px;color:#57606a;font-weight:600;text-transform:uppercase;letter-spacing:.06em;text-align:${i ? 'right' : 'left'};${i ? 'padding-left:16px' : ''}">${c}</th>`).join('')}</tr>`;

  const html = layout(subject, `
    <p style="margin:0 0 16px;color:#57606a">${escapeHtml(range)} · ${escapeHtml(status)}</p>
    <table role="presentation" style="width:100%;border-collapse:collapse;font-size:14px">
      ${stat('Visitors', week.site, `${escapeHtml(change(week.site, previousWeek.site))} vs last week`)}
      ${stat('CV opens', week.resume, `${escapeHtml(change(week.resume, previousWeek.resume))} vs last week`)}
      ${stat('CV rate', `${rate}%`, 'of visitors')}
    </table>
    <h2 style="font-size:14px;margin:24px 0 8px">Top sources</h2>
    ${sources.length
      ? `<table role="presentation" style="width:100%;border-collapse:collapse;font-size:14px">${head(['Source', 'Visitors', 'CV'])}${sources.map((s) => row([escapeHtml(s.name), s.site, s.resume])).join('')}</table>`
      : `<p style="margin:0;color:#57606a">${escapeHtml(noSources)}</p>`}
    <h2 style="font-size:14px;margin:24px 0 8px">Résumé links opened this week</h2>
    ${links.length
      ? `<table role="presentation" style="width:100%;border-collapse:collapse;font-size:14px">${head(['Link', 'Last opened', 'Opens'])}${links.map((l) => row([`/r/${escapeHtml(l.name)}`, escapeHtml(l.lastOpenedLabel), l.opens])).join('')}</table>`
      : '<p style="margin:0;color:#57606a">None.</p>'}
    <p style="margin:24px 0 0"><a href="${escapeHtml(siteUrl)}/stats" style="color:#0969da">Open the full dashboard</a></p>`);

  return { subject, text, html };
}

function plural(n, word) {
  return `${n} ${word}${n === 1 ? '' : 's'}`;
}

function hostOf(url) {
  return new URL(url).host;
}

function link(url) {
  return `<a href="${escapeHtml(url)}" style="color:#0969da">${escapeHtml(hostOf(url))}</a>`;
}

function layout(title, body) {
  return `<!doctype html><html><head><meta charset="utf-8"><title>${escapeHtml(title)}</title></head>
<body style="margin:0;padding:16px 12px;background:#f6f8fa;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;color:#1f2328">
  <div style="max-width:560px;margin:0 auto;background:#ffffff;border:1px solid #d0d7de;border-radius:8px;padding:20px">
    <h1 style="font-size:18px;margin:0 0 12px">${escapeHtml(title)}</h1>
    ${body}
  </div>
</body></html>`;
}
