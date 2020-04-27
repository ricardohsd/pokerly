defmodule Engine.RegistryOf do
  def encode(name) do
    name |> String.downcase() |> Base.encode64()
  end

  defmacro __using__(registry) do
    quote do
      # ensure global name is normalized
      def via_tuple(name),
        do: {:via, Registry, {unquote(registry), Engine.RegistryOf.encode(name)}}

      def pid_of(name) do
        via_tuple(name)
        |> GenServer.whereis()
      end

      def exists?(name) do
        Registry.lookup(unquote(registry), Engine.RegistryOf.encode(name))
      end
    end
  end
end
