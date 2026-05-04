#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$APP_ROOT"

set +u

if [ -f /etc/profile ]; then
  # shellcheck disable=SC1091
  source /etc/profile
fi

for profile in "${HOME:-}/.bash_profile" "${HOME:-}/.bashrc" "${HOME:-}/.profile"; do
  if [ -f "$profile" ]; then
    # shellcheck disable=SC1090
    source "$profile"
  fi
done

set -u

export RBENV_ROOT="/home/ubuntu/.rbenv"
export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
eval "$(rbenv init - bash)"
rbenv global 4.0.3

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command '$1' was not found in PATH." >&2
    echo "Current PATH: $PATH" >&2
    exit 127
  fi
}
