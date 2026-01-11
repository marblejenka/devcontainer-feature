
# Gemini CLI (gemini-cli)

Installs Gemini CLI, and needed dependencies.

## Example Usage

```json
"features": {
    "ghcr.io/marblejenka/devcontainer-feature/gemini-cli:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter a Gemini CLI version to install | string | latest |
| geminifiles | A git repository URL to clone for gemini-cli configuration. It is expected to have an install.sh at the root. | string | - |
| keep_google_api_credentials | If true, persists Google API credentials across container rebuilds by storing them in a volume. | boolean | false |
| google_api_credentials_persist_dir | The directory where Google API credentials will be persisted if keep_google_api_credentials is true. | string | /dc/gemini-cli |

## Customizations

### VS Code Extensions

- `google.geminicodeassist`

## OS Support

TODO


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/marblejenka/devcontainer-feature/blob/main/src/gemini-cli/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
