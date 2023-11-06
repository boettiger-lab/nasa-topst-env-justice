# devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

# Consider setting up a renv / venv to house this stuff?
RUN /rocker_scripts/install_python.sh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/experimental/install_dev_osgeo.sh install_dev_osgeo.sh
RUN bash install_dev_osgeo.sh

USER rstudio
WORKDIR /home/rstudio

COPY requirements.txt requirements.txt
ENV PATH=$PATH:/home/rstudio/.local/bin

RUN pip install --user -r requirements.txt
COPY install.R install.R
RUN Rscript install.R

