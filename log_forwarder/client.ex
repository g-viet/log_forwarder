defmodule LogForwader.Client do
  use GenServer

  require Logger

  defmodule State do
    defstruct socket: nil, config: []
  end

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  def init(_options) do
    config = compile_config() || default_config()
    {:ok, %State{config: config}}
  end

  def handle_cast(msg, %State{socket: nil, config: config} = state) do
    if socket = connect(config, config[:retry_times]) do
      handle_cast(msg, %State{state | socket: socket})
    else
      Logger.error("Cannot connect to #{config[:host]}:#{config[:port]}")
      {:noreply, state}
    end
  end

  def handle_cast({:send, tag, data}, state) do
    state = send(tag, data, state)
    {:noreply, state}
  end

  def handle_cast(_, state), do: {:noreply, state}

  defp connect(config, retry_times) do
    case Socket.TCP.connect(config[:host], config[:port], packet: 0) do
      {:ok, socket} ->
        socket

      {:error, _error} ->
        Logger.info("Try connecting to: #{config[:host]}:#{config[:port]}", type: :common)

        if retry_times > 0 do
          :timer.sleep(10)
          connect(config, retry_times - 1)
        end
    end
  end

  defp send(tag, data, %State{socket: socket, config: config} = state) do
    try do
      cur_time = System.system_time(:second)
      packet = Msgpax.pack!([tag, cur_time, data])
      Socket.Stream.send!(socket, packet)
    rescue
      reason in _ ->
        Logger.error("#{inspect(reason)}")
    end

    state
  end

  defp default_config do
    [
      host: "localhost",
      port: 24224,
      prefix: "LogForwarder",
      retry_times: 10
    ]
  end

  defp compile_config, do: Application.get_env(:log_forwarder, :config)
end
