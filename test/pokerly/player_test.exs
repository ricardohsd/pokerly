defmodule Pokerly.PlayerTest do
  use ExUnit.Case
  doctest Pokerly.Player

  alias Pokerly.Player
  alias Pokerly.Card

  setup do
    {:ok, pid} = Player.start_link("JohnDoe")
    {:ok, process: pid}
  end

  describe "init/1" do
    test "initial balance is setup", %{process: pid} do
      %{balance: balance} = Player.balance(pid)

      assert 200 == balance
    end

    test "player's status is joining", %{process: pid} do
      %{status: status} = Player.balance(pid)

      assert :joining == status
    end
  end

  describe "bet/1" do
    test "returns error when betting not a number", %{process: pid} do
      error = Player.bet(pid, "notanumber")
      assert :invalid_bet_value == error
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
  end
end
