  LogForwarder
=================

A simple `LogForwarder` backend which forwards logs to another server which running as a supervisor

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
    import LogForwarder, only: [send_log: 3]

    def sample_func() do
        # do something ...
        send_log("api_tag", :info, data)
    end
end

```