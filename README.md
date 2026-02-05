# BoringCache Actions Demo

**Cache once. Reuse everywhere.**

This repository demonstrates all BoringCache GitHub Actions with real-world examples.

## Available Actions

| Action | Description | Example |
|--------|-------------|---------|
| [boringcache/action](https://github.com/boringcache/action) | Drop-in replacement for `actions/cache` | [ci.yml](.github/workflows/ci.yml) |
| [boringcache/save](https://github.com/boringcache/save) | Save cache artifacts | [save-restore.yml](.github/workflows/save-restore.yml) |
| [boringcache/restore](https://github.com/boringcache/restore) | Restore cache artifacts | [save-restore.yml](.github/workflows/save-restore.yml) |
| [boringcache/setup-boringcache](https://github.com/boringcache/setup-boringcache) | Install BoringCache CLI | [setup-cli.yml](.github/workflows/setup-cli.yml) |
| [boringcache/nodejs-action](https://github.com/boringcache/nodejs-action) | Node.js + npm/yarn/pnpm caching | [nodejs.yml](.github/workflows/nodejs.yml) |
| [boringcache/ruby-action](https://github.com/boringcache/ruby-action) | Ruby + Bundler caching | [ruby.yml](.github/workflows/ruby.yml) |
| [boringcache/rust-action](https://github.com/boringcache/rust-action) | Rust + Cargo caching | [rust.yml](.github/workflows/rust.yml) |
| [boringcache/docker-action](https://github.com/boringcache/docker-action) | Docker BuildKit layer caching | [docker.yml](.github/workflows/docker.yml) |
| [boringcache/buildkit-action](https://github.com/boringcache/buildkit-action) | BuildKit daemon caching | [buildkit.yml](.github/workflows/buildkit.yml) |

## Quick Start

1. Get your API token from [boringcache.com](https://boringcache.com)
2. Add `BORINGCACHE_API_TOKEN` to your repository secrets
3. Copy any workflow from this repo and adapt to your needs

## Usage Patterns

### Pattern 1: Drop-in Cache (Simplest)

Replace `actions/cache` with `boringcache/action`:

```yaml
- uses: boringcache/action@v1
  with:
    path: node_modules
    key: deps-${{ hashFiles('package-lock.json') }}
  env:
    BORINGCACHE_API_TOKEN: ${{ secrets.BORINGCACHE_API_TOKEN }}
```

### Pattern 2: Workspace Format (Recommended)

Use workspace format for multi-project caching:

```yaml
- uses: boringcache/action@v1
  with:
    workspace: my-org/my-project
    entries: deps:node_modules,build:.next
  env:
    BORINGCACHE_API_TOKEN: ${{ secrets.BORINGCACHE_API_TOKEN }}
```

### Pattern 3: Save/Restore (Granular Control)

Separate restore and save steps:

```yaml
- uses: boringcache/restore@v1
  id: cache
  with:
    workspace: my-org/my-project
    entries: deps:node_modules

- run: npm ci
  if: steps.cache.outputs.cache-hit != 'true'

- uses: boringcache/save@v1
  with:
    workspace: my-org/my-project
    entries: deps:node_modules
```

### Pattern 4: Language-Specific (Zero Config)

Use language actions for automatic setup + caching:

```yaml
# Node.js
- uses: boringcache/nodejs-action@v1
  with:
    node-version: '20'

# Ruby
- uses: boringcache/ruby-action@v1
  with:
    ruby-version: '3.3'

# Rust
- uses: boringcache/rust-action@v1
  with:
    toolchain: stable
```

## Why BoringCache?

- **Portable caches** - reuse in CI, Docker, and local dev
- **Content-addressed** - skip uploads for unchanged content
- **Cross-platform** - Linux, macOS, Windows
- **Unified caching** - same cache works everywhere

## License

MIT
