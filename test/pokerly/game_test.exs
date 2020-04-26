defmodule Pokerly.GameTest do
  use ExUnit.Case
  doctest Pokerly.Game

  alias Pokerly.Game

  setup do
    name = "Game1"
    {:ok, _pid} = Game.start_link(name: name)

    {:ok, name: name}
  end

  describe "players/1" do
    test "return current player's names", %{name: name} do
      players = Game.players(name)

      assert [] == players
    end
  end

  describe "add_player/2" do
    test "adds a player to the game state", %{name: game} do
      players = Game.players(game)
      assert [] == players

      Game.add_player(game, "John")

      assert ["John"] == Game.players(game)
    end

    test "doesn't add already existing player", %{name: game} do
      Game.add_player(game, "John")
      Game.add_player(game, "Mary")
      Game.add_player(game, "John")

      assert ["John", "Mary"] == Game.players(game)
    end
  end
end
