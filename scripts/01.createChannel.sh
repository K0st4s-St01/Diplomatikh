set -e
export CORE_PEER_TLS_ENABLED=true
Directory=${PWD}/..
export ORDERER_CA=${Directory}/crypto-config/ordererOrganizations/kstoi.com/orderers/orderer.kstoi.com/msp/tlscacerts/tlsca.kstoi.com-cert.pem
export PEER0_ORG1_CA=${Directory}/crypto-config/peerOrganizations/org1.kstoi.com/peers/peer0.org1.kstoi.com/tls/ca.crt
export FABRIC_CFG_PATH=${Directory}/configuration/building_files
CHANNEL_NAME="bdgka-channel"
export ORDERER_ADMIN_TLS_CERT=${Directory}/crypto-config/ordererOrganizations/kstoi.com/orderers/orderer.kstoi.com/tls/server.crt
export ORDERER_ADMIN_TLS_KEY=${Directory}/crypto-config/ordererOrganizations/kstoi.com/orderers/orderer.kstoi.com/tls/server.key

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
    echo "initializing channel"
    setGlobalsForPeer0Org1

    ../bin/peer channel create -o localhost:7050 \
      -c $CHANNEL_NAME \
      -f ../configuration/channel_blocks/bdgka-channel.block \
      --tls --cafile $ORDERER_CA \
      --ordererTLSHostnameOverride orderer.kstoi.com
}

joinChannel(){
    echo "joining channel"
    setGlobalsForPeer0Org1
    ../bin/peer channel join -b ../configuration/channel_blocks/$CHANNEL_NAME.block

    setGlobalsForPeer1Org1
    ../bin/peer channel join -b ../configuration/channel_blocks/$CHANNEL_NAME.block
}

# updatePeers(){
#     echo "updating peers"
#     setGlobalsForPeer0Org1
#     ../bin/peer channel update -o localhost:7050 \
#       --ordererTLSHostnameOverride orderer.kstoi.com \
#       -c $CHANNEL_NAME \
#       -f ../configuration/channel_blocks/Org1MSPanchors.tx \
#       --tls --cafile $ORDERER_CA
# }

# bring containers down/up then wait for orderer to be ready
docker-compose -f ../artifacts/docker-compose.yaml down
docker-compose -f ../artifacts/docker-compose.yaml up -d

# wait for orderer to come up (watch logs in parallel if you want)
echo "Waiting 5s for orderer to start..."
sleep 5

createChannel


../bin/osnadmin channel join \
  --channelID $CHANNEL_NAME \
 --ca-file=$ORDERER_CA \
  --config-block=../configuration/channel_blocks/bdgka-channel.block \
  -o localhost:8443 
# create channel
# createChannel
# sleep 5

# join peers
echo "joining channel"
joinChannel
# leep 5

# update peers anchors
# echo "updating peers"
# updatePeers
sleep 5

# join orderer via osnadmin: use plaintext if operations TLS disabled

echo "done"
