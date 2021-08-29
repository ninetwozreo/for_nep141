/*!
Some hypothetical DeFi contract that will do smart things with the transferred tokens
*/

use near_contract_standards::fungible_token::receiver::FungibleTokenReceiver;
use near_sdk::borsh::{self, BorshDeserialize, BorshSerialize};
use near_sdk::json_types::{ValidAccountId, U128};
use near_sdk::collections::*;
use near_sdk::{  
    env, ext_contract, log, near_bindgen, setup_alloc, AccountId, Balance, Gas, PanicOnDefault,
    PromiseOrValue,
};

setup_alloc!();

const BASE_GAS: Gas = 5_000_000_000_000;
const PROMISE_CALL: Gas = 5_000_000_000_000;
const GAS_FOR_FT_ON_TRANSFER: Gas = BASE_GAS + PROMISE_CALL;

const NO_DEPOSIT: Balance = 0;
const MAX_TOKEN_NUM: u128 = 20;

// If the name is not provided, the namespace for generated methods in derived by applying snake
// case to the trait name, e.g. ext_status_message.
#[ext_contract]
pub trait ExtTransfer {
    fn register_account(&mut self, account: AccountId);
    fn ft_transfer_call(&mut self,
        receiver_id: AccountId,
        amount: U128,
        memo: Option<String>,
        msg: String,
    ) -> PromiseOrValue<U128>;
}

#[near_bindgen]
#[derive(BorshDeserialize, BorshSerialize, PanicOnDefault)]
pub struct DeFi {
    fungible_token_account_id: AccountId,
    tokens: LookupMap<ValidAccountId, u128>,
    token_list: Vec<ValidAccountId>
}

// Defining cross-contract interface. This allows to create a new promise.
#[ext_contract(ext_self)]
pub trait ValueReturnTrait {
    fn value_please(&self, amount_to_return: String) -> PromiseOrValue<U128>;
}

// Have to repeat the same trait for our own implementation.
trait ValueReturnTrait {
    fn value_please(&self, amount_to_return: String) -> PromiseOrValue<U128>;
}

#[near_bindgen]
impl DeFi {
    #[init]
    pub fn new(fungible_token_account_id: ValidAccountId) -> Self {
        assert!(!env::state_exists(), "Already initialized");
        Self { 
            fungible_token_account_id: fungible_token_account_id.into(),
            tokens: LookupMap::new(b"tokens".to_vec()), 
            token_list: Vec::new(),
        }
    }

    pub fn add(&mut self,fungible_token_account_id: ValidAccountId) {
        assert!(!self.tokens.contains_key(&fungible_token_account_id), "token already added!");
        let token_count = self.token_list.len() + 1;
        assert!(token_count as u128 <= MAX_TOKEN_NUM, "token count exceeds");
        ext_transfer::register_account(env::current_account_id(), &fungible_token_account_id, 1000000000000000000000000 as u128, env::prepaid_gas() / 3);
        // assert!(!self.tokens.(&fungible_token_account_id), "token already added!");
        self.tokens.insert(
            &fungible_token_account_id,
            &1,
        );
        self.token_list.push(fungible_token_account_id.clone());
        // Self { fungible_token_account_id: fungible_token_account_id.into(),tokens: LookupMap::new(b"tokens".to_vec()), }
    }

    pub fn is_valid(&self,fungible_token_account_id: ValidAccountId) ->bool {
        // assert!(!env::state_exists(), "Already initialized");
        self.tokens.contains_key(&fungible_token_account_id)
        // Self { fungible_token_account_id: fungible_token_account_id.into(),tokens: LookupMap::new(b"tokens".to_vec()), }
    }

    pub fn list(&self) -> Vec<ValidAccountId> {
        // assert!(!env::state_exists(), "Already initialized");
        // self.tokens.contains_key(&fungible_token_account_id)
        self.token_list.clone()
        // Self { fungible_token_account_id: fungible_token_account_id.into(),tokens: LookupMap::new(b"tokens".to_vec()), }
    }

    #[payable]
    pub fn transfer(&mut self, receiver_id: ValidAccountId, amount: U128, fungible_token_account_id: ValidAccountId) {
        ext_transfer::register_account(env::predecessor_account_id(), &fungible_token_account_id, u128::from(amount), env::prepaid_gas() / 4).then(
            ext_transfer::ft_transfer_call(
                env::current_account_id(),
                amount,
                Option::None,
                "".to_string(),
                &fungible_token_account_id,
                1 as u128,
                env::prepaid_gas() / 4
            ).then(
                ext_transfer::ft_transfer_call(
                    receiver_id.to_string(),
                    amount,
                    Option::None,
                    "".to_string(),
                    &fungible_token_account_id,
                    1 as u128,
                    env::prepaid_gas() / 4
                ),
            )
        );
    }
}

#[near_bindgen]
impl FungibleTokenReceiver for DeFi {
    /// If given `msg: "take-my-money", immediately returns U128::From(0)
    /// Otherwise, makes a cross-contract call to own `value_please` function, passing `msg`
    /// value_please will attempt to parse `msg` as an integer and return a U128 version of it
    fn ft_on_transfer(
        &mut self,
        sender_id: ValidAccountId,
        amount: U128,
        msg: String,
    ) -> PromiseOrValue<U128> { 
        // Verifying that we were called by fungible token contract that we expect.
        
        assert!(!self.tokens.contains_key(&sender_id), "token should be added first!");

        log!("in {} tokens from @{} ft_on_transfer, msg = {}", amount.0, sender_id.as_ref(), msg);
        match msg.as_str() {
            "take-my-money" => PromiseOrValue::Value(U128::from(0)),
            _ => {
                let prepaid_gas = env::prepaid_gas();
                let account_id = env::current_account_id();
                ext_self::value_please(
                    msg,
                    &account_id,
                    NO_DEPOSIT,
                    prepaid_gas - GAS_FOR_FT_ON_TRANSFER,
                )
                .into()
            }
        }
    }
}

#[near_bindgen]
impl ValueReturnTrait for DeFi {
    fn value_please(&self, amount_to_return: String) -> PromiseOrValue<U128> {
        log!("in value_please, amount_to_return = {}", amount_to_return);
        let amount: Balance = amount_to_return.parse().expect("Not an integer");
        PromiseOrValue::Value(amount.into())
    }
}