SHELL := /bin/bash

# Makefile

.PHONY: install build deploy dd

install:
	@echo "Installing dependencies..."
	forge install

build:
	@echo "Building project..."
	forge build


deploy-sourcify:
	forge script script/DeployMinimal.s.sol:DeployMinimal --rpc-url buildbear --verifier sourcify --verify --verifier-url https://rpc.buildbear.io/verify/sourcify/server/{SANDBOX_ID} -vvvv --broadcast

deploy-etherscan:
	forge script script/DeployMinimal.s.sol:DeployMinimal --rpc-url buildbear --etherscan-api-key "verifyContract" --verifier-url "https://rpc.buildbear.io/verify/etherscan/{SANDBOX_ID}" --broadcast --verify

# cast-send-failing-tx:
	
# /*
# Etherscan - after contract deployment
# forge verify-contract --flatten --watch --constructor-args $(cast abi-encode "constructor(address,address)" "0xD5f930f156541e33F7d8b83da6ad84B4B1775aAc" "0x0000000071727De22E5E9d8BAf0edAc6f37da032") 0x0b781184693288d0Db306ebF41C5Aee82d56D752 MinimalAccount --etherscan-api-key "verifyContract" --verifier-url "https://rpc.buildbear.io/verify/etherscan/{SANDBOX_ID}" 
# */

# /*
# forge verify-contract --flatten --watch --constructor-args $(cast abi-encode "constructor(address,address)" 0xD5f930f156541e33F7d8b83da6ad84B4B1775aAc 0x0000000071727De22E5E9d8BAf0edAc6f37da032) 0x0b781184693288d0Db306ebF41C5Aee82d56D752 MinimalAccount --verifier sourcify --verifier-url  https://rpc.buildbear.io/verify/sourcify/server/{SANDBOX_ID}
# */



# cast call 0x00B7Df58FE280C109121936D0B4c3eE3b67E4be4 --data 0xb61d27f6000000000000000000000000a72e562f24515c060f36a2da07e0442899d39d2c0000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000440f8865c30000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 --value 1000000000000000000 --private-key $PRIVATE_KEY  --rpc-url https://rpc.buildbear.io/{SANDBOX_ID} -vvvv
