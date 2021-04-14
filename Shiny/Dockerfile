FROM rocker/shiny-verse

# install R package dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    git \
    ## clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install packages from CRAN
RUN install2.r --error \
    -r 'http://cran.rstudio.com' \
    remotes \
    learnr #\
#    && Rscript -e "remotes::install_github('rstudio-education/gradethis')" \
## clean up
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

EXPOSE 3838

WORKDIR /srv/shiny-server
#COPY ./app/* /srv/shiny-server/
#COPY ./data/ /srv/shiny-server/
#ENV SHINY_DATADIR /srv/shiny-server/data
RUN sudo chown -R shiny:shiny /srv/shiny-server
