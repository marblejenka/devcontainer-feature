## Persistence of CLI Credentials

This feature ensures that your authentication state (e.g., Google OAuth tokens) is preserved even after rebuilding the container. By defining a Named Volume in `devcontainer.json`, the sensitive credential files are stored outside the container's ephemeral file system. Note that this feature only targets the `Login with Google` option and ensures the session persists across container rebuilds.

### How it works

- A dedicated volume is expected to be mounted at `/dc/gemini-cli`.
- The authentication file (`~/.gemini/oauth_creds.json`) is symlinked to this persistent volume by the feature.
- This allows your login session to persist while still allowing other configuration files to be managed via your GEMINIFILES repository.

### Example of `devcontainer.json`

```json
"features": {
    "gemini-cli": {
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

### Authentication Scope & Persistence Limitations

This persistence feature is specifically designed for the `Login with Google` (OAuth) flow. Please note that it does **not** manage or affect the following authentication methods:

- API Key (Token): If you use an API Key, it is not stored in the persistent volume. Users are expected to manage API Keys securely via environment variables or your preferred secret management provider.

- Vertex AI: Authentication for Vertex AI is handled through the Google Cloud CLI (gcloud). To persist Vertex AI credentials, please use the `gcloud-cli-persistence` feature instead of (or alongside) this one.

