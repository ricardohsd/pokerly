defmodule Pokerly.Ranker do
    @hands %{
        straight_flush:   9,
        four_of_a_kind:   8,
        full_house:       7,
        flush:            6,
        straight:         5,
        three_of_a_kind:  4,
        two_pair:         3,
        one_pair:         2,
        high_card:        1
      }

    def rank([ head | tail ]) do
        #
    end

    def compare(hand_1, hand_2) do
        do_compare(categorize(hand_1), categorize(hand_2))
    end

    defp do_compare({hand_1, ranks_1}, {hand_2, ranks_2}) do
        cond do
            @hands[hand_1] < @hands[hand_2] -> -1
            @hands[hand_1] > @hands[hand_2] -> 1
            ranks_1 < ranks_2 -> -1
            ranks_1 > ranks_2 -> 1
            true -> 0
        end
    end

    # Categorize the hand in the possible ranking categories
    def categorize(hand) do
        weights(hand)
        |> analyze
    end

    # straight flush
    defp analyze([{rank_1, color},
                  {rank_2, color},
                  {rank_3, color},
                  {rank_4, color},
                  {rank_5, color}])
        when rank_2 == rank_1 + 1 and
             rank_3 == rank_2 + 1 and
             rank_4 == rank_3 + 1 and
             rank_5 == rank_4 + 1,
        do: {:straight_flush, {rank_5}}

    # straight flush, lesser rank
    defp analyze([{rank_1, color},
                  {rank_2, color},
                  {rank_3, color},
                  {rank_4, color},
                  {rank_5, color}])
        when rank_2 == rank_1 + 1 and
             rank_3 == rank_2 + 1 and
             rank_4 == rank_3 + 1 and
             rank_5 == rank_1 + 12, # 12 ranks A-King
        do: {:straight_flush, {rank_4}}

    # four of a kind, lesser rank
    defp analyze([{rank_1, _},
                  {rank_1, _},
                  {rank_1, _},
                  {rank_1, _},
                  {rank_2, _}]),
        do: {:four_of_a_kind, {rank_1, rank_2}}

    # four of a kind, higher rank
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_2, _},
                  {rank_2, _},
                  {rank_2, _}]),
        do: {:four_of_a_kind, {rank_2, rank_1}}

    # full house, higher rank
    defp analyze([{rank_1, _},
                  {rank_1, _},
                  {rank_1, _},
                  {rank_2, _},
                  {rank_2, _}]),
        do: {:full_house, {rank_1, rank_2}}

    # full house, lesser rank
    defp analyze([{rank_1, _},
                  {rank_1, _},
                  {rank_2, _},
                  {rank_2, _},
                  {rank_2, _}]),
        do: {:full_house, {rank_2, rank_1}}
 
    # flush
    defp analyze([{rank_1, color},
                  {rank_2, color},
                  {rank_3, color},
                  {rank_4, color},
                  {rank_5, color}]),
        do: {:flush, {rank_5, rank_4, rank_3, rank_2, rank_1}} 
    
    # straight
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_4, _},
                  {rank_5, _}])
        when rank_2 == rank_1 + 1 and
             rank_3 == rank_2 + 1 and
             rank_4 == rank_3 + 1 and
             rank_5 == rank_4 + 1,
        do: {:straight, {rank_5}}
   
    # straight, ace as lower card
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_4, _},
                  {rank_5, _}])
        when rank_2 == rank_1 + 1 and
             rank_3 == rank_2 + 1 and
             rank_4 == rank_3 + 1 and
             rank_5 == rank_1 + 12, # 12 ranks A-King
        do: {:straight, {rank_4}}

    # three of a kind, higher rank
    defp analyze([{rank_1, _},
                  {rank_1, _},
                  {rank_1, _},
                  {rank_2, _},
                  {rank_3, _}]),
        do: {:three_of_a_kind, {rank_1, rank_3, rank_2}}

    # three of a kind, lesser rank
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_3, _},
                  {rank_3, _}]),
        do: {:three_of_a_kind, {rank_3, rank_2, rank_1}}

    # three of a kind, higher and lesser rank
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_2, _},
                  {rank_2, _},
                  {rank_3, _}]),
        do: {:three_of_a_kind, {rank_2, rank_3, rank_1}}

    # two pair, + a higher ranking card
    defp analyze([{rank_1, _},
                  {rank_1, _},
                  {rank_2, _},
                  {rank_2, _},
                  {rank_3, _}]),
        do: {:two_pair, {rank_2, rank_1, rank_3}}

    # two pair, + a lesser ranking card
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_3, _}]),
        do: {:two_pair, {rank_3, rank_2, rank_1}}

    # two pair
    defp analyze([{rank_1, _},
                  {rank_1, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_3, _}]),
        do: {:two_pair, {rank_3, rank_1, rank_2}}

    # one pair, mid + 2 higher ranking cards
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_4, _}]),
        do: {:one_pair, {rank_2, rank_4, rank_3, rank_1}}

    # one pair, mid + 2 lesser ranking cards
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_3, _},
                  {rank_4, _}]),
        do: {:one_pair, {rank_3, rank_4, rank_2, rank_1}}

    # one pair, bottom
    defp analyze([{rank_1, _},
                  {rank_1, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_4, _}]),
        do: {:one_pair, {rank_1, rank_4, rank_3, rank_2}}

    # one pair, top
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_4, _},
                  {rank_4, _}]),
        do: {:one_pair, {rank_4, rank_3, rank_2, rank_1}}

    # higher card
    defp analyze([{rank_1, _},
                  {rank_2, _},
                  {rank_3, _},
                  {rank_4, _},
                  {rank_5, _}]),
        do: {:high_card, {rank_5, rank_4, rank_3, rank_2, rank_1}}

    def weights(hand) do
        Enum.map(hand, fn x -> hand_weight(x) end)
        |> Enum.sort_by(fn {r, _c} -> r end)
    end

    defp hand_weight(%{"color" => color, "rank" => rank}) do
        {Pokerly.Deck.rank_of(rank), color}
    end
end