set -e

sudo rm -rf ../crypto-config/* ../configuration/channel_blocks/*
sleep 5
../bin/cryptogen generate --config=../configuration/building_files/config.yaml --output=../crypto-config/.

SYS_CHANNEL="sys-channel"
MY_CHANNEL="bdgka-channel"

../bin/configtxgen -profile OrdererGenesis -configPath ../configuration/building_files/. -channelID $SYS_CHANNEL -outputBlock ../configuration/channel_blocks/genesis.block
../bin/configtxgen -profile BasicChannel -configPath ../configuration/building_files/. -outputCreateChannelTx ../configuration/channel_blocks/${MY_CHANNEL}.tx -channelID $MY_CHANNEL

../bin/configtxgen -profile BasicChannel -configPath ../configuration/building_files/. -outputAnchorPeersUpdate ../configuration/channel_blocks/Org1MSPanchors.tx -channelID $MY_CHANNEL -asOrg Org1MSP
