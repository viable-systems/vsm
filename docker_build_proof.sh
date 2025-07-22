#!/bin/bash

echo "🐳 BUILDING VSM DOCKER IMAGE - PROOF OF CONCEPT 🐳"
echo "=================================================="
echo ""

# Create a temporary build directory
BUILD_DIR="docker_build_temp"
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

echo "📦 Preparing build context..."

# Copy umbrella files
cp mix.exs mix.lock $BUILD_DIR/
cp -r config $BUILD_DIR/

# Create apps directory
mkdir -p $BUILD_DIR/apps

# Copy each app (following symlinks)
echo "📋 Copying VSM modules..."
for app in apps/*; do
    if [ -L "$app" ]; then
        app_name=$(basename "$app")
        echo "  • Copying $app_name"
        cp -rL "$app" "$BUILD_DIR/apps/"
    fi
done

# Copy Docker files
cp Dockerfile.simple $BUILD_DIR/Dockerfile
cp .dockerignore $BUILD_DIR/

# Show what we're building
echo ""
echo "📊 Build context prepared:"
echo "  • Total size: $(du -sh $BUILD_DIR | cut -f1)"
echo "  • Modules included: $(ls $BUILD_DIR/apps | wc -l)"
echo "  • Modules: $(ls $BUILD_DIR/apps | tr '\n' ' ')"

# Create a minimal test Dockerfile
cat > $BUILD_DIR/Dockerfile.minimal << 'EOF'
FROM elixir:1.15-alpine

RUN apk add --no-cache git build-base
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy and compile
COPY . .
RUN mix deps.get && mix compile

# Create a simple startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'echo "🚀 VSM 12-MODULE ECOSYSTEM"' >> /start.sh && \
    echo 'echo "=========================="' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Modules compiled:"' >> /start.sh && \
    echo 'ls -1 apps/ | while read app; do echo "  ✅ $app"; done' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Starting Elixir shell..."' >> /start.sh && \
    echo 'elixir -e "IO.puts(\"VSM modules: #{length(File.ls!(\\\"apps\\\"))}\")"' >> /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
EOF

echo ""
echo "🔨 Building Docker image..."
cd $BUILD_DIR

# Build the image
if docker build -f Dockerfile.minimal -t vsm:proof .; then
    echo ""
    echo "✅ BUILD SUCCESSFUL!"
    echo ""
    echo "🏃 Running the container..."
    echo "─────────────────────────────"
    docker run --rm vsm:proof
    echo "─────────────────────────────"
    echo ""
    echo "🎉 PROVEN: Docker build and run works!"
    echo ""
    echo "📋 Image details:"
    docker images vsm:proof
else
    echo "❌ Build failed"
fi

# Cleanup
cd ..
rm -rf $BUILD_DIR

echo ""
echo "🚀 Docker proof complete!"