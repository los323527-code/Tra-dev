#!/bin/bash
# Vercel build: installs Rust + Trunk, then builds the Yew/WASM site into dist/
set -euo pipefail

TOOLCHAIN="1.99.0"

echo ">> Installing Rust $TOOLCHAIN"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
  | sh -s -- -y --profile minimal --default-toolchain "$TOOLCHAIN" -t wasm32-unknown-unknown
export PATH="$HOME/.cargo/bin:$PATH"
rustup target add wasm32-unknown-unknown

echo ">> Installing Trunk (prebuilt binary)"
mkdir -p "$HOME/.local/bin"
curl -sSfL https://github.com/trunk-rs/trunk/releases/latest/download/trunk-x86_64-unknown-linux-gnu.tar.gz \
  | tar -xz -C "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

rustc --version
trunk --version

echo ">> Building"
trunk build --release --public-url /

ls -la dist
