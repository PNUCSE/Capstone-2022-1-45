#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $6)
    local CP=$(one_line_pem $7)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${ORGDOMAIN}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${P1PORT}/$4/" \
        -e "s/\${CAPORT}/$5/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $6)
    local CP=$(one_line_pem $7)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${ORGDOMAIN}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${P1PORT}/$4/" \
        -e "s/\${CAPORT}/$5/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG=ManagementPeerOrg
ORGDOMAIN=management-peer-org
P0PORT=7051
P1PORT=8051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/management-peer-org.pnu.com/tlsca/tlsca.management-peer-org.pnu.com-cert.pem
CAPEM=organizations/peerOrganizations/management-peer-org.pnu.com/ca/ca.management-peer-org.pnu.com-cert.pem

echo "$(json_ccp $ORG $ORGDOMAIN $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/management-peer-org.pnu.com/connection-management-peer-org.json
echo "$(yaml_ccp $ORG $ORGDOMAIN $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/management-peer-org.pnu.com/connection-management-peer-org.yaml

ORG=RecClientPeerOrg
ORGDOMAIN=rec-client-peer-org
P0PORT=9051
P1PORT=10051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/rec-client-peer-org.pnu.com/tlsca/tlsca.rec-client-peer-org.pnu.com-cert.pem
CAPEM=organizations/peerOrganizations/rec-client-peer-org.pnu.com/ca/ca.rec-client-peer-org.pnu.com-cert.pem

echo "$(json_ccp $ORG $ORGDOMAIN $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/rec-client-peer-org.pnu.com/connection-rec-client-peer-org.json
echo "$(yaml_ccp $ORG $ORGDOMAIN $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/rec-client-peer-org.pnu.com/connection-rec-client-peer-org.yaml
