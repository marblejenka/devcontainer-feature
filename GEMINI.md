# AI/LLM Instructions for `devcontainer-feature` Repository

This document outlines the conventions and instructions for AI/LLM agents interacting with this repository.

## Repository Structure

This repository follows the standard [Devcontainer Feature](https://containers.dev/implementors/features/) layout:

-   **`src/`**: Contains the source code for each feature (e.g., `gemini-cli`, `tlaplus`).
-   **`test/`**: Contains the test suites corresponding to each feature.
-   **`.github/`**: Automation and CI/CD workflows.

### Available Features

-   **`gemini-cli`**: Installs the Gemini CLI and its environment.
-   **`tlaplus`**: Installs TLA+ Tools and dependencies.

## Conventions

### Documentation

Each feature directory (e.g., `src/gemini-cli`, `src/tlaplus`) must contain the following documentation files:

-   **`README.md`**: Human-readable descriptions intended for developers and users.
-   **`GEMINI.md`**: Machine-oriented context, conventions, and instructions for AI agents. Do not manually edit `README.md` files that are marked as auto-generated. These files are typically refreshed from `devcontainer-feature.json` during the release process.
-   **`NOTES.md`**: Additional notes, implementation details, or manual documentation that complements the README. 

### Testing

When implementing features or adding tests, adhere to the following standards:

-   **Scenario Tests**: Test scripts located within the `test/<feature>/` directory must be prefixed with `scenario_` (e.g., `scenario_keep_google_api_credentials.sh`). This prefix is required for proper identification and execution by the test runner.
