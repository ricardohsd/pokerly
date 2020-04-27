defmodule Engine.Fixtures do
  alias Engine.Card

  defmacro __using__(fixtures) when is_list(fixtures) do
    for fixture <- fixtures, is_atom(fixture), do: apply(__MODULE__, fixture, [])
  end

  def hands do
    quote do
      @high_ace [
        %Card{color: "♦", rank: "4"},
        %Card{color: "♠", rank: "A"},
        %Card{color: "♦", rank: "3"},
        %Card{color: "♣", rank: "8"},
        %Card{color: "♣", rank: "7"}
      ]

      @straight_flush [
        %Card{color: "♣", rank: "8"},
        %Card{color: "♣", rank: "9"},
        %Card{color: "♣", rank: "J"},
        %Card{color: "♣", rank: "7"},
        %Card{color: "♣", rank: "10"}
      ]

      @lesser_straight_flush [
        %Card{color: "♣", rank: "A"},
        %Card{color: "♣", rank: "2"},
        %Card{color: "♣", rank: "3"},
        %Card{color: "♣", rank: "4"},
        %Card{color: "♣", rank: "5"}
      ]

      @lesser_four_of_a_kind [
        %Card{color: "♣", rank: "8"},
        %Card{color: "♦", rank: "8"},
        %Card{color: "♠", rank: "8"},
        %Card{color: "♥", rank: "8"},
        %Card{color: "♠", rank: "2"}
      ]

      @higher_four_of_a_kind [
        %Card{color: "♣", rank: "8"},
        %Card{color: "♦", rank: "8"},
        %Card{color: "♠", rank: "8"},
        %Card{color: "♥", rank: "8"},
        %Card{color: "♠", rank: "10"}
      ]

      @lesser_full_house [
        %Card{color: "♣", rank: "6"},
        %Card{color: "♦", rank: "6"},
        %Card{color: "♠", rank: "6"},
        %Card{color: "♥", rank: "2"},
        %Card{color: "♠", rank: "2"}
      ]

      @higher_full_house [
        %Card{color: "♣", rank: "6"},
        %Card{color: "♦", rank: "6"},
        %Card{color: "♠", rank: "6"},
        %Card{color: "♥", rank: "10"},
        %Card{color: "♠", rank: "10"}
      ]

      @flush [
        %Card{color: "♦", rank: "J"},
        %Card{color: "♦", rank: "9"},
        %Card{color: "♦", rank: "8"},
        %Card{color: "♦", rank: "4"},
        %Card{color: "♦", rank: "3"}
      ]

      @straight [
        %Card{color: "♣", rank: "8"},
        %Card{color: "♦", rank: "9"},
        %Card{color: "♦", rank: "J"},
        %Card{color: "♣", rank: "7"},
        %Card{color: "♠", rank: "10"}
      ]

      @low_straight [
        %Card{color: "♣", rank: "A"},
        %Card{color: "♦", rank: "2"},
        %Card{color: "♦", rank: "3"},
        %Card{color: "♣", rank: "4"},
        %Card{color: "♠", rank: "5"}
      ]

      @lesser_three_of_a_kind [
        %Card{color: "♣", rank: "4"},
        %Card{color: "♦", rank: "4"},
        %Card{color: "♠", rank: "4"},
        %Card{color: "♣", rank: "3"},
        %Card{color: "♠", rank: "2"}
      ]

      @higher_three_of_a_kind [
        %Card{color: "♣", rank: "4"},
        %Card{color: "♦", rank: "4"},
        %Card{color: "♠", rank: "4"},
        %Card{color: "♣", rank: "7"},
        %Card{color: "♠", rank: "10"}
      ]

      @three_of_a_kind [
        %Card{color: "♣", rank: "4"},
        %Card{color: "♦", rank: "4"},
        %Card{color: "♠", rank: "4"},
        %Card{color: "♣", rank: "2"},
        %Card{color: "♠", rank: "10"}
      ]

      @higher_two_pair [
        %Card{color: "♣", rank: "4"},
        %Card{color: "♦", rank: "4"},
        %Card{color: "♠", rank: "3"},
        %Card{color: "♣", rank: "3"},
        %Card{color: "♠", rank: "J"}
      ]

      @lesser_two_pair [
        %Card{color: "♣", rank: "7"},
        %Card{color: "♦", rank: "7"},
        %Card{color: "♠", rank: "8"},
        %Card{color: "♣", rank: "8"},
        %Card{color: "♠", rank: "2"}
      ]

      @two_pair [
        %Card{color: "♣", rank: "7"},
        %Card{color: "♦", rank: "7"},
        %Card{color: "♠", rank: "10"},
        %Card{color: "♣", rank: "10"},
        %Card{color: "♠", rank: "9"}
      ]

      @bottom_one_pair [
        %Card{color: "♦", rank: "7"},
        %Card{color: "♣", rank: "7"},
        %Card{color: "♠", rank: "10"},
        %Card{color: "♣", rank: "8"},
        %Card{color: "♠", rank: "9"}
      ]

      @top_one_pair [
        %Card{color: "♠", rank: "7"},
        %Card{color: "♥", rank: "7"},
        %Card{color: "♠", rank: "3"},
        %Card{color: "♣", rank: "4"},
        %Card{color: "♠", rank: "5"}
      ]

      @mid_bottom_one_pair [
        %Card{color: "♣", rank: "6"},
        %Card{color: "♦", rank: "6"},
        %Card{color: "♠", rank: "8"},
        %Card{color: "♣", rank: "9"},
        %Card{color: "♦", rank: "5"}
      ]

      @mid_top_one_pair [
        %Card{color: "♠", rank: "6"},
        %Card{color: "♥", rank: "6"},
        %Card{color: "♥", rank: "8"},
        %Card{color: "♠", rank: "4"},
        %Card{color: "♣", rank: "5"}
      ]

      @high_card [
        %Card{color: "♦", rank: "4"},
        %Card{color: "♠", rank: "Q"},
        %Card{color: "♦", rank: "3"},
        %Card{color: "♣", rank: "8"},
        %Card{color: "♣", rank: "7"}
      ]
    end
  end
end
