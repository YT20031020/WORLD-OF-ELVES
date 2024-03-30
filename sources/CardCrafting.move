address 0x1;

module CardCraftingModule {

// Card Metadata
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

// Card Collection
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

// Craft a stronger card by consuming two cards
public fun craftCard(card1: &mut Card, card2: &mut Card, metadata: CardMetadata, level: u8): Card acquires CardCollection {
assert(CardCollection::isCardOwner(card1, move_from<CardCollection>(CardCollection::exists(self))));
assert(CardCollection::isCardOwner(card2, move_from<CardCollection>(CardCollection::exists(self))));

// Destroy the consumed cards
CardCollection::destroyCard(card1);
CardCollection::destroyCard(card2);

// Mint a new, stronger card
let craftedCard: Card = Card {
metadata: metadata,
level: level,
owner: card1.owner // New card inherits the owner of the consumed cards
};
CardCollection::cards.push_back(craftedCard);
return craftedCard;
}

// Destroy a card
public fun destroyCard(card: &mut Card) {
assert(CardCollection::isCardOwner(card, move_from<CardCollection>(CardCollection::exists(self))));
// Remove the card from the collection
CardCollection::cards.swap_remove(CardCollection::cards.position(card));
}
}

public fun main() {
let collection: CardCollection;
let metadata: CardMetadata = CardMetadata {
name: "My Card",
symbol: "MC",
icon: "card.png"
};
let card1: Card = collection.mintCard(metadata, 1);
let card2: Card = collection.mintCard(metadata, 1);
let craftedCard: Card = collection.craftCard(&mut card1, &mut card2, metadata, 2);
}
}   