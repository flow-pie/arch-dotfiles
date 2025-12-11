# Installation Guide

## Distro Compatibility

### ✅ Fully Compatible
- **Arch Linux**
- **Manjaro**
- **EndeavourOS**
- **ArcoLinux**
- Other Arch-based distributions

### ✅ Compatible (with manual dependency install)
- **Ubuntu** (20.04+)
- **Debian** (Testing/Unstable)
- **Fedora** (39+)
- **openSUSE** (Tumbleweed/Leap 15.5+)
- **Linux Mint** (with Wayland)
- **Pop!_OS** (with Wayland)

### ⚠️ Limited Support
- **Alpine Linux** - Minimal Hyprland support in repos
- Other non-mainstream distributions may require manual setup

## Quick Start

### Option 1: Simple Installation

For a quick, straightforward installation:

```bash
cd ~/Downloads
git clone https://github.com/yourusername/arch-dotfiles.git
cd arch-dotfiles
chmod +x install.sh
./install.sh
```

### Option 2: Advanced Installation (Recommended)

For a more robust installation with dependency checks and logging:

```bash
cd ~/Downloads
git clone https://github.com/yourusername/arch-dotfiles.git
cd arch-dotfiles
chmod +x Builder
./Builder
```

The Builder script will:
- Detect your distro automatically
- Check for required dependencies
- Create timestamped backups
- Copy configs to your home directory
- Generate a detailed log file
- Configure your shell if needed

## Prerequisites

### Required Packages

Install these BEFORE running the installer:

**Arch/Manjaro/EndeavourOS:**
```bash
sudo pacman -S hyprland hyprlock kitty waybar
```

**Ubuntu/Debian:**
```bash
sudo apt install hyprland hyprlock kitty waybar
```

**Fedora:**
```bash
sudo dnf install hyprland hyprlock kitty waybar
```

**openSUSE:**
```bash
sudo zypper install hyprland hyprlock kitty waybar
```

### Optional Packages

For full functionality, also install:

**Arch/Manjaro:**
```bash
sudo pacman -S vim zsh
```

**Ubuntu/Debian:**
```bash
sudo apt install vim zsh
```

**Fedora:**
```bash
sudo dnf install vim zsh
```

**openSUSE:**
```bash
sudo zypper install vim zsh
```

## Installation by Distro

### Arch Linux & Based Distros

Complete support - all scripts work automatically:

```bash
cd arch-dotfiles
./Builder    # Recommended - full automation
```

Or simple install:
```bash
./install.sh
```

### Ubuntu/Debian

```bash
# 1. Install dependencies
sudo apt update
sudo apt install hyprland hyprlock kitty waybar zsh vim

# 2. Install dotfiles
cd arch-dotfiles
./install.sh
```

### Fedora

```bash
# 1. Install dependencies
sudo dnf install hyprland hyprlock kitty waybar zsh vim

# 2. Install dotfiles
cd arch-dotfiles
./install.sh
```

### openSUSE

```bash
# 1. Install dependencies
sudo zypper install hyprland hyprlock kitty waybar zsh vim

# 2. Install dotfiles
cd arch-dotfiles
./install.sh
```

## After Installation

### Reload Hyprland

After installation, reload Hyprland to apply the new configs:

- Press `Super + Shift + R` to reload
- Or restart Hyprland with `Alt + F2` then type `hyprland`

### Initial Configuration

1. **Check your display setup**: Edit `~/.config/hypr/monitors.conf`
2. **Customize keybindings**: Edit `~/.config/hypr/keybindings.conf`
3. **Choose a theme**: Edit `~/.config/hypr/themes/theme.conf`
4. **Select animations**: Edit `~/.config/hypr/animations.conf`

### Using Workflows

Switch between activity profiles in `~/.config/hypr/hyprland.conf`:

```conf
# Uncomment the workflow you want
source = ~/.config/hypr/workflows/default.conf
# source = ~/.config/hypr/workflows/gaming.conf
# source = ~/.config/hypr/workflows/editing.conf
# source = ~/.config/hypr/workflows/snappy.conf
# source = ~/.config/hypr/workflows/powersaver.conf
```

## Backup Locations

### Automatic Backups

If you used the `Builder` script, backups are here:

```
~/.config/backup-YYYYMMDD-HHMMSS/
```

### Manual Backups

The `install.sh` script creates backups with `.bak.TIMESTAMP` extension:

```
~/.config/hypr.bak.1702373400
~/.config/kitty.bak.1702373400
```

## Troubleshooting

### Configs Not Applying

1. **Check for syntax errors**: 
   ```bash
   hyprctl openergodebug
   ```

2. **Verify file permissions**:
   ```bash
   ls -la ~/.config/hypr/
   ```

3. **Reload Hyprland**: `Super + Shift + R`

### Missing Dependencies

Check the installation log:

```bash
cat install.log
```

If packages are missing, install them using your distro's package manager (see Prerequisites section above).

### Package Manager Not Recognized

The `Builder` script attempts to auto-detect your package manager. If it fails:

1. Check what's available:
   ```bash
   which pacman apt dnf zypper apk
   ```

2. Install manually using the appropriate command for your distro

3. Re-run the installer

### Keybindings Not Working

1. Check `keybindings.conf` syntax
2. Ensure Super key is not bound by your system
3. Reload with `Super + Shift + R`

### Themes Not Changing

1. Verify theme file exists: `~/.config/hypr/themes/theme.conf`
2. Check color scheme: `~/.config/hypr/themes/colors.conf`
3. Reload Hyprland

## Customization

### Adding Custom Keybindings

Edit `~/.config/hypr/keybindings.conf`:

```conf
bind = SUPER, Z, exec, [your-command-here]
```

### Creating a New Workflow

1. Copy an existing workflow:
   ```bash
   cp ~/.config/hypr/workflows/default.conf ~/.config/hypr/workflows/custom.conf
   ```

2. Edit the new workflow

3. Source it in `hyprland.conf`:
   ```conf
   source = ~/.config/hypr/workflows/custom.conf
   ```

### Custom Color Theme

Create `~/.config/hypr/themes/custom.conf`:

```conf
$color0 = rgb(aa0000)
$color1 = rgb(00aa00)
# ... more colors
```

Then source it in `theme.conf`.

## Updating

To update your installation with latest changes:

```bash
cd ~/path/to/arch-dotfiles
git pull origin main
./install.sh  # or ./Builder
```

The scripts will create new backups before overwriting.

## Uninstalling

If you need to revert to a backup:

```bash
cp -r ~/.config/backup-YYYYMMDD-HHMMSS/* ~/.config/
```

Or manually restore from `.bak` files:

```bash
rm -rf ~/.config/hypr
mv ~/.config/hypr.bak.TIMESTAMP ~/.config/hypr
```

## Getting Help

1. **Check logs**: `cat install.log`
2. **Read docs**: `cat README.md` and `cat STRUCTURE.md`
3. **Hyprland docs**: https://wiki.hyprland.org
4. **Open an issue**: Add your error message and output

## Performance Tips

### For Low-End Systems

Use the `snappy` or `powersaver` workflows:

```conf
source = ~/.config/hypr/workflows/snappy.conf
# or
source = ~/.config/hypr/workflows/powersaver.conf
```

Use minimal animations:

```conf
source = ~/.config/hypr/animations/minimal-1.conf
```

### For High-End Systems

Use the `dynamic` or `high` animation preset:

```conf
source = ~/.config/hypr/animations/high.conf
```

## Support by Distro

If you encounter issues specific to your distro, check:

1. All required packages are installed
2. You're using Wayland (not X11)
3. Hyprland version compatibility

Common issues:
- **Ubuntu**: May need to install `wayland` and `wlroots`
- **Fedora**: May need development tools (`gcc`, `make`)
- **openSUSE**: Check for wayland variants of packages

---

Happy ricing! 🎨

