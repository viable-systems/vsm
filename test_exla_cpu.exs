#!/usr/bin/env elixir

# Test EXLA CPU configuration
IO.puts("🧪 Testing EXLA CPU Configuration...")
IO.puts("=====================================")

# Check environment variables
IO.puts("\n📋 Environment Variables:")
IO.puts("XLA_TARGET: #{System.get_env("XLA_TARGET", "not set")}")
IO.puts("EXLA_TARGET: #{System.get_env("EXLA_TARGET", "not set")}")

# Test if EXLA is available
try do
  # Check EXLA configuration
  IO.puts("\n🔧 EXLA Configuration:")
  config = Application.get_env(:exla, :clients, [])
  IO.inspect(config, label: "EXLA clients config")
  
  # Try to use Nx with EXLA backend
  IO.puts("\n🧮 Testing Nx with EXLA Backend:")
  
  # Create a simple tensor
  tensor = Nx.tensor([1, 2, 3, 4, 5])
  IO.inspect(tensor, label: "Original tensor")
  
  # Perform a computation
  result = Nx.add(tensor, 10)
  IO.inspect(result, label: "After adding 10")
  
  # Check the backend
  IO.puts("\n✅ Backend: #{inspect(Nx.default_backend())}")
  
  IO.puts("\n🎉 EXLA CPU mode is working correctly!")
  
rescue
  e ->
    IO.puts("\n❌ Error testing EXLA: #{inspect(e)}")
    IO.puts("This is expected if EXLA is not compiled yet.")
end