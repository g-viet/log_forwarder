defmodule LogForwader do
  @moduledoc """
  A simple LogForwarder backend which run as a supervisor to forward logs to another server.
  """

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

  @doc """
  Send log

  ## Parameters:
  | Param | Description | Example |
  |-|-|-|
  | `tag` | Tag of log | `API`, `Auth`, ...|
  | `level` | Log level | `:info` or `:error`|
  | `data` | Log data | `%{user_id: 123, function_name: 'Client.sample_func', ...`} |

  ## Examples

      iex> LogForwarder.send_log('API', :info, data)

  """
  @spec send_log(tag :: binary, level :: Atom.t(), data :: Map.t()) :: {:ok, pid} | nil
  def send_log(tag, level, data) when level in [:info, :error] and is_map(data) do
    Task.start(fn ->
      tag_with_level = "#{tag}.#{level}"

      data = Map.put(data, "level", "#{level}")

      GenServer.cast(Client, {:send, tag_with_level, data})
    end)
  end

  def send_log(_, _, _), do: nil
end
