GOPATH=~/go
# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.cargo/bin:$HOME/bin:$PATH:$HOME/.pub-cache/bin:$GOPATH/bin"

fpath=($HOME/.zfunc $fpath)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

if [ -f "$HOME/.keys" ] ; then
	source ~/.keys
fi

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
	git
	fast-syntax-highlighting
  	wd
	rust
	#vi-mode
)

source "$ZSH/oh-my-zsh.sh"

export EDITOR=nvim
#bindkey -v

alias cat='bat -p'
alias ls="exa"
alias nvim-conf='nvim ~/.config/nvim/init.vim'
alias screenRegion='slurp | grim -g - '
alias pacmanBySize='expac "%n %m" -l'\n' -Q $(pacman -Qq) | sort -rhk 2 | less'
alias make="make -j2"
alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'

alias icat="kitty +kitten icat"

export XKB_DEFAULT_LAYOUT=us
export XKB_DEFAULT_VARIANT=dvp
export XKB_DEFAULT_MODEL=pc105
export XKB_DEFAULT_OPTION=compose:102

if [ -f "$HOME/.wayland" ]; then
	export QT_QPA_PLATFORM=wayland-egl
	export CLUTTER_BACKEND=wayland
	export SDL_VIDEODRIVER=wayland
	export MOZ_ENABLE_WAYLAND=1
	export KITTY_ENABLE_WAYLAND=1
	export _JAVA_AWT_WM_NONREPARENTING=1
fi

if [ -f "$HOME/.zvars" ]; then
	source "$HOME/.zvars"
fi

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

#export RUSTC_WRAPPER=sccache
export RUSTC_WRAPPER=


DVORAK=/usr/share/kbd/keymaps/i386/dvorak/dvorak-programmer.map.gz
#source ~/.purepower

export TERM=xterm-256color
export CARGO_BUILD_PIPELINING=true
eval "$(zoxide init zsh)"

# source /home/traxys/.config/broot/launcher/bash/br

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/traxys/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/traxys/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/traxys/node_modules/tabtab/.completions/sls.zsh ]] && . /home/traxys/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/traxys/node_modules/tabtab/.completions/slss.zsh ]] && . /home/traxys/node_modules/tabtab/.completions/slss.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

fortune | cowsay | dotacat
