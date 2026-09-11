# Diagnose ty unresolved import

- [x] Reproduce the unresolved import with the same project and ty executable.
- [x] Identify the project root, Python environment, and installed Crypto package.
- [x] Confirm no additional config fix is needed; the live server predates `.venv`.
- [x] Verify the import resolves in ty and Neovim-equivalent startup conditions.

## Review

- Plain checking from an unrelated cwd reproduced the unresolved imports.
- Project-aware checking and a fresh headless Neovim client resolved the imports via `.venv`.
- The existing `ty` process started before `.venv` and its dependencies were created.
