set -e

sudo rm -rf ../crypto-config/* ../configuration/channel_blocks/*
sleep 5
../bin/cryptogen generate --config=../configuration/building_files/config.yaml --output=../crypto-config/.

MY_CHANNEL="bdgka-channel"

../bin/configtxgen -profile AppChannel -configPath ../configuration/building_files/. -outputBlock ../configuration/channel_blocks/${MY_CHANNEL}.block -channelID $MY_CHANNEL

../bin/configtxgen -profile AppChannel -configPath ../configuration/building_files/. -outputAnchorPeersUpdate ../configuration/channel_blocks/Org1MSPanchors.tx -channelID $MY_CHANNEL -asOrg Org1MSP
