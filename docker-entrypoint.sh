#!/bin/sh
set -e

# The keystore is generated here rather than at image build time. Baking it in published
# both the keystore and its password into the image, and the image is public. Generating it
# per container start also means the password can never drift from the one the application
# is configured with, because both come from the same environment variable.

if [ -z "$KEYSTORE_PASSWORD" ]; then
    echo "KEYSTORE_PASSWORD is not set. Refusing to start without one." >&2
    exit 1
fi

KEY_PASSWORD="${KEY_PASSWORD:-$KEYSTORE_PASSWORD}"

keytool -keystore /app/helios_portfolio.jks \
    -alias heliosAlias \
    -genkeypair \
    -keyalg RSA \
    -keysize 4096 \
    -validity 365 \
    -storepass "$KEYSTORE_PASSWORD" \
    -keypass "$KEY_PASSWORD" \
    -dname 'CN=localhost, OU=ktor, O=ktor, L=Unspecified, ST=Unspecified, C=US' \
    > /dev/null

exec java -jar /app/ktor-app.jar "$@"
