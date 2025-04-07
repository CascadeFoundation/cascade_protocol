module cascade_protocol::mint_cap;

use cascade_protocol::menu::Menu;
use cascade_protocol::treasury::Treasury;
use sui::coin::Coin;
use sui::sui::SUI;

public struct MintCap<phantom T> {}

public fun new<T>(payment: Coin<SUI>, menu: &Menu, treasury: &mut Treasury): MintCap<T> {
    menu.assert_correct_payment_value<T>(1, payment.value());
    treasury.deposit(payment);
    internal_new<T>()
}

public fun new_bulk<T>(
    payment: Coin<SUI>,
    quantity: u64,
    menu: &Menu,
    treasury: &mut Treasury,
): vector<MintCap<T>> {
    menu.assert_correct_payment_value<T>(quantity, payment.value());
    treasury.deposit(payment);
    vector::tabulate!(quantity, |_| internal_new<T>())
}

public fun destroy<T>(self: MintCap<T>) {
    let MintCap {} = self;
}

fun internal_new<T>(): MintCap<T> {
    MintCap {}
}
