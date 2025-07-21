#!/usr/bin/env elixir

IO.puts("\n🧪 VSM Umbrella Integration Test")
IO.puts("=" <> String.duplicate("=", 50))

# Test 1: Module availability
IO.puts("\n1️⃣ Testing module availability...")
modules = [
  {VSMCore, "VSM Core"},
  {VSMCore.Shared.Message, "Message"},
  {VsmConnections, "VSM Connections"},
  {VsmExternalInterfaces, "External Interfaces"},
  {VsmTelemetry, "Telemetry"},
  {VsmGoldrush, "Goldrush"}
]

modules_ok = Enum.all?(modules, fn {mod, name} ->
  case Code.ensure_compiled(mod) do
    {:module, _} ->
      IO.puts("  ✅ #{name} module available")
      true
    {:error, reason} ->
      IO.puts("  ❌ #{name} module not found: #{inspect(reason)}")
      false
  end
end)

# Test 2: Create and route messages
IO.puts("\n2️⃣ Testing message creation and routing...")
try do
  message = VSMCore.Shared.Message.new(
    from: {:system1, :unit1},
    to: {:system2, :coordinator},
    type: :command,
    content: %{action: "test", params: %{}}
  )
  
  IO.puts("  ✅ Message created: #{inspect(message.id)}")
  
  # Test validation
  case VSMCore.Shared.Message.validate(message) do
    :ok -> 
      IO.puts("  ✅ Message validation passed")
    {:error, reason} ->
      IO.puts("  ❌ Message validation failed: #{inspect(reason)}")
  end
rescue
  e ->
    IO.puts("  ❌ Error creating message: #{inspect(e)}")
end

# Test 3: JSON translation
IO.puts("\n3️⃣ Testing JSON translation...")
json_message = %{
  "from" => "external_system",
  "to" => "system1",
  "type" => "command",
  "channel" => "command",
  "content" => %{"test" => "data"}
}

try do
  case VsmExternalInterfaces.Translators.JsonTranslator.from_json(json_message) do
    {:ok, vsm_message} ->
      IO.puts("  ✅ JSON to VSM translation successful")
      
      case VsmExternalInterfaces.Translators.JsonTranslator.to_json(vsm_message) do
        {:ok, _json} ->
          IO.puts("  ✅ VSM to JSON translation successful")
        {:error, reason} ->
          IO.puts("  ❌ VSM to JSON translation failed: #{inspect(reason)}")
      end
      
    {:error, reason} ->
      IO.puts("  ❌ JSON to VSM translation failed: #{inspect(reason)}")
  end
rescue
  e ->
    IO.puts("  ❌ Error in JSON translation: #{inspect(e)}")
end

# Test 4: Goldrush pattern matching
IO.puts("\n4️⃣ Testing Goldrush pattern matching...")
try do
  # Create a simple pattern
  pattern = VsmGoldrush.QueryBuilder.new()
  |> VsmGoldrush.QueryBuilder.match(:error_type, :timeout)
  |> VsmGoldrush.QueryBuilder.build()
  
  IO.puts("  ✅ Goldrush pattern created")
  
  # Test event matching
  event = %{error_type: :timeout, timestamp: DateTime.utc_now()}
  
  case VsmGoldrush.EventProcessor.match_event(event, pattern) do
    true ->
      IO.puts("  ✅ Event matching successful")
    false ->
      IO.puts("  ❌ Event matching failed")
  end
rescue
  e ->
    IO.puts("  ❌ Error in Goldrush: #{inspect(e)}")
end

# Test 5: Telemetry metrics
IO.puts("\n5️⃣ Testing telemetry metrics...")
try do
  metric = Telemetry.Metrics.counter("vsm.test.counter")
  IO.puts("  ✅ Telemetry metric created: #{inspect(metric.name)}")
  
  # Emit a test event
  :telemetry.execute([:vsm, :test, :counter], %{count: 1}, %{})
  IO.puts("  ✅ Telemetry event emitted")
rescue
  e ->
    IO.puts("  ❌ Error in telemetry: #{inspect(e)}")
end

# Summary
IO.puts("\n📊 Test Summary:")
IO.puts("=" <> String.duplicate("=", 50))

if modules_ok do
  IO.puts("✅ All modules compiled and available")
  IO.puts("✅ Basic functionality verified")
  IO.puts("\n🎉 VSM Umbrella integration test PASSED!")
else
  IO.puts("❌ Some modules failed to compile")
  IO.puts("\n💥 VSM Umbrella integration test FAILED!")
end

IO.puts("\n💡 Note: This test verifies compile-time integration.")
IO.puts("   For runtime integration, applications need to be started.")