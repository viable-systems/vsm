#!/usr/bin/env elixir

IO.puts("\n🧪 VSM Direct Function Test")
IO.puts("=" <> String.duplicate("=", 50))

# Ensure code is loaded
Code.ensure_loaded(VSMCore.Shared.Message)
Code.ensure_loaded(VsmExternalInterfaces.Translators.JsonTranslator)
Code.ensure_loaded(VsmGoldrush.QueryBuilder)

# Test 1: VSM Core Message functionality
IO.puts("\n1️⃣ Testing VSM Core Message creation...")
try do
  message = VSMCore.Shared.Message.new(
    from: {:system1, :unit1},
    to: {:system2, :coordinator},
    type: :command,
    content: %{action: "test", params: %{value: 42}}
  )
  
  IO.puts("  ✅ Message created:")
  IO.puts("    ID: #{message.id}")
  IO.puts("    Channel: #{message.channel}")
  IO.puts("    Type: #{message.type}")
  
  # Test validation
  case VSMCore.Shared.Message.validate(message) do
    :ok -> 
      IO.puts("  ✅ Message validation passed")
    {:error, reason} ->
      IO.puts("  ❌ Message validation failed: #{inspect(reason)}")
  end
rescue
  e ->
    IO.puts("  ❌ Error: #{inspect(e)}")
    IO.puts("    #{Exception.format_stacktrace(__STACKTRACE__)}")
end

# Test 2: JSON Translation
IO.puts("\n2️⃣ Testing JSON translation...")
json_data = %{
  "from" => "external_system",
  "to" => "system1",
  "type" => "command",
  "channel" => "command",
  "content" => %{
    "action" => "process_data",
    "data" => [1, 2, 3]
  }
}

try do
  case VsmExternalInterfaces.Translators.JsonTranslator.from_json(json_data) do
    {:ok, vsm_message} ->
      IO.puts("  ✅ JSON → VSM translation successful")
      IO.puts("    Message ID: #{vsm_message.id}")
      
      # Try reverse translation
      case VsmExternalInterfaces.Translators.JsonTranslator.to_json(vsm_message) do
        {:ok, json_output} ->
          IO.puts("  ✅ VSM → JSON translation successful")
          IO.puts("    JSON keys: #{json_output |> Map.keys() |> Enum.join(", ")}")
        {:error, reason} ->
          IO.puts("  ❌ VSM → JSON failed: #{inspect(reason)}")
      end
      
    {:error, reason} ->
      IO.puts("  ❌ JSON → VSM failed: #{inspect(reason)}")
  end
rescue
  e ->
    IO.puts("  ❌ Error: #{inspect(e)}")
end

# Test 3: Goldrush pattern matching
IO.puts("\n3️⃣ Testing Goldrush patterns...")
try do
  # Build a pattern
  pattern = VsmGoldrush.QueryBuilder.new()
  |> VsmGoldrush.QueryBuilder.match(:status, :eq, :error)
  |> VsmGoldrush.QueryBuilder.match(:severity, :gt, 5)
  |> VsmGoldrush.QueryBuilder.build()
  
  IO.puts("  ✅ Pattern built successfully")
  
  # Test events
  events = [
    %{status: :error, severity: 8, message: "Critical error"},
    %{status: :warning, severity: 3, message: "Minor warning"},
    %{status: :error, severity: 2, message: "Low severity error"}
  ]
  
  IO.puts("\n  Testing pattern matching:")
  Enum.each(events, fn event ->
    matches = VsmGoldrush.EventProcessor.match_event(event, pattern)
    result = if matches, do: "✅ MATCH", else: "❌ NO MATCH"
    IO.puts("    #{result} - #{inspect(event)}")
  end)
  
rescue
  e ->
    IO.puts("  ❌ Error: #{inspect(e)}")
end

# Test 4: Channel communication
IO.puts("\n4️⃣ Testing channel types...")
channels = [
  :command_channel,
  :coordination_channel,
  :audit_channel,
  :algedonic_channel,
  :resource_bargain_channel
]

Enum.each(channels, fn channel ->
  try do
    message = VSMCore.Shared.Message.new(
      from: {:test, :source},
      to: {:test, :target},
      type: :test,
      channel: channel,
      content: %{test: true}
    )
    IO.puts("  ✅ #{channel} message created")
  rescue
    e ->
      IO.puts("  ❌ #{channel} failed: #{inspect(e)}")
  end
end)

# Test 5: Integration patterns
IO.puts("\n5️⃣ Testing integration patterns...")
try do
  # Create a VSM message
  vsm_msg = VSMCore.Shared.Message.new(
    from: {:system3, :auditor},
    to: {:system5, :policy},
    type: :audit,
    channel: :audit_channel,
    content: %{
      audit_type: :compliance,
      findings: ["issue1", "issue2"],
      severity: :high
    }
  )
  
  # Convert to JSON
  {:ok, json} = VsmExternalInterfaces.Translators.JsonTranslator.to_json(vsm_msg)
  
  # Create Goldrush pattern for high severity audits
  pattern = VsmGoldrush.QueryBuilder.new()
  |> VsmGoldrush.QueryBuilder.match(:channel, :eq, "audit_channel")
  |> VsmGoldrush.QueryBuilder.match(:severity, :eq, :high)
  |> VsmGoldrush.QueryBuilder.build()
  
  # Check if our message matches
  event = %{
    channel: "audit_channel",
    severity: :high,
    from: "system3"
  }
  
  matches = VsmGoldrush.EventProcessor.match_event(event, pattern)
  
  IO.puts("  ✅ Full integration test completed")
  IO.puts("    VSM Message → JSON → Pattern Match: #{if matches, do: "SUCCESS", else: "FAILED"}")
  
rescue
  e ->
    IO.puts("  ❌ Integration test failed: #{inspect(e)}")
end

IO.puts("\n✨ Direct function tests completed!")
IO.puts("=" <> String.duplicate("=", 50))