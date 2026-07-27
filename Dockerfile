# syntax=docker/dockerfile:1.4
FROM joseluisq/static-web-server:2
COPY index.html /public/

# Persuade Cloudflare to cache the page hard at the edge (1 year) while keeping
# browsers on a short leash (1 day) so a redeploy shows up quickly. Past that day
# stale-while-revalidate lets the return visit paint from cache immediately and
# refresh in the background, instead of blocking on a revalidation. Custom
# headers are the one SWS setting env vars can't express, so they need a config
# file — written inline here (COPY heredoc, no shell needed) to keep the repo
# down to one file.
COPY <<'EOF' /sws.toml
[general]
root = "/public"

[advanced]

[[advanced.headers]]
source = "**/*.html"

[advanced.headers.headers]
Cache-Control = "public, max-age=86400, stale-while-revalidate=604800"
CDN-Cache-Control = "public, max-age=31536000"
EOF

ENV SERVER_CONFIG_FILE=/sws.toml
