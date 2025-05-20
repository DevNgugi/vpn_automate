#!/bin/bash
SECRETS_FILE="$HOME/.vpn_secrets.gpg"
AUTH_FILE="/tmp/ovpn_creds.txt"
OVPN_CONFIG="$HOME/.config.ovpn"  # <- replace with your actual .ovpn config path

# === Decrypt secrets (GPG will prompt for passphrase) ===
eval $(gpg --quiet --batch --decrypt "$SECRETS_FILE")

if [[ -z "$USERNAME" || -z "$STATIC_PASSWORD" || -z "$TOTP_SECRET" ]]; then
    echo "Failed to load secrets. Exiting."
    exit 1
fi

# === Generate TOTP ===
OTP_CODE=$(python3 -c "import pyotp; print(pyotp.TOTP('$TOTP_SECRET').now())")
FULL_PASSWORD="${STATIC_PASSWORD}${OTP_CODE}"

# === Write temporary auth file ===
echo -e "${USERNAME}\n${FULL_PASSWORD}" > "$AUTH_FILE"

# === Start OpenVPN ===
sudo openvpn --config "$OVPN_CONFIG" --auth-user-pass "$AUTH_FILE"

# === Clean up ===
rm -f "$AUTH_FILE"
