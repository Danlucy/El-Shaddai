# Zoom OAuth Android App Link

Upload `assetlinks.json` unchanged to:

`https://daniel-ong.com/.well-known/assetlinks.json`

The server must return the file directly over HTTPS with a successful `200`
response and without a redirect.

The included SHA-256 fingerprint belongs to the keystore currently configured
by `android/key.properties`. If Google Play App Signing is enabled, also add
the SHA-256 fingerprint shown under **Play Console > Setup > App integrity >
App signing key certificate** to `sha256_cert_fingerprints`.
