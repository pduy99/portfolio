// Monitors phpduy.dev: an uptime check every 5 minutes with an email when the site goes down
// or comes back, and a weekly email summarising /stats.
import { applyCheck, initialState, renderAlert, renderSummary, stateChanged } from './lib.js';

const STATE_KEY = 'uptime';
const CHECK_CRON = '*/5 * * * *';
const SUMMARY_CRON = '0 1 * * MON';
const TIMEOUT_MS = 15000;
// Contains "uptime" and "monitor", which the site's visitor counter treats as a crawler.
const USER_AGENT = 'phpduy-uptime-monitor/1.0';

export default {
  async scheduled(controller, env, ctx) {
    if (controller.cron === SUMMARY_CRON) {
      await sendSummary(env);
    } else if (controller.cron === CHECK_CRON) {
      await runCheck(env);
    } else {
      console.error(`Unexpected cron "${controller.cron}"`);
    }
  },

  /**
   * Manual runs for testing, behind a bearer token: POST /run/check or POST /run/summary.
   * Everything else is 404 so the workers.dev URL reveals nothing.
   */
  async fetch(request, env) {
    const url = new URL(request.url);
    const task = { '/run/check': runCheck, '/run/summary': sendSummary }[url.pathname];
    if (!task || request.method !== 'POST' || !(await authorized(request, env))) {
      return new Response('Not found', { status: 404 });
    }
    return Response.json(await task(env));
  },
};

async function authorized(request, env) {
  const header = request.headers.get('Authorization') ?? '';
  const expected = `Bearer ${env.TRIGGER_TOKEN ?? ''}`;
  if (!env.TRIGGER_TOKEN || header.length !== expected.length) return false;
  const encoder = new TextEncoder();
  return crypto.subtle.timingSafeEqual(encoder.encode(header), encoder.encode(expected));
}

/** Both the page and the résumé must answer 200. */
async function probe(siteUrl) {
  const targets = [
    { path: '/', method: 'GET', expectType: 'text/html' },
    { path: '/resume', method: 'HEAD', expectType: 'application/pdf' },
  ];
  const errors = [];
  for (const { path, method, expectType } of targets) {
    try {
      const response = await fetch(siteUrl + path, {
        method,
        headers: { 'User-Agent': USER_AGENT, 'Cache-Control': 'no-cache' },
        redirect: 'manual',
        signal: AbortSignal.timeout(TIMEOUT_MS),
      });
      const type = response.headers.get('Content-Type') ?? '';
      if (response.status !== 200) errors.push(`${method} ${path} returned ${response.status}`);
      else if (!type.startsWith(expectType)) errors.push(`${method} ${path} returned ${type || 'no content type'}`);
      if (method === 'GET') await response.body?.cancel();
    } catch (error) {
      errors.push(`${method} ${path} failed: ${error.name === 'TimeoutError' ? `no answer within ${TIMEOUT_MS / 1000} s` : error.message}`);
    }
  }
  return errors.length ? { ok: false, error: errors.join('; ') } : { ok: true };
}

async function loadState(env, now) {
  return (await env.STATE.get(STATE_KEY, 'json')) ?? initialState(now);
}

async function runCheck(env) {
  const now = new Date().toISOString();
  const previous = await loadState(env, now);
  const result = await probe(env.SITE_URL);
  const { state, alert } = applyCheck(previous, result, now);

  if (alert) await send(env, renderAlert(alert, context(env)));
  if (stateChanged(previous, state)) await env.STATE.put(STATE_KEY, JSON.stringify(state));
  if (!result.ok) console.warn(`Check failed (${state.failures} in a row): ${result.error}`);
  return { result, state, alert: alert?.kind ?? null };
}

async function sendSummary(env) {
  const response = await fetch(`${env.SITE_URL}/stats.json`, {
    headers: {
      'User-Agent': USER_AGENT,
      Authorization: `Basic ${btoa(`${env.STATS_USER}:${env.STATS_PASSWORD}`)}`,
    },
    signal: AbortSignal.timeout(TIMEOUT_MS),
  });
  if (!response.ok) throw new Error(`/stats.json returned ${response.status}`);
  const stats = await response.json();
  const uptime = await loadState(env, new Date().toISOString());
  const email = renderSummary(stats, { ...context(env), uptime });
  const messageId = await send(env, email);
  return { sent: email.subject, messageId };
}

function context(env) {
  return { siteUrl: env.SITE_URL, timeZone: env.TIME_ZONE };
}

async function send(env, { subject, text, html }) {
  try {
    const { messageId } = await env.EMAIL.send({
      from: { email: env.FROM_EMAIL, name: 'phpduy.dev monitor' },
      to: env.TO_EMAIL,
      subject,
      text,
      html,
    });
    return messageId;
  } catch (error) {
    console.error(`Email "${subject}" failed: ${error.code ?? ''} ${error.message}`);
    throw error;
  }
}
