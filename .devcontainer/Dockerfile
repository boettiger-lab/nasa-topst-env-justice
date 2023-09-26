# devcontainer-focused Rocker
FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

# Consider setting up a renv / venv to house this stuff?
RUN /rocker_scripts/install_python.sh
ADD https://raw.githubusercontent.com/rocker-org/rocker-versioned2/patch/osgeo/scripts/install_dev_osgeo.sh install_dev_osgeo.sh
RUN bash install_dev_osgeo.sh

USER rstudio
WORKDIR /home/rstudio
RUN <<-EOF
  Rscript -e 'renv::activate(profile = "spatial") \\
  install.packages(c("tidyverse", "rmarkdown", "languageserver")) \\
  install.packages(c("sf", "terra", "gdalcubes", "stars", "rstac"), repos = "https://cran.r-project.org") \\
  renv::snapshot()'
EOF

COPY ./requirements.txt requirements.txt
RUN pip install -u -r requirements.txt


