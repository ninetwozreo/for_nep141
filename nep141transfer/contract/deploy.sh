#!/bin/bash

# random
time=`date +%s`

# publisher/contract
# contract_name=$1
publisher=$1
default_publisher='shark.testnet'
publisher=${publisher:-$default_publisher}

num='8'
ftcontract_id="fttest-100${num}.$publisher"
ftcontract1_id="fttest-200${num}.$publisher"
pwd_path=`pwd`

cargo build --target wasm32-unknown-unknown --release

wasm_path="./target/wasm32-unknown-unknown/release/token_swap_testnet.wasm"

echo $wasm_path

# create sub-account



near create-account "$ftcontract_id" --initialBalance 8 --masterAccount ${publisher}

# deploy contract
near deploy --accountId "$ftcontract_id" --wasmFile "$wasm_path"   --initFunction new_default_meta --initArgs  '{"owner_id":"'${publisher}'","fungible_token_account_id":"'${ftcontract_id}'","ssymbol":"eth-'${time}'","sname":"eth_name-'${time}'","total_supply":"10000000000000000000000000000000"}'


echo "Contract:$ftcontract_id published successfully."

near create-account "$ftcontract1_id" --initialBalance 8 --masterAccount ${publisher}

# deploy contract
near deploy --accountId "$ftcontract1_id" --wasmFile "$wasm_path"   --initFunction new_default_meta --initArgs  '{"owner_id":"'${publisher}'","fungible_token_account_id":"'${ftcontract_id}'","ssymbol":"btc-'${time}'","sname":"btc-'${time}'","total_supply":"10000000000000000000000000000000"}'


echo "Contract:$ftcontract1_id published successfully."
