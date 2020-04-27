defmodule Pokerly.Game do
  use GenServer

  alias Pokerly.PlayerSupervisor

  use Pokerly.RegistryOf, Registry.Game

  def start_link([name: name, owner: _owner] = opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(name))
  end

  def start_link([name: name] = opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(name))
  end

  def init([name: game, owner: player] = _opts) do
    PlayerSupervisor.create_player(player, game)
    {:ok, %{name: game, players: [player]}}
  end

  def init([name: game] = _opts) do
    {:ok, %{name: game, players: []}}
  end

  def players(game) do
    via_tuple(game)
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
    cond do
      Enum.member?(state[:players], player) ->
        {:reply, state, state}

      true ->
        players = Enum.uniq(state[:players] ++ [player])
        new_state = %{state | players: players}

        PlayerSupervisor.create_player(player, state[:name])

        {:reply, new_state, new_state}
    end
  end
end
