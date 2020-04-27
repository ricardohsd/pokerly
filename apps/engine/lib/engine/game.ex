defmodule Engine.Game do
  use GenServer

  require Logger

  alias Engine.Data.Table

  use Engine.RegistryOf, Registry.Game

  def start_link([name: name, owner: _] = opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(name))
  end

  def start_link([name: name, owner: _, ticker_interval: _] = opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(name))
  end

  def start_link([name: name] = opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(name))
  end

  # TODO: Move ticker_interval to a config file. This was required for testing purpose
  def init([name: game, owner: player, ticker_interval: interval] = _opts) do
    table = Table.new(%{name: game, ticker_interval: interval})
    {:ok, table} = Table.add_player(table, player)

    ticker(table.ticker_interval)
    {:ok, table}
  end

  def init([name: game, owner: player] = _opts) do
    table = Table.new(%{name: game})
    {:ok, table} = Table.add_player(table, player)

    ticker(table.ticker_interval)
    {:ok, table}
  end

  def init([name: game] = _opts) do
    table = Table.new(%{name: game, players: []})
    ticker(table.ticker_interval)
    {:ok, table}
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

  def handle_call(:players, _from, table) do
    {:reply, table.players, table}
  end

  def handle_call({:add_player, player}, _from, table) do
    {_, table} = Table.add_player(table, player)

    {:reply, table, table}
  end

  # Round rules

  def handle_info(:tick, table) do
    {_status, table} = handle_round_state(table.status, table)
    ticker(table.ticker_interval)
    {:noreply, table}
  end

  defp handle_round_state(:waiting, table) do
    Logger.debug("Waiting for players to join. Current players #{inspect(table.players)}")

    case Table.enough_players?(table) do
      true ->
        table = Table.start!(table)
        {:moving_to_started, table}

      _ ->
        {:waiting_for_players, table}
    end
  end

  defp handle_round_state(:playing, table) do
    Logger.debug(
      "Playing with #{table.players}. Button: #{table.button}, small: #{table.small_blind}, big: #{
        table.big_blind
      }"
    )

    {:playing, table}
  end

  defp handle_round_state(:on_hold, table) do
    Logger.debug("Game on hold")
    {:on_hold, table}
  end

  defp handle_round_state(:quitting, table) do
    Logger.debug("Quitting game")
    {:quitting, table}
  end

  defp ticker(interval) do
    Process.send_after(self(), :tick, interval)
  end
end
