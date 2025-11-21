#!/usr/bin/env bash
# restore.sh - Interactive restore for archives created by backup.sh
# Usage: sudo ./restore.sh /path/to/archive.tar.gz

set -euo pipefail
IFS=$'\n\t'

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 /path/to/archive.tar.gz"; exit 2
fi
ARCHIVE="$1"
WORKDIR=$(mktemp -d)

log(){ echo "[restore] $*"; }
err(){ echo "[ERROR] $*" >&2; }
confirm(){
  read -r -p "$1 [y/N]: " ans
  case "$ans" in
    [yY]|[yY][eE][sS]) return 0 ;;
    *) return 1 ;;
  esac
}

if [ ! -f "$ARCHIVE" ]; then err "Archive not found: $ARCHIVE"; exit 1; fi

log "Extracting archive to $WORKDIR"
if [[ "$ARCHIVE" =~ \.gpg$ ]]; then
  if command -v gpg >/dev/null 2>&1; then
    log "Detected GPG archive. Attempting decrypt..."
    gpg --output "$WORKDIR/archive.tar.gz" --decrypt "$ARCHIVE"
    ARCHIVE_TO_EXTRACT="$WORKDIR/archive.tar.gz"
  else
    err "gpg not installed. Install gpg to decrypt the archive."; exit 1
  fi
else
  ARCHIVE_TO_EXTRACT="$ARCHIVE"
fi

mkdir -p "$WORKDIR/extracted"
tar -xzf "$ARCHIVE_TO_EXTRACT" -C "$WORKDIR/extracted"

log "Files available in: $WORKDIR/extracted"
ls -la "$WORKDIR/extracted/metadata" || true

# Ask user what to restore
if confirm "Restore pacman explicit package list?"; then
  if [ -f "$WORKDIR/extracted/metadata/pacman-explicit.txt" ]; then
    log "Installing pacman packages from list (this may take a while)."
    sudo pacman -Syu --needed - < "$WORKDIR/extracted/metadata/pacman-explicit.txt"
  else
    err "No pacman-explicit.txt found in archive."
  fi
fi

if confirm "Restore AUR package list (requires your AUR helper like yay)?"; then
  if [ -f "$WORKDIR/extracted/metadata/pacman-foreign.txt" ]; then
    if command -v yay >/dev/null 2>&1; then
      yay -S --needed - < "$WORKDIR/extracted/metadata/pacman-foreign.txt"
    else
      log "No yay found. Skipping AUR. You can install an AUR helper and re-run this step.";
    fi
  else
    err "No AUR list found in archive."
  fi
fi

if confirm "Restore /etc (system config)?\nWARNING: This will overwrite files in /etc. Proceed only if you know what you are doing."; then
  log "Restoring /etc contents (will create backups of existing files in /etc.restore.")
  sudo mkdir -p /etc.restore
  sudo rsync -a --backup --backup-dir=/etc.restore --exclude 'ssl/private' --exclude 'ssh/ssh_host_*' "$WORKDIR/extracted/etc/" /etc/
fi

if confirm "Restore user dotfiles (~/.config, ~/.local/share, and dotfiles)?"; then
  log "Restoring user configs to $HOME (will back up existing into ~/.backup-configs-<ts>)"
  TS=$(date +"%Y%m%d-%H%M%S")
  BACKUPDIR="$HOME/.backup-configs-$TS"
  mkdir -p "$BACKUPDIR"
  for p in "$WORKDIR/extracted/home/.config" "$WORKDIR/extracted/home/.local" "$WORKDIR/extracted/home/.bashrc" "$WORKDIR/extracted/home/.zshrc"; do
    if [ -e "$p" ]; then
      base=$(basename "$p")
      if [ -e "$HOME/$base" ]; then
        mv "$HOME/$base" "$BACKUPDIR/" || true
      fi
      rsync -a "$p" "$HOME/"
    fi
  done
  log "User configs restored. Old versions (if any) are in $BACKUPDIR"
fi

if confirm "Enable systemd services listed in archive?"; then
  if [ -f "$WORKDIR/extracted/metadata/enabled-services.txt" ]; then
    while IFS= read -r s; do
      log "Enabling $s"; sudo systemctl enable "$s" || true
    done < "$WORKDIR/extracted/metadata/enabled-services.txt"
  else
    err "No enabled-services.txt found."
  fi
fi

log "Restore complete. Cleanup $WORKDIR?"
if confirm "Remove temporary extracted files?"; then
  rm -rf "$WORKDIR"
  log "Cleaned up.";
else
  log "Temporary data kept at: $WORKDIR"
fi
