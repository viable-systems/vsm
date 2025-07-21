#!/bin/bash

echo "🔧 VSM Umbrella Runtime Test"
echo "============================"
echo ""

# Start the applications in background
echo "📦 Starting VSM applications..."
mix run --no-halt &
APP_PID=$!

# Wait for startup
sleep 5

echo ""
echo "✅ Applications started with PID: $APP_PID"
echo ""

# Test HTTP endpoint
echo "🌐 Testing HTTP endpoint..."
curl -s http://localhost:4000/health | jq . || echo "  ❌ HTTP endpoint not responding"

echo ""
echo "📊 Running status checks..."

# Check if processes are running
if ps -p $APP_PID > /dev/null; then
    echo "  ✅ VSM applications are running"
else
    echo "  ❌ VSM applications failed to start"
fi

# List running applications
echo ""
echo "📋 Running applications:"
ps aux | grep beam | grep -v grep | head -5

# Gracefully stop
echo ""
echo "🛑 Stopping applications..."
kill -TERM $APP_PID
wait $APP_PID

echo ""
echo "✨ Runtime test complete!"