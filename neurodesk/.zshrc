# Set default user
export USER=pamcconnell

# Set Mamba root prefix
export MAMBA_ROOT_PREFIX=/home/$USER/mamba

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
#         . "/opt/conda/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/conda/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

# Mamba initialization
if [ -f "/opt/conda/etc/profile.d/mamba.sh" ]; then
    export PATH="/opt/conda/bin:$PATH" && \
    . "/opt/conda/etc/profile.d/mamba.sh"
fi


# Activate the neurodevenv_test environment
if command -v mamba > /dev/null; then
    mamba activate neurodevenv_test
else
    echo "Mamba is not installed or not found in PATH."
fi

# Clean duplicate entries in PATH
export PATH=$(perl -e 'print join(":", grep { !$seen{$_}++ } split(/:/, $ENV{PATH}))')

if ! mamba activate neurodevenv_test; then
    echo "Failed to activate neurodevenv_test environment. Ensure it exists."
fi

source ~/.zshrc
