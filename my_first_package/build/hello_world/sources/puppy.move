module hello_world::puppy {
    use std::string::String;
    use std::vector;

    use sui::object::{Self, ID, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::event;
    use hello_world::random;
    use sui::transfer;
    use std::string;


    struct ShareObject has key, store {
        id: UID,
        rand: random::Random
    }
    /// An example NFT that can be minted by anybody. A Puppy is
    /// a freely-transferable object. Owner can add new traits to
    /// their puppy at any time and even change the image to the
    /// puppy's liking.
    struct Puppy has key, store {
        id: UID,
        /// Name of the Puppy
        name: String,
        /// The URL of the Puppy's image
        url: String,
        /// rarity , Legend, Common, Rare
        rarity: String
    }

    /// Event: emitted when a new Puppy is minted.
    struct PuppyMinted has copy, drop {
        /// ID of the Puppy
        puppy_id: ID,
        /// The address of the NFT minter
        minted_by: address,
    }

    fun init(ctx: &mut TxContext) {
        // Share the object to make it accessible to everyone!
        sui::transfer::share_object(ShareObject {rand: random::new(b"seed", ctx), id: object::new(ctx)})
        
    }

    /// Mint a new Puppy with the given `name`, `traits` and `url`.
    /// The object is returned to sender and they're free to transfer
    /// it to themselves or anyone else.
    entry public fun mint(
        shop: &mut ShareObject,
        name: String,
        url: String,
        ctx: &mut TxContext
    ) {
        let id = object::new(ctx);
        let r = random::next_u8(&mut shop.rand);
        event::emit(PuppyMinted {
            puppy_id: object::uid_to_inner(&id),
            minted_by: tx_context::sender(ctx),
        });
        let rarity = if (r < 200) {
            b"Common"
        } else if (r < 250) {
            b"Rare"
        } else {
            b"Legend"
        };
        let puppy = Puppy { id, name, url, rarity: string::utf8(rarity) };
        transfer::public_transfer(puppy, tx_context::sender(ctx));
    }

    /// As the puppy grows, owners can change the image to reflect
    /// the puppy's current state and look.
    public fun set_url(puppy: &mut Puppy, url: String) {
        puppy.url = url;
    }

    /// It's a good practice to allow the owner to destroy the NFT
    /// and get a storage rebate. Not a requirement and depends on
    /// your use case. At last, who doesn't love puppies?
    public fun destroy(puppy: Puppy) {
        let Puppy { id, url: _, name: _, rarity: _ } = puppy;
        object::delete(id);
    }

    // Getters for properties.
    // Struct fields are always private and unless there's a getter,
    // other modules can't access them. It's up to the module author
    // to decide which fields to expose and which to keep private.

    /// Get the Puppy's `name`
    public fun name(puppy: &Puppy): String { puppy.name }


    /// Get the Puppy's `url`
    public fun url(puppy: &Puppy): String { puppy.url }
}
