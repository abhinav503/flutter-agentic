# MCP Registry listing

`server.json` is the listing for registry.modelcontextprotocol.io — a remote
(Streamable HTTP) server at `https://cordeliaapps.com/api/mcp` under the
DNS-verified namespace `com.cordeliaapps`.

**Not published yet** — a listing is public discovery, and the store stays
unlisted until launch. When it's time:

1. DNS — one TXT record on the **apex** `cordeliaapps.com` (not a selector):
   `v=MCPv1; k=ed25519; p=<public key>` — the value printed when the key was
   generated. The private key lives at `~/.config/cordelia/mcp-registry-key.pem`
   on the machine that publishes; it is never in the repo.
2. Check propagation: `dig +short TXT cordeliaapps.com | grep MCPv1`
3. Log in and publish, from this directory:

   ```bash
   OPENSSL=/opt/homebrew/opt/openssl@3/bin/openssl   # macOS: LibreSSL lacks Ed25519
   PRIVATE_KEY="$($OPENSSL pkey -in ~/.config/cordelia/mcp-registry-key.pem -noout -text | grep -A3 "priv:" | tail -n +2 | tr -d ' :\n')"
   mcp-publisher login dns --domain cordeliaapps.com --private-key "$PRIVATE_KEY"
   mcp-publisher publish
   ```

4. Bump `version` in `server.json` for every later republish.

Free directories to list on at the same time (forms, no review): mcpmarket.com,
claudemarketplaces.com, skillsclaude.org, lobehub.com/skills, glama.ai.
