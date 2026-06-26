# Security Notes

Do not commit secrets to this repository.

Never publish:

- Android keystore files
- key.properties
- API keys
- passwords
- access tokens
- private server URLs that should not be public

This app fetches HTML from user-provided URLs. Use it only where you have permission to inspect the page source.
