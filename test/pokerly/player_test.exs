defmodule Pokerly.PlayerTest do
  use ExUnit.Case
  doctest Pokerly.Player

  alias Pokerly.Player
  alias Pokerly.Card

  setup do
    {:ok, pid} = Player.start_link("JohnDoe")
    :ok = Player.status(pid, :playing)

    {:ok, process: pid}
  end

  describe "init/1" do
    setup do
      {:ok, pid} = Player.start_link("Mary")

      {:ok, process: pid}
    end

    test "initial balance is setup", %{process: pid} do
      %{balance: balance} = Player.balance(pid)

      assert 200 == balance
    end

    test "player's status is joining", %{process: pid} do
      %{status: status} = Player.balance(pid)

      assert :joining == status
    end
  end

  describe "status/1" do
    test "accepts :joining as a valid status", %{process: pid} do
      assert :ok == Player.status(pid, :joining)
    end

    test "accepts :playing as a valid status", %{process: pid} do
      assert :ok == Player.status(pid, :playing)
    end

    test "accepts :away as a valid status", %{process: pid} do
      assert :ok == Player.status(pid, :away)
    end

    test "accepts :quit as a valid status", %{process: pid} do
      assert :ok == Player.status(pid, :quit)
    end

    test "doesn't accept an invalid status", %{process: pid} do
      {:invalid_status, status} = Player.status(pid, :wrong_status)

      assert :wrong_status == status
    end
  end

  describe "bet/1" do
    test "returns error when betting not a number", %{process: pid} do
      error = Player.bet(pid, "notanumber")
      assert :invalid_bet_value == error
    end

    test "returns error when player has 'joining' status", %{process: pid} do
      :ok = Player.status(pid, :joining)
      {error, :joining} = Player.bet(pid, 10)
      assert :invalid_status == error
    end

    test "returns error when player has 'away' status", %{process: pid} do
      :ok = Player.status(pid, :away)
      {error, :away} = Player.bet(pid, 10)
      assert :invalid_status == error
    end

    test "returns error when player has 'quit' status", %{process: pid} do
      :ok = Player.status(pid, :quit)
      {error, :quit} = Player.bet(pid, 10)
      assert :invalid_status == error
    end

    test "deduct bet from balance", %{process: pid} do
      :ok = Player.bet(pid, 100)
      %{balance: balance} = Player.balance(pid)
      assert 100 == balance
    end

    test "balance can't be negative", %{process: pid} do
      error = Player.bet(pid, 201)
      assert :not_enough_funds == error
    end
  end

  describe "receive_card/1" do
    test "receives a card", %{process: pid} do
      card = %Card{color: "♠", rank: "K"}

      :ok = Player.receive_card(pid, card)

      %{cards: cards} = Player.balance(pid)

      assert [card] == cards
    end

    test "returns error when receiving more than 3 cards", %{process: pid} do
      :ok = Player.receive_card(pid, %Card{color: "♠", rank: "K"})
      :ok = Player.receive_card(pid, %Card{color: "♠", rank: "Q"})
      :ok = Player.receive_card(pid, %Card{color: "♠", rank: "J"})
      error = Player.receive_card(pid, %Card{color: "♠", rank: "10"})

      assert :invalid_amount_of_cards == error
    end

    test "returns error when player has 'joining' status", %{process: pid} do
      :ok = Player.status(pid, :joining)
      {error, :joining} = Player.receive_card(pid, %Card{color: "♠", rank: "K"})
      assert :invalid_status == error
    end

    test "returns error when player has 'away' status", %{process: pid} do
      :ok = Player.status(pid, :away)
      {error, :away} = Player.receive_card(pid, %Card{color: "♠", rank: "K"})
      assert :invalid_status == error
    end

    test "returns error when player has 'quit' status", %{process: pid} do
      :ok = Player.status(pid, :quit)
      {error, :quit} = Player.receive_card(pid, %Card{color: "♠", rank: "K"})
      assert :invalid_status == error
    end
  end
end
