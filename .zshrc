# init
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -Uz compinit promptinit
compinit -d .cache/zcompdump

# zsh
HISTFILE=~/.zsh_history
HISTSIZE=16384
SAVEHIST=16384
setopt autocd extendedglob sharehistory histignoredups
unsetopt beep
bindkey -e
autoload -U select-word-style
select-word-style bash
WORDCHARS=''
zstyle ':completion:*' menu select

# alias
alias lla="exa -alh --git --icons"
alias trexa="exa --tree --git-ignore"
alias t="trans -x 127.0.0.1:20171"  # I tried bing, but not asgoodas google
alias neofetch='neofetch | sed "s/4.2/42./g"'
alias gs="git status -sb"
alias cls=clear
alias vifzf='vim $(fzf)'
alias ra=ranger
alias bat='bat -p'
alias e="emacs -nw"
alias vim=nvim
alias vi=vis
alias potato='echo notify-send -u critical stop! | at now+25 minutes'
alias firefox=firefox-developer-edition
alias pandock='docker run -v "$(pwd):/data" -u $(id -u):$(id -g) pandoc/minimal'
alias todo='vi ~/TODO'
alias py=python
alias dnstatus='journalctl -u dnscrypt-proxy.service -f'

# color
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ls='ls --color=auto'


# env
export LANG=en_US.UTF-8
export EDITOR=vim
export FZF_DEFAULT_COMMAND='rg --hidden --files'
export SDCV_PAGER='less' # not using -F
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_SIGNING_KEY=2394861A728929E3755D8FFADB55889E730F5B41
export PF_INFO="ascii title os host kernel uptime pkgs cpu memory wm palette"

# ~ cleanup
export SQLITE_HISTORY=
export W3M_DIR="$XDG_DATA_HOME"/w3m

# functions
mkcd() { mkdir $1 && cd $1 }

colorman() {
# https://wiki.archlinux.org/title/Color_output_in_console#man
export LESS='-R --use-color -Dd+c'
export MANROFFOPT="-P -c"
}

fh() {
	print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

proxy() {
	export http_proxy=http://127.0.0.1:20172
	export https_proxy=http://127.0.0.1:20172
}

noproxy() {
	unset http_proxy
	unset https_proxy
}

colorpicker() {
	grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-
}

# post-init
. $HOME/.cargo/env
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
cat ~/TODO
