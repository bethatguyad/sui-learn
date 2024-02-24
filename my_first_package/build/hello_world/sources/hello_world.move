// Copyright (c) 2022, Sui Foundation
// SPDX-License-Identifier: Apache-2.0

/// A basic Hello World example for Sui Move, part of the Sui Move intro course:
/// https://github.com/sui-foundation/sui-move-intro-course
/// 
module hello_world::hello_world {

    use std::{string};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};


    /// An object that contains an arbitrary string
    struct HelloWorldObject has key, store {
        id: UID,
        /// A string contained in the object
        text: string::String
    }

    struct Person has key, store {
        id: UID,
        name: string::String,
        city: string::String,
        age: u8,
        ty: string::String,
        date_of_birth: string::String

    }


    entry fun mint(ctx: &mut TxContext) {
        let object = HelloWorldObject {
            id: object::new(ctx),
            text: string::utf8(b"Hello World!")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }

    public entry fun create_person(name: vector<u8>, city: vector<u8>, age: u8, date_of_birth: vector<u8>, ctx: &mut TxContext) {
        let ty = if (age < 10) {
            string::utf8(b"too young")
        } else {
            string::utf8(b"too simple")
        };
        let object = Person {
            id: object::new(ctx),
            name: string::utf8(name),
            city: string::utf8(city),
            age: age,
            date_of_birth: string::utf8(date_of_birth),
            ty: ty
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }

}

