defmodule Engine.Data.TableTest do
  use ExUnit.Case

  alias Engine.Data.Table
  alias Engine.Player

  @owner "Steve"

  describe "new/1" do
    test "returns new Table set" do
      assert %Table{name: "Game1", players: []} == Table.new(%{name: "Game1"})
    end
  end

  describe "add_player/2" do
    test "add player to a random position" do
      table = Table.new(%{name: "Game1", players: ["John", "Mary", "Mark"]})

      # seed required so test can be assertive
      :rand.seed(:exrop, {101, 102, 103})
      {:ok, table} = Table.add_player(table, "Ana")

      assert ["John", "Mary", "Ana", "Mark"] == table.players
    end

    test "ensure player actor exists" do
      table = Table.new(%{name: "Game1", players: []})
      {:ok, _} = Table.add_player(table, "Ana")

       assert nil != Player.exists?("Ana")
    end

    test "doesn't add already existing player" do
      table = Table.new(%{players: [@owner]})
      {:ok, table} = Table.add_player(table, "Robert")
      {:ok, table} = Table.add_player(table, "Elise")
      {:nothing_to_add, table} = Table.add_player(table, "Robert")

      assert Enum.member?(table.players, @owner)
      assert Enum.member?(table.players, "Robert")
      assert Enum.member?(table.players, "Elise")
    end
  end

  describe "enough_players?/1" do
    test "returns true when having more or 3 players" do
      table = Table.new(%{players: ["John", "Mary"]})
      assert !Table.enough_players?(table)

      table = Table.new(%{players: ["John", "Mary", "Mark"]})
      assert Table.enough_players?(table)
    end
  end
end
