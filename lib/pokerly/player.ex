defmodule Pokerly.Player do
  use GenServer

  alias Pokerly.Card

  @initial_balance String.to_integer(System.get_env("PLAYER_INITIAL_BALANCE") || "200")
  @statuses [:joining, :playing, :away, :quit]

  defp encode(name) do
    name |> String.downcase() |> Base.encode64()
  end

  # ensure global name is normalized
  def via_tuple(name), do: {:via, Registry, {Registry.Player, encode(name)}}

  def pid_of(name) do
    via_tuple(name)
    |> GenServer.whereis()
  end

  def start_link([name: name] = _opts) when is_binary(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def exists?(name) do
    Registry.lookup(Registry.Player, encode(name))
  end

  def init(name) do
    {:ok, %{name: name, status: :joining, balance: @initial_balance, cards: []}}
  end

  def balance(name) do
    via_tuple(name)
    |> GenServer.call(:balance)
  end

  def status(name, status) do
    via_tuple(name)
    |> GenServer.call({:status, status})
  end

  def bet(name, value) when is_number(value) do
    via_tuple(name)
    |> GenServer.call({:bet, value})
  end

  def bet(_, _) do
    :invalid_bet_value
  end

  def receive_card(name, %Card{color: _, rank: _} = card) do
    via_tuple(name)
    |> GenServer.call({:receive_card, card})
  end

  # Callbacks

  def handle_call(:balance, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:status, new_status}, _from, state) when new_status in @statuses do
    {:reply, :ok, %{state | status: new_status}}
  end

  def handle_call({:status, new_status}, _from, state) do
    {:reply, {:invalid_status, new_status}, state}
  end

  def handle_call({:bet, value}, _from, %{status: status} = state) when status == :playing do
    {:ok, balance} = Map.fetch(state, :balance)
    new_balance = balance - value

    cond do
      new_balance < 0 ->
        {:reply, :not_enough_funds, state}

      true ->
        {:reply, :ok, %{state | balance: new_balance}}
    end
  end

  def handle_call({:bet, _value}, _from, %{status: status} = state) when status != :playing do
    {:reply, {:invalid_status, status}, state}
  end

  def handle_call({:receive_card, card}, _from, %{status: status} = state)
      when status == :playing do
    {:reply, :ok, %{state | cards: state[:cards] ++ [card]}}
  end

  def handle_call({:receive_card, _card}, _from, %{status: status} = state)
      when status != :playing do
    {:reply, {:invalid_status, status}, state}
  end
end
