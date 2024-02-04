## devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

## latest version of geospatial libs
RUN /rocker_scripts/experimental/install_dev_osgeo.sh
RUN apt-get update -qq && apt-get -y install vim

# standard python/jupyter setup
ENV NB_USER=rstudio
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=${VIRTUAL_ENV}/bin:${PATH}
RUN /rocker_scripts/install_python.sh && \
  chown ${NB_USER}:staff -R ${VIRTUAL_ENV}

# podman doesn't not understand group permissions
RUN chown ${NB_USER}:staff -R ${R_HOME}/site-library

# some teaching preferences
RUN git config --system pull.rebase false && \
    git config --system credential.helper 'cache --timeout=36000'

## codeserver
RUN curl -fsSL https://code-server.dev/install.sh | sh

USER rstudio
WORKDIR /home/rstudio
RUN usermod -s /bin/bash rstudio
ENV PATH=$PATH:/home/rstudio/.local/bin

COPY jupyter-requirements.txt jupyter-requirements.txt
RUN python -m pip install -r jupyter-requirements.txt && rm jupyter-requirements.txt

COPY nasa-requirements.txt requirements.txt
RUN python -m pip install -r requirements.txt && rm requirements.txt

COPY install.R install.R
RUN Rscript install.R && rm install.R

