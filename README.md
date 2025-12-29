# Terminal Development Environment Setup

This repository contains a comprehensive Bash script designed to automate the installation and configuration of a high-performance, **TUI-focused (Terminal User Interface)** development environment.
I built this to eliminate the friction of manual setups and ensure a consistent, powerful workflow across different machines.

---

## 🚀 Overview

The script provides an interactive selection menu to install and configure a curated suite of modern terminal tools:

* **Shell**: ZSH with Oh-My-Zsh, autosuggestions, and syntax highlighting.
* **IDE**: Neovim (v0.9+) pre-configured with **LazyVim**, including extra plugins for Obsidian and SQL management (DadBod).
* **Multiplexer**: Tmux with TPM (Tmux Plugin Manager) and a custom Catppuccin-inspired theme.
* **Terminal**: Kitty emulator configuration with GPU acceleration support.
* **Navigation**: Zoxide (smart cd), FZF (fuzzy finder), and Yazi (blazing fast terminal file manager).
* **Monitoring**: Btop for system resources and Bandwhich for network utilization.
* **Extras**: Nerd Fonts (JetBrainsMono) and Browsh (text-based browser).

---

## 🛠️ Requirements

The script is designed to be cross-distribution and automatically detects the following package managers:

* **APT** (Debian/Ubuntu)
* **DNF** (Fedora/RHEL)
* **Pacman** (Arch Linux)
* **Zypper** (openSUSE)

---

## ⚙️ Installation

1. **Clone the repository**:
```bash
git clone https://github.com/b92c/setup-dev-environment-terminal.git
cd setup-dev-environment-terminal

```


2. **Make the script executable**:
```bash
chmod +x setup_dev_environment.sh

```


3. **Run the script**:
```bash
./setup_dev_environment.sh

```



---

## ⌨️ How to Use

Once the script starts, you will see an interactive menu:

* **Arrows (↑/↓) or j/k**: Navigate the list.
* **Space or x**: Toggle individual applications.
* **'a'**: Select/Deselect all.
* **Numbers (1-9, 0)**: Direct toggle for specific items.
* **Enter**: Confirm and start installation.

---

## 📂 Post-Installation

After the script finishes, remember to:

* **ZSH**: Restart your terminal or run `source ~/.zshrc`.
* **Neovim**: Run `nvim` to allow LazyVim to install its plugins.
* **Tmux**: Open `tmux` and press `prefix + I` (Ctrl+A + I by default in this config) to install plugins.
* **Path**: The script adds `$HOME/.local/bin` and `$HOME/.cargo/bin` to your PATH.

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License.

Would you like me to add a "Troubleshooting" section to this README based on common Linux package errors?