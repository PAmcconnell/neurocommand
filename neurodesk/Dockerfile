# Base image
FROM vnmd/neurodesktop:2024-12-06

# Set working directory and copy content
WORKDIR /neurodesk
COPY . /neurodesk/

# Set username and environment variables
ARG NB_USER=pamcconnell
ARG NB_UID=1100
ARG NB_GID=1100
ENV NB_USER=${NB_USER} \
    NB_UID=${NB_UID} \
    NB_GID=${NB_GID} \
    HOME=/home/${NB_USER} \
    ZSH="${HOME}/.oh-my-zsh"

# Ensure root user and install required packages
USER root
RUN apt-get update && apt-get install -y \
    sudo \
    zsh \
    git \
    curl \
    wget \
    fonts-powerline \
    perl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user and set permissions
RUN groupadd -g ${NB_GID} ${NB_USER} && \
    useradd -m -s /usr/bin/zsh -u ${NB_UID} -g ${NB_GID} ${NB_USER} && \
    echo "${NB_USER}:neurodesk" | chpasswd && \
    usermod -aG sudo ${NB_USER} && \
    echo "${NB_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the new user
USER ${NB_USER}
RUN cd ${HOME}
USER root

# Install Oh My Zsh
RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O install.sh
RUN  sh install.sh

# Install Zinit
RUN mkdir -p "${HOME}/.local/share/zinit" && \
    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/main/scripts/install.sh)"

# Copy custom shell configuration files
COPY .zshrc ${HOME}/.zshrc
COPY .bashrc ${HOME}/.bashrc

# Fix permissions for copied files
USER root
RUN chown -R ${NB_USER}:${NB_USER} ${HOME}/.zshrc ${HOME}/.bashrc

# Switch to Zsh as the default shell
RUN chsh -s /usr/bin/zsh ${NB_USER}

# Add custom environment configurations
USER ${NB_USER}
RUN echo "export USER=${NB_USER}" >> ${HOME}/.zshrc

# Entry point
WORKDIR ${HOME}
ENTRYPOINT ["/usr/bin/zsh"]
HEALTHCHECK NONE
