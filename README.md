# Fitbit

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add fitbit to your list of dependencies in `mix.exs`:

        def deps do
          [{:fitbit, "~> 0.0.1"}]
        end

  2. Ensure fitbit is started before your application:

        def application do
          [applications: [:fitbit]]
        end

  3. Add your client details to your configuration:

        config :fitbit,
          client_id: System.get_env("FITBIT_CLIENT_ID"),
          client_secret: System.get_env("FITBIT_CLIENT_SECRET")
