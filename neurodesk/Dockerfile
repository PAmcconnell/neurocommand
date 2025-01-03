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
ARG NB_PASSWORD=Br@1nz!

# Create user and set password
RUN useradd -m -s /bin/zsh ${NB_USER} && echo "${NB_USER}:${NB_PASSWORD}" | chpasswd && adduser ${NB_USER} sudo
ARG NB_UID=1000
ARG NB_GID=1000
ENV NB_USER=${NB_USER} NB_UID=${NB_UID} NB_GID=${NB_GID}
ENV HOME=/home/${NB_USER}
ENV ZSH="${HOME}/.oh-my-zsh"

# Dynamically create user with specified UID and GID
RUN groupadd -g ${NB_GID} ${NB_USER} && \
    useradd -m -s /bin/zsh -u ${NB_UID} -g ${NB_GID} ${NB_USER} && \
    echo "${NB_USER}:${NB_USER}" | chpasswd && \
    adduser ${NB_USER} sudo

# Switch to the new user
USER ${NB_USER}
WORKDIR /home/${NB_USER}
ENV HOME=/home/${NB_USER}
ENV ZSH="${HOME}/.oh-my-zsh"

# Install Oh My Zsh
RUN RUNZSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Install Zinit
RUN mkdir -p "${HOME}/.local/share/zinit" && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/main/scripts/install.sh)" && \
    chown -R ${NB_USER}:${NB_USER} "${HOME}/.local/share/zinit"

# Set up Powerlevel10k and plugins
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH}/custom/themes/powerlevel10k && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH}/custom/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH}/custom/plugins/zsh-syntax-highlighting && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git ${ZSH}/custom/plugins/zsh-completions

# Copy custom .zshrc and .p10k.zsh
COPY .zshrc ${HOME}/.zshrc
COPY .p10k.zsh ${HOME}/.p10k.zsh
RUN chown ${NB_USER}:${NB_USER} ${HOME}/.zshrc ${HOME}/.p10k.zsh

# Install Python environment with mamba
RUN echo 'export MAMBA_ROOT_PREFIX=/home/jovyan/mamba' >> ~/.zshrc
RUN mamba create -n neurodevenv_test python=3.10 ipykernel -y && \
    echo "mamba activate neurodevenv_test" >> ${HOME}/.zshrc && \
    echo "python -m ipykernel install --user --name neurodevenv_test --display-name "neurodevenv_test_devenv4" " >> ${HOME}/.zshrc
RUN pip install bids-validator pybids nilearn nipype
# Clean PATH duplicates
RUN echo 'export PATH=$(perl -e "print join(\":\", grep { !\\$seen{\\$_}++ } split(/:/, \\$ENV{PATH}))")' >> ${HOME}/.zshrc

# Set entrypoint to Zsh
ENTRYPOINT ["/bin/zsh"]

# docker run -it --rm \
#     --shm-size=1gb --user=root --cap-add=SYS_ADMIN --security-opt=apparmor:unconfined \
#     --device=/dev/fuse --name neurodesk \
#     -v ~/neurodesktop-storage:/neurodesktop-storage \
#     -p 8888:8888 \
#     -e NB_USER=pamcconnell \
#     -e NB_UID=$(id -u) \
#     -e NB_GID=$(id -g) \
#     neurodesk:custom
