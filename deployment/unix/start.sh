#!/bin/bash

# Function to kill background processes on exit
cleanup() {
    echo "Stopping Backend..."
    kill $BACKEND_PID
}
trap cleanup EXIT

echo "=========================================="
echo "🚀 STARTING COLD TURKEY CLONE"
echo "=========================================="

# 1. Start Backend (Requires Sudo)
echo "🔒 Enter your password to allow 'hosts' file editing:"
cd ../../api_server
uv sync
# Run uvicorn in background
sudo uvicorn app.main:app --port 2345 &
BACKEND_PID=$!

# Wait a second for backend to initialize
sleep 10

# 2. Start Frontend
echo "Starting Web Server..."
cd ../web_server
pnpm run dev