#!/bin/bash
set -euxo pipefail

TOOLCHAIN="1.99.0"

if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --profile minimal --default-toolchain none
fi
export PATH="${CARGO_HOME:-$HOME/.cargo}/bin:/rust/bin:$HOME/.cargo/bin:$PATH"

rustup toolchain install "$TOOLCHAIN" --profile minimal -t wasm32-unknown-unknown
rustup default "$TOOLCHAIN"

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
if curl -sSfL https://github.com/trunk-rs/trunk/releases/latest/download/trunk-x86_64-unknown-linux-musl.tar.gz \
     | tar -xz -C "$HOME/.local/bin" && trunk --version; then
  echo ">> Using prebuilt musl Trunk"
else
  echo ">> Compiling Trunk from source (takes a few minutes)"
  rm -f "$HOME/.local/bin/trunk"
  cargo install --locked trunk --root "$HOME/.local"
fi

rustc --version
trunk --version

trunk build --release --public-url /
cp -r launcher dist/launcher

ls -la dist
