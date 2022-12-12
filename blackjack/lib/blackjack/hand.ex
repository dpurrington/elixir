defmodule Blackjack.Hand do
  defstruct bet: 0, cards: []
  def new(bet, cards \\ []) do
    %Blackjack.Hand{bet: bet, cards: cards}
  end

  def take_turn(hand, {:stand}), do: hand
  def take_turn(hand, {:hit}), do: hand
  def take_turn(hand, {:split}), do: hand
  def take_turn(hand, {:double}), do: hand
  def take_turn(hand, {:surrender}), do: hand
end
