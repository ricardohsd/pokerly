defmodule Pokerly.Fixtures do
  defmacro __using__(fixtures) when is_list(fixtures) do
    for fixture <- fixtures, is_atom(fixture), do: apply(__MODULE__, fixture, [])
  end

  def hands do
    quote do
      @high_ace [
        %{"color" => "♦", "rank" => "4"},
        %{"color" => "♠", "rank" => "A"},
        %{"color" => "♦", "rank" => "3"},
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♣", "rank" => "7"}
      ]

      @straight_flush [
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♣", "rank" => "9"},
        %{"color" => "♣", "rank" => "J"},
        %{"color" => "♣", "rank" => "7"},
        %{"color" => "♣", "rank" => "10"}
      ]

      @lesser_straight_flush [
        %{"color" => "♣", "rank" => "A"},
        %{"color" => "♣", "rank" => "2"},
        %{"color" => "♣", "rank" => "3"},
        %{"color" => "♣", "rank" => "4"},
        %{"color" => "♣", "rank" => "5"}
      ]

      @lesser_four_of_a_kind [
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♦", "rank" => "8"},
        %{"color" => "♠", "rank" => "8"},
        %{"color" => "♥", "rank" => "8"},
        %{"color" => "♠", "rank" => "2"}
      ]

      @higher_four_of_a_kind [
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♦", "rank" => "8"},
        %{"color" => "♠", "rank" => "8"},
        %{"color" => "♥", "rank" => "8"},
        %{"color" => "♠", "rank" => "10"}
      ]

      @lesser_full_house [
        %{"color" => "♣", "rank" => "6"},
        %{"color" => "♦", "rank" => "6"},
        %{"color" => "♠", "rank" => "6"},
        %{"color" => "♥", "rank" => "2"},
        %{"color" => "♠", "rank" => "2"}
      ]

      @higher_full_house [
        %{"color" => "♣", "rank" => "6"},
        %{"color" => "♦", "rank" => "6"},
        %{"color" => "♠", "rank" => "6"},
        %{"color" => "♥", "rank" => "10"},
        %{"color" => "♠", "rank" => "10"}
      ]

      @flush [
        %{"color" => "♦", "rank" => "J"},
        %{"color" => "♦", "rank" => "9"},
        %{"color" => "♦", "rank" => "8"},
        %{"color" => "♦", "rank" => "4"},
        %{"color" => "♦", "rank" => "3"}
      ]

      @straight [
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♦", "rank" => "9"},
        %{"color" => "♦", "rank" => "J"},
        %{"color" => "♣", "rank" => "7"},
        %{"color" => "♠", "rank" => "10"}
      ]

      @low_straight [
        %{"color" => "♣", "rank" => "A"},
        %{"color" => "♦", "rank" => "2"},
        %{"color" => "♦", "rank" => "3"},
        %{"color" => "♣", "rank" => "4"},
        %{"color" => "♠", "rank" => "5"}
      ]

      @lesser_three_of_a_kind [
        %{"color" => "♣", "rank" => "4"},
        %{"color" => "♦", "rank" => "4"},
        %{"color" => "♠", "rank" => "4"},
        %{"color" => "♣", "rank" => "3"},
        %{"color" => "♠", "rank" => "2"}
      ]

      @higher_three_of_a_kind [
        %{"color" => "♣", "rank" => "4"},
        %{"color" => "♦", "rank" => "4"},
        %{"color" => "♠", "rank" => "4"},
        %{"color" => "♣", "rank" => "7"},
        %{"color" => "♠", "rank" => "10"}
      ]

      @three_of_a_kind [
        %{"color" => "♣", "rank" => "4"},
        %{"color" => "♦", "rank" => "4"},
        %{"color" => "♠", "rank" => "4"},
        %{"color" => "♣", "rank" => "2"},
        %{"color" => "♠", "rank" => "10"}
      ]

      @higher_two_pair [
        %{"color" => "♣", "rank" => "4"},
        %{"color" => "♦", "rank" => "4"},
        %{"color" => "♠", "rank" => "3"},
        %{"color" => "♣", "rank" => "3"},
        %{"color" => "♠", "rank" => "J"}
      ]

      @lesser_two_pair [
        %{"color" => "♣", "rank" => "7"},
        %{"color" => "♦", "rank" => "7"},
        %{"color" => "♠", "rank" => "8"},
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♠", "rank" => "2"}
      ]

      @two_pair [
        %{"color" => "♣", "rank" => "7"},
        %{"color" => "♦", "rank" => "7"},
        %{"color" => "♠", "rank" => "10"},
        %{"color" => "♣", "rank" => "10"},
        %{"color" => "♠", "rank" => "9"}
      ]

      @bottom_one_pair [
        %{"color" => "♦", "rank" => "7"},
        %{"color" => "♣", "rank" => "7"},
        %{"color" => "♠", "rank" => "10"},
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♠", "rank" => "9"}
      ]

      @top_one_pair [
        %{"color" => "♠", "rank" => "7"},
        %{"color" => "♥", "rank" => "7"},
        %{"color" => "♠", "rank" => "3"},
        %{"color" => "♣", "rank" => "4"},
        %{"color" => "♠", "rank" => "5"}
      ]

      @mid_bottom_one_pair [
        %{"color" => "♣", "rank" => "6"},
        %{"color" => "♦", "rank" => "6"},
        %{"color" => "♠", "rank" => "8"},
        %{"color" => "♣", "rank" => "9"},
        %{"color" => "♦", "rank" => "5"}
      ]

      @mid_top_one_pair [
        %{"color" => "♠", "rank" => "6"},
        %{"color" => "♥", "rank" => "6"},
        %{"color" => "♥", "rank" => "8"},
        %{"color" => "♠", "rank" => "4"},
        %{"color" => "♣", "rank" => "5"}
      ]

      @high_card [
        %{"color" => "♦", "rank" => "4"},
        %{"color" => "♠", "rank" => "Q"},
        %{"color" => "♦", "rank" => "3"},
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♣", "rank" => "7"}
      ]
    end
  end
end
