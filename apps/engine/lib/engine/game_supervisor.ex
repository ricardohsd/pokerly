defmodule Engine.GameSupervisor do
  use DynamicSupervisor

  alias Engine.Game

  def start_link(_options), do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)

  def start_game(name, owner) do
    spec = {Game, name: name, owner: owner}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_game(name), do: DynamicSupervisor.terminate_child(__MODULE__, Game.pid_of(name))
end
