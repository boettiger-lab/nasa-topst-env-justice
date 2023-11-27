sudo useradd rstudio -u 1000 -s /bin/bash
mkdir -p ~/.local/share/rstudio/projects_settings
sudo mkdir -p /home/rstudio/.local/share/rstudio/projects_settings
export RPROJ"=$(ls -d $PWD/*.Rproj)"
sudo echo ${RPROJ} > ~/.local/share/rstudio/projects_settings/last-project-path
sudo cp ~/.local/share/rstudio/projects_settings/last-project-path /home/rstudio/.local/share/rstudio/projects_settings/last-project-path
sudo chown -R rstudio:rstudio /home/rstudio/.local/share/rstudio
