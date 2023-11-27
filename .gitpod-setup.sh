export DEFAULT_USER=gitpod
mkdir -p ~/.local/share/rstudio/projects_settings
export RPROJ"=$(ls -d $PWD/*.Rproj)"
echo ${RPROJ} > ~/.local/share/rstudio/projects_settings/last-project-path

