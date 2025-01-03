# Set default user
export USER=pamcconnell

# Set Mamba root prefix
export MAMBA_ROOT_PREFIX="/home/$USER/mamba"

# Clean duplicate entries in PATH
#export PATH=$(perl -e 'print join(":", grep { !$seen{$_}++ } split(/:/, $ENV{PATH}))')

# Source the Zsh configuration
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
else
    echo "Zsh configuration file (~/.zshrc) not found."
fi
