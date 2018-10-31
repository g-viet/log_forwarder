defmodule LogForwader do
  use Supervisor
  alias LogForwader.Client

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    Supervisor.init(
      [
        {Client, []}
      ],
      strategy: :one_for_one
    )
  end

  @spec send_log(tag :: binary, level :: Atom.t(), data :: Map.t()) :: {:ok, pid} | nil
  def send_log(tag, level, data) when level in [:info, :error] and is_map(data) do
    Task.start(fn ->
      tag_with_level = "#{tag}.#{level}"

      data =
        data
        |> Map.take(log_attrs())
        |> Map.put("level", "#{level}")

      GenServer.cast(Client, {:send, tag_with_level, data})
    end)
  end

  def send_log(_, _, _), do: nil

  defp log_attrs do
    ~w(level error)
  end
end
