#!/bin/sh


set -o errexit
set -o nounset
set -o pipefail
set -o xtrace


USER_HOME="/home/$(logname)"
readonly USER_HOME

CONFIG_DIR="${USER_HOME}/.config"
readonly CONFIG_DIR

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
readonly SCRIPT_DIR


symlink() {
  local origin_path="$1"
  local link_path="$2"
  local backup_path="$3"

  if [ -e "$link_path" ]; then
    if [ -e "$backup_path" ]; then
      rm --recursive --force "$backup_path" || {
        echo "Failed to remove $backup_path"
        return 1
      }
    fi

    cp --recursive --force "$link_path" "$backup_path" || {
      echo "Failed to backup ${link_path}"
      return 1
    }

    rm --recursive --force "$link_path" || {
      echo "Failed to remove ${link_path}"
      return 1
    }
  fi

  ln -s "$origin_path" "$link_path" || {
    echo "Failed to create symlink from ${origin_path} to ${link_path}"
    return 1
  }
}


main() {
  mkdir --parents "$CONFIG_DIR"

  symlink \
    "${SCRIPT_DIR}/nixos" \
    "/etc/nixos" \
    "${USER_HOME}/.etc-nixos-backup"

  symlink \
    "${SCRIPT_DIR}/configs/foot" \
    "${CONFIG_DIR}/foot" \
    "${USER_HOME}/.config-foot-backup"

  symlink \
    "${SCRIPT_DIR}/configs/helix" \
    "${CONFIG_DIR}/helix" \
    "${USER_HOME}/.config-helix-backup"

  symlink \
    "${SCRIPT_DIR}/configs/sway" \
    "${CONFIG_DIR}/sway" \
    "${USER_HOME}/.config-sway-backup"

  symlink \
    "${SCRIPT_DIR}/configs/.zshrc" \
    "${USER_HOME}/.zshrc" \
    "${USER_HOME}/.zshrc-backup"

  symlink \
    "${SCRIPT_DIR}/wallpapers" \
    "${USER_HOME}/wallpapers" \
    "${USER_HOME}/.wallpapers-backup"

  nixos-rebuild switch
  nix-collect-garbage -d
}


main
