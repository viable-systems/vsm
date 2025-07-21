# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :subsystem, :channel]

# VSM Core configuration
config :vsm_core,
  system_id: "vsm_umbrella",
  environment: Mix.env(),
  telemetry_prefix: [:vsm, :core]

# VSM Connections configuration
config :vsm_connections,
  default_pool_size: 10,
  circuit_breaker_threshold: 5,
  circuit_breaker_timeout: 60_000,
  health_check_interval: 30_000,
  health_checks: %{
    enabled: true,
    default_interval: 30_000,
    default_timeout: 5_000,
    max_failures: 3,
    services: %{
      vsm_core: %{
        url: "http://localhost:4000/health",
        interval: 30_000,
        timeout: 5_000
      }
    }
  }

# VSM External Interfaces configuration
config :vsm_external_interfaces,
  http_port: 4000,
  websocket_port: 4001,
  grpc_port: 50051

# VSM Telemetry configuration
config :vsm_telemetry,
  port: 4002,
  enabled: true

# VSM Goldrush configuration
config :vsm_goldrush,
  event_buffer_size: 10_000,
  pattern_check_interval: 1_000,
  cybernetic_failure_threshold: 0.7

# Configure Phoenix
config :phoenix, :json_library, Jason

# VSM Event Bus configuration
config :vsm_event_bus,
  node_name: :vsm_event_bus,
  cluster_strategy: :gossip,
  event_store_limit: 10_000,
  pubsub_adapter: Phoenix.PubSub.PG2

# VSM Rate Limiter configuration  
config :vsm_rate_limiter,
  default_rate: 100,
  default_interval: 60_000,
  storage_backend: :ets

# Hammer rate limiter configuration
config :hammer,
  backend: {Hammer.Backend.ETS, [
    expiry_ms: 60_000 * 60 * 4,
    cleanup_interval_ms: 60_000 * 10
  ]}

# VSM Security configuration
config :vsm_security,
  secret_key_base: "RvNX+3R5TGUnS8qJPkTHZlHh0nJF4p7DaD7VsMi4LjUfEaOJlJBmFGAQlwMxJqGg",
  encryption_salt: "vsm_security_salt",
  signing_salt: "vsm_signing_salt",
  z3n_network: %{
    enabled: true  # Enable Z3N network - fixed the self-call issue
  }

# VSM Security Guardian configuration
config :vsm_security, VsmSecurity.Guardian,
  issuer: "vsm_security",
  secret_key: "uY3dwYQKPJQkvOptSnBApHBhHyL4psRqviJkGGEf1iBbhQ8Z0GvEoarw6j/Zr+Jw"

# VSM Starter configuration
config :vsm_starter,
  environment: Mix.env(),
  telemetry_enabled: true

# Configure esbuild (to remove warning)
config :esbuild,
  version: "0.25.0",
  vsm_telemetry: [
    args: ~w(js/app.js --bundle --target=es2020 --outdir=../priv/static/assets),
    cd: Path.expand("../apps/vsm_telemetry/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (to remove warning)
config :tailwind,
  version: "4.0.9",
  vsm_telemetry: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/vsm_telemetry/assets", __DIR__)
  ]
