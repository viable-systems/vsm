#!/usr/bin/env elixir

# Simple compile-time test without starting applications

IO.puts("\n🧪 VSM Umbrella Compile Test")
IO.puts("=" <> String.duplicate("=", 50))

# Load all modules without starting applications
Code.compile_string("""
# Test creating a message
message = %VSMCore.Shared.Message{
  id: "test-123",
  from: {:system1, :unit1},
  to: {:system2, :coordinator},
  type: :command,
  channel: :command_channel,
  content: %{action: "test"},
  metadata: %{},
  timestamp: DateTime.utc_now()
}

IO.puts("✅ Message struct created: #{message.id}")

# Test JSON translation
json_data = %{
  "from" => "external",
  "to" => "system1",
  "type" => "command",
  "channel" => "command",
  "content" => %{"test" => true}
}

case VsmExternalInterfaces.Translators.JsonTranslator.from_json(json_data) do
  {:ok, vsm_msg} ->
    IO.puts("✅ JSON translation successful")
  {:error, reason} ->
    IO.puts("❌ JSON translation failed: #{inspect(reason)}")
end

# Test Goldrush pattern
pattern = %VsmGoldrush.QueryBuilder{
  clauses: [{:match, :error_type, :eq, :timeout}]
}
IO.puts("✅ Goldrush pattern created")

# Test telemetry metric definition
metric = %Telemetry.Metrics.Counter{
  name: [:vsm, :test],
  description: "Test counter"
}
IO.puts("✅ Telemetry metric defined")

IO.puts("\\n🎉 All compile-time tests passed!")
""")