module hello_world::game {
    use std::string::String;
    use std::vector;

    use sui::object::{Self, ID, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::event;
    use sui::balance::{Self, Balance};
    use sui::sui::SUI;
    use hello_world::random;
    use sui::transfer;
    use std::string;
    use sui::coin::{Self, Coin};


    const EWrongAmount: u64 = 0;
    const EWrongParams: u64 = 1;

    struct Status has copy, drop {
        status: u8
    }

    struct ShareObject has key, store {
        id: UID,
        rand: random::Random,
        prize_pool: Balance<SUI>,
    }

    fun init(ctx: &mut TxContext) {
        sui::transfer::share_object(ShareObject {rand: random::new(b"seed", ctx), id: object::new(ctx), prize_pool: balance::zero<SUI>()})
    }

    public fun add_prize_pool(
        obj: &mut ShareObject,
        fee: Coin<SUI>,
    ) {
        assert!(coin::value(&fee) > 0, EWrongAmount);

        // add a payment to the LandRegistry balance
        balance::join(&mut obj.prize_pool, coin::into_balance(fee));

    }

    /// rock for 0, paper for 1, scissors for 2
    entry public fun play(
        shop: &mut ShareObject,
        user_gesture: u8,
        ctx: &mut TxContext
    ) {
        assert!(user_gesture == 0 || user_gesture == 1 || user_gesture == 2, EWrongParams);
        assert!(balance::value(&shop.prize_pool) > 0, EWrongAmount);
        let r = random::next_u8(&mut shop.rand);
        let npc_gesture = r % 3;
        /// 0 for lose, 1 for tie, 2 for win
        let status = if (user_gesture == 0) {
            if (npc_gesture == 0)  {
                1
            } else if (npc_gesture == 1) {
                0
            } else {
                2
            }
        } else if (user_gesture == 1){
            if (npc_gesture == 0)  {
                2
            } else if (npc_gesture == 1) {
                1
            } else {
                0
            }
        } else {
            if (npc_gesture == 0)  {
                0
            } else if (npc_gesture == 1) {
                2
            } else {
                1
            }

        };

        if (status == 2) {

            event::emit(Status {status: status });
            let b = balance::split(&mut shop.prize_pool, 100000);
            let c = coin::from_balance(b, ctx);
            transfer::public_transfer(c, tx_context::sender(ctx));
        }

    }


}
