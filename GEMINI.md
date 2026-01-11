# AI/LLM Instructions for `devcontainer-feature` Repository

This document outlines the conventions and instructions for AI/LLM agents interacting with this repository.

## Documentation Conventions

We maintain a strict distinction between human-facing and AI-facing documentation:

-   **`README.md`**: Human-readable descriptions intended for developers and users.
-   **`GEMINI.md`**: Machine-oriented context, conventions, and instructions for AI agents.

**Requirement:** Before performing any task, always check for a `GEMINI.md` file in the current directory and its parent directories to ensure compliance with local instructions.

## Feature Directory Structure

Each feature directory (e.g., `src/gemini-cli`, `src/tlaplus`) must contain the following documentation files:

-   **`GEMINI.md`**: AI/LLM specific instructions and context.
-   **`README.md`**: Human-readable documentation (often auto-generated).
-   **`NOTES.md`**: Additional notes, implementation details, or manual documentation that complements the README.

## Repository Structure

This repository follows the standard [Devcontainer Feature](https://containers.dev/implementors/features/) layout:

-   **`src/`**: Contains the source code for each feature (e.g., `gemini-cli`, `tlaplus`).
-   **`test/`**: Contains the test suites corresponding to each feature.
-   **`.github/`**: Automation and CI/CD workflows.

### Available Features

-   **`gemini-cli`**: Installs the Gemini CLI and its environment.
-   **`tlaplus`**: Installs TLA+ Tools and dependencies.

## Testing and Contribution Standards

When implementing features or adding tests, adhere to the following standards:

-   **Scenario Tests**: Test scripts located within the `test/<feature>/` directory must be prefixed with `scenario_` (e.g., `scenario_keep_google_api_credentials.sh`). This prefix is required for proper identification and execution by the test runner.
-   **Auto-generated Files**: Do not manually edit `README.md` files that are marked as auto-generated. These files are typically refreshed from `devcontainer-feature.json` during the release process.