#!/usr/bin/env elixir

IO.puts("\n🧪 VSM Minimal Runtime Test")
IO.puts("=" <> String.duplicate("=", 50))

# Test starting just VSM Core
IO.puts("\n1️⃣ Starting VSM Core...")
case Application.ensure_all_started(:vsm_core) do
  {:ok, apps} ->
    IO.puts("  ✅ VSM Core started successfully")
    IO.puts("  Started apps: #{inspect(apps)}")
    
    # Check if channels are running
    channels = [
      VSMCore.Channels.CommandChannel,
      VSMCore.Channels.CoordinationChannel,
      VSMCore.Channels.AuditChannel,
      VSMCore.Channels.AlgedonicChannel,
      VSMCore.Channels.ResourceBargainChannel
    ]
    
    IO.puts("\n  📡 Checking channels:")
    Enum.each(channels, fn channel ->
      case Process.whereis(channel) do
        nil -> IO.puts("    ❌ #{inspect(channel)} not running")
        pid -> IO.puts("    ✅ #{inspect(channel)} running: #{inspect(pid)}")
      end
    end)
    
    # Test creating a message
    IO.puts("\n  📨 Testing message creation:")
    try do
      message = VSMCore.Shared.Message.new(
        from: {:system1, :unit1},
        to: {:system2, :coordinator},
        type: :command,
        content: %{action: "test"}
      )
      IO.puts("    ✅ Message created: #{inspect(message.id)}")
    rescue
      e ->
        IO.puts("    ❌ Failed to create message: #{inspect(e)}")
    end
    
  {:error, {app, reason}} ->
    IO.puts("  ❌ Failed to start #{app}: #{inspect(reason)}")
end

# Test starting VSM Connections
IO.puts("\n2️⃣ Starting VSM Connections...")
case Application.ensure_all_started(:vsm_connections) do
  {:ok, apps} ->
    IO.puts("  ✅ VSM Connections started successfully")
    IO.puts("  Started apps: #{inspect(apps)}")
  {:error, {app, reason}} ->
    IO.puts("  ❌ Failed to start #{app}: #{inspect(reason)}")
end

# Test starting VSM External Interfaces
IO.puts("\n3️⃣ Starting VSM External Interfaces...")
case Application.ensure_all_started(:vsm_external_interfaces) do
  {:ok, apps} ->
    IO.puts("  ✅ VSM External Interfaces started successfully")
    IO.puts("  Started apps: #{inspect(apps)}")
    
    # Check HTTP endpoint
    IO.puts("\n  🌐 Checking HTTP endpoint:")
    case :httpc.request(:get, {'http://localhost:4000/health', []}, [], []) do
      {:ok, {{_, 200, _}, _, _}} ->
        IO.puts("    ✅ HTTP endpoint responding on port 4000")
      {:ok, {{_, code, _}, _, _}} ->
        IO.puts("    ⚠️  HTTP endpoint returned code #{code}")
      {:error, reason} ->
        IO.puts("    ❌ HTTP endpoint not responding: #{inspect(reason)}")
    end
    
  {:error, {app, reason}} ->
    IO.puts("  ❌ Failed to start #{app}: #{inspect(reason)}")
end

# Summary
IO.puts("\n📊 Summary:")
IO.puts("=" <> String.duplicate("=", 50))

running_apps = Application.started_applications() |> Enum.map(fn {app, _, _} -> app end)
vsm_apps = [:vsm_core, :vsm_connections, :vsm_external_interfaces, :vsm_telemetry, :vsm_goldrush]
running_vsm = Enum.filter(vsm_apps, &(&1 in running_apps))

IO.puts("VSM Applications Running: #{length(running_vsm)}/#{length(vsm_apps)}")
Enum.each(running_vsm, fn app ->
  IO.puts("  ✅ #{app}")
end)

IO.puts("\n💡 Press Ctrl+C twice to stop.")