defmodule Engine.GameTest do
  use ExUnit.Case
  doctest Engine.Game

  alias Engine.Game
  alias Engine.Player

  @owner "Steve"

  setup do
    name = "Game1"
    {:ok, _pid} = Game.start_link(name: name, owner: @owner)

    {:ok, name: name}
  end

  describe "players/1" do
    test "return current player's names", %{name: name} do
      players = Game.players(name)

      assert [@owner] == players
    end
  end

  describe "add_player/2" do
    test "adds a player to the game state", %{name: game} do
      assert [] == Player.exists?("Martin")

      players = Game.players(game)
      assert [@owner] == players

      Game.add_player(game, "Martin")
      assert [@owner, "Martin"] == Game.players(game)

      assert nil != Player.exists?("Martin")
    end

    test "doesn't add already existing player", %{name: game} do
      Game.add_player(game, "Robert")
      Game.add_player(game, "Elise")
      Game.add_player(game, "Robert")

      assert [@owner, "Robert", "Elise"] == Game.players(game)
    end
  end
end
