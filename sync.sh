#! /bin/sh
cp ~/.emacs                            .
cp ~/.zshrc                            .
cp ~/.tmux.conf                        .
cp ~/.nethackrc                        .
cp ~/.config/starship.toml             .
cp ~/.config/nvim/init.vim             .
cp ~/.config/vis/visrc.lua             .
cp ~/.config/mutt/muttrc               .
cp ~/.config/lf/lfrc                   .
cp -r ~/.config/sway/*                 sway/
cp -r ~/.config/waybar/*               waybar/
cp ~/.config/rofi/*                    rofi/
cp ~/.config/newsboat/config           newsboat/
./epp.lua dump < .emacs >              ~/.emacs.d/emacs/lisp/site-init.el
