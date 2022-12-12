defmodule Blackjack.Player do
  defstruct name: nil, holdings: 0, hands: []

  def new(stake, name) do
    %Blackjack.Player{ name: name, holdings: stake}
  end

  def get_bets(%Blackjack.Player{holdings: holdings} = player) do
    {%Blackjack.Player{player | holdings: holdings - 25}, [25]}
  end

  @spec get_play(Blackjack.Player, Blackjack.Hand, Blackjack.Hand) :: atom
  def get_play(player, dealer_hand, player_hand) do
    do_get_play(player, dealer_hand, player_hand)
  end

  @spec do_get_play(Blackjack.Player, Blackjack.Hand, Blackjack.Hand) :: atom
  defp do_get_play(_,_,player_hand) when length(player_hand.cards) == 2 do
    # split, double, and surrender are allowed
    # must verify player has funds for split and double
    :stand
  end

  @spec do_get_play(Blackjack.Player, Blackjack.Hand, Blackjack.Hand) :: atom
  defp do_get_play(_,_,player_hand) when length(player_hand.cards) > 2 do
    # split, double, and surrender are not allowed
    :stand
  end

  @spec end_round(Blackjack.Player, number) :: Blackjack.Player
  def end_round(%{holdings: holdings} = player, net_winnings) do
    %Blackjack.Player{player | holdings: holdings + net_winnings, hands: []}
  end
end
