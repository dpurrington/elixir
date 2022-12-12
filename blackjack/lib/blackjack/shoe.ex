defmodule Blackjack.Shoe do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> new(5) end)
  end

  def new(num_decks) do
    Enum.map(1..num_decks, fn(_) -> Blackjack.Card.deck() end)
    |> List.flatten()
    |> shuffle
  end

  def shuffle(cards) do
    Enum.take_random(cards, length(cards))
  end

  @spec take_cards(List, integer, List) :: List
  def take_cards(shoe, num_cards, acc \\ [])
  def take_cards(shoe, 0, acc), do: {acc, shoe}
  def take_cards(shoe, num_cards, acc) do
    take_cards(tl(shoe), num_cards - 1, [hd(shoe) | acc])
  end

  def get_cards(shoe_agent, num_cards) do
    Agent.get_and_update(shoe_agent, fn(shoe) -> take_cards(shoe, num_cards) end)
  end

  def new_shoe(shoe_agent) do
    Agent.update(shoe_agent, fn(shoe) -> new(5) end)
  end
end
