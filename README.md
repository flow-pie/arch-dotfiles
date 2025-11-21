# arch-backup-restore

Professional backup and restore scripts for Arch-based systems.

## Features

- Export pacman (explicit) packages and AUR package list
- Export list of enabled systemd services
- Archive `/etc` and selected system folders safely
- Archive user dotfiles (`~/.config`, `~/.local/share`, shell rc files)
- Interactive selection of what to back up / restore
- Timestamped archives with integrity checks
- Scripts are idempotent and safe: they won't overwrite without confirmation
- Optional GPG encryption for archives

## Security Notes

- Backups may contain secrets (SSH keys, API tokens) if you include `/etc` and user home
- Store backups securely and consider encrypting with GPG
- Use a private repository if storing metadata and links in GitHub

## Usage

### Backup

```bash
chmod +x backup.sh
sudo ./backup.sh
```

The script will interactively ask you what to include:
- Pacman explicit package list
- AUR/foreign package list
- System config (`/etc`)
- User dotfiles and configs
- Enabled systemd services
- Additional paths (optional)
- GPG encryption (optional)

**Command-line flags** (for automation):
```bash
./backup.sh --no-aur --no-etc --dest /mnt/backup --gpg user@example.com
```

Available flags:
- `--no-packages` - Skip pacman packages
- `--no-aur` - Skip AUR packages
- `--no-etc` - Skip `/etc` backup
- `--no-home` - Skip user dotfiles
- `--gpg <recipient>` - Encrypt with GPG
- `--dest <dir>` - Specify backup destination

### Restore

```bash
sudo ./restore.sh /path/to/archive.tar.gz
```

The restore script will:
1. Extract the archive (decrypt if GPG-encrypted)
2. Interactively ask what to restore
3. Create backups of existing files before overwriting
4. Guide you through enabling services

**Important**: The restore script will ask for confirmation before overwriting system files.

## Workflow

1. **Create backups** regularly:
   ```bash
   sudo ./backup.sh
   ```

2. **Store archives** safely:
   - External USB drive
   - Encrypted cloud storage
   - Private S3 bucket
   - Nextcloud with encryption

3. **Keep metadata in GitHub** (optional):
   - Add scripts and README to a private repo
   - Store links to large archives in a metadata folder
   - Do NOT commit binary archives to git

## GitHub Integration (Recommended)

For recovery metadata without storing large binaries:

```bash
git init
git add backup.sh restore.sh README.md .gitignore
git commit -m "Add arch backup/restore scripts"
git branch -M main
git remote add origin git@github.com:YOURUSER/arch-backup-restore.git
git push -u origin main
```

Add to `.gitignore`:
```
*.tar.gz
*.tar.gz.gpg
backups/
```

## Example Workflow

```bash
# Backup everything with GPG encryption
sudo ./backup.sh --gpg your-email@example.com

# Later, restore from a saved archive
sudo ./restore.sh ~/backups/20231215-120000-myhost.tar.gz.gpg
```

## Troubleshooting

- **pacman not found**: Install Arch or Arch-based distro
- **rsync permission denied**: Run with `sudo`
- **GPG decrypt fails**: Ensure you have the private key imported
- **AUR packages fail**: Install an AUR helper (`yay`, `paru`, etc.)

## License

Use freely for personal and commercial purposes.
