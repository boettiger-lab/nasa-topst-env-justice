#!/bin/bash

sudo cp /etc/rstudio/disable_auth_rserver.conf /etc/rstudio/rserver.conf
sudo sudo bash -c 'echo "USER=rstudio" >>/etc/environment'
sudo /init &> /dev/null &

## set startup dir
mkdir -p ~/.local/share/rstudio/projects_settings
export RPROJ"=$(ls ${CODESPACE_VSCODE_FOLDER}/*.Rproj)"
echo ${RPROJ} > ~/.local/share/rstudio/projects_settings/last-project-path


