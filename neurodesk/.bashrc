# ~/.bashrc: executed by bash(1) for non-login shells.

# Exit if not running interactively
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000

# Check window size after each command
shopt -s checkwinsize

# Enable color support for terminal
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Additional ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Enable programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Conda and Mamba initialization
__conda_setup="$('/opt/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/conda/etc/profile.d/mamba.sh" ]; then
        export PATH="/opt/conda/bin:$PATH"
        . "/opt/conda/etc/profile.d/mamba.sh"
    else
        export PATH="/opt/conda/bin:$PATH"
    fi
fi
unset __conda_setup

# Automatically switch to Zsh if available
if [ -x "$(command -v zsh)" ] && [ -f ~/.zshrc ]; then
    exec zsh
fi
