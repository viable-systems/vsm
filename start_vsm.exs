#!/usr/bin/env elixir

# VSM Umbrella Application Startup Script
# This starts all VSM components with proper supervision

IO.puts("\n🚀 Starting VSM Umbrella Application...")
IO.puts("=" <> String.duplicate("=", 50))

# Check if all apps are available
apps = [:vsm_core, :vsm_connections, :vsm_external_interfaces, :vsm_telemetry, :vsm_goldrush]

IO.puts("\n📦 Checking VSM applications...")
Enum.each(apps, fn app ->
  case Application.ensure_all_started(app) do
    {:ok, started} ->
      IO.puts("✅ #{app} started (#{length(started)} apps)")
    {:error, {app, reason}} ->
      IO.puts("❌ Failed to start #{app}: #{inspect(reason)}")
  end
end)

IO.puts("\n📊 System Status:")
IO.puts("=" <> String.duplicate("=", 50))

# Check HTTP endpoints
IO.puts("\n🌐 HTTP Endpoints:")
IO.puts("  - External Interfaces: http://localhost:4000")
IO.puts("  - Telemetry Dashboard: http://localhost:4002")

# Check processes
IO.puts("\n📈 Running Processes:")
process_info = [
  {VSMCore.Application, "VSM Core"},
  {VsmConnections.Application, "VSM Connections"},
  {VsmExternalInterfaces.Application, "VSM External Interfaces"},
  {VsmTelemetry.Application, "VSM Telemetry"},
  {VsmGoldrush.Application, "VSM Goldrush"}
]

Enum.each(process_info, fn {mod, name} ->
  case Process.whereis(mod) do
    nil -> IO.puts("  ⚠️  #{name}: Not running")
    pid -> IO.puts("  ✅ #{name}: #{inspect(pid)}")
  end
end)

# Show some basic metrics
IO.puts("\n📊 Basic Metrics:")
IO.puts("  - Memory: #{:erlang.memory(:total) |> div(1024 * 1024)} MB")
IO.puts("  - Processes: #{length(Process.list())}")
IO.puts("  - Atoms: #{:erlang.system_info(:atom_count)}")

IO.puts("\n✨ VSM Umbrella is running!")
IO.puts("Press Ctrl+C twice to stop.\n")

# Keep the script running
Process.sleep(:infinity)