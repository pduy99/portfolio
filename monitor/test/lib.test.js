import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  applyCheck, change, FAILURES_BEFORE_DOWN, formatDuration, initialState, renderAlert, renderSummary, stateChanged,
} from '../src/lib.js';

const T0 = '2026-10-25T10:00:00.000Z';
const at = (minutes) => new Date(Date.parse(T0) + minutes * 60000).toISOString();
const ctx = { siteUrl: 'https://phpduy.dev', timeZone: 'Asia/Ho_Chi_Minh' };
const fail = { ok: false, error: 'GET / returned 502' };

test('a healthy site stays up without alerts or state changes', () => {
  const state = initialState(T0);
  const { state: next, alert } = applyCheck(state, { ok: true }, at(5));
  assert.equal(alert, null);
  assert.equal(stateChanged(state, next), false);
});

test('one failed check is not an outage', () => {
  const { state, alert } = applyCheck(initialState(T0), fail, at(5));
  assert.equal(alert, null);
  assert.equal(state.status, 'up');
  assert.equal(state.failures, 1);
});

test('a blip followed by success resets the failure count', () => {
  let { state } = applyCheck(initialState(T0), fail, at(5));
  ({ state } = applyCheck(state, { ok: true }, at(10)));
  ({ state } = applyCheck(state, fail, at(15)));
  assert.equal(state.status, 'up');
  assert.equal(state.failures, 1);
});

test('consecutive failures declare the site down once, dated from the first failure', () => {
  let state = initialState(T0);
  const alerts = [];
  for (let i = 1; i <= FAILURES_BEFORE_DOWN + 2; i++) {
    const r = applyCheck(state, fail, at(5 * i));
    state = r.state;
    if (r.alert) alerts.push(r.alert);
  }
  assert.deepEqual(alerts, [{ kind: 'down', since: at(5), error: fail.error }]);
  assert.equal(state.status, 'down');
  assert.equal(state.since, at(5));
});

test('recovery alerts with the downtime and resets the state', () => {
  let state = initialState(T0);
  for (let i = 1; i <= FAILURES_BEFORE_DOWN; i++) state = applyCheck(state, fail, at(5 * i)).state;
  const { state: next, alert } = applyCheck(state, { ok: true }, at(65));
  assert.deepEqual(alert, { kind: 'up', downSince: at(5), downtimeMs: 60 * 60000 });
  assert.deepEqual(next, initialState(at(65)));
});

test('durations read naturally', () => {
  assert.equal(formatDuration(20 * 1000), '1 min');
  assert.equal(formatDuration(42 * 60000), '42 min');
  assert.equal(formatDuration(60 * 60000), '1 h');
  assert.equal(formatDuration(95 * 60000), '1 h 35 min');
  assert.equal(formatDuration(50 * 3600000), '2 d 2 h');
});

test('week-on-week change', () => {
  assert.equal(change(12, 10), '+20%');
  assert.equal(change(5, 10), '-50%');
  assert.equal(change(10, 10), 'no change');
  assert.equal(change(3, 0), 'new');
  assert.equal(change(0, 0), 'no change');
});

test('down and recovery emails name the site, time and error in the local zone', () => {
  const down = renderAlert({ kind: 'down', since: T0, error: 'GET / returned <502>' }, ctx);
  assert.equal(down.subject, 'phpduy.dev is down');
  assert.match(down.text, /since 25 Oct 2026, 17:00/);
  assert.match(down.text, /GET \/ returned <502>/);
  assert.match(down.html, /GET \/ returned &lt;502&gt;/, 'error text is escaped in HTML');

  const up = renderAlert({ kind: 'up', downSince: T0, downtimeMs: 35 * 60000 }, ctx);
  assert.equal(up.subject, 'phpduy.dev is back up after 35 min');
});

const stats = {
  week: {
    from: '2026-10-19', to: '2026-10-25', site: 170, resume: 14,
    sources: [
      { name: 'linkedin.com', site: 80, resume: 9 }, { name: 'google', site: 40, resume: 2 },
      { name: 'direct', site: 30, resume: 2 }, { name: 'github.com', site: 10, resume: 1 },
      { name: 'x.com', site: 6, resume: 0 }, { name: '<b>evil</b>', site: 4, resume: 0 },
    ],
  },
  previousWeek: { from: '2026-10-12', to: '2026-10-18', site: 100, resume: 14, sources: [] },
  links: [
    { name: 'grab', opens: 3, firstOpened: '2026-10-20T09:00:00', lastOpened: '2026-10-24T18:02:00', lastOpenedLabel: '24 Oct 2026, 18:02' },
    { name: 'old-co', opens: 1, firstOpened: '2026-09-01T09:00:00', lastOpened: '2026-09-01T09:00:00', lastOpenedLabel: '1 Sep 2026, 09:00' },
  ],
};

test('weekly summary reports the week, change, top five sources and this week\'s links', () => {
  const email = renderSummary(stats, { ...ctx, uptime: initialState(T0) });
  assert.equal(email.subject, 'phpduy.dev this week: 170 visitors, 14 CV opens');
  assert.match(email.text, /19 Oct to 25 Oct/);
  assert.match(email.text, /Visitors: 170 \(\+70% on the week before\)/);
  assert.match(email.text, /CV opens: 14 \(no change\)/);
  assert.match(email.text, /CV rate: 8%/);
  assert.match(email.text, /Up since 25 Oct 2026, 17:00/);
  assert.match(email.text, /linkedin\.com: 80 visitors, 9 CV opens/);
  assert.doesNotMatch(email.text, /evil/, 'only the top five sources');
  assert.match(email.text, /\/r\/grab: last opened 24 Oct 2026, 18:02, 3 opens in total/);
  assert.doesNotMatch(email.text, /old-co/, 'links not opened this week are left out');
  assert.match(email.html, /https:\/\/phpduy\.dev\/stats/);
});

test('weekly summary escapes source names and handles an empty week', () => {
  const tricky = { ...stats, week: { ...stats.week, sources: [{ name: '<b>evil</b>', site: 1, resume: 0 }] } };
  assert.match(renderSummary(tricky, { ...ctx, uptime: initialState(T0) }).html, /&lt;b&gt;evil&lt;\/b&gt;/);

  const empty = {
    week: { from: '2026-10-19', to: '2026-10-25', site: 0, resume: 0, sources: [] },
    previousWeek: { from: '2026-10-12', to: '2026-10-18', site: 0, resume: 0, sources: [] },
    links: [],
  };
  const email = renderSummary(empty, { ...ctx, uptime: { ...initialState(T0), status: 'down' } });
  assert.equal(email.subject, 'phpduy.dev this week: 0 visitors, 0 CV opens');
  assert.match(email.text, /No visits this week/);

  const untracked = { ...stats, sourcesSince: '25 Oct 2026', week: { ...stats.week, sources: [] } };
  assert.match(
    renderSummary(untracked, { ...ctx, uptime: initialState(T0) }).text,
    /No sources recorded this week\. Sources are tracked from 25 Oct 2026\./,
    'visits without sources are explained, not reported as no visits'
  );
  assert.match(email.text, /Down since/);
  assert.match(email.text, /CV rate: 0%/);
});
