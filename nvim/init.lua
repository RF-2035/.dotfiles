--  NOTE:──────────────────────────────────────────────────────────────────────┐
--  │                                                                          │
--  │ MODIFIED FROM KICKSTART.NVIM                                             │
--  │                                                                          │
--  │ enable UTF-8:                                                            │
--  │   - nano /etc/locale.conf         # write LANG=en_US.UTF-8               │
--  │   - nano /etc/locale.gen          # uncomment en_US.UTF-8 UTF-8          │
--  │   - locale-gen                                                           │
--  │                                                                          │
--  │ install the dependencies:                                                │
--  │   - pacman -S neovim git base-devel stow yarn nnn fzf lazygit tmux       │
--  │   - git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si │
--  │   - yay -S pandoc-bin                                                    │
--  │                                                                          │
--  │ install node modules:                                                    │
--  │   - npm install --prefix ~/.opt/gemini -g @google/gemini-cli             │
--  │   - ln -s ~/.opt/gemini/bin/gemini ~/.local/bin/gemini                   │
--  │                                                                          │
--  │ apply the config:                                                        │
--  │   - git clone https://github.com/photonism/.dotfiles.git ~/.dotfiles     │
--  │   - cd ~/.dotfiles && stow nvim                                          │
--  └──────────────────────────────────────────────────────────────────────────┘

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'photonism.lazy'
require 'photonism.maps'
require 'photonism.opts'
