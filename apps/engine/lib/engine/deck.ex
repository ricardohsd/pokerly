defmodule Engine.Deck do
  alias Engine.Data.Card

  @color_values %{
    "♠" => "spades",
    "♥" => "hearts",
    "♦" => "diamonds",
    "♣" => "clubs"
  }

  @rank_values %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  defp colors() do
    Map.keys(@color_values) |> Enum.shuffle()
  end

  defp ranks() do
    Map.keys(@rank_values) |> Enum.shuffle()
  end

  def rank_of(rank) do
    @rank_values[rank]
  end

  def shuffle() do
    colors()
    |> Enum.flat_map(fn x ->
      Enum.map(ranks(), fn y ->
        %Card{color: x, rank: y}
      end)
    end)
    |> Enum.shuffle()
  end

  def shortened() do
    shuffle()
    |> Enum.map(fn x ->
      x.rank <> x.color
    end)
  end
end
