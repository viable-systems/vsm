import Config

# Configure your endpoints for test
config :vsm_external_interfaces, VsmExternalInterfaces.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4001],
  secret_key_base: "vQYGx8XhYsVBm4Lqb7mhIjRZfKaVLqBvNhKxqQxh3nK2vRjQ6V7yDvQ2fK5qXxXn",
  server: false

config :vsm_telemetry, VsmTelemetry.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4003],
  secret_key_base: "xYGx8XhYsVBm4Lqb7mhIjRZfKaVLqBvNhKxqQxh3nK2vRjQ6V7yDvQ2fK5qXxXn",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Disable costly runtime tests
config :bcrypt_elixir, :log_rounds, 1