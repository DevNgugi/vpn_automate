# vpn_automate
Connect to VPN on Linux script (with auto OTP)


``` cat <<EOF | gpg --symmetric --cipher-algo AES256 -o ~/.vpn_secrets.gpg
USERNAME=<username>
STATIC_PASSWORD=<password>
TOTP_SECRET=<From provider>
EOF
```
