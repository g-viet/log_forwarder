defmodule LogForwarder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      LogForwarder
      # Starts a worker by calling: LogForwarder.Worker.start_link(arg)
      # {LogForwarder.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LogForwarder.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
