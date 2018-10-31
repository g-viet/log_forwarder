defmodule LogForwarder.MixProject do
  use Mix.Project

  def project do
    [
      app: :log_forwarder,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :msgpax, :socket]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:msgpax, "~> 2.1"},
      {:socket, "~> 0.3"}
    ]
  end
end
