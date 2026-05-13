# .dotfiles/

Nora Amita's personal dotfiles. `cd ~/.dotfiles` and follow the instructions to use these configs.

## .obsidian/

A minimalist obsidian vault `.obsidian/` configuration.

To use these configs:

1. find or create `<obsidian_vault_directory>/.obsidian/`, delete all but `workspace.json` under it.
2. run `stow -t <obsidian_vault_directory>/.obsidian .obsidian` (linux), `dploy stow .obsidian <obsidian_vault_directory>\.obsidian` (windows) or copy the `.obsidian` directory's contents to vault's `.obsidian` manually (android).
3. repeat step 1 and 2 whenever a new vault is created.

## firefox/

`chrome/userChrome.css` for a focused firefox ui with sidebery.

To use these configs:

1. find firefox profile directory: ☰ → Help → More troubleshooting information → Profile Directory (usually ending with `default-release`).
2. run `stow -t <profile_directory> firefox/default-release` (linux) or `dploy stow firefox\default-release <profile_directory>` (windows) in the root directory of this repository.

## linux/

Linux CLI configuration, including:

- configs for bash, conda, dialog, tmux & alacritty
- some scripts in ~/.local/bin

To use these configs in linux:

```bash
mkdir -p ~/.local/bin ~/.local/share/applications ~/.config ~/.config/musikcube
stow linux

sudo mkdir -p /root/.local/bin /root/.local/share/applications /root/.config /root/.config/musikcube
sudo stow -t /root linux
```

## nvim/

Neovim configuration, modified from https://github.com/nvim-lua/kickstart.nvim.

To use these configs in archlinux:

```bash
pacman -S neovim git base-devel stow yarn nnn fzf lazygit tmux
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay -S pandoc-bin

npm install --prefix ~/.opt/gemini -g @google/gemini-cli
ln -s ~/.opt/gemini/bin/gemini ~/.local/bin/gemini

ln -s ~/.dotfiles/nvim ~/.config/nvim
sudo ln -s ~/.dotfiles/nvim /root/.config/nvim
```

To use these configs in windows:

```powershell
New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\nvim -Target $env:USERPROFILE\.dotfiles\nvim
```

## rime/

Rime configuration, including https://github.com/rimeinn/rime-moran, an improved version of Ziranma

To use these configs in linux:

```bash
ln -s ~/.dotfiles/rime ~/.local/share/fcitx5/rime
```

To use these configs in windows:

```pwsh
New-Item -ItemType SymbolicLink -Path $env:APPDATA\Rime -Target $env:USERPROFILE\.dotfiles\rime
```

To use these configs in android:

1. install fctix5 and rime, then open fctix5 and enable rime input method.
2. find or create `/storage/emulated/0/Android/data/org.fcitx.fcitx5.android/files/data/rime`, copy the contents of `.dotfiles/rime/` to it.

## termux/

A heavily customized termux configuration, including:

- configs for bash, dialog & termux
- a startup script that:
    1. manages startup services in ~/.local/share/init.d:
        - lastd (restore last path)
        - searxng (searxng server)
    2. shows a menu with path selection and some shortcuts from ~/.local/bin:
        - Neovim (start neovim in ubuntu)
        - Ubuntu (Terminal) (start ubuntu proot-distro)
        - Ubuntu (X11) (start ubuntu proot-distro with X11 GUI)

To use these configs, clone this repository to ubuntu proot-distro home, **exit proot-distro**, replace nora with your username, then run:

```
cd $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/home/nora/.dotfiles
mkdir -p ~/.local/bin ~/.local/share ~/.config
stow -t ~ termux
```

## windows/

A linux user's windows configuarion, including:

- configs for pwsh, psmux & alacritty
- an autohotkey script ~\\.ahk

To use these configs in windows:

```pwsh
scoop install pipx

pipx ensurepath
pipx install dploy

mkdir $env:APPDATA\musikcube
dploy stow windows $env:USERPROFILE
```
