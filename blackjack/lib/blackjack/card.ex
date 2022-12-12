defmodule Blackjack.Card do
  defstruct name: nil, suit: nil, value: nil

  @suits [:clubs, :spades, :hearts, :diamonds]
  @values %{:two => 2,
    :three => 3,
    :four => 4,
    :five => 5,
    :six => 6,
    :seven => 7,
    :eight => 8,
    :nine => 9,
    :ten => 10,
    :jack => 10,
    :queen => 10,
    :king => 10,
    :ace => 11
}

  @spec new(atom, atom) :: Blackjack.Card
  defp new(name, suit) do
    %Blackjack.Card{name: name, suit: suit, value: Map.get(@values, name)}
  end

  def deck do
    for suit <- @suits, name_entry <- @values do
      new(elem(name_entry, 0), suit)
    end
  end

end
