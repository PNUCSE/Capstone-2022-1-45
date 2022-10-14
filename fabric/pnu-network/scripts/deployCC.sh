
CHANNEL_NAME="$1"
CC_SRC_LANGUAGE="$2"
VERSION="$3"
DELAY="$4"
MAX_RETRY="$5"
VERBOSE="$6"
: ${CHANNEL_NAME:="rec-trade-channel"}
: ${CC_SRC_LANGUAGE:="golang"}
: ${VERSION:="1"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}
CC_SRC_LANGUAGE=`echo "$CC_SRC_LANGUAGE" | tr [:upper:] [:lower:]`

FABRIC_CFG_PATH=$PWD/../config/


CC_RUNTIME_LANGUAGE=node # chaincode runtime language is node.js
CC_SRC_PATH="../chaincode/pnucc/javascript/"

# import utils
. scripts/envVar.sh


packageChaincode() {
  ORG=$1
  setGlobals $ORG $2
  set -x
  peer lifecycle chaincode package pnucc.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label pnucc_${VERSION} >&log.txt
  res=$?
  set +x
  cat log.txt
  verifyResult $res "Chaincode packaging on peer$2.${ORG} has failed"
  echo "===================== Chaincode is packaged on peer$2.${ORG} ===================== "
  echo
}

# installChaincode PEER ORG
installChaincode() {
  ORG=$1
  setGlobals $ORG $2
  set -x
  peer lifecycle chaincode install pnucc.tar.gz >&log.txt
  res=$?
  set +x
  cat log.txt
  verifyResult $res "Chaincode installation on peer$2.${ORG} has failed"
  echo "===================== Chaincode is installed on peer$2.${ORG} ===================== "
  echo
}

# queryInstalled PEER ORG
queryInstalled() {
  ORG=$1
  setGlobals $ORG $2
  set -x
  peer lifecycle chaincode queryinstalled >&log.txt
  res=$?
  set +x
  cat log.txt
	PACKAGE_ID=$(sed -n "/pnucc_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
  verifyResult $res "Query installed on peer$2.${ORG} has failed"
  echo PackageID is ${PACKAGE_ID}
  echo "===================== Query installed successful on peer$2.${ORG} on channel ===================== "
  echo
}

# approveForMyOrg VERSION PEER ORG
approveForMyOrg() {
  ORG=$1
  setGlobals $ORG $2
  set -x
  peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.pnu.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name pnucc --version ${VERSION} --init-required --package-id ${PACKAGE_ID} --sequence ${VERSION} >&log.txt
  set +x
  cat log.txt
  verifyResult $res "Chaincode definition approved on peer$2.${ORG} on channel '$CHANNEL_NAME' failed"
  echo "===================== Chaincode definition approved on peer$2.${ORG} on channel '$CHANNEL_NAME' ===================== "
  echo
}

# checkCommitReadiness VERSION PEER ORG
checkCommitReadiness() {
  ORG=$1
  shift 1
  PEERNUM=$1
  shift 1
  setGlobals $ORG $PEERNUM
  echo "===================== Checking the commit readiness of the chaincode definition on peer$PEERNUM.${ORG} on channel '$CHANNEL_NAME'... ===================== "
	local rc=1
	local COUNTER=1
	# continue to poll
  # we either get a successful response, or reach MAX RETRY
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    echo "Attempting to check the commit readiness of the chaincode definition on peer$PEERNUM.${ORG} secs"
    set -x
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name pnucc --version ${VERSION} --sequence ${VERSION} --output json --init-required >&log.txt
    res=$?
    set +x
    let rc=0
    for var in "$@"
    do
      grep "$var" log.txt &>/dev/null || let rc=1
    done
		COUNTER=$(expr $COUNTER + 1)
	done
  echo "캣캣"
  cat log.txt
  echo "캣캣 끝"
  if test $rc -eq 0; then
    echo "===================== Checking the commit readiness of the chaincode definition successful on peer$PEERNUM.${ORG} on channel '$CHANNEL_NAME' ===================== "
  else
    echo "!!!!!!!!!!!!!!! After $MAX_RETRY attempts, Check commit readiness result on peer$PEERNUM.${ORG} is INVALID !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}

# commitChaincodeDefinition VERSION PEER ORG (PEER ORG)...
commitChaincodeDefinition() {
  parsePeerConnectionParameters $@
  #PEER_CONN_PARMS="--peerAddresses localhost:7051 --tlsRootCertFiles /vagrant/fabric-samples/pnu-network/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/ca.crt --peerAddresses localhost:8051 --tlsRootCertFiles /vagrant/fabric-samples/pnu-network/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles /vagrant/fabric-samples/pnu-network/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/ca.crt --peerAddresses localhost:10051 --tlsRootCertFiles /vagrant/fabric-samples/pnu-network/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls/ca.crt"
  setGlobals ManagementPeerOrg 0
  res=$?
  verifyResult $res "Invoke transaction failed on channel '$CHANNEL_NAME' due to uneven number of peer and org parameters "

  # while 'peer chaincode' command can get the orderer endpoint from the
  # peer (if join was successful), let's supply it directly as we know
  # it using the "-o" option
  set -x
  peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.pnu.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name pnucc $PEER_CONN_PARMS --version ${VERSION} --sequence ${VERSION} --init-required >&log.txt
  res=$?
  set +x
  cat log.txt
  verifyResult $res "Chaincode definition commit failed on peer$2.${ORG} on channel '$CHANNEL_NAME' failed"
  echo "===================== Chaincode definition committed on channel '$CHANNEL_NAME' ===================== "
  echo
}

# queryCommitted ORG
queryCommitted() {
  ORG=$1
  setGlobals $ORG $2
  EXPECTED_RESULT="Version: ${VERSION}, Sequence: ${VERSION}, Endorsement Plugin: escc, Validation Plugin: vscc"
  echo "===================== Querying chaincode definition on peer$2.${ORG} on channel '$CHANNEL_NAME'... ===================== "
	local rc=1
	local COUNTER=1
	# continue to poll
  # we either get a successful response, or reach MAX RETRY
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    echo "Attempting to Query committed status on peer$2.${ORG}, Retry after $DELAY seconds."
    set -x
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name pnucc >&log.txt
    res=$?
    set +x
		test $res -eq 0 && VALUE=$(cat log.txt | grep -o '^Version: [0-9], Sequence: [0-9], Endorsement Plugin: escc, Validation Plugin: vscc')
    test "$VALUE" = "$EXPECTED_RESULT" && let rc=0
		COUNTER=$(expr $COUNTER + 1)
	done
  echo
  cat log.txt
  if test $rc -eq 0; then
    echo "===================== Query chaincode definition successful on peer$2.${ORG} on channel '$CHANNEL_NAME' ===================== "
		echo
  else
    echo "!!!!!!!!!!!!!!! After $MAX_RETRY attempts, Query chaincode definition result on peer$2.${ORG} is INVALID !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}

chaincodeInvokeInit() {
  parsePeerConnectionParameters $@
  res=$?
  verifyResult $res "Invoke transaction failed on channel '$CHANNEL_NAME' due to uneven number of peer and org parameters "

  # while 'peer chaincode' command can get the orderer endpoint from the
  # peer (if join was successful), let's supply it directly as we know
  # it using the "-o" option
  set -x
  peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.pnu.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n pnucc $PEER_CONN_PARMS --isInit -c '{"function":"initLedger","Args":[]}' >&log.txt
  res=$?
  set +x
  cat log.txt
  verifyResult $res "Invoke execution on $PEERS failed "
  echo "===================== Invoke transaction successful on $PEERS on channel '$CHANNEL_NAME' ===================== "
  echo
}

chaincodeQuery() {
  ORG=$1
  setGlobals $ORG $2
  echo "===================== Querying on peer$2.${ORG} on channel '$CHANNEL_NAME'... ===================== "
	local rc=1
	local COUNTER=1
	# continue to poll
  # we either get a successful response, or reach MAX RETRY
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    echo "Attempting to Query peer$2.${ORG} ...$(($(date +%s) - starttime)) secs"
    set -x
    peer chaincode query -C $CHANNEL_NAME -n pnucc -c '{"Args":["queryAllTransactions"]}' >&log.txt
    res=$?
    set +x
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
  echo
  cat log.txt
  if test $rc -eq 0; then
    echo "===================== Query successful on peer$2.${ORG} on channel '$CHANNEL_NAME' ===================== "
		echo
  else
    echo "!!!!!!!!!!!!!!! After $MAX_RETRY attempts, Query result on peer$2.${ORG} is INVALID !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}

## at first we package the chaincode
packageChaincode ManagementPeerOrg 0

echo "peer0.management-peer-org에 CC 설치..."
installChaincode ManagementPeerOrg 0
echo "peer1.management-peer-org에 CC 설치..."
installChaincode ManagementPeerOrg 1

echo "peer0.rec-client-peer-org에 CC 설치..."
installChaincode RecClientPeerOrg 0
echo "peer1.rec-client-peer-org에 CC 설치..."
installChaincode RecClientPeerOrg 1

## query whether the chaincode is installed
queryInstalled ManagementPeerOrg 0
queryInstalled ManagementPeerOrg 1
queryInstalled RecClientPeerOrg 0
queryInstalled RecClientPeerOrg 1

## approve the definition for management-peer-org
approveForMyOrg ManagementPeerOrg 0
approveForMyOrg ManagementPeerOrg 1

## check whether the chaincode definition is ready to be committed
## expect management-peer-org to have approved and rec-client-peer-org not to
#checkCommitReadiness ManagementPeerOrg 1 "\"ManagementPeerOrgMSP\": true" "\"RecClientPeerOrgMSP\": false"
#checkCommitReadiness RecClientPeerOrg 0 "\"ManagementPeerOrgMSP\": true" "\"RecClientPeerOrgMSP\": false"

## now approve also for rec-client-peer-org
approveForMyOrg RecClientPeerOrg 0
approveForMyOrg RecClientPeerOrg 1

## check whether the chaincode definition is ready to be committed
## expect them both to have approved
checkCommitReadiness ManagementPeerOrg 0 "\"ManagementPeerOrgMSP\": true" "\"RecClientPeerOrgMSP\": true"
checkCommitReadiness ManagementPeerOrg 1 "\"ManagementPeerOrgMSP\": true" "\"RecClientPeerOrgMSP\": true"
checkCommitReadiness RecClientPeerOrg 0 "\"ManagementPeerOrgMSP\": true" "\"RecClientPeerOrgMSP\": true"
checkCommitReadiness RecClientPeerOrg 1 "\"ManagementPeerOrgMSP\": true" "\"RecClientPeerOrgMSP\": true"

## now that we know for sure both orgs have approved, commit the definition
commitChaincodeDefinition ManagementPeerOrg 0 ManagementPeerOrg 1 RecClientPeerOrg 0 RecClientPeerOrg 1

## query on both orgs to see that the definition committed successfully
queryCommitted ManagementPeerOrg 0
queryCommitted ManagementPeerOrg 1
queryCommitted RecClientPeerOrg 0
queryCommitted RecClientPeerOrg 1

## Invoke the chaincode
chaincodeInvokeInit ManagementPeerOrg 0 RecClientPeerOrg 0

sleep 10

# Query chaincode on peer0.management-peer-org
echo "Querying chaincode on peer0.management-peer-org..."
chaincodeQuery ManagementPeerOrg 0

exit 0
