#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$ ]]; then
  echo "Usage: $0 <version> (for example: 1.0.0+19)" >&2
  exit 2
fi

version="$1"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"
snap_file="$repo_root/ksvh-exam-scholar_${version}_amd64.snap"

if ! command -v snapcraft >/dev/null 2>&1; then
  echo "Error: snapcraft is required but was not found in PATH." >&2
  exit 1
fi

if [[ -e "$snap_file" ]]; then
  echo "Error: $snap_file already exists; move it before running this release." >&2
  exit 1
fi

python3 - "$repo_root" "$version" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
version = sys.argv[2]
files = {
    root / "pubspec.yaml": f"version: {version}",
    root / "snap" / "snapcraft.yaml": f"version: '{version}'",
}

updates = {}
for path, replacement in files.items():
    contents = path.read_text()
    updated, count = re.subn(r"(?m)^version:\s*.*$", replacement, contents)
    if count != 1:
        raise SystemExit(f"Error: expected one version entry in {path}, found {count}.")

    updates[path] = updated

for path, updated in updates.items():
    path.write_text(updated)
    print(f"Updated {path.relative_to(root)} to {version}")
PY

cd "$repo_root"
snapcraft pack

if [[ ! -f "$snap_file" ]]; then
  echo "Error: snapcraft pack completed but did not create $snap_file." >&2
  exit 1
fi

snapcraft upload --release=beta "$snap_file"
rm -- "$snap_file"
echo "Uploaded version $version to the beta channel and removed the local Snap package."
