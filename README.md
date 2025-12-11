# Arch Dotfiles

A curated collection of configuration files optimized for Linux with Hyprland window manager.

## Features

- **Hyprland** - Tiling window manager configuration
- **Kitty** - GPU-based terminal emulator
- **Vim** - Text editor configuration
- **Waybar** - Wayland bar for Hyprland

## Installation

### Quick Install

```bash
git clone https://github.com/yourusername/arch-dotfiles.git
cd arch-dotfiles
chmod +x install.sh
./install.sh
```

### Manual Install

Copy files from `home/` to your home directory:

```bash
cp -r home/.config/* ~/.config/
cp -r home/.zshrc ~/
```

## Distro Compatibility

### ✅ Works On

- **Arch Linux** - Full support (all scripts work perfectly)
- **Arch-based** - Manjaro, EndeavourOS, ArcoLinux, etc. (full support)
- **Debian/Ubuntu** - Config files work; manually install dependencies
- **Fedora/RHEL** - Config files work; manually install dependencies
- **openSUSE** - Config files work; manually install dependencies

### ⚠️ Important Notes

**The configuration files themselves are universal** - they work on any Linux distro that has Hyprland installed.

**The installation scripts are optimized for Arch** but will work on other distros:

#### For Arch-based systems:
```bash
./Builder  # Everything works automatically
```

#### For Debian/Ubuntu:
```bash
./install.sh  # Copies files successfully
sudo apt install hyprland hyprlock kitty waybar zsh
# Then reload your shell
```

#### For Fedora:
```bash
./install.sh  # Copies files successfully
sudo dnf install hyprland hyprlock kitty waybar zsh
# Then reload your shell
```

#### For openSUSE:
```bash
./install.sh  # Copies files successfully
sudo zypper install hyprland hyprlock kitty waybar zsh
# Then reload your shell
```

The `Builder` script will auto-detect your package manager and suggest the correct install command.

## Structure

```
arch-dotfiles/
├── home/                      # Files to install to home directory
│   ├── .config/
│   │   ├── hypr/             # Hyprland config
│   │   ├── kitty/            # Kitty terminal config
│   │   ├── vim/              # Vim configuration
│   │   └── waybar/           # Waybar status bar config
│   └── .zshrc                # Zsh shell configuration
├── install.sh                # Installation script
└── LICENSE                   # License
```

## Dependencies

### Required
- `hyprland` - Wayland compositor
- `hyprlock` - Screen lock utility
- `kitty` - Terminal emulator
- `waybar` - Status bar

### Optional
- `vim` - Text editor
- `zsh` - Shell
- `pyprland` - Hyprland helper

### Install on Your Distro

**Arch:**
```bash
sudo pacman -S hyprland hyprlock kitty waybar vim zsh
```

**Debian/Ubuntu:**
```bash
sudo apt install hyprland hyprlock kitty waybar vim zsh
```

**Fedora:**
```bash
sudo dnf install hyprland hyprlock kitty waybar vim zsh
```

**openSUSE:**
```bash
sudo zypper install hyprland hyprlock kitty waybar vim zsh
```

## Configuration

### Hyprland

Main config: `home/.config/hypr/hyprland.conf`

Includes:
- `keybindings.conf` - Keyboard shortcuts
- `monitors.conf` - Display setup
- `windowrules.conf` - Window management rules
- `animations.conf` - Animation presets
- `themes/` - Color themes
- `workflows/` - Workflow profiles (gaming, editing, etc.)
- `hyprlock/` - Screen lock themes

### Kitty

Terminal configuration: `home/.config/kitty/`

### Waybar

Status bar: `home/.config/waybar/`

### Vim

Text editor: `home/.config/vim/`

## Customization

Edit the configuration files directly in `home/.config/` before installing, or modify them in your home directory after installation.

## Workflows

Hyprland includes predefined workflows:
- `default` - Standard setup
- `gaming` - Optimized for gaming
- `editing` - Development/editing
- `snappy` - Fast and minimal
- `powersaver` - Power efficiency

Switch workflows by editing the active profile in `hyprland.conf`.

## Troubleshooting

### Configs not applying
1. Reload Hyprland: `Super + Shift + R`
2. Check for syntax errors: `hyprctl openergodebug`

### Missing dependencies
Check which distro you're on and install using the commands above.

### Package manager not found
The `Builder` script will suggest the correct install command for your distro. If it doesn't recognize your distro, manually install the packages listed above.

## License

See LICENSE file

## Credits

Based on best practices from the Hyprland community. Universal distro support added for broader compatibility.

