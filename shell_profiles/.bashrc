if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec sway
fi

eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/clean-detailed.json)"

# Fast fs traversal
eval "$(zoxide init bash)"

eval "$(keychain --eval --quiet --agents ssh id_ed25519)"

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-env
fi

# Exporting Env Vars 

cat "../.env" | while read line; do
    export "$line"
done

export PATH=$PATH:/usr/sbin
export PATH="$HOME/.local/share/bob/v0.11.0/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$PATH:~/scripting/bash"
export PATH="$PATH:~/scripting/bash"
export PATH="$HOME/.nvm/versions/node/v24.11.1/bin:$PATH"
export PATH="$HOME/.nvm/versions/node/v20.19.6/bin:$PATH"
export EDITOR=nvim
export MANPAGER=nvim
export PATH="/opt/Beekeeper Studio:$PATH"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration

export HISTFILE="$HOME/.bash_history"

# Bigger history
export HISTSIZE=200000
export HISTFILESIZE=400000

HISTCONTROL=ignoreboth #???
HISTSIZE=50000
HISTFILESIZE=50000
HISTTIMEFORMAT="%Y-%m-%d %T "

shopt -s histappend
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## Fzf for Ctrl + r

if [ -f /usr/share/fzf/key-bindings.bash ]; then
  source /usr/share/fzf/key-bindings.bash
elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi

## Bindings

bind 'set bell-style none'

## Aliases

alias nv=nvim
alias th=trash
alias fd=fdfind
alias lg=lazygit
alias swrl="swaymsg reload"
alias autopush="~/scripting/bash/gitpush.sh"
alias gn="~/scripting/bash/nightly_backup.sh"
alias rlnm="sudo systemctl restart NetworkManager && sleep 4 && nmcli"
alias rlsh=". ~/.bashrc"
alias imv=imv-wayland

alias day='nvim ~/scripting/bash/daily_plan.sh'
alias tui='taskwarrior-tui'
alias ssleep='systemctl sleep'
alias simg="wl-paste --type image/png > "

## Coding agents

alias code="claude"
alias codes="claude --model sonnet"
alias codeh="claude --model haiku"
alias clau="claude-desktop"
alias nvc='nvim +"terminal bash -lc claude" +"vsplit | terminal bash -lc codex"'


alias tm="tmux"
alias tn="tmux new -A -s"
alias tl="tmux list-sessions"
# alias tr="tmux kill-session"
# alias td="tmux kill-session"
alias mx="tmuxinator"

## Quick Paths

alias prog='cd ~/programming'
alias prac='cd ~/programming/practice'
alias practs='cd ~/programming/practice/typescript'
alias dotfs='cd ~/.dotfiles'
alias nvconf='cd ~/.config/nvim'
alias st='speedtest'

## APT

alias apti='sudo apt install'
alias aptr='sudo apt remove'
alias aptup='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

## Task management

alias urge='task add +urge priority:H "Intensity: " && task +urge newest limit:1'
alias relapse='task add +relapse +urge priority:H "Trigger: " && task +relapse newest limit:1'
alias urge-stats='task +urge count && echo "Last 5 entries:" && task +urge newest limit:5'
for i in {1..10}; do
    alias urge$i="task add +urge priority:H \"Intensity: $i, Trigger: \" wait:1s"
done

if [ -f ~/.tmuxinator.bash ]; then
	source ~/.tmuxinator.bash
	complete -F _tmuxinator mux
fi

## NVM

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"
