#!/bin/bash

sudo cp /etc/rstudio/disable_auth_rserver.conf /etc/rstudio/rserver.conf
cp /etc/environment env
echo "USER=$USER" >> env
sudo mv env /etc/environment

mkdir -p ~/.local/share/rstudio/projects_settings
export RPROJ"=$(ls -d $PWD/*.Rproj)"
echo ${RPROJ} > ~/.local/share/rstudio/projects_settings/last-project-path

sudo rstudio-server start

