bindkey -v

if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec sway
fi

eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/clean-detailed.json)"

# Fast Navigation

eval "$(zoxide init zsh)"
alias cd='echo "use zoxide!"'



# SSH into keychain (for GH pushes)

eval "$(keychain --eval --quiet --agents ssh id_ed25519)"

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-env
fi

# Exporting Environment Variables

cat "$HOME/.dotfiles/.env" | while read line; do
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
if [[ $- != *i* ]]; then
    return
fi

# History configuration

export HISTFILE="$HOME/.zsh_history"

# Bigger history
HISTSIZE=200000
SAVEHIST=400000

# ignoreboth in bash -> ignore duplicates and leading spaces
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY

setopt APPEND_HISTORY

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# setopt CHECK_WINSIZE

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
    if [ -x /usr/bin/tput ] && tput setaf 1 >/dev/null 2>&1; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PROMPT='${debian_chroot:+($debian_chroot)}%{\e[01;32m%}%n@%m%{\e[00m%}:%{\e[01;34m%}%~%{\e[00m%}%# '
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT="%{\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a%}$PROMPT"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

## Fzf for Ctrl + r

if [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

## Bindings

setopt NO_BEEP

## Aliases

alias nv=nvim
alias th=trash
alias fd=fdfind
alias lg=lazygit
alias swrl="swaymsg reload"
alias autopush="~/scripting/bash/gitpush.sh"
alias gn="~/scripting/bash/nightly_backup.sh"
alias rlnm="sudo systemctl restart NetworkManager && sleep 5 && nmcli"
alias rlsh=". ~/.zshrc"
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
alias nvc='nvim +"terminal bash -ic claude" +"vsplit | terminal bash -c codex"'

alias tm="tmux"
alias tn="tmux new -A -s"
alias tl="tmux list-sessions"
# alias tr="tmux kill-session"
# alias td="tmux kill-session"
alias mx="tmuxinator"

## Docker

alias dc="docker compose"

## APT

alias apti='sudo apt install'
alias aptr='sudo apt remove'
alias aptup='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

## Task management

alias urge='task add +urge priority:H "Intensity: " && task +urge newest limit:1'
alias relapse='task add +relapse +urge priority:H "Trigger: " && task +relapse newest limit:1'
alias urge-stats='task +urge count && echo "Last 5 entries:" && task +urge newest limit:5'
for i in {1..10}; do
    alias "urge$i=task add +urge priority:H \"Intensity: $i, Trigger: \" wait:1s"
done

if [ -f ~/.tmuxinator.zsh ]; then
	source ~/.tmuxinator.zsh
fi

## NVM

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.local/bin/env"


## ZLE Widgets

bindkey -r '^[C'
bindkey '^f' fzf-cd-widget
bindkey -r '^[d'
