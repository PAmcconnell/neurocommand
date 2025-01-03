# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.

# Set up paths
cd /home/$(whoami)/
export HOME=$(pwd)
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH_DEBUG_LOG="$HOME/.zsh_debug_log"
# exec 2>>$ZSH_DEBUG_LOG
# set -x

# Install Oh My Zsh
USER ${NB_USER}

# Path to Oh My Zsh installation
mkdir -p $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
export ZSH="$HOME/.oh-my-zsh"

# Install Zinit
mkdir -p ~/.local/share/zinit
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/main/scripts/install.sh)"

# Add Zinit snippet paths
export PATH="$HOME/.local/share/zinit/snippets:$PATH"
export PATH="$HOME/.local/share/zinit/polaris/bin:$PATH"

# Remove duplicate entries
export PATH=$(perl -e 'print join(":", grep { !$seen{$_}++ } split(/:/, $ENV{PATH}))')

# Zinit installation and setup
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Zinit paths and configurations
declare -A ZINIT
ZINIT[BIN_DIR]="$ZINIT_HOME"
ZINIT[HOME_DIR]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
ZINIT[MAN_DIR]="$HOME/.local/share/zinit/man"
ZINIT[PLUGINS_DIR]="$HOME/.local/share/zinit/plugins"
ZINIT[COMPLETIONS_DIR]="$HOME/.local/share/zinit/completions"
ZINIT[SNIPPETS_DIR]="$HOME/.local/share/zinit/snippets"
ZINIT[LIST_COMMAND]="tree"
ZINIT[ZCOMPDUMP_PATH]="$HOME/.zcompdump"
ZINIT[COMPINIT_OPTS]="-C"
ZINIT[MUTE_WARNINGS]="1"
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]="1"

# === Plugin Setup ===
# Turbo mode for essential plugins
zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zdharma-continuum/history-search-multi-word

# OMZ plugins (loaded as snippets)
zinit ice pick"git.plugin.zsh"
zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh

zinit ice pick"alias-finder.plugin.zsh"
zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/alias-finder/alias-finder.plugin.zsh

# Additional programs and utilities
zinit ice as"program" mv"httpstat.sh -> httpstat" pick"httpstat"
zinit snippet https://github.com/b4b4r07/httpstat/blob/master/httpstat.sh
# Theme setup: Powerlevel10k
zinit load romkatv/powerlevel10k

# === Zsh Configuration ===
# Enable Zinit completions
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# Enable auto-correction and optimize Git performance
ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Set history format
HIST_STAMPS="yyyy-mm-dd"

# Load Oh My Zsh compatibility layer
source $ZSH/oh-my-zsh.sh

# Plugins managed via OMZ fallback
plugins=(
  git
  alias-finder
)

# Finalize compinit setup
autoload -Uz compinit && compinit ${ZINIT[COMPINIT_OPTS]} -u
zinit cdreplay -q

# Clean up PATH to remove duplicates
#export PATH=$(perl -e 'print join(":", grep { !$seen{$_}++ } split(/:/, $ENV{PATH}))')

# === Miscellaneous Settings ===
# Default editor
export EDITOR=vim

# Alias for quick reload
alias reload="source ~/.zshrc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.

# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
        . "/opt/conda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/conda/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/opt/conda/etc/profile.d/mamba.sh" ]; then
    . "/opt/conda/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
