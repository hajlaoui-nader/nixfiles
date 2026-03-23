#!/bin/sh
set -e

# Capture available bytes before
before_avail=$(df -k / | tail -1 | awk '{print $4}')

echo "╔══════════════════════════════════════╗"
echo "║         Nix Garbage Collection       ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "▶ Before"
df -h / | tail -1
echo ""

echo "▶ Deleting old generations..."
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
nix-env --delete-generations old --profile ~/.local/state/nix/profiles/home-manager
echo ""

echo "▶ Running garbage collection..."
nix-store --gc
echo ""

# Capture available bytes after
after_avail=$(df -k / | tail -1 | awk '{print $4}')

echo "▶ After"
df -h / | tail -1
echo ""

# Compute saved (in KB, then convert)
saved_kb=$(( after_avail - before_avail ))

if [ "$saved_kb" -ge 1048576 ]; then
  saved=$(awk "BEGIN {printf \"%.1f GiB\", $saved_kb / 1048576}")
elif [ "$saved_kb" -ge 1024 ]; then
  saved=$(awk "BEGIN {printf \"%.1f MiB\", $saved_kb / 1024}")
else
  saved="${saved_kb} KiB"
fi

echo "══════════════════════════════════════"
if [ "$saved_kb" -gt 0 ]; then
  echo "  ✓ Freed: ${saved}"
else
  echo "  ✓ Nothing to collect (already clean)"
fi
echo "══════════════════════════════════════"
