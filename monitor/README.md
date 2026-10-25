# phpduy.dev monitor

A Cloudflare Worker that watches the site and emails the owner.

- Every 5 minutes it requests `/` and `HEAD /resume`.
  After two failed checks in a row it emails that the site is down, and it emails again when the site recovers.
- Every Monday at 01:00 UTC (08:00 in Vietnam) it emails a summary of `/stats.json`: visitors, CV opens, top sources and the résumé links opened that week.

Mail goes through Cloudflare Email Routing to its verified destination address, which is free on every plan.
The `send_email` binding only allows that address.

## Develop

```bash
node --test test/            # unit tests, no dependencies
npx wrangler dev --test-scheduled
curl "http://localhost:8787/__scheduled?cron=*/5+*+*+*+*"
```

Put local secrets in `.dev.vars`, quoting each value because a `#` starts a comment:

```
STATS_USER="..."
STATS_PASSWORD="..."
TRIGGER_TOKEN="..."
```

Local runs write emails to `.wrangler/tmp/email` instead of sending them.

## Deploy

```bash
npx wrangler login
npx wrangler deploy
npx wrangler secret put STATS_USER
npx wrangler secret put STATS_PASSWORD
npx wrangler secret put TRIGGER_TOKEN
```

## Run now

```bash
curl -X POST -H "Authorization: Bearer $TRIGGER_TOKEN" https://phpduy-monitor.phuocduypham2502.workers.dev/run/check
curl -X POST -H "Authorization: Bearer $TRIGGER_TOKEN" https://phpduy-monitor.phuocduypham2502.workers.dev/run/summary
```

Any other request gets a 404.
