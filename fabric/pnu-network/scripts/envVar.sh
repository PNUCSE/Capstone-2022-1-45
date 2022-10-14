#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/msp/tlscacerts/tlsca.pnu.com-cert.pem
export PEER0_MANAGEMENT_PEER_ORG_CA=${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/ca.crt
export PEER1_MANAGEMENT_PEER_ORG_CA=${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls/ca.crt
export PEER0_REC_CLIENT_PEER_ORG_CA=${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/ca.crt
export PEER1_REC_CLIENT_PEER_ORG_CA=${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/msp/tlscacerts/tlsca.pnu.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/pnu.com/users/Admin@pnu.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  echo "Using organization ${USING_ORG}"
  if [ $USING_ORG = "ManagementPeerOrg" ]; then
    export CORE_PEER_LOCALMSPID="ManagementPeerOrgMSP"
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/users/Admin@management-peer-org.pnu.com/msp
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MANAGEMENT_PEER_ORG_CA
      export CORE_PEER_ADDRESS=localhost:7051
    else
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_MANAGEMENT_PEER_ORG_CA
      export CORE_PEER_ADDRESS=localhost:8051
    fi
  elif [ $USING_ORG = "RecClientPeerOrg" ]; then
    export CORE_PEER_LOCALMSPID="RecClientPeerOrgMSP"
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/users/Admin@rec-client-peer-org.pnu.com/msp
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_REC_CLIENT_PEER_ORG_CA
      export CORE_PEER_ADDRESS=localhost:9051
    else
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_REC_CLIENT_PEER_ORG_CA
      export CORE_PEER_ADDRESS=localhost:10051
    fi
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    echo "얍얍 $@"
    echo "얍얍 $PEERS"
    echo "얍얍 $PEER_CONN_PARMS"
    setGlobals $1 $2

    ## Peer 설정
    if [ $1 = "ManagementPeerOrg" ]; then
      PEER="peer$2.management-peer-org"
    elif [ $1 = "RecClientPeerOrg" ]; then
      PEER="peer$2.rec-client-peer-org"
    elif [ $1 -eq 3 ]; then
      PEER="peer$2.org$1"
    else
      echo "============ ERROR !!! ORG Unknown 이므로 peer 정의할 수 없음 ============"
    fi


    ## Set peer adresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate


    ## CA 설정    
    if [ $1 = "ManagementPeerOrg" ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER$2_MANAGEMENT_PEER_ORG_CA")
    elif [ $1 = "RecClientPeerOrg" ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER$2_REC_CLIENT_PEER_ORG_CA")
    elif [ $1 -eq 3 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_$1_CA")
    else
      echo "============ ERROR !!! ORG Unknown 이므로 CA 찾을 수 없음 ============"
    fi



    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # 인자가 추가되었기 때문에 2번 shift 합니다!!
    shift 2
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}
