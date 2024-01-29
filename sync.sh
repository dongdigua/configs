#! /bin/sh
cp ~/.emacs                            .
cp ~/.zshrc                            .
cp ~/.tmux.conf                        .
cp ~/.nethackrc                        .
cp ~/.config/starship.toml             .
cp ~/.config/nvim/init.vim             .
cp ~/.config/mutt/muttrc               .
cp -r ~/.config/sway/*                 sway/
cp -r ~/.config/waybar/*               waybar/
cp ~/.config/rofi/*                    rofi/
./epp.lua dump < .emacs >              ~/.emacs.d/emacs/lisp/site-init.el
