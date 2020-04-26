defmodule Pokerly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Pokerly.Worker.start_link(arg)
      # {Pokerly.Worker, arg}
      {Registry, keys: :unique, name: Registry.Game},
      {Registry, keys: :unique, name: Registry.Player},
      Pokerly.GameSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pokerly.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
