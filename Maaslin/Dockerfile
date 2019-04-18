FROM rocker/r-ver:3.4.4

RUN mkdir /home/analysis

RUN Rscript -e "if(! require('pacman')) \
      install.packages('pacman', 
repos='http://cran.us.r-project.org'); \
      suppressPackageStartupMessages(library('pacman')); \
      pacman::p_load('devtools', 'agricolae', 'gamlss', 'gbm', 'nlme', \
         'gam', 'glmnet', 'inlinedocs', 'logging', 'devtools','MASS', \
         'optparse', 'outliers','penalized', 'pscl', 'robustbase')"



RUN Rscript -e "if(! require("pacman"));
      install.packages("pacman", repos='http://cran.us.r-project.org');
      suppressPackageStartupMessages(library("pacman")); 
      pacman::p_load('devtools', 'agricolae', 'gamlss', 'gbm', 'nlme', 'gam', 'glmnet', 'inlinedocs', 'logging', 'devtools','MASS', 'optparse', 'outliers','penalized', 'pscl', 'robustbase')"

RUN Rscript -e "if (!packageVersion('gam')=='1.14') { remove.packages('gam');
       devtools::install_version("gam", version = "1.14", 
       repos = "http://cran.us.r-project.org")}"

RUN Rscript -e "if (!packageVersion('logging')=='0.7-103') { remove.packages('logging');
       devtools::install_version("logging", 
       version = "0.7-103", repos = "http://cran.us.r-project.org")}"

# Install older version of nlme
if (!packageVersion('nlme')=='3.1-127') {
remove.packages('nlme')
devtools::install_version("nlme", version = "3.1-127", repos = "http://cran.us.r-project.org")
}
