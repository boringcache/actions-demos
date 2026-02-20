# BoringCache Actions Demos

Example workflows for every BoringCache GitHub Action.

## Available Actions

| Action | Description | Example |
|--------|-------------|---------|
| [boringcache/action](https://github.com/boringcache/action) | Cache any directory (drop-in for `actions/cache`) | [ci.yml](.github/workflows/ci.yml) |
| [boringcache/save](https://github.com/boringcache/save) | Save directories at a specific workflow point | [save-restore.yml](.github/workflows/save-restore.yml) |
| [boringcache/restore](https://github.com/boringcache/restore) | Restore directories at a specific workflow point | [save-restore.yml](.github/workflows/save-restore.yml) |
| [boringcache/setup-boringcache](https://github.com/boringcache/setup-boringcache) | Install the BoringCache CLI | [setup-cli.yml](.github/workflows/setup-cli.yml) |
| [boringcache/nodejs-action](https://github.com/boringcache/nodejs-action) | Setup Node.js + cache node_modules and build tools | [nodejs.yml](.github/workflows/nodejs.yml) |
| [boringcache/ruby-action](https://github.com/boringcache/ruby-action) | Setup Ruby + cache Bundler gems | [ruby.yml](.github/workflows/ruby.yml) |
| [boringcache/rust-action](https://github.com/boringcache/rust-action) | Setup Rust + cache Cargo registry and target | [rust.yml](.github/workflows/rust.yml) |
| [boringcache/docker-action](https://github.com/boringcache/docker-action) | Cache Docker BuildKit layers via OCI proxy | [docker.yml](.github/workflows/docker.yml) |
| [boringcache/buildkit-action](https://github.com/boringcache/buildkit-action) | Cache BuildKit layers for raw buildctl builds | [buildkit.yml](.github/workflows/buildkit.yml) |

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
  with:
    workspace: my-org/my-project
    entries: deps:node_modules
  env:
    BORINGCACHE_API_TOKEN: ${{ secrets.BORINGCACHE_API_TOKEN }}

- run: npm ci

- uses: boringcache/save@v1
  with:
    workspace: my-org/my-project
    entries: deps:node_modules
  env:
    BORINGCACHE_API_TOKEN: ${{ secrets.BORINGCACHE_API_TOKEN }}
```

### Pattern 4: Language-Specific (Zero Config)

Use language actions for automatic setup + caching:

```yaml
# Node.js
- uses: boringcache/nodejs-action@v1
  with:
    node-version: '20'
  env:
    BORINGCACHE_API_TOKEN: ${{ secrets.BORINGCACHE_API_TOKEN }}

# Ruby
- uses: boringcache/ruby-action@v1
  with:
    ruby-version: '3.3'
  env:
    BORINGCACHE_API_TOKEN: ${{ secrets.BORINGCACHE_API_TOKEN }}

# Rust
- uses: boringcache/rust-action@v1
  with:
    toolchain: stable
  env:
    BORINGCACHE_API_TOKEN: ${{ secrets.BORINGCACHE_API_TOKEN }}
```

## Why BoringCache?

- **Content-addressed** — identical content is never re-uploaded
- **Portable** — same cache works in CI, Docker builds, and local dev
- **Cross-platform** — Linux, macOS, Windows

## License

MIT
