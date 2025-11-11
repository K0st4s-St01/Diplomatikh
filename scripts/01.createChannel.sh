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

createChannel(){
    setGlobalsForPeer0Org1
    
    ../bin/peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.kstoi.com \
    -f ../configuration/channel_blocks/${CHANNEL_NAME}.tx --outputBlock ../configuration/channel_blocks/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

}

joinChannel(){
    setGlobalsForPeer0Org1
    ../bin/peer channel join -b ../configuration/channel_blocks/$CHANNEL_NAME.block
    
    setGlobalsForPeer1Org1
    ../bin/peer channel join -b ../configuration/channel_blocks/$CHANNEL_NAME.block

}
updatePeers(){
    setGlobalsForPeer0Org1
    ../bin/peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.kstoi.com -c $CHANNEL_NAME -f ../configuration/channel_blocks/Org1MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}
# removeOldCrypto(){
#     #to be implemented
# }
docker-compose -f ../artifacts/docker-compose.yaml down
docker-compose -f ../artifacts/docker-compose.yaml up -d
sleep 5
echo "creating channel"
createChannel
sleep 5
echo "joining channel"
joinChannel
sleep 5
echo "updating peers"
updatePeers
sleep 5