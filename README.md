  LogForwarder
=================

A simple `LogForwarder` backend which run as a supervisor to forward logs to another server.

## Configuration

Our config.exs would have an entry similar to this:

```elixir
config :log_forwarder,
  config: [
      host: "localhost",
      port: 24224,
      prefix: "LogForwarder",
      retry_times: 10,
      attributes: ~w(level error ...)
    ]
```

Application will start `LogForwader`.

`LogForwader` supports the following configuration values:

* host
* port
* prefix
* retry_times
* attributes

## How to use

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