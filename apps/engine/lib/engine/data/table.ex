defmodule Engine.Data.Table do
  alias Engine.Player
  alias Engine.PlayerSupervisor

  # TODO: Move ticker_interval to a config file
  @default_ticker_interval 1 * 1000
  @min_players 3
  @statuses [:waiting, :started, :on_hold, :quitting]

  defstruct name: nil,
            ticker_interval: @default_ticker_interval,
            status: :waiting,
            current_round: 0,
            current_player: nil,
            button: nil,
            small_blind: nil,
            big_blind: nil,
            players: []

  def new() do
    %__MODULE__{}
  end

  def new(opts) do
    Map.merge(%__MODULE__{}, opts)
  end

  def add_player(table, player) do
    cond do
      Enum.member?(table.players, player) ->
        {:nothing_to_add, table}

      true ->
        PlayerSupervisor.create_player(player, table.name)

        count = Enum.count(table.players)
        rand_position = Enum.random(0..count)
        players = List.insert_at(table.players, rand_position, player)
        {:ok, %{table | players: players}}
    end
  end

  def enough_players?(table) do
    Enum.count(table.players) >= 3
  end

  def start!(table) do
    table = put_players_on_bench!(table, table.players)
    %{table | status: :playing}
  end

  defp put_players_on_bench!(table, [] = _players) do
    table
  end

  defp put_players_on_bench!(table, [player | tail] = _players) do
    Player.status(player, :on_bench)
    table = assign_initial_blinds(table)
    put_players_on_bench!(table, tail)
  end

  defp assign_initial_blinds(%{players: players} = table) when length(players) >= 3 do
    {:ok, button} = Enum.fetch(table.players, 0)
    {:ok, small} = Enum.fetch(table.players, 1)
    {:ok, big} = Enum.fetch(table.players, 2)

    %{table | button: button, small_blind: small, big_blind: big}
  end
end
