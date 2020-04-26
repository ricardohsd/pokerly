defmodule Pokerly.PlayerTest do
  use ExUnit.Case
  doctest Pokerly.Player

  alias Pokerly.Game
  alias Pokerly.Player
  alias Pokerly.Card

  setup do
    {:ok, _pid} = Game.start_link(name: "game1")
    player_name = "JohnDoe"
    {:ok, _pid} = Player.start_link(name: player_name, game: "game1")
    :ok = Player.status(player_name, :playing)

    {:ok, name: player_name}
  end

  describe "init/1" do
    setup do
      {:ok, _pid} = Game.start_link(name: "game2")
      player_name = "Mary"
      {:ok, _pid} = Player.start_link(name: player_name, game: "game2")

      {:ok, name: player_name}
    end

    test "initial balance is setup", %{name: name} do
      %{balance: balance} = Player.balance(name)

      assert 200 == balance
    end

    test "player's status is joining", %{name: name} do
      %{status: status} = Player.balance(name)

      assert :joining == status
    end
  end

  describe "exists?/1" do
    test "returns pid when player already exists" do
      [{pid, nil}] = Player.exists?("JohnDoe")

      assert Process.alive?(pid)
    end

    test "returns nothing when player doesn't exists" do
      assert [] == Player.exists?("Mark")
    end
  end

  describe "status/1" do
    test "accepts :joining as a valid status", %{name: name} do
      assert :ok == Player.status(name, :joining)
    end

    test "accepts :playing as a valid status", %{name: name} do
      assert :ok == Player.status(name, :playing)
    end

    test "accepts :away as a valid status", %{name: name} do
      assert :ok == Player.status(name, :away)
    end

    test "accepts :quit as a valid status", %{name: name} do
      assert :ok == Player.status(name, :quit)
    end

    test "doesn't accept an invalid status", %{name: name} do
      {:invalid_status, status} = Player.status(name, :wrong_status)

      assert :wrong_status == status
    end
  end

  describe "bet/1" do
    test "returns error when betting not a number", %{name: name} do
      error = Player.bet(name, "notanumber")
      assert :invalid_bet_value == error
    end

    test "returns error when player has 'joining' status", %{name: name} do
      :ok = Player.status(name, :joining)
      {error, :joining} = Player.bet(name, 10)
      assert :invalid_status == error
    end

    test "returns error when player has 'away' status", %{name: name} do
      :ok = Player.status(name, :away)
      {error, :away} = Player.bet(name, 10)
      assert :invalid_status == error
    end

    test "returns error when player has 'quit' status", %{name: name} do
      :ok = Player.status(name, :quit)
      {error, :quit} = Player.bet(name, 10)
      assert :invalid_status == error
    end

    test "deduct bet from balance", %{name: name} do
      :ok = Player.bet(name, 100)
      %{balance: balance} = Player.balance(name)
      assert 100 == balance
    end

    test "balance can't be negative", %{name: name} do
      error = Player.bet(name, 201)
      assert :not_enough_funds == error
    end
  end

  describe "receive_card/1" do
    test "receives a card", %{name: name} do
      card = %Card{color: "♠", rank: "K"}

      :ok = Player.receive_card(name, card)

      %{cards: cards} = Player.balance(name)

      assert [card] == cards
    end

    test "returns error when player has 'joining' status", %{name: name} do
      :ok = Player.status(name, :joining)
      {error, :joining} = Player.receive_card(name, %Card{color: "♠", rank: "K"})
      assert :invalid_status == error
    end

    test "returns error when player has 'away' status", %{name: name} do
      :ok = Player.status(name, :away)
      {error, :away} = Player.receive_card(name, %Card{color: "♠", rank: "K"})
      assert :invalid_status == error
    end

    test "returns error when player has 'quit' status", %{name: name} do
      :ok = Player.status(name, :quit)
      {error, :quit} = Player.receive_card(name, %Card{color: "♠", rank: "K"})
      assert :invalid_status == error
    end
  end
end
