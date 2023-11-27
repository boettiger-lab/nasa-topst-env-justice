sudo useradd rstudio -u 1000 -s /bin/bash
mkdir -p /home/rstudio/.local/share/rstudio/projects_settings
export RPROJ"=$(ls *.Rproj)"
echo ${RPROJ} > /home/rstudio/.local/share/rstudio/projects_settings/last-project-path
