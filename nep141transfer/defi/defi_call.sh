#!/bin/bash

# random
time=`date +%s`

# publisher/contract
# contract_name=$1
publisher=$1
default_publisher='shark.testnet'
publisher=${publisher:-$default_publisher}

contract_id="defi-1002.$publisher"
ftcontract_id="fttest-1005.$publisher"
pwd_path=`pwd`


near call  ${contract_id}  ft_transfer_call   '{"fungible_token_account_id":"fttest-1005.shark.testnet"}' --account-id shark.testnet --deposit 0.000000000000000000000001 --gas 100000000000000 

# create sub-account



