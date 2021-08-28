 
owner_id='shark.testnet'
another_id='shark1.testnet'

num="8"
nep1_contract_id="fttest-100${num}.shark.testnet"
nep2_contract_id="fttest-200${num}.shark.testnet"

defi_contract_id='defi-1003.shark.testnet'
#poke 0.2$
#near call  ${contract_id} poke   '{"token_price":"20000000"}' --account-id ${owner_id}


near call  ${nep1_contract_id}  register_account   '{"account":"'${owner_id}'"}' --account-id ${owner_id} --deposit 0.2
# near call  ${nep1_contract_id}  register_account   '{"account":"'${another_id}'"}' --account-id ${owner_id} --deposit 0.2
near call  ${nep1_contract_id}  register_account   '{"account":"'${defi_contract_id}'"}' --account-id ${owner_id} --deposit 0.2
near call  ${nep2_contract_id}  register_account   '{"account":"'${owner_id}'"}' --account-id ${owner_id} --deposit 0.2
# near call  ${nep2_contract_id}  register_account   '{"account":"'${another_id}'"}' --account-id ${owner_id} --deposit 0.2
near call  ${nep2_contract_id}  register_account   '{"account":"'${defi_contract_id}'"}' --account-id ${owner_id} --deposit 0.2
# add new nep-141 token 
near call  ${defi_contract_id}  add   '{"fungible_token_account_id":"'${nep1_contract_id}'"}' --account-id shark.testnet 
near call  ${defi_contract_id}  is_valid   '{"fungible_token_account_id":"'${nep1_contract_id}'"}' --account-id shark.testnet 
near call  ${defi_contract_id}  add   '{"fungible_token_account_id":"'${nep2_contract_id}'"}' --account-id shark.testnet 
near call  ${defi_contract_id}  is_valid   '{"fungible_token_account_id":"'${nep2_contract_id}'"}' --account-id shark.testnet 


# near call  ${nep1_contract_id}  ft_transfer_call   '{"fungible_token_account_id":"'${nep1_contract_id}'"}' --account-id shark.testnet --deposit 0.000000000000000000000001 --gas 100000000000000 
# call token transfer  
near call  ${nep1_contract_id}  ft_transfer_call   '{"receiver_id":"'${defi_contract_id}'","amount":"1000000000000000000000000","msg":"200000000000000000000000"}' --account-id shark.testnet --deposit 0.000000000000000000000001 --gas 100000000000000 
near call  ${nep2_contract_id}  ft_transfer_call   '{"receiver_id":"'${defi_contract_id}'","amount":"1000000000000000000000000","msg":"300000000000000000000000"}' --account-id shark.testnet --deposit 0.000000000000000000000001 --gas 100000000000000 

# near call  ${nep2_contract_id}  ft_transfer_call   '{"fungible_token_account_id":"'${nep1_contract_id}'"}' --account-id shark.testnet --deposit 0.000000000000000000000001 --gas 100000000000000 


# near call  ${contract_id}  register_account   '{"account":"'${owner_id}'"}' --account-id ${owner_id} --deposit 0.2
# near call  ${contract_id}  register_account   '{"account":"'${another_id}'"}' --account-id ${owner_id} --deposit 0.2
# near call  ${contract_id}  register_account   '{"account":"'${defi_contract_id}'"}' --account-id ${owner_id} --deposit 0.2


# near call  ${contract_id}  ft_balance_of   '{"account_id":"'${owner_id}'"}' --account-id ${owner_id} 

# near call  ${contract_id}  internal_deposit   '{"account_id":"'${owner_id}'","amount":"10000000000000"}' --account-id ${owner_id} 
# near call  ${contract_id}  ft_balance_of   '{"account_id":"'${another_id}'"}' --account-id ${owner_id} 
# near call  ${contract_id}  ft_transfer   '{"receiver_id":"'${another_id}'","amount":"1"}' --account-id ${owner_id} --deposit 0.2
# near call  ${contract_id}  ft_transfer_call   '{"receiver_id":"'${another_id}'","amount":"100000000000000000000000","msg":"刘哥还钱"}' --account-id shark.testnet --deposit 0.000000000000000000000001 --gas 100000000000000 

# near call  ${contract_id}  ft_transfer_call   '{"receiver_id":"defi-1001.shark.testnet","amount":"100000000000000000000000","msg":"100000"}' --account-id ${owner_id} --deposit 0.000000000000000000000001 --gas 100000000000000 

 

 
