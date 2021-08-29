pub use near_sdk::json_types::{Base64VecU8, ValidAccountId, WrappedDuration, U64};
use near_sdk_sim::{call, view, deploy, init_simulator, ContractAccount, UserAccount};
use token_swap_testnet::DefiContract;
use token_swap_testnet::{*};
use near_sdk::json_types::{U128};
use near_sdk_sim::to_yocto;

near_sdk_sim::lazy_static_include::lazy_static_include_bytes! {
    COUNTER_BYTES => "../target/wasm32-unknown-unknown/release/token-swap-testnet.wasm",
}

pub const DEFAULT_GAS: u64 = 300_000_000_000_000;

fn init() -> (UserAccount, ContractAccount<DefiContract>) {
    let root = init_simulator(None);
    let roulette: ContractAccount<DefiContract> = deploy!(
        contract: DefiContract,
        contract_id: "contract",
        bytes: &COUNTER_BYTES,
        signer_account: root
    );

    

    (root, roulette)
}

#[test]
fn simulate() {
    let (root, roulette) = init();

    let alice = root.create_user(
        "alice".parse().unwrap(),
        to_yocto("10000")// initial balance

    );

    let bob = root.create_user(
        "bob".parse().unwrap(),
        to_yocto("10000")// initial balance
    );

    call!(
        root,
        roulette.new()
    ).assert_success();
    // Get number on account that hasn't incremented or decremented
    
}