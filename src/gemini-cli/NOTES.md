## OS Support

This feature supports Ubuntu-based operating systems and has been tested with the following container images:

-   `ubuntu:latest`
-   `mcr.microsoft.com/devcontainers/base:ubuntu`
-   `mcr.microsoft.com/devcontainers/universal:linux`

## Using with Default Features

To install the Gemini CLI across all your development environments that use Dev Containers, you can add this feature to `Dev > Containers: Default Features` in VS Code settings. Open your VS Code settings, search for `default feature`, and then select `Edit in settings.json` to add the feature.

![Default Feature Image](imgs/default-feature.png)

## Persistence of CLI Credentials

Maintaining authentication state across container rebuilds is crucial. This feature helps manage the persistence of credentials for the 'Login with Google (OAuth)' method using a named volume. Other authentication methods, such as Vertex AI or API Keys, typically rely on related features or external mechanisms for persistence.

### Login with Google (OAuth)

This feature provides persistence mechanism for the `Login with Google` (OAuth) flow. By utilizing the `keep_google_api_credentials` option, you can preserve your Google OAuth tokens across container rebuilds within a named volume.

#### How it works

-   A dedicated volume is mounted at `/dc/gemini-cli`.
-   The feature creates a symlink from the authentication file (`~/.gemini/oauth_creds.json`) to this persistent volume.
-   This ensures your login session remains active across rebuilds, while other configuration files can be managed independently, for example, through your GEMINIFILES repository.

#### Example `devcontainer.json` Configuration

```json
"features": {
    "ghcr.io/marblejenka/devcontainer-feature/gemini-cli:0": {
        "keep_google_api_credentials": true
    }
},
"mounts": [
    {
        "source": "gemini-cli-persistence",
        "target": "/dc/gemini-cli",
        "type": "volume"
    }
]
```

### Vertex AI

Authentication for Vertex AI is handled through the Google Cloud CLI (`gcloud`). To persist Vertex AI credentials, it is recommended to use a feature specifically designed for `gcloud` credential persistence, such as `gcloud-cli-persistence`.

#### Example `devcontainer.json` Configuration

```json
"features": {
    "ghcr.io/jajera/features/gcloud-cli:1": {},
    "ghcr.io/joshuanianji/devcontainer-features/gcloud-cli-persistence:1": {},
    "ghcr.io/marblejenka/devcontainer-feature/gemini-cli:0": {}
},
"mounts": [
    {
        "source": "gcloud-cli-persistence",
        "target": "/dc/gcloud-cli",
        "type": "volume"
    }
]
```

#### Environment Variables

You may also want to create a `.env` file at your project root to automatically select the Google Cloud project and model region.

```
GOOGLE_CLOUD_PROJECT=your_project_id
GOOGLE_CLOUD_LOCATION=global # or your preferred region
```

### API Key (Token)

This feature does not manage API Keys (Tokens). Users are expected to handle these securely, for instance, by using environment variables or a preferred secret management provider (e.g., [1Password CLI (op)](https://ghcr.io/flexwie/devcontainer-features/op)).