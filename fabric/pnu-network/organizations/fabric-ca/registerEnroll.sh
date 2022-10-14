

function createManagementPeerOrg {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/management-peer-org.pnu.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-management-peer-org --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-management-peer-org.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-management-peer-org.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-management-peer-org.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-management-peer-org.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-management-peer-org --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-management-peer-org --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-management-peer-org --id.name management-peer-orgadmin --id.secret management-peer-orgadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/management-peer-org.pnu.com/peers
  mkdir -p organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-management-peer-org -M ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/msp --csr.hosts peer0.management-peer-org.pnu.com --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-management-peer-org -M ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls --enrollment.profile tls --csr.hosts peer0.management-peer-org.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/tlsca/tlsca.management-peer-org.pnu.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/ca
  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer0.management-peer-org.pnu.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/ca/ca.management-peer-org.pnu.com-cert.pem

  mkdir -p organizations/peerOrganizations/management-peer-org.pnu.com/users
  mkdir -p organizations/peerOrganizations/management-peer-org.pnu.com/users/User1@management-peer-org.pnu.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-management-peer-org -M ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/users/User1@management-peer-org.pnu.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/management-peer-org.pnu.com/users/Admin@management-peer-org.pnu.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://management-peer-orgadmin:management-peer-orgadminpw@localhost:7054 --caname ca-management-peer-org -M ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/users/Admin@management-peer-org.pnu.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/users/Admin@management-peer-org.pnu.com/msp/config.yaml


  echo
	echo "Register peer1"
  echo
  set -x
	fabric-ca-client register --caname ca-management-peer-org --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com

  echo
  echo "## Generate the peer1 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-management-peer-org -M ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/msp --csr.hosts peer1.management-peer-org.pnu.com --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-management-peer-org -M ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls --enrollment.profile tls --csr.hosts peer1.management-peer-org.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/management-peer-org/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/management-peer-org.pnu.com/peers/peer1.management-peer-org.pnu.com/tls/server.key

}


function createRecClientPeerOrg {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/rec-client-peer-org.pnu.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-rec-client-peer-org --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: intermediatecerts/localhost-8054-ca-rec-client-peer-org.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: intermediatecerts/localhost-8054-ca-rec-client-peer-org.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: intermediatecerts/localhost-8054-ca-rec-client-peer-org.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: intermediatecerts/localhost-8054-ca-rec-client-peer-org.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-rec-client-peer-org --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-rec-client-peer-org --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-rec-client-peer-org --id.name rec-client-peer-orgadmin --id.secret rec-client-peer-orgadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers
  mkdir -p organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-rec-client-peer-org -M ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/msp --csr.hosts peer0.rec-client-peer-org.pnu.com --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-rec-client-peer-org -M ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls --enrollment.profile tls --csr.hosts peer0.rec-client-peer-org.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/tlsintermediatecerts/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/tlsintermediatecerts/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/tls/tlsintermediatecerts/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/tlsca/tlsca.rec-client-peer-org.pnu.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/ca
  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer0.rec-client-peer-org.pnu.com/msp/intermediatecerts/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/ca/ca.rec-client-peer-org.pnu.com-cert.pem

  mkdir -p organizations/peerOrganizations/rec-client-peer-org.pnu.com/users
  mkdir -p organizations/peerOrganizations/rec-client-peer-org.pnu.com/users/User1@rec-client-peer-org.pnu.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-rec-client-peer-org -M ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/users/User1@rec-client-peer-org.pnu.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/rec-client-peer-org.pnu.com/users/Admin@rec-client-peer-org.pnu.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://rec-client-peer-orgadmin:rec-client-peer-orgadminpw@localhost:8054 --caname ca-rec-client-peer-org -M ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/users/Admin@rec-client-peer-org.pnu.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/users/Admin@rec-client-peer-org.pnu.com/msp/config.yaml


  echo
	echo "Register peer1"
  echo
  set -x
	fabric-ca-client register --caname ca-rec-client-peer-org --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com

  echo
  echo "## Generate the peer1 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-rec-client-peer-org -M ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/msp --csr.hosts peer1.rec-client-peer-org.pnu.com --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-rec-client-peer-org -M ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls --enrollment.profile tls --csr.hosts peer1.rec-client-peer-org.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/rec-client-peer-org/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls/tlsintermediatecerts/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/rec-client-peer-org.pnu.com/peers/peer1.rec-client-peer-org.pnu.com/tls/server.key

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/pnu.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/pnu.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/pnu.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/pnu.com/orderers
  mkdir -p organizations/ordererOrganizations/pnu.com/orderers/pnu.com

  mkdir -p organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/msp --csr.hosts orderer.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/pnu.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls --enrollment.profile tls --csr.hosts orderer.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/msp/tlscacerts/tlsca.pnu.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/pnu.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer.pnu.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/msp/tlscacerts/tlsca.pnu.com-cert.pem

  mkdir -p organizations/ordererOrganizations/pnu.com/users
  mkdir -p organizations/ordererOrganizations/pnu.com/users/Admin@pnu.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pnu.com/users/Admin@pnu.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/pnu.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/pnu.com/users/Admin@pnu.com/msp/config.yaml










  echo
	echo "Register orderer2"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "## Generate the orderer2 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/msp --csr.hosts orderer2.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo
	echo "orderer2 mkdir & cp"
  echo
  mkdir -p organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/tls --enrollment.profile tls --csr.hosts orderer2.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo
	echo "orderer2 cp"
  echo
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/tls/server.key

  echo
	echo "orderer2 mkdir & cp"
  echo
  mkdir ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer2.pnu.com/msp/tlscacerts/tlsca.pnu.com-cert.pem

  echo
	echo "Register orderer3"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  mkdir -p organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com
  
  echo
  echo "## Generate the orderer3 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/msp --csr.hosts orderer3.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/pnu.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/tls --enrollment.profile tls --csr.hosts orderer3.pnu.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/pnu.com/orderers/orderer3.pnu.com/msp/tlscacerts/tlsca.pnu.com-cert.pem





}
