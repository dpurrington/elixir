defmodule Card do
  defstruct value: nil, name: nil, suit: nil

  def new, do: %Card{}
end

#keylist for the suits
suits = [hearts: 1, clubs: 2, diamonds: 3, spades: 4]
#keylist for the faces
faces = [two: 2, three: 3, four: 4, five: 5, six: 6,
  seven: 7, eight: 8, nine: 9, ten: 10, jack: 11, queen: 12,
  king: 13, ace: 14]

defmodule Deck do
  defstruct cards: []

  def new do
    #deck is the cross product of suits and faces
  end

  def shuffle(%Deck{cards: cards}) do
    # randomize the cards
  end
end

# section 4.2.2
