# Base image
FROM vnmd/neurodesktop:2024-12-06

# Copy Neurodesk content
COPY . /neurodesk/
WORKDIR /neurodesk

# Switch to root user for package installation
USER root

# Install required packages
RUN apt-get update && apt-get install -y \
    zsh \
    git \
    curl \
    wget \
    fonts-powerline \
    perl \
    && apt-get clean

# Set username and password
ARG NB_USER=pamcconnell
#ARG NB_PASSWORD=Br@1nz
ARG NB_UID=1100
ARG NB_GID=1100
ENV NB_USER=${NB_USER} NB_UID=${NB_UID} NB_GID=${NB_GID}
ENV HOME=/home/${NB_USER}
ENV ZSH="${HOME}/.oh-my-zsh"

# Dynamically create a user with a unique UID and GID
RUN if ! id -u ${NB_USER} > /dev/null 2>&1; then \
    groupadd -f -g ${NB_GID} ${NB_USER} || echo "Group ${NB_GID} already exists"; \
    useradd -m -s /bin/zsh -u ${NB_UID} -g ${NB_GID} ${NB_USER} || echo "User with UID ${NB_UID} already exists"; \
    echo "${NB_USER}:${NB_PASSWORD}" | chpasswd; \
    adduser ${NB_USER} sudo; \
    fi


# Switch to the new user
USER ${NB_USER}
WORKDIR /home/${NB_USER}

# Install Oh My Zsh
RUN RUNZSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Install Zinit
RUN mkdir -p "${HOME}/.local/share/zinit" && \
    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/main/scripts/install.sh)"

# Set up Powerlevel10k and plugins
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH}/custom/themes/powerlevel10k && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH}/custom/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH}/custom/plugins/zsh-syntax-highlighting && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git ${ZSH}/custom/plugins/zsh-completions

# Switch back to root for file operations
USER root

# Copy custom .zshrc and .p10k.zsh and fix permissions
COPY .zshrc ${HOME}/.zshrc
COPY .p10k.zsh ${HOME}/.p10k.zsh
RUN chown ${NB_USER}:${NB_USER} ${HOME}/.zshrc ${HOME}/.p10k.zsh

# Switch back to user
USER ${NB_USER}

# Add configurations
RUN echo "export USER=root" >> ${HOME}/.zshrc && \
    echo "export USER=${NB_USER}" >> ${HOME}/.zshrc

# Install Python environment with mamba
RUN echo 'export MAMBA_ROOT_PREFIX=/home/${NB_USER}/mamba' >> ${HOME}/.zshrc && \
    mamba init && \
    mamba create -n neurodevenv_test python=3.10 ipykernel -y && \
    echo "mamba activate neurodevenv_test" >> ${HOME}/.zshrc && \
    python -m ipykernel install --user --name neurodevenv_test --display-name "Python (neurodevenv_test)"

# Install additional Python packages
RUN pip install bids-validator pybids nilearn nipype

# Clean PATH duplicates
RUN echo 'export PATH=$(perl -e "print join(\":\", grep { !\\$seen{\\$_}++ } split(/:/, \\$ENV{PATH}))")' >> ${HOME}/.zshrc

# Set entrypoint to Zsh
ENTRYPOINT ["/bin/zsh"]

# docker run -it --entrypoint /bin/bash neurodesk:custom

# docker run -it --rm \
#     --shm-size=1gb --user=root --cap-add=SYS_ADMIN --security-opt=apparmor:unconfined \
#     --device=/dev/fuse --name neurodesk \
#     -v ~/neurodesktop-storage:/neurodesktop-storage \
#     -p 8888:8888 \
#     -e NB_USER=pamcconnell \
#     -e NB_UID=$(id -u) \
#     -e NB_GID=$(id -g) \
#     neurodesk:custom
