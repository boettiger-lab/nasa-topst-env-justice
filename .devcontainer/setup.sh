#!/bin/bash

sudo cp /etc/rstudio/disable_auth_rserver.conf /etc/rstudio/rserver.conf
sudo sudo bash -c 'echo "USER=rstudio" >>/etc/environment'
sudo /init &

## set startup dir
mkdir -p ~/.local/share/rstudio/projects_settings
echo "/workspaces/nasa-topst-env-justice/nasa-topst-env-justice.Rproj" > ~/.local/share/rstudio/projects_settings/last-project-path

echo "setup complete"
