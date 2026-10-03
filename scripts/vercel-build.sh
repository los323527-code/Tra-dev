#!/bin/bash
set -euo pipefail

TOOLCHAIN="1.99.0"

if ! command -v rustup >/dev/null 2>&1; then
  echo ">> rustup not found, installing"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --profile minimal --default-toolchain none
fi
export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:/rust/bin:$HOME/.cargo/bin:$PATH"

echo ">> Rust toolchain $TOOLCHAIN"
rustup toolchain install "$TOOLCHAIN" --profile minimal -t wasm32-unknown-unknown
rustup default "$TOOLCHAIN"

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
