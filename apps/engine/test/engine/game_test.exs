defmodule Engine.GameTest do
  use ExUnit.Case
  doctest Engine.Game

  alias Engine.Game
  alias Engine.Player

  @owner "Steve"

  setup do
    name = "Game1"
    {:ok, _pid} = Game.start_link(name: name, owner: @owner, ticker_interval: 10 * 1000)

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
      players = Game.players(game)

      assert Enum.member?(players, @owner)
      assert Enum.member?(players, "Martin")

      assert nil != Player.exists?("Martin")
    end
  end
end
