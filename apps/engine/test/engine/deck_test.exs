defmodule Engine.DeckTest do
  use ExUnit.Case

  test "shortened returns 52 cards" do
    assert Engine.Deck.shortened() |> Enum.count() == 52
  end

  test "shuffle returns 52 cards" do
    assert Engine.Deck.shuffle() |> Enum.count() == 52
  end
end
