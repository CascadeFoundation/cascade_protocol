module cascade_protocol::mint_cap;

use cascade_protocol::menu::Menu;
use std::type_name::{Self, TypeName};
use sui::coin::Coin;
use sui::sui::SUI;

public struct MintCap has drop {
    dos_type: TypeName,
}

public fun new<T>(payment: Coin<SUI>, menu: &Menu): MintCap {
    menu.assert_price_correct<T>(payment.value());

    transfer::public_transfer(
        payment,
        @cascade_treasury,
    );

    MintCap {
        dos_type: type_name::get<T>(),
    }
}
