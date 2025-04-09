module cascade_protocol::treasury;

use cascade_protocol::admin::AdminCap;
use sui::balance::{Self, Balance};
use sui::coin::{Self, Coin};
use sui::sui::SUI;
use sui::vec_set::{Self, VecSet};

//=== Structs ===

public struct TREASURY has drop {}

public struct Treasury has key, store {
    id: UID,
    balance: Balance<SUI>,
}

public struct TreasuryManager has key, store {
    id: UID,
    treasury_ids: VecSet<ID>,
}

//=== Init Function ===

fun init(_otw: TREASURY, ctx: &mut TxContext) {
    let treasury = Treasury {
        id: object::new(ctx),
        balance: balance::zero(),
    };

    let mut treasury_manager = TreasuryManager {
        id: object::new(ctx),
        treasury_ids: vec_set::empty(),
    };

    treasury_manager.treasury_ids.insert(treasury.id.to_inner());

    transfer::public_share_object(treasury);
    transfer::public_share_object(treasury_manager);
}

//=== Public Functions ===

// Create a new Treasury objects.
// Useful for load balancing deposits across multiple Treasury objects.
public fun new(_: &AdminCap, manager: &mut TreasuryManager, ctx: &mut TxContext) {
    let treasury = Treasury {
        id: object::new(ctx),
        balance: balance::zero(),
    };

    manager.treasury_ids.insert(treasury.id.to_inner());

    transfer::public_share_object(treasury);
}

// Destroy a Treasury object, and unregister it from the TreasuryManager.
public fun destroy(self: Treasury, manager: &mut TreasuryManager, ctx: &mut TxContext): Coin<SUI> {
    manager.treasury_ids.remove(&self.id.to_inner());

    let Treasury { id, balance } = self;
    id.delete();

    coin::from_balance(balance, ctx)
}

// Withdraw SUI from the Treasury.
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

// Deposit SUI into the Treasury.
public(package) fun deposit(self: &mut Treasury, coin: Coin<SUI>) {
    self.balance.join(coin.into_balance());
}

//=== View Functions ===

public fun balance(self: &Treasury): &Balance<SUI> {
    &self.balance
}
