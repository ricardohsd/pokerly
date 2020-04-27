defmodule Engine.PlayerSupervisor do
  use DynamicSupervisor

  alias Engine.Player

  def start_link(_options), do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)

  def create_player(name, game) do
    spec = {Player, name: name, game: game}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_player(name), do: DynamicSupervisor.terminate_child(__MODULE__, Player.pid_of(name))
end
