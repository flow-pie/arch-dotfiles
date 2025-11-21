# GitHub Setup Instructions

## Step 1: Create a Repository on GitHub

1. Go to https://github.com/new
2. Create a **private** repository named `arch-backup-restore`
3. Do NOT initialize with README, .gitignore, or license (we already have these)

## Step 2: Connect Your Local Repository

Run these commands in `/home/jon/arch-backup-restore/`:

```bash
# Update the URL below with YOUR username and repository name
git remote add origin git@github.com:YOUR_USERNAME/arch-backup-restore.git

# Rename branch to main (optional, GitHub's default)
git branch -M main

# Push to GitHub
git push -u origin main
```

## Step 3: Using SSH Keys (Recommended)

If you get authentication errors, ensure you have SSH keys set up:

```bash
# Check if you have SSH keys
ls -la ~/.ssh

# If not, create them
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to GitHub: https://github.com/settings/keys
cat ~/.ssh/id_ed25519.pub
```

## Step 4: Verify

After pushing, verify at: `https://github.com/YOUR_USERNAME/arch-backup-restore`

---

## Alternative: Use GitHub CLI (gh)

If you prefer, use the GitHub CLI:

```bash
gh repo create arch-backup-restore --private --source=. --remote=origin --push
```
