# VSM 12-Module Ecosystem Docker Image
FROM elixir:1.15-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    git \
    build-base \
    nodejs \
    npm \
    python3 \
    postgresql-client

# Set environment
ENV MIX_ENV=prod

# Create app directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy umbrella project files
COPY mix.exs mix.lock ./
COPY config config

# Copy all app directories (they're symlinks, but Docker follows them)
COPY apps apps

# Get all dependencies
RUN mix deps.get --only $MIX_ENV

# Compile all dependencies
RUN mix deps.compile

# Compile all VSM modules
RUN mix compile

# Build assets for telemetry dashboard
WORKDIR /app/apps/vsm_telemetry
RUN mix assets.deploy

# Build release
WORKDIR /app
RUN mix release

# Final stage - minimal runtime image
FROM alpine:3.18

# Install runtime dependencies
RUN apk add --no-cache \
    openssl \
    ncurses-libs \
    libstdc++ \
    libgcc

# Create app user
RUN adduser -D -h /app app

WORKDIR /app

# Copy release from builder
COPY --from=builder --chown=app:app /app/_build/prod/rel/vsm ./

# Set user
USER app

# Expose ports
EXPOSE 4000 4001 4040 50051

# Set up environment
ENV HOME=/app
ENV MIX_ENV=prod
ENV PORT=4000
ENV PHX_HOST=localhost

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD nc -z localhost 4000 || exit 1

# Start the VSM ecosystem
CMD ["bin/vsm", "start"]