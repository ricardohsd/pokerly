defmodule Pokerly.Player do
    use GenServer

    alias Pokerly.Card

    @initial_balance 200
    @max_amount_of_cards 3
    @status %{
        joining: 0,
        playing: 1,
        away: 2,
        quit: 3
    }

    def start_link(name) when is_binary(name) do
        GenServer.start_link(__MODULE__, name, [])
    end

    def init(name) do
        {:ok, %{name: name, status: :joining, balance: @initial_balance, cards: []}}
    end

    def balance(pid) do
        GenServer.call(pid, :balance)
    end

    # TODO: Player should be allowed to play only when status move from joining to playing
    def bet(pid, value) when is_number(value) do
        GenServer.call(pid, {:bet, value})
    end

    def bet(pid, _) do
        :invalid_bet_value
    end

    def receive_card(pid, %Card{color: _, rank: _} = card) do
        GenServer.call(pid, {:receive_card, card})
    end

    # Callbacks

    def handle_call(:balance, _from, state) do
        {:reply, state, state}
    end

    def handle_call({:bet, value}, _from, state) do
        {:ok, balance} = Map.fetch(state, :balance)
        new_balance = balance - value

        cond do
            new_balance < 0 ->
                {:reply, :not_enough_funds, state}
            true ->
                {:reply, :ok, %{state | balance: new_balance}}
        end
    end

    def handle_call({:receive_card, card}, _from, state) do
        with :ok <- can_receive_cards(state)
        do
            {:reply, :ok, %{state | cards: state[:cards] ++ [card]}}
        else
            :error -> {:reply, :invalid_amount_of_cards, state}
        end
    end

    defp can_receive_cards(state) do
        if Enum.count(state[:cards]) >= @max_amount_of_cards do
            :error
        else
            :ok
        end
    end
end