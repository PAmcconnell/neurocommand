# Set default user
export USER=pamcconnell

# Set Mamba root prefix
export MAMBA_ROOT_PREFIX=/home/$USER/mamba

# Activate the neurodevenv_test environment
if command -v mamba > /dev/null; then
    if ! mamba activate neurodevenv_test; then
        echo "Failed to activate neurodevenv_test environment. Ensure it exists."
    fi
else
    echo "Mamba is not installed or not found in PATH."
fi

# Clean duplicate entries in PATH
#export PATH=$(perl -e 'print join(":", grep { !$seen{$_}++ } split(/:/, $ENV{PATH}))')

# Source the Zsh configuration
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
else
    echo "Zsh configuration file (~/.zshrc) not found."
fi
