#!/usr/bin/env bash
set -euo pipefail
OUT="${HOME}/Videos/recording_$(date +%Y%m%d_%H%M%S).mp4"
mkdir -p "${HOME}/Videos"
wf-recorder -f "$OUT" -g "$(slurp)" 2>/dev/null || wf-recorder -f "$OUT"
notify-send "Recording saved" "$OUT" 2>/dev/null || true
