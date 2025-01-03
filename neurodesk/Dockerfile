# Base image
FROM vnmd/neurodesktop:2024-12-06

# Set working directory and copy content
WORKDIR /neurodesk
COPY . /neurodesk/

# Set username and password
ARG NB_USER=pamcconnell
ARG NB_UID=1100
ARG NB_GID=1100
ENV NB_USER=${NB_USER} \
    NB_UID=${NB_UID} \
    NB_GID=${NB_GID} \
    HOME=/home/${NB_USER} \
    ZSH="${HOME}/.oh-my-zsh"

# Add user and install required packages
RUN apt-get update && apt-get install -y zsh git curl wget fonts-powerline perl && apt-get clean && \
    groupadd -f -g ${NB_GID} ${NB_USER} && \
    useradd -m -s /bin/zsh -u ${NB_UID} -g ${NB_GID} ${NB_USER} && \
    echo "${NB_USER}:neurodesk" | chpasswd && \
    adduser ${NB_USER} sudo && \
    RUNZSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" || echo "Oh My Zsh already installed"

# Switch to the new user
USER ${NB_USER}
# Install Oh My Zsh and Zinit
RUN RUNZSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" || echo "Oh My Zsh already installed" && \
    mkdir -p "${HOME}/.local/share/zinit" && \
    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/main/scripts/install.sh)"
COPY .zshrc ${HOME}/.zshrc
COPY .bashrc ${HOME}/.bashrc
RUN chown ${NB_USER}:${NB_USER} ${HOME}/.zshrc ${HOME}/.bashrc

# Switch to Zsh as the default shell
# Add environment configuration and change default shell
RUN chsh -s /usr/bin/zsh ${NB_USER} && \
# Add environment configuration
RUN echo "export USER=${NB_USER}" >> ${HOME}/.zshrc && \
    apt-get clean && \
    chown ${NB_USER}:${NB_USER} ${HOME}/.zshrc ${HOME}/.bashrc

ENTRYPOINT ["/usr/bin/zsh"]
HEALTHCHECK NONE
