defmodule Pokerly.Game do
  use GenServer

  defp encode(name) do
    name |> String.downcase() |> Base.encode64()
  end

  # ensure global name is normalized
  def via_tuple(name), do: {:via, Registry, {Registry.Game, encode(name)}}

  def pid_of(name) do
    via_tuple(name)
    |> GenServer.whereis()
  end

  def start_link([name: name] = _opts) do
    GenServer.start_link(__MODULE__, [name: name], name: via_tuple(name))
  end

  def init([name: name] = _opts) do
    {:ok, %{name: name, players: []}}
  end

  def players(name) do
    via_tuple(name)
    |> GenServer.call(:players)
  end

  def add_player(game, player) do
    via_tuple(game)
    |> GenServer.call({:add_player, player})
  end

  # Callbacks

  def handle_call(:players, _from, state) do
    {:reply, state[:players], state}
  end

  def handle_call({:add_player, player}, _from, state) do
    players = Enum.uniq(state[:players] ++ [player])
    new_state = %{state | players: players}
    {:reply, new_state, new_state}
  end
end
