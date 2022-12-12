# Blackjack

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `blackjack` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:blackjack, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/blackjack>.


Dealer
* Deals hands, adds cards
* Pays off winning bets
* Collects losing bets

Player
* Buys hand
* Takes turn -- hit, stand, split, double, surrender
* Holds stake

Card
* Has suit, name, value

Ace
* Is card
* Value can be either 1 or 11

Facecard
* Is card
* Value is 10

Deck
* Has 52 cards, 13 of each suit

Shoe
* Has 5 decks
* Can shuffle
