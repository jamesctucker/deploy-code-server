#!/bin/bash

sudo test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
sudo test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
sudo test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
sudo echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile