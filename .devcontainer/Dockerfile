# devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3


ENV NB_USER=rstudio
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=${PATH}:${VIRTUAL_ENV}/bin
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/c1a472465532c8349cf0ad4f3f95c86e85787dc3/scripts/install_python.sh install_python.sh
RUN bash install_python.sh && rm install_python.sh


RUN apt-get update && apt-get -y install libxt6 libzmq3-dev gh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/experimental/install_dev_osgeo.sh install_dev_osgeo.sh
RUN bash install_dev_osgeo.sh && rm install_dev_osgeo.sh

RUN chown -R rstudio:rstudio /opt/venv

USER rstudio
WORKDIR /home/rstudio
RUN usermod -s /bin/bash rstudio

COPY requirements.txt requirements.txt
ENV PATH=$PATH:/home/rstudio/.local/bin

RUN python -m pip install -r requirements.txt && rm requirements.txt
COPY install.R install.R
RUN Rscript install.R && rm install.R

RUN python -m ipykernel install --user --name=nasa

# some teaching preferences
RUN git config --global pull.rebase false
