#!/usr/bin/env bash
set -euo pipefail

# Creates a local virtual environment and installs requirements
VENVDIR=".venv"
REQ_FILE="root/requirements.txt"

if [ ! -f "$REQ_FILE" ]; then
  echo "Requirements file not found: $REQ_FILE" >&2
  exit 1
fi

python3 -m venv "$VENVDIR"
echo "Created virtualenv at $VENVDIR"
echo "Activating and installing packages..."
# shellcheck disable=SC1090
source "$VENVDIR/bin/activate"
pip install --upgrade pip
pip install -r "$REQ_FILE"
echo "Installation complete. Activate with: source $VENVDIR/bin/activate"
