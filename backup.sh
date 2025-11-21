#!/usr/bin/env bash
# backup.sh - Interactive Arch backup script
# Outputs: backups/YYYYMMDD-HHMMSS-<hostname>-<what>.tar.gz

set -euo pipefail
IFS=$'\n\t'

VERSION="1.0"
DEST_DIR="${HOME}/backups"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
HOSTNAME=$(hostname -s)
ARCHIVE_NAME="${TIMESTAMP}-${HOSTNAME}.tar.gz"
TMPDIR=$(mktemp -d)
GPG_RECIPIENT=""

# Helpers
log(){ echo "[backup] $*"; }
err(){ echo "[ERROR] $*" >&2; }
confirm(){
  read -r -p "$1 [y/N]: " ans
  case "$ans" in
    [yY]|[yY][eE][sS]) return 0 ;;
    *) return 1 ;;
  esac
}

mkdir -p "$DEST_DIR"

# Interactive menu defaults
DO_PACKAGES=true
DO_AUR=true
DO_ETC=true
DO_HOME_CONFIGS=true
DO_SERVICES=true
DO_EXTRA=false
DO_GPG=false

# Parse CLI args (quick non-interactive flags)
while [[ ${#} -gt 0 ]]; do
  case "$1" in
    --no-aur) DO_AUR=false; shift ;;
    --no-etc) DO_ETC=false; shift ;;
    --no-home) DO_HOME_CONFIGS=false; shift ;;
    --no-packages) DO_PACKAGES=false; shift ;;
    --gpg) DO_GPG=true; GPG_RECIPIENT="$2"; shift 2 ;;
    --dest) DEST_DIR="$2"; shift 2 ;;
    --help) sed -n '1,120p' "$0"; exit 0 ;;
    *) shift ;;
  esac
done

# Interactive prompts
log "Arch Backup Script v${VERSION}"
if confirm "Create interactive backup?"; then
  log "Interactive mode..."
  if confirm "Include pacman explicit package list (recommended)?"; then DO_PACKAGES=true; else DO_PACKAGES=false; fi
  if confirm "Include AUR package list (if you use an AUR helper like yay)?"; then DO_AUR=true; else DO_AUR=false; fi
  if confirm "Include /etc system config folder? (recommended)"; then DO_ETC=true; else DO_ETC=false; fi
  if confirm "Include user config folders (~/.config, ~/.local/share, shell rc)?"; then DO_HOME_CONFIGS=true; else DO_HOME_CONFIGS=false; fi
  if confirm "Include list of enabled systemd services?"; then DO_SERVICES=true; else DO_SERVICES=false; fi
  if confirm "Include additional paths (e.g. /opt, /var/lib/someapp) ?"; then DO_EXTRA=true; else DO_EXTRA=false; fi
  if confirm "Encrypt archive with GPG (you'll need gpg setup)?"; then DO_GPG=true; read -r -p "GPG recipient (email or key id): " GPG_RECIPIENT; fi
else
  log "Non-interactive mode using defaults"
fi

# Collect metadata
mkdir -p "$TMPDIR/metadata"

# 1) Package lists
if [ "$DO_PACKAGES" = true ]; then
  if command -v pacman >/dev/null 2>&1; then
    log "Exporting pacman explicit packages..."
    pacman -Qqe > "$TMPDIR/metadata/pacman-explicit.txt"
  else
    err "pacman not found; skipping pacman packages.";
  fi
fi

if [ "$DO_AUR" = true ]; then
  if command -v pacman >/dev/null 2>&1; then
    log "Exporting pacman foreign (AUR) packages..."
    pacman -Qqm > "$TMPDIR/metadata/pacman-foreign.txt" || true
  else
    err "pacman not found; skipping AUR list.";
  fi
fi

# 2) Enabled services
if [ "$DO_SERVICES" = true ]; then
  if command -v systemctl >/dev/null 2>&1; then
    log "Listing enabled systemd unit files..."
    systemctl list-unit-files --state=enabled --no-legend | awk '{print $1}' > "$TMPDIR/metadata/enabled-services.txt" || true
    systemctl list-units --type=service --state=running --no-legend | awk '{print $1"\t"$4}' > "$TMPDIR/metadata/running-services.txt" || true
  else
    err "systemctl not available; skipping services.";
  fi
fi

# 3) /etc backup
ETC_EXCLUDE=("/etc/ssl/private" "/etc/ssh/ssh_host_*" )
if [ "$DO_ETC" = true ]; then
  log "Archiving /etc into backup (exclusions applied)..."
  mkdir -p "$TMPDIR/etc"
  rsync -aAX --delete --exclude 'ssl/private' --exclude 'ssh/ssh_host_*' /etc/ "$TMPDIR/etc/" || true
fi

# 4) Home configs
if [ "$DO_HOME_CONFIGS" = true ]; then
  log "Collecting user config files from $HOME"
  mkdir -p "$TMPDIR/home"
  echo "Backing up: ~/.config, ~/.local/share, ~/.bashrc, ~/.zshrc, ~/.profile, ~/.gitconfig"
  rsync -a --copy-links --exclude 'Downloads' --exclude 'Trash' "$HOME/.config" "$TMPDIR/home/" 2>/dev/null || true
  rsync -a --copy-links --exclude 'cache' "$HOME/.local/share" "$TMPDIR/home/" 2>/dev/null || true
  for f in .bashrc .zshrc .profile .gitconfig .pam_environment; do
    [ -e "$HOME/$f" ] && cp -a "$HOME/$f" "$TMPDIR/home/" || true
  done
fi

# 5) Extra paths
EXTRAPATHS=()
if [ "$DO_EXTRA" = true ]; then
  read -r -p "Enter extra absolute paths to include (comma separated), or blank to skip: " EXTRA_INPUT
  if [ -n "$EXTRA_INPUT" ]; then
    IFS=','; for p in $EXTRA_INPUT; do ptrim=$(echo "$p" | xargs); EXTRAPATHS+=("$ptrim"); done
    for p in "${EXTRAPATHS[@]}"; do
      if [ -e "$p" ]; then
        mkdir -p "$TMPDIR/extra"
        rsync -a "$p" "$TMPDIR/extra/" || true
      else
        err "Path $p not found; skipping."
      fi
    done
  fi
fi

# 6) Copy script and notes
cp -- "${BASH_SOURCE[0]}" "$TMPDIR/README-scripts.txt" || true

# 7) Create archive
pushd "$TMPDIR" >/dev/null
log "Creating archive $ARCHIVE_NAME ..."
tar -czf "$DEST_DIR/$ARCHIVE_NAME" . || { err "tar failed"; exit 1; }
popd >/dev/null

# 8) Optional GPG
if [ "$DO_GPG" = true ]; then
  if command -v gpg >/dev/null 2>&1; then
    if [ -z "$GPG_RECIPIENT" ]; then
      read -r -p "GPG recipient (email/key id): " GPG_RECIPIENT
    fi
    log "Signing/encrypting archive for: $GPG_RECIPIENT"
    gpg --output "$DEST_DIR/$ARCHIVE_NAME.gpg" --encrypt --recipient "$GPG_RECIPIENT" "$DEST_DIR/$ARCHIVE_NAME" && log "Created $DEST_DIR/$ARCHIVE_NAME.gpg"
  else
    err "gpg not found; cannot encrypt."
  fi
fi

log "Cleaning up temp files"
rm -rf "$TMPDIR"
log "Backup complete: $DEST_DIR/$ARCHIVE_NAME"
if [ "$DO_GPG" = true ]; then
  log "Encrypted archive: $DEST_DIR/$ARCHIVE_NAME.gpg"
fi

echo
log "Next steps:"
log "- Move the archive to external storage or upload to private storage."
log "- Commit the package lists (metadata) to a private GitHub repo for quick restore."
