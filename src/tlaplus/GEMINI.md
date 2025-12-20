# AI/LLM Instructions for `tlaplus` Feature

This document provides instructions for an AI/LLM on how to interact with the `tlaplus` devcontainer feature.

## Feature Structure

-   `devcontainer-feature.json`: The definition of the feature. To add a new option, edit this file.
-   `install.sh`: The installation script for the feature.
-   `README.md`: The documentation for the feature. This file is auto-generated from `devcontainer-feature.json`.

## Testing

To test this feature, run the following command from the root of the repository:

```bash
devcontainer features test --features tlaplus --base-image mcr.microsoft.com/devcontainers/base:ubuntu .
```

The tests are defined in `test/tlaplus/`.
