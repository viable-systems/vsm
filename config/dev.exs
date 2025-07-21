import Config

# For development, disable request forgery protection
config :vsm_external_interfaces, VsmExternalInterfaces.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "vQYGx8XhYsVBm4Lqb7mhIjRZfKaVLqBvNhKxqQxh3nK2vRjQ6V7yDvQ2fK5qXxXn",
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Development telemetry endpoint
config :vsm_telemetry, VsmTelemetry.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "xYGx8XhYsVBm4Lqb7mhIjRZfKaVLqBvNhKxqQxh3nK2vRjQ6V7yDvQ2fK5qXxXn",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:vsm_telemetry, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:vsm_telemetry, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading
config :vsm_telemetry, VsmTelemetry.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/vsm_telemetry/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]