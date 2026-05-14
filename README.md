# .dotfiles/

Nora Amita's personal dotfiles. `cd ~/.dotfiles` and follow the instructions to use these configs.

## .obsidian/

A minimalist obsidian vault `.obsidian/` configuration.

To use these configs:

1. find or create `<obsidian_vault_directory>/.obsidian/`, delete all but `workspace.json` under it.
2. run `stow -t <obsidian_vault_directory>/.obsidian .obsidian` (linux), `sudo dploy stow .obsidian <obsidian_vault_directory>\.obsidian` (windows) or copy the `.obsidian` directory's contents to vault's `.obsidian` manually (android).
3. repeat step 1 and 2 whenever a new vault is created.

## firefox/

`chrome/userChrome.css` for a focused firefox ui with sidebery.

To use these configs:

1. find firefox profile directory: ☰ → Help → More troubleshooting information → Profile Directory (usually ending with `default-release`).
2. run `stow -t <profile_directory> firefox/default-release` (linux) or `sudo dploy stow firefox\default-release <profile_directory>` (windows) in the root directory of this repository.

## linux/

Linux CLI configuration, including:

- configs for `alacritty`, `bash`, `conda`, `dialog`, `musikcube`, `neovide`, `tmux`
- some scripts in `~/.local/bin`

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
scoop bucket add main
scoop bucket add extras
scoop bucket add nerd-fonts

scoop install fzf git lazygit neovide neovim nodejs pandoc psmux psutils refreshenv ripgrep stylua yarn Iosevka-NF Noto-CJK-Mega-OTC
npm install --prefix $env:USERPROFILE\.opt\gemini -g @google/gemini-cli

if (-not ($env:PATH -like "*$env:USERPROFILE\.local\bin*")) {
    [Environment]::SetEnvironmentVariable("PATH", "$env:USERPROFILE\.local\bin;$env:PATH", "User")
    refreshenv
}

mkdir $env:USERPROFILE\.local\bin
sudo ln -s $env:USERPROFILE\.opt\gemini\bin\gemini $env:USERPROFILE\.local\bin\gemini
sudo ln -s $env:USERPROFILE\.dotfiles\nvim $env:LOCALAPPDATA\nvim
```

## rime/

Rime configuration, including https://github.com/rimeinn/rime-moran, an improved version of Ziranma

To use these configs in linux:

```bash
ln -s ~/.dotfiles/rime ~/.local/share/fcitx5/rime
```

To use these configs in windows:

```powershell
sudo ln -s $env:USERPROFILE\.dotfiles\rime $env:APPDATA\Rime
```

To use these configs in android:

1. install fctix5 and rime, then open fctix5 and enable rime input method.
2. find or create `/storage/emulated/0/Android/data/org.fcitx.fcitx5.android/files/data/rime`, copy the contents of `.dotfiles/rime/` to it.

## termux/

A heavily customized termux configuration, including:

- configs for `bash`, `dialog`, `termux`
- a startup script that:
    1. manages startup services in `~/.local/share/init.d`:
        - `lastd` (restore last path)
        - `searxng` (searxng server)
    2. shows a menu with path selection and some shortcuts from `~/.local/bin`:
        - `Neovim` (start neovim in ubuntu)
        - `Ubuntu (Terminal)` (start ubuntu proot-distro)
        - `Ubuntu (X11)` (start ubuntu proot-distro with X11 GUI)

To use these configs, clone this repository to ubuntu proot-distro home, **exit proot-distro**, replace nora with your username, then run:

```bash
cd $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/home/nora/.dotfiles
mkdir -p ~/.local/bin ~/.local/share ~/.config
stow -t ~ termux
```

## windows/

A linux user's windows configuarion, including:

- configs for `alacritty`, `musikcube`, `psmux`, `pwsh`
- autohotkey script `~\.ahk`
- msys2 `.bashrc` and binary shortcuts inside `~\.local\bin`

To use these configs in windows:

```powershell
scoop install pipx psutils refreshenv
pipx install dploy

if (-not ($env:PATH -like "*$env:USERPROFILE\.local\bin*")) {
    [Environment]::SetEnvironmentVariable("PATH", "$env:USERPROFILE\.local\bin;$env:PATH", "User")
    refreshenv
}

mkdir $env:APPDATA\musikcube
mkdir $env:USERPROFILE\.local\bin

sudo dploy stow windows $env:USERPROFILE
```

To use these configs with msys2:

```powershell
rm -r -fo C:\msys64\home\$env:USERNAME
sudo ln -s $env:USERPROFILE C:\msys64\home\$env:USERNAME

msys-run pacman -Syu
msys-run pacman -S nnn

sudo ln -s C:\ $env:USERPROFILE\.config\nnn\bookmarks\c
sudo ln -s D:\ $env:USERPROFILE\.config\nnn\bookmarks\d

[Environment]::SetEnvironmentVariable("EDITOR", "nvim", "User")
[Environment]::SetEnvironmentVariable("MSYS2_PATH_TYPE", "inherit", "User")
[Environment]::SetEnvironmentVariable("NNN_OPENER", "start", "User")
[Environment]::SetEnvironmentVariable("VISUAL", "nvim", "User")

refreshenv
```

To remove windows AI:

```powershell
sudo powershell.exe
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/zoicware/RemoveWindowsAI/main/RemoveWindowsAi.ps1")))
```
