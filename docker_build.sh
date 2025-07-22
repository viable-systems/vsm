#!/bin/bash

# VSM Docker Build Script
set -e

echo "🐳 Building VSM 12-Module Docker Image"
echo "======================================"

# Default values
REGISTRY=${DOCKER_REGISTRY:-"ghcr.io"}
NAMESPACE=${DOCKER_NAMESPACE:-"viable-systems"}
IMAGE_NAME="vsm"
VERSION=${VSM_VERSION:-"latest"}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --push)
      PUSH=true
      shift
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    --dev)
      DEV_BUILD=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Full image name
FULL_IMAGE="${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${VERSION}"

echo "Building: ${FULL_IMAGE}"

# Build the image
if [ "$DEV_BUILD" = true ]; then
  echo "🔨 Building development image..."
  docker build -f Dockerfile.dev -t "${FULL_IMAGE}-dev" .
else
  echo "🔨 Building production image..."
  docker build -t "${FULL_IMAGE}" .
  
  # Also tag as latest
  docker tag "${FULL_IMAGE}" "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:latest"
fi

echo "✅ Build complete!"

# Push if requested
if [ "$PUSH" = true ]; then
  echo "📤 Pushing to registry..."
  docker push "${FULL_IMAGE}"
  
  if [ "$DEV_BUILD" != true ]; then
    docker push "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:latest"
  fi
  
  echo "✅ Push complete!"
fi

echo ""
echo "🚀 VSM Docker image ready!"
echo ""
echo "To run locally:"
echo "  docker run -p 4000:4000 -p 4040:4040 ${FULL_IMAGE}"
echo ""
echo "To use docker-compose:"
echo "  docker-compose up -d"