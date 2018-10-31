defmodule LogForwarder.MixProject do
  use Mix.Project

  def project do
    [
      app: :log_forwarder,
      version: "0.2.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/g-viet/log_forwarder"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :msgpax, :socket],
      mod: {LogForwarder.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:msgpax, "~> 2.1"},
      {:socket, "~> 0.3"},
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A log forwarder backend which run as a supervisor to forward logs to another server."
  end

  defp package do
    [
      files: ["lib", "mix.exs", ".formatter.exs", "README*"],
      maintainers: ["Viet Nguyen"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/g-viet/log_forwarder"}
    ]
  end
end
