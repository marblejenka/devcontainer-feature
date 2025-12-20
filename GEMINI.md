# Devcontainer Features Repository

This repository contains a collection of [Devcontainer Features](https://containers.dev/implementors/features/).

## Directory Structure

The repository is structured as follows:

-   `.github/`: Contains GitHub Actions workflows for CI/CD and other automations.
-   `src/`: Contains the source code for the devcontainer features.
    -   `gemini-cli/`: The `gemini-cli` feature.
        -   `devcontainer-feature.json`: The definition of the feature.
        -   `install.sh`: The installation script for the feature.
        -   `README.md`: The documentation for the feature.
    -   `tlaplus/`: The `tlaplus` feature.
        -   `devcontainer-feature.json`: The definition of the feature.
        -   `install.sh`: The installation script for the feature.
        -   `README.md`: The documentation for the feature.
-   `test/`: Contains the tests for the features.
    -   `gemini-cli/`: Tests for the `gemini-cli` feature.
    -   `tlaplus/`: Tests for the `tlaplus` feature.
-   `README.md`: The main README file for the repository.
-   `GEMINI.md`: This file, providing an overview of the repository.

## Available Features

### Gemini CLI (gemini-cli)

Installs Gemini CLI, and needed dependencies.

#### Example Usage

```json
"features": {
    "ghcr.io/marblejenka/devcontainer-feature/gemini-cli:0": {}
}
```

#### Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter a Gemini CLI version to install | string | latest |

#### Customizations

##### VS Code Extensions

- `google.geminicodeassist`

#### OS Support

TODO

---

### TLA+ Tools (tlaplus)

Installs TLA+ Tools, and needed dependencies.

#### Example Usage

```json
"features": {
    "ghcr.io/marblejenka/devcontainer-feature/tlaplus:0": {}
}
```

#### Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| toolsPath | Enter a TLA+ Tools installation path | string | /tlaplus |
| setupShorthand | Whether to setup shorthand commands for TLA+ Tools | boolean | true |
| installTlaplus | Whether to install TLA+ Tools | boolean | true |
| versionForTlaplus | Select or enter a TLA+ Tools version to install | string | latest |
| installCommunityModules | Whether to install TLA+ CommunityModules | boolean | true |
| versionForCommunityModules | Select or enter a TLA+ CommunityModules version to install | string | latest |
| installTlapm | Whether to install TLAPM (TLA+ Proof Manager ) | boolean | true |
| versionForTlapm | Select or enter a TLAPM version to install | string | 1.6.0-pre |
| installApalache | Whether to install Apalache | boolean | true |
| versionForApalache | Select or enter an Apalache version to install | string | latest |
| installTLAUC | Whether to install TLAUC | boolean | true |
| versionForTLAUC | Select or enter a TLAUC version to install | string | latest |

#### OS Support

TODO

#### The original install script

Adapted from https://github.com/tlaplus/Examples/blob/1.1.0/.devcontainer/install.sh
