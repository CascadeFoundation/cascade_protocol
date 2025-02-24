module cascade_protocol::treasury;

use cascade_protocol::admin::AdminCap;
use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};
use sui::sui::SUI;

//=== Structs ===

public struct TREASURY has drop {}

public struct Treasury has key, store {
    id: UID,
    balance: Balance<SUI>,
}

//=== Init Function ===

fun init(_otw: TREASURY, ctx: &mut TxContext) {
    let treasury = Treasury {
        id: object::new(ctx),
        balance: balance::zero(),
    };

    transfer::public_share_object(treasury);
}

//=== Public Functions ===

entry fun new(_: &AdminCap, ctx: &mut TxContext) {
    let treasury = Treasury {
        id: object::new(ctx),
        balance: balance::zero(),
    };

    transfer::public_share_object(treasury);
}

public fun pay(self: &mut Treasury, coin: Coin<SUI>) {
    self.balance.join(coin.into_balance());
}

public fun withdraw(
    self: &mut Treasury,
    _: &AdminCap,
    amount: Option<u64>,
    ctx: &mut TxContext,
): Coin<SUI> {
    let amount = amount.destroy_or!(self.balance.value());
    let balance = self.balance.split(amount);
    let coin = coin::from_balance(balance, ctx);

    coin
}

//=== View Functions ===

public fun balance(self: &Treasury): &Balance<SUI> {
    &self.balance
}
