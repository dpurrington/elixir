defmodule Blackjack.ShoeTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, shoe} = Blackjack.Shoe.start_link([])
    %{shoe: shoe}
  end

  test "deals cards", %{shoe: shoe} do
    cards = Blackjack.Shoe.get_cards(shoe, 2)
    assert length(cards) == 2
  end

  test "creates new shoe", %{shoe: shoe} do
    Blackjack.Shoe.new_shoe(shoe)
  end
end
