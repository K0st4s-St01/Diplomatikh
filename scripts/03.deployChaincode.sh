set -e

export CORE_PEER_TLS_ENABLED=true
Directory=${PWD}/..
export ORDERER_CA=${Directory}/crypto-config/ordererOrganizations/kstoi.com/orderers/orderer.kstoi.com/msp/tlscacerts/tlsca.kstoi.com-cert.pem
export PEER0_ORG1_CA=${Directory}/crypto-config/peerOrganizations/org1.kstoi.com/peers/peer0.org1.kstoi.com/tls/ca.crt
export FABRIC_CFG_PATH=${Directory}/configuration/building_files
CHANNEL_NAME="bdgka-channel"

setGlobalsForPeer0Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${Directory}/crypto-config/peerOrganizations/org1.kstoi.com/users/Admin@org1.kstoi.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Org1(){
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${Directory}/crypto-config/peerOrganizations/org1.kstoi.com/users/Admin@org1.kstoi.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0Org1
../bin/peer lifecycle chaincode install bdgka_chaincode.tar.gz
# setGlobalsForPeer1Org1
# ../bin/peer lifecycle chaincode install bdgka_chaincode.tar.gz