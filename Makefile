.PHONY: test
.DEFAULT_GOAL := l 

# Variable
eth_rpc := https://speedy-nodes-nyc.moralis.io/cede2bf2868b0e93070abef2/eth/mainnet/archive

install:; yarn && forge install
clean:; rm -rf build/

# Utils
l:;		yarn lint && yarn build

# Forge
# test:; 		forge test
test:; forge test -vvv --fork-url $(eth_rpc) # For this project, by default.
test-fork-gas:; forge test -vvv --fork-url $(eth_rpc) --gas-report
coverage:; forge coverage -vvv --fork-url $(eth_rpc) 