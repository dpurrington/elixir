defmodule Blackjack.Game do
  @num_decks 5
  defstruct players: [], shoe: Blackjack.Shoe.new(@num_decks), dealer: nil

  @spec new(integer) :: Blackjack.Game
  def new(num_players) do
    players = Enum.map(1..num_players, &(Blackjack.Player.new(1000, "Player #{&1}")))
    %Blackjack.Game{players: players}
  end

  def deal(%{shoe: shoe, players: players} = game) do
    bets = Enum.map(players, &(Blackjack.Player.get_bets(&1)))
    IO.inspect(bets)
    players = Enum.map(bets, fn({player, player_bets}) ->
      IO.inspect(player_bets)
      {shoe, hands} = Enum.map(player_bets, fn(bet) ->
          IO.inspect(bet)
          {shoe, cards} = Blackjack.Shoe.take_cards(shoe, 2)
          {shoe, Blackjack.Hand.new(bet, cards)}
      end)
      IO.inspect(shoe)
      IO.inspect(hands)
#      %{player | cards: cards}
    end)
#    %{game | players: players}
  end
end
