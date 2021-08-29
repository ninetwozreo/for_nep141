#!/bin/bash

# random
time=`date +%s`

# publisher/contract
# contract_name=$1
publisher=$1
default_publisher='shark.testnet'
publisher=${publisher:-$default_publisher}

contract_id="defi-1003.$publisher"
ftcontract_id="fttest-1005.$publisher"
pwd_path=`pwd`

cargo build --target wasm32-unknown-unknown --release

wasm_path="./target/wasm32-unknown-unknown/release/token_swap_testnet.wasm"

echo $wasm_path

# create sub-account



near create-account "$contract_id" --initialBalance 8 --masterAccount ${publisher}

# deploy contract
near deploy --accountId "$contract_id" --wasmFile "$wasm_path"   --initFunction new --initArgs  '{"fungible_token_account_id":"'${ftcontract_id}'"}'

# generate key
# res_key=`npx near generate-key`
# echo $res_key
# public_key=`echo $res_key | egrep -o 'ed25519:[A-Z0-9a-z]{44}'`
# echo $public_key

# # add key
# near add-key "$publisher" "$public_key" --contract-id "$contract_id" --allowance 100

# echo
echo "Contract:$contract_id published successfully."
