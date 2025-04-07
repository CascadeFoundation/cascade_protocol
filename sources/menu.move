module cascade_protocol::menu;

use cascade_protocol::admin::AdminCap;
use std::type_name::{Self, TypeName};
use sui::table::{Self, Table};

//=== Structs ===

public struct MENU has drop {}

public struct Menu has key, store {
    id: UID,
    prices: Table<TypeName, u64>,
}

public struct MenuAdminCap has key, store {
    id: UID,
}

const EIncorrectPrice: u64 = 0;
const EIncorrectPaymentValue: u64 = 1;

//=== Init Function ===

fun init(_otw: MENU, ctx: &mut TxContext) {
    let menu = Menu {
        id: object::new(ctx),
        prices: table::new(ctx),
    };

    transfer::public_share_object(menu);
}

//=== Public Functions ===

public fun add_price<T>(self: &mut Menu, _: &AdminCap, price: u64) {
    self.prices.add(type_name::get<T>(), price);
}

public fun remove_price<T>(self: &mut Menu, _: &AdminCap) {
    self.prices.remove(type_name::get<T>());
}

//=== View Functions ===

public fun price<T>(self: &Menu): u64 {
    *self.prices.borrow(type_name::get<T>())
}

//=== Assertions ===

public(package) fun assert_correct_payment_value<T>(
    self: &Menu,
    quantity: u64,
    payment_value: u64,
) {
    assert!(quantity * self.price<T>() == payment_value, EIncorrectPaymentValue);
}
