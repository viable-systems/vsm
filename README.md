# VSM - Viable Systems Model

The complete Viable Systems Model implementation integrating all VSM components into a unified platform.

## Overview

VSM is the main application that brings together all the components of the Viable Systems Model:

- **vsm-core** - Core VSM implementation with S1-S5 subsystems
- **vsm-connections** - Connection infrastructure and resilience
- **vsm-external-interfaces** - HTTP, WebSocket, and gRPC interfaces  
- **vsm-telemetry** - Prometheus metrics and observability
- **vsm-security** - Z3N security framework with neural threat detection
- **vsm-event-bus** - Event routing and pub/sub messaging
- **vsm-rate-limiter** - Rate limiting with Hammer
- **vsm-goldrush** - Pattern matching and event processing
- **vsm-starter** - Template for new VSM applications

## Architecture

VSM uses Elixir's umbrella application structure to manage all components while maintaining clear boundaries between them. Each component can be developed and tested independently while working seamlessly together.

## Quick Start

### Prerequisites

- Elixir 1.15+
- Erlang/OTP 26+
- PostgreSQL (for vsm-security)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/viable-systems/vsm.git
cd vsm
```

2. Install dependencies:
```bash
mix deps.get
```

3. Compile the project:
```bash
mix compile
```

4. Run the system:
```bash
mix run --no-halt
```

The system will start with:
- HTTP API on port 4000
- WebSocket server on port 4001  
- Prometheus metrics on port 4002
- All VSM subsystems (S1-S5) active
- Z3N security network enabled
- Event bus routing messages
- Rate limiting active

## Testing

Run the comprehensive test suite:
```bash
./test_100_percent.sh
```

This verifies:
- All applications compile without errors
- All applications start without crashes
- HTTP endpoints respond correctly
- Telemetry metrics are collected
- No runtime failures

## Configuration

Main configuration is in `config/config.exs`. Each component also has its own configuration section:

- VSM Core settings (system ID, telemetry prefix)
- Connection pool sizes and circuit breaker thresholds
- HTTP/WebSocket/gRPC ports
- Security settings (Z3N network enabled by default)
- Rate limiting parameters
- Event bus topology

## Development

VSM uses an umbrella structure where each component is in the `apps/` directory:

```
vsm/
├── apps/
│   ├── vsm_core/
│   ├── vsm_connections/
│   ├── vsm_external_interfaces/
│   └── ... (other components)
├── config/
├── mix.exs
└── README.md
```

Each component can be worked on independently:
```bash
cd apps/vsm_core
mix test
```

## Production Deployment

VSM is designed for production use with:

- OTP supervision trees for fault tolerance
- Health check endpoints
- Prometheus metrics for monitoring
- Circuit breakers for external connections
- Rate limiting for API protection
- Z3N security for threat detection

## Contributing

See the individual component repositories for specific contribution guidelines.

## License

Part of the Viable Systems Model project.