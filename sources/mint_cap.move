module cascade_protocol::mint_cap;

use cascade_protocol::menu::Menu;
use sui::coin::Coin;
use sui::sui::SUI;

public struct MintCap<phantom T> {}

public fun new<T>(payment: Coin<SUI>, menu: &Menu): MintCap<T> {
    menu.assert_price_correct<T>(payment.value());

    transfer::public_transfer(
        payment,
        @cascade_treasury,
    );

    MintCap {}
}

public fun destroy<T>(self: MintCap<T>) {
    let MintCap {} = self;
}
