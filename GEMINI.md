# AI/LLM Instructions for `devcontainer-feature` Repository

This document provides instructions for an AI/LLM on how to interact with this repository.

## `GEMINI.md` vs `README.md` Convention

In this repository, we follow a convention for `GEMINI.md` and `README.md` files:

-   **`README.md`**: These files contain human-readable descriptions of the project or feature. They are intended for developers and users.
-   **`GEMINI.md`**: These files contain instructions specifically for AI/LLM agents. They provide context, conventions, and instructions on how to interact with the repository's code and resources.

When you are asked to perform a task, you should first look for a `GEMINI.md` file in the current directory and its parent directories to get instructions.

## Repository Structure

This repository contains a collection of [Devcontainer Features](https://containers.dev/implementors/features/).

-   `.github/`: Contains GitHub Actions workflows for CI/CD and other automations.
-   `src/`: Contains the source code for the devcontainer features.
    -   `gemini-cli/`: The `gemini-cli` feature.
    -   `tlaplus/`: The `tlaplus` feature.
-   `test/`: Contains the tests for the features.
    -   `gemini-cli/`: Tests for the `gemini-cli` feature.
    -   `tlaplus/`: Tests for the `tlaplus` feature.

## Available Features

This repository provides the following features:

-   **`gemini-cli`**: Installs the Gemini CLI and its dependencies.
-   **`tlaplus`**: Installs TLA+ Tools and their dependencies.

When working with a feature, you should look for the `README.md` file in the feature's directory for a human-readable description, and a `GEMINI.md` file for AI-specific instructions.