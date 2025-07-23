
# TLA+ Tools (tlaplus)

Installs TLA+ Tools, and needed dependencies.

## Example Usage

```json
"features": {
    "ghcr.io/marblejenka/devcontainer-feature/tlaplus:0": {}
}
```

## Options

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

## OS Support

TODO

## The original install script

Adapted from https://github.com/tlaplus/Examples/blob/1.1.0/.devcontainer/install.sh


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/marblejenka/devcontainer-feature/blob/main/src/tlaplus/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
