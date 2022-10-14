#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
set -e

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1
starttime=$(date +%s)

echo 네트워크 설정을 시작 합니다.
echo CC는 JavaScript를 사용 합니다.

# clean out any old identites in the wallets
rm -rf javascript/wallet/*

# launch network; create channel and join peer to channel
pushd ../pnu-network
./network.sh down
./network.sh up createChannel -ca -s couchdb
./network.sh deployCC -l javascript
popd

cat <<EOF

Total setup execution time : $(($(date +%s) - starttime)) secs ...

네트워크 설정 완료!!


EOF
