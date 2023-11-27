sudo useradd rstudio -u 1000 -s /bin/bash
print pwd
mkdir -p ~/.local/share/rstudio/projects_settings
export RPROJ"=$(ls *.Rproj)"
echo ${RPROJ} > ~/.local/share/rstudio/projects_settings/last-project-path
