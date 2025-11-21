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
- **Push to GitHub** (optional - stores backups in private repo)

**Command-line flags** (for automation):
```bash
./backup.sh --no-aur --no-etc --dest /mnt/backup --gpg user@example.com --push ~/my-backups-repo
```

Available flags:
- `--no-packages` - Skip pacman packages
- `--no-aur` - Skip AUR packages
- `--no-etc` - Skip `/etc` backup
- `--no-home` - Skip user dotfiles
- `--gpg <recipient>` - Encrypt with GPG
- `--dest <dir>` - Specify backup destination
- `--push <repo-path>` - Auto-commit and push to GitHub repo

### Restore

**From local file**:
```bash
sudo ./restore.sh /path/to/archive.tar.gz
```

**From GitHub repo**:
```bash
sudo ./restore.sh github:YOUR_USERNAME/your-backups-repo backups/
```

The restore script will:
1. Download backup from GitHub (if using `github:` syntax)
2. Extract the archive (decrypt if GPG-encrypted)
3. Interactively ask what to restore
4. Create backups of existing files before overwriting
5. Guide you through enabling services

**Important**: The restore script will ask for confirmation before overwriting system files.

## Workflow

### Simple Workflow (Local + GitHub)

1. **Create and auto-push backups**:
   ```bash
   sudo ./backup.sh --push ~/my-backups-repo
   ```
   This creates backups in `~/backups/` AND pushes them to GitHub.

2. **On another computer, restore**:
   ```bash
   sudo ./restore.sh github:flow-pie/arch-backup-restore backups/
   ```
   The script will list available backups and let you choose which to download and restore.

3. **Everything is version-controlled** in GitHub for easy recovery anywhere.

### Benefits of GitHub Storage

- ✅ Access backups from any machine with internet
- ✅ Full version history (can recover old backups)
- ✅ Automatic versioning - new backups create new commits
- ✅ Private repo keeps data secure
- ✅ Free for small backups (Git LFS: 1GB free/month)

## GitHub Integration (Recommended)

Two repos are recommended:

### 1. Scripts + Config Repo (Current)
Store the backup/restore scripts and README:
```bash
# Already done: https://github.com/flow-pie/arch-backup-restore
```

### 2. Backups Repo (For storing archives)
Create a separate **private** repo for actual backups:

```bash
# Create local backups repo
mkdir -p ~/my-backups
cd ~/my-backups
git init
echo "*.tar.gz.gpg" > .gitignore
echo "# Encrypted system backups" > README.md
git add -A && git commit -m "Init backups repo"

# Create repo on GitHub: https://github.com/new
# Name it: "my-backups" (or anything)
# Make it PRIVATE

# Connect and push
git remote add origin git@github.com:YOUR_USERNAME/my-backups.git
git branch -M main
git push -u origin main
```

Then use it with backup script:
```bash
sudo ./backup.sh --push ~/my-backups
```

And restore from it:
```bash
sudo ./restore.sh github:YOUR_USERNAME/my-backups backups/
```

## Example Workflow

**First time - create backups repo**:
```bash
mkdir -p ~/my-backups && cd ~/my-backups
git init
echo "*.tar.gz.gpg" > .gitignore
git add -A && git commit -m "Init"
# Create private repo on GitHub, then:
git remote add origin git@github.com:YOUR_USERNAME/my-backups.git
git push -u origin main
```

**Regular backups with auto-push**:
```bash
# Backup everything, encrypt, and push to GitHub
sudo ./backup.sh --gpg your-email@example.com --push ~/my-backups
```

**Restore on any machine**:
```bash
# List backups and download from GitHub
sudo ./restore.sh github:YOUR_USERNAME/my-backups backups/

# Or restore from local file
sudo ./restore.sh ~/backups/20231215-120000-myhost.tar.gz.gpg
```

## Troubleshooting

- **pacman not found**: Install Arch or Arch-based distro
- **rsync permission denied**: Run with `sudo`
- **GPG decrypt fails**: Ensure you have the private key imported
- **AUR packages fail**: Install an AUR helper (`yay`, `paru`, etc.)

## License

Use freely for personal and commercial purposes.
