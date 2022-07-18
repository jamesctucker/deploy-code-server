# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json
COPY deploy-container/script.sh /usr/bin/script.sh

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------
# Install NVM
RUN sudo apt-get update --fix-missing
RUN sudo apt-get install -y curl
RUN sudo apt-get install -y build-essential libssl-dev
ENV NVM_DIR /home/.nvm

# Install nvm with node and npm
RUN sudo curl https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install node




# RUN sudo chmod a+x /usr/bin/script.sh 
# RUN /usr/bin/script.sh
# RUN /bin/bash -c ". ~/.bashrc"
# # Install NodeJS
# RUN /bin/bash -c "nvm install node"
# Install Yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# RUN sudo apt update && sudo apt install yarn
# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension eamodio.gitlens
RUN code-server --install-extension golang.Go
# launch a local development server
RUN code-server --install-extension ritwickdey.LiveServer
# my preferred VS Code theme
RUN code-server --install-extension enkia.tokyo-night

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
