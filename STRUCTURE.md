# Directory Structure

```
arch-dotfiles/
├── Builder                          # Advanced installer with dependency checks
├── README.md                        # Documentation
├── STRUCTURE.md                     # This file
├── install.sh                       # Simple installation script
├── LICENSE                          # License file
├── .gitignore                       # Git ignore rules
│
└── home/                            # Files to sync to $HOME
    ├── .config/
    │   ├── hypr/                    # Hyprland window manager
    │   │   ├── hyprland.conf        # Main configuration
    │   │   ├── hyprlock.conf        # Screen lock config
    │   │   ├── hypridle.conf        # Idle handler
    │   │   ├── keybindings.conf     # Keyboard shortcuts
    │   │   ├── monitors.conf        # Display configuration
    │   │   ├── windowrules.conf     # Window management
    │   │   ├── workspaces.conf      # Workspace setup
    │   │   ├── userprefs.conf       # User preferences
    │   │   ├── pyprland.toml        # PyPrland config
    │   │   ├── shaders.conf         # Shader effects
    │   │   ├── animations.conf      # Animation config
    │   │   ├── themes/              # Color themes
    │   │   │   ├── theme.conf
    │   │   │   ├── colors.conf
    │   │   │   └── wallbash.conf
    │   │   ├── animations/          # Animation presets
    │   │   │   ├── minimal-1.conf
    │   │   │   ├── minimal-2.conf
    │   │   │   ├── dynamic.conf
    │   │   │   ├── high.conf
    │   │   │   ├── ja.conf
    │   │   │   └── ... (more presets)
    │   │   ├── workflows/           # Activity profiles
    │   │   │   ├── default.conf     # Standard setup
    │   │   │   ├── gaming.conf      # Gaming optimized
    │   │   │   ├── editing.conf     # Development setup
    │   │   │   ├── snappy.conf      # Fast & minimal
    │   │   │   └── powersaver.conf  # Power saving
    │   │   └── hyprlock/            # Screen lock themes
    │   │       ├── theme.conf
    │   │       ├── greetd.conf
    │   │       ├── greetd-wallbash.conf
    │   │       └── ... (more themes)
    │   │
    │   ├── kitty/                   # Terminal emulator
    │   │   ├── kitty.conf           # Main config
    │   │   ├── theme.conf           # Theme
    │   │   └── hyde.conf            # Hyde theme variant
    │   │
    │   ├── waybar/                  # Status bar
    │   │   ├── config.jsonc         # Main configuration
    │   │   ├── style.css            # Styling
    │   │   ├── theme.css            # Theme styles
    │   │   ├── user-style.css       # Custom styles
    │   │   └── includes/            # Config includes
    │   │       ├── includes.json
    │   │       ├── global.css
    │   │       └── border-radius.css
    │   │
    │   └── vim/                     # Vim editor
    │       ├── vimrc                # Main config
    │       ├── hyde.vim             # Hyde theme
    │       └── colors/              # Color schemes
    │           └── wallbash.vim
    │
    └── .zshrc                       # Zsh configuration
```

## Installation Methods

### Quick Install (Simple)
```bash
./install.sh
```

### Advanced Install (With Checks)
```bash
./Builder
```

## Key Features

- **Hyprland**: Full window manager configuration with multiple themes and workflows
- **Kitty**: GPU-accelerated terminal with theme support
- **Waybar**: Customizable status bar
- **Vim**: Text editor with color schemes
- **Modular Design**: Each application is self-contained
- **Multiple Workflows**: Switch between profiles (gaming, editing, etc.)
- **Theme Support**: Dark and light theme variants

## Customization Tips

1. **Change Theme**: Edit `home/.config/hypr/themes/theme.conf`
2. **Switch Animations**: Edit `home/.config/hypr/animations.conf`
3. **Modify Keybinds**: Edit `home/.config/hypr/keybindings.conf`
4. **Custom Workflows**: Add new files in `home/.config/hypr/workflows/`
5. **Personalize Waybar**: Modify `home/.config/waybar/config.jsonc`

## Backup Before Installing

The `Builder` script automatically creates backups:
```
~/.config/backup-YYYYMMDD-HHMMSS/
```

Manual backups are also recommended!
