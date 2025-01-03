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

# Switch to root and install packages
USER root
RUN apt-get update && apt-get install -y \
    sudo \
    zsh \
    git \
    curl \
    wget \
    fonts-powerline \
    perl \
    python3 \
    python3-pip \
    python3-venv && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user and set permissions
RUN if ! getent group ${NB_GID}; then groupadd -g ${NB_GID} ${NB_USER}; fi && \
    if ! id -u ${NB_USER} > /dev/null 2>&1; then \
    useradd -m -s /usr/bin/zsh -u ${NB_UID} -g ${NB_GID} ${NB_USER}; \
    fi && \
    echo "${NB_USER}:neurodesk1!" | chpasswd && \
    usermod -aG sudo ${NB_USER} && \
    echo "${NB_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    if ! getent group users; then groupadd -g 100 users; fi && \
    usermod -aG users ${NB_USER} && \
    chown -R ${NB_USER}:${NB_USER} /home/${NB_USER}

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
