# Working in this repository

Read this before making changes.

## What this repo is

A chezmoi source repository. `.chezmoiroot` points at `home/`, so every managed
file lives under `home/` using chezmoi's naming (`dot_`, `private_`, `.tmpl`).

It is a hand-maintained derivative of the public repo `bjw-s-labs/dotfiles`. It
is not a git fork and has no upstream remote, so upstream changes are ported by
hand. The two trees are kept substantively identical, differing only in the
local substitutions listed below.

## Applying the dotfiles is the user's job

Never run `chezmoi apply` or `chezmoi update`. The user runs those. Apply
rewrites their live home directory, and the Homebrew script runs
`brew bundle cleanup`, which uninstalls anything removed from the brewfile —
so when dropping a package, say plainly that applying will uninstall it.

Read-only chezmoi commands are fine: `status`, `diff`, `source-path`,
`managed`, `execute-template`.

`chezmoi apply` performs its own update from the remote. Do not prepend a
`git pull` step.

## Porting an upstream change

Given an upstream commit URL, port it. Do not first audit whether it is already
applied — a 3-way apply fails loudly if it is.

```bash
curl -sL <commit-url>.patch -o /tmp/port.patch
git apply --3way /tmp/port.patch
```

Commit using upstream's own subject line so the two histories stay comparable.
Fix upstream's bugs rather than replicating them, and say what was changed —
for example, upstream once added YAML keys at an indentation that would not
parse. Report any deviation from the patch after applying it.

## Local substitutions to preserve

| upstream | here |
|---|---|
| `bjw-s.dev` domains | `greyrock.io` |
| `Bernd Schorgers` / `bjw-s` | `Todd Punderson` / `tpunderson` |
| `:bjw-s/dotfiles.git` in `setup.sh` | `:todd/dotfiles.git` |
| upstream's 1Password vault/item UUIDs | this account's vault/item UUIDs |

## Secrets

Secrets never appear in a config file. They reach the config through the
environment, which is what lets most config files stay non-`.tmpl`:

- `home/dot_config/mise/secrets.env.toml.tmpl` resolves the secret and exports it
- the config references it as `{env:VAR_NAME}`

Only files that must resolve a secret at render time carry a `.tmpl` suffix and
call `onepasswordRead`. Those refs are UUID-form, matching upstream, with no
account argument (only one 1Password account is signed in):

```
{{ onepasswordRead "op://<vault-uuid>/<item-uuid>/<field>" }}
```

The one named-form ref is mise's `credential_command`
(`op://Developer/GitHub - Mise/password`), which matches upstream as-is.

The `Developer` vault (`scxg6mxpeiyz4coi6ivojwp2mq`) holds the SSH signing key
and the GitHub token that mise uses for its API rate limit. Moving an item
between vaults changes its item id, so re-read ids after any move.

Never print a secret's value. To check that a ref resolves, pipe it to
`wc -c` and report the byte count.

## Git conventions

- Commit directly to `main`. No branches, no pull requests.
- Push safe commits without asking — routine, verified changes such as adding
  or removing packages and tools, or doc edits. Ask before pushing anything
  risky: secrets or 1Password refs, signing or SSH config, setup and
  `.chezmoiscripts` changes, shell startup files, history rewrites, or
  anything you could not verify.
- Commits are signed through the 1Password SSH agent. A signing failure usually
  means the agent config (`~/.config/1Password/ssh/agent.toml`) names the wrong
  vault, or the 1Password app is not running — it is not a missed prompt.
- `origin` fetches from the GitHub mirror and pushes to Forgejo. The mirror
  propagates from Forgejo within seconds.

## Verifying a change

- `mise latest <tool>` confirms a tool name resolves before adding it.
- `brew info --cask <name>` confirms a cask exists.
- Templates: `chezmoi execute-template` renders without applying.
- Never assume a rename or move is safe because the surrounding text matches;
  check the actual file on disk.
