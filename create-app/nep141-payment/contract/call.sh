 
owner_id='shark.testnet'
contract_id='fttest-1005.shark.testnet'
#poke 0.2$
#near call  ${contract_id} poke   '{"token_price":"20000000"}' --account-id ${owner_id}


near call  ${contract_id}  register_account   '{"account":"'${owner_id}'"}' --account-id shark.testnet --deposit 0.2
near call  ${contract_id}  register_account   '{"account":"shakou.testnet"}' --account-id shark.testnet --deposit 0.2

near call  ${contract_id}  ft_balance_of   '{"account_id":"'${owner_id}'"}' --account-id shark.testnet 

near call  ${contract_id}  internal_deposit   '{"account_id":"'${owner_id}'","amount":"10000000000000"}' --account-id shark.testnet 
near call  ${contract_id}  ft_balance_of   '{"account_id":"shakou.testnet"}' --account-id shark.testnet 
near call  ${contract_id}  ft_transfer   '{"receiver_id":"shakou.testnet","amount":"1"}' --account-id shark.testnet --deposit 0.2
near call  ${contract_id}  ft_transfer_call   '{"receiver_id":"shakou.testnet","amount":"100000000000000000000000","msg":"刘哥还钱"}' --account-id shark.testnet --deposit 0.000000000000000000000001 --gas 100000000000000 

# #register_account
near call  ${contract_id}  test_new   '{"account":"'${owner_id}'"}' --account-id shark.testnet --deposit 0.2
# view_methods
# get_available_token
near call  ${contract_id} get_available_token   '{"account":"'${owner_id}'"}' --account-id shark.testnet
# # get_associated_contract
# near call  ${contract_id} get_associated_contract   '{}' --account-id shark.testnet
# echo "设置为"

# #is_register
# near call  ${contract_id} is_register   '{"account":"'${owner_id}'"}' --account-id shark.testnet

# #get_owner
# near call  ${contract_id} get_owner   '{}' --account-id ${owner_id}

# #internal_mint
# near call  ${contract_id} internal_mint   '{"account_id":"'${owner_id}'","amount":"3"}' --account-id ${contract_id}
 

 
