#!/usr/bin/env bash
set -euo pipefail

open_source_skills=(
  "linearis-oss/linearis"
)

for skill in "${open_source_skills[@]}"; do
  npx --yes skills add "${skill}"
done
