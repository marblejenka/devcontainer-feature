## OS Support

We support Ubuntu-based operating systems and have tested the following container images:

- ubuntu:latest
- mcr.microsoft.com/devcontainers/base:ubuntu
- mcr.microsoft.com/devcontainers/universal:linux

## Use with `default feature`

To install the Gemini CLI across all your development environments that use Dev Containers locally in VSCode, add this feature to `Dev › Containers: Default Features`. To do this, open the VSCode settings, search for `default feature`, and then add the feature by selecting `Edit in settings.json`.

![Default Feature Image](imgs/default-feature.png)

## Persistence of CLI Credentials

It is crucial to help persist authentication state. We can do it for across container rebuilds by storing sensitive files on a named volume. The persistence for 'Login with Google (OAuth)' is handled by this feature itself, while persistence for other authentication methods, such as Vertex AI, are typically managed by other related features or external mechanisms. Below are the guidance for different authentication methods.

### Login with Google (OAuth)

This persistence feature is designed specifically for the `Login with Google` (OAuth) flow by use of `keep_google_api_credentials`. It preserves your Google OAuth tokens across container rebuilds in the named volume.

#### How it works

-   A dedicated volume should be mounted at `/dc/gemini-cli`.
-   The feature symlinks the authentication file (`~/.gemini/oauth_creds.json`) to this persistent volume.
-   This ensures your login session persists while allowing other configuration files to be managed through your GEMINIFILES repository.

#### Example of `devcontainer.json`

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

### 2. Vertex AI

Authentication for Vertex AI is handled via the Google Cloud CLI (`gcloud`). To persist Vertex AI credentials, it is recommended to use a feature that persists `gcloud` credentials, such as `gcloud-cli-persistence`.

#### Example of `devcontainer.json`

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

### 3. API Key (Token)

This persistence feature does not manage API Keys (Tokens). Users are expected to manage them securely, for example, via environment variables or a preferred secret management provider(e.g. [1Password CLI (op)
](ghcr.io/flexwie/devcontainer-features/op)).

