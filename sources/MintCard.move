address 0x1;
address 0x2;

module MintCardModule {

// Token Metadata
struct CardMetadata {
name: string,
symbol: string,
icon: string
}

// Card Token
struct Card {
metadata: CardMetadata,
level: u8,
owner: address
}

// Token Collection
public resource CardCollection {
cards: vector<Card>;

// Mint a new card
public fun mintCard(metadata: CardMetadata, level: u8): Card acquires CardCollection {
let card: Card = Card {
metadata: metadata,
level: level,
owner: 0x0 // Initialize owner to null address
};
CardCollection::cards.push_back(card);
return card;
}

// Transfer card ownership
public fun transferCard(card: &mut Card, to: address) {
assert(CardCollection::isCardOwner(card, move_from<CardCollection>(CardCollection::exists(self))));
card.owner = to;
}

// Check if address is the owner of the card
public fun isCardOwner(card: &Card, collection: &mut CardCollection): bool {
return card.owner == move_from<CardCollection>(CardCollection::exists(collection));
}
}

public fun main() {
let collection: CardCollection;
let metadata: CardMetadata = CardMetadata {
name: "My Card",
symbol: "MC",
icon: "card.png"
};
let card: Card = collection.mintCard(metadata, 1);
collection.transferCard(&mut card, 0x2); // Transfer ownership to address 0x2
}
}