#!/bin/bash

echo "=========================================="
echo "📦 SETTING UP COLD TURKEY CLONE (MAC/LINUX)"
echo "=========================================="

# Setup Backend
echo ""
echo "[1/4] Setting up Python Backend..."
cd ../../api_server
uv sync

# Setup Frontend
echo ""
echo "[2/4] Setting up Next.js Frontend..."
cd ../web_server
pnpm install

echo ""
echo "=========================================="
echo "✅ SETUP COMPLETE!"
echo "Run './run_mac.sh' to start."
echo "=========================================="