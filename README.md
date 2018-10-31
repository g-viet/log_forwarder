  LogForwarder
=================

A simple `LogForwarder` backend as a supervisor which forwards logs to another server.

## Installation

```elixir
def deps do
  [
    {:log_forwarder, "~> 0.2.1"}
  ]
end
```

## Configuration

Our config.exs would have an entry similar to this:

```elixir
config :log_forwarder, config:
    host: "localhost",
    port: 24224,
    prefix: "LogForwarder",
    retry_times: 10,
    attributes: ~w(level error ...)
```

`LogForwarder` supports the following configuration values:

* host
* port
* prefix
* retry_times
* attributes

## How to use

The typical use of `LogForwarder` is to set up using a Supervisor. It can be handled automatically:
1. Add following into `application.ex`:

```elixir
def start(_type, _args) do
    Supervisor.start_link(
        [ supervisor(LogForwarder, []),
        # other Supervisor or Worker
        ]
    )
end
```

2. Ensure `LogForwarder` is started before your app:
```elixir
def application do
  [applications: [:cachex]]
end
```

3. Then:
```elixir
defmodule SampleModule do
    import LogForwarder

    def sample_func() do
        # do something ...
        send_log("api_tag", :info, data)
    end
end

```

## Todo
- Add unit test
