#!/usr/bin/env bash
# Fetch the exact source revisions used by the LIO localization launch.
# This is intentionally explicit because older snapshots of this repository
# contain gitlinks without a .gitmodules file.
set -euo pipefail

workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ensure_revision() {
  local relative_path="$1"
  local remote_url="$2"
  local revision="$3"
  local target="$workspace_dir/$relative_path"

  if [ -e "$target" ]; then
    if [ ! -d "$target/.git" ]; then
      echo "Refusing to overwrite non-Git path: $target" >&2
      exit 1
    fi
    if [ "$(git -C "$target" rev-parse HEAD)" != "$revision" ]; then
      echo "Existing dependency has an unexpected revision: $target" >&2
      echo "Expected $revision; update it manually instead of overwriting it." >&2
      exit 1
    fi
    return
  fi

  git clone --no-checkout "$remote_url" "$target"
  git -C "$target" fetch --depth 1 origin "$revision"
  git -C "$target" checkout --detach "$revision"
}

ensure_revision src/fast_lio \
  https://github.com/hku-mars/FAST_LIO.git \
  7cc4175de6f8ba2edf34bab02a42195b141027e9
ensure_revision src/hector_slam \
  https://github.com/tu-darmstadt-ros-pkg/hector_slam.git \
  a5e77fd3297055f5f0776ed56fafa60790494e98
ensure_revision src/livox_ros_driver \
  https://github.com/Livox-SDK/livox_ros_driver.git \
  3d240d5666129e1a3052e78ee8487a04b08fdda3

echo "LIO localization dependencies are ready."
