```
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
```
