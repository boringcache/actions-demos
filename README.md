# BoringCache Action Demos

Example workflows for `boringcache/one@v1`.

## What this repo is for

Use these workflows as a starting point when you want a working example before you shape the YAML around your own build.

## Available examples

| Pattern | Description | Example |
|--------|-------------|---------|
| Archive compatibility | Swap `actions/cache` for `boringcache/one` and keep `path` / `key` inputs | [ci.yml](.github/workflows/ci.yml) |
| Job lifecycle | Let `boringcache/one` restore at step start and save in the post step | [save-restore.yml](.github/workflows/save-restore.yml) |
| Node preset | Install Node with `mise` and cache package-manager state | [nodejs.yml](.github/workflows/nodejs.yml) |
| Ruby preset | Install Ruby with `mise` and cache Bundler state | [ruby.yml](.github/workflows/ruby.yml) |
| Rust mode | Use `mode: rust-sccache` for toolchain, cargo, target, and sccache flows | [rust.yml](.github/workflows/rust.yml) |
| Docker mode | Use `mode: docker` for `docker buildx build` orchestration | [docker.yml](.github/workflows/docker.yml) |
| BuildKit mode | Use `mode: buildkit` for direct `buildctl` flows | [buildkit.yml](.github/workflows/buildkit.yml) |
| CLI bootstrap | Install only the CLI with `setup: none` | [setup-cli.yml](.github/workflows/setup-cli.yml) |

## Quick start

1. Create a restore token and a save token in [boringcache.com](https://boringcache.com)
2. Add `BORINGCACHE_RESTORE_TOKEN` and `BORINGCACHE_SAVE_TOKEN` to your repository secrets
3. Copy any workflow from this repo and adapt the `workspace`, tags, entries, and tools to your project

## Common patterns

### Pattern 1: Drop-in cache

Replace `actions/cache` with `boringcache/one`:

```yaml
- uses: boringcache/one@v1
  with:
    setup: none
    path: node_modules
    key: deps-${{ hashFiles('package-lock.json') }}
  env:
    BORINGCACHE_RESTORE_TOKEN: ${{ secrets.BORINGCACHE_RESTORE_TOKEN }}
    BORINGCACHE_SAVE_TOKEN: ${{ github.event_name == 'pull_request' && '' || secrets.BORINGCACHE_SAVE_TOKEN }}
```

### Pattern 2: Workspace format

Use workspace format for multi-project caching:

```yaml
- uses: boringcache/one@v1
  with:
    setup: none
    workspace: my-org/my-project
    entries: deps:node_modules,build:.next
  env:
    BORINGCACHE_RESTORE_TOKEN: ${{ secrets.BORINGCACHE_RESTORE_TOKEN }}
    BORINGCACHE_SAVE_TOKEN: ${{ github.event_name == 'pull_request' && '' || secrets.BORINGCACHE_SAVE_TOKEN }}
```

### Pattern 3: Restore now, save automatically later

`boringcache/one` restores at step start and saves in the post step:

```yaml
- uses: boringcache/one@v1
  with:
    setup: none
    workspace: my-org/my-project
    entries: deps:node_modules
  env:
    BORINGCACHE_RESTORE_TOKEN: ${{ secrets.BORINGCACHE_RESTORE_TOKEN }}
    BORINGCACHE_SAVE_TOKEN: ${{ github.event_name == 'pull_request' && '' || secrets.BORINGCACHE_SAVE_TOKEN }}

- run: npm ci
```

### Pattern 4: Presets and modes

Use `preset` or `mode` to describe the workflow shape:

```yaml
# Node.js
- uses: boringcache/one@v1
  with:
    preset: node
    tools: "node@20"
  env:
    BORINGCACHE_RESTORE_TOKEN: ${{ secrets.BORINGCACHE_RESTORE_TOKEN }}
    BORINGCACHE_SAVE_TOKEN: ${{ github.event_name == 'pull_request' && '' || secrets.BORINGCACHE_SAVE_TOKEN }}

# Ruby
- uses: boringcache/one@v1
  with:
    preset: ruby
    tools: "ruby@3.3"
  env:
    BORINGCACHE_RESTORE_TOKEN: ${{ secrets.BORINGCACHE_RESTORE_TOKEN }}
    BORINGCACHE_SAVE_TOKEN: ${{ github.event_name == 'pull_request' && '' || secrets.BORINGCACHE_SAVE_TOKEN }}

# Rust
- uses: boringcache/one@v1
  with:
    setup: none
    mode: rust-sccache
    toolchain: stable
    sccache: true
    sccache-mode: proxy
  env:
    BORINGCACHE_RESTORE_TOKEN: ${{ secrets.BORINGCACHE_RESTORE_TOKEN }}
    BORINGCACHE_SAVE_TOKEN: ${{ github.event_name == 'pull_request' && '' || secrets.BORINGCACHE_SAVE_TOKEN }}
```

## Why this layout?

- **Content-addressed** — identical content is never re-uploaded
- **Portable** — same cache works in CI, Docker builds, and local dev
- **Cross-platform** — Linux, macOS, Windows

## License

MIT
