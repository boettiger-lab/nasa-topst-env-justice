# devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

# Consider setting up a renv / venv to house this stuff?
RUN /rocker_scripts/install_python.sh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/patch/osgeo/scripts/install_dev_osgeo.sh install_dev_osgeo.sh
RUN bash install_dev_osgeo.sh

USER rstudio
WORKDIR /home/rstudio
#COPY renv.lock renv.lock
ADD https://raw.githubusercontent.com/boettiger-lab/nasa-topst-env-justice/main/.devcontainer/renv.lock renv.lock
RUN Rscript -e "renv::activate(profile='spatial'); renv::restore(lockfile='renv.lock')"
COPY requirements.txt requirements.txt
RUN pip install --user -r requirements.txt


