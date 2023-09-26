# devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.2
RUN /rocker_scripts/install_python.sh

ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/patch/osgeo/scripts/install_dev_osgeo.sh install_dev_osgeo.sh
RUN bash install_dev_osgeo.sh
