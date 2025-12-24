GOFLAGS=-mod=vendor go mod vendor -C ../chaincode/bdgka-chaincode
../bin/peer lifecycle chaincode package bdgka_chaincode.tar.gz --path ../chaincode/bdgka-chaincode --lang golang --label bdgka