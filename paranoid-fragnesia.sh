#!/usr/bin/env bash
#
# Fragnesia mitigation script
#
# This script:
#   1. Blocks vulnerable kernel modules from loading
#   2. Unloads them if currently active
#   3. Verifies mitigation status
#
# WARNING:
#   Disables Linux IPsec ESP support (esp4/esp6)
#   and RxRPC support.
#
#   This may break:
#     - strongSwan
#     - libreswan
#     - some enterprise VPNs
#     - AFS/RxRPC services

set -euo pipefail

CONF_FILE="/etc/modprobe.d/disable-fragnesia.conf"

echo "[*] Writing module blacklist configuration..."

cat <<'EOF' | tee "$CONF_FILE" >/dev/null
# Fragnesia mitigation
# Prevent vulnerable modules from loading

install esp4 /bin/false
install esp6 /bin/false
install rxrpc /bin/false
EOF

echo "[+] Configuration written to:"
echo "    $CONF_FILE"
echo

echo "[*] Attempting to unload vulnerable modules..."

for mod in esp4 esp6 rxrpc; do
    if lsmod | grep -q "^${mod}"; then
        echo "    -> Unloading $mod"
        modprobe -r "$mod" || true
    else
        echo "    -> $mod not loaded"
    fi
done

echo

echo "[*] Verifying mitigation..."

if lsmod | grep -E '^(esp4|esp6|rxrpc)' >/dev/null; then
    echo "[!] STILL EXPOSED"
    echo
    echo "Loaded modules:"
    lsmod | grep -E '^(esp4|esp6|rxrpc)'
    exit 1
else
    echo "[+] PROTECTED"
fi

echo
echo "[*] Done."
