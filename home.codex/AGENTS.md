# Global Codex Instructions

## Go Commands

- In Codex sandboxed sessions, run Go tests and Go build-related commands with a writable build cache under `/tmp`, because the default Go build cache may be outside the writable sandbox.
- Prefer `env GOCACHE=/tmp/go-build-cache go test ./...` instead of plain `go test ./...`.
- For package-scoped tests, keep the same prefix, for example `env GOCACHE=/tmp/go-build-cache go test ./cmd/foo ./internal/bar`.
- For `golangci-lint`, use `env GOCACHE=/tmp/go-build-cache GOLANGCI_LINT_CACHE=/tmp/golangci-lint-cache go tool golangci-lint run ...`.
