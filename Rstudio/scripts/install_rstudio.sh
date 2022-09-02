#!/bin/bash
set -e

# R
apt-get update && apt-get -y install lsb-release

UBUNTU_VERSION=${UBUNTU_VERSION:-$(lsb_release -sc)}
LANG=${LANG:-en_US.UTF-8}
LC_ALL=${LC_ALL:-en_US.UTF-8}
CRAN=${CRAN:-https://cran.r-project.org}

##  mechanism to force source installs if we're using RSPM
CRAN_SOURCE=${CRAN/"__linux__/$UBUNTU_VERSION/"/""}

## source install if using RSPM and arm64 image
if [ "$(uname -m)" = "aarch64" ]; then
    CRAN=$CRAN_SOURCE
fi

export DEBIAN_FRONTEND=noninteractive

# Set up and install R
R_HOME=${R_HOME:-/usr/local/lib/R}
READLINE_VERSION=8
OPENBLAS=libopenblas-dev

apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

export -f apt_install

BASICDEPS="bash-completion \
    ca-certificates \
    devscripts \
    file \
    fonts-texgyre \
    g++ \
    git \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-* \
    libcurl4 \
    libicu* \
    libpcre2* \
    libjpeg-turbo* \
    ${OPENBLAS} \
    libpangocairo-* \
    libpng16* \
    libreadline${READLINE_VERSION} \
    libtiff* \
    liblzma* \
    locales \
    make \
    sudo \
    unzip \
    wget \
    zip \
    zlib1g"

apt_install ${BASICDEPS}

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen en_US.utf8
/usr/sbin/update-locale LANG=en_US.UTF-8

BUILDDEPS="curl \
    default-jdk \
    default-libmysqlclient-dev \
    libapparmor1 \
    libbz2-dev \
    libcairo2-dev \
    libclang-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgc1c2 \
    libgit2-dev \
    libicu-dev \
    libjpeg-dev \
    liblzma-dev \
    libobjc4 \
    libpango1.0-dev \
    libpcre2-dev \
    libpng-dev \
    libpq-dev \
    libpq5 \
    libreadline-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssh2-1-dev \
    libssl-dev \
    libtiff5-dev \
    libx11-dev \
    libxml2-dev \
    libxt-dev \
    libxtst6 \
    perl \
    procps \
    psmisc \
    python-setuptools \
    rsync \
    subversion \
    tcl-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-latex-recommended \
    tk-dev \
    unixodbc-dev \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    zlib1g-dev"

apt_install $BUILDDEPS

wget https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz || \
wget https://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz &&                                                                \
tar xzf R-${R_VERSION}.tar.gz &&

cd R-${R_VERSION}
R_PAPERSIZE=letter \
R_BATCHSAVE="--no-save --no-restore" \
R_BROWSER=xdg-open \
PAGER=/usr/bin/pager \
PERL=/usr/bin/perl \
R_UNZIPCMD=/usr/bin/unzip \
R_ZIPCMD=/usr/bin/zip \
R_PRINTCMD=/usr/bin/lpr \
LIBnn=lib \
AWK=/usr/bin/awk \
CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
./configure --enable-R-shlib \
            --enable-memory-profiling \
		    --with-readline \
		    --with-blas \
		    --with-lapack \
		    --with-tcltk \
		    --disable-nls \
		    --with-recommended-packages
make
make install
make clean

## Add a default CRAN mirror
echo "options(repos = c(CRAN = '${CRAN}'), download.file.method = 'libcurl')" >> ${R_HOME}/etc/Rprofile.site

## Set HTTPUserAgent for RSPM (https://github.com/rocker-org/rocker/issues/400)
echo  'options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(),
                 paste(getRversion(), R.version$platform,
                       R.version$arch, R.version$os)))' >> ${R_HOME}/etc/Rprofile.site

## Add a library directory (for user-installed packages)
mkdir -p ${R_HOME}/site-library
chown root:staff ${R_HOME}/site-library
chmod g+ws ${R_HOME}/site-library

## Fix library path
echo "R_LIBS=\${R_LIBS-'${R_HOME}/site-library:${R_HOME}/library'}" >> ${R_HOME}/etc/Renviron.site

## Use littler installation scripts
Rscript -e "install.packages(c('littler', 'docopt'), repos='${CRAN_SOURCE}')"
ln -s ${R_HOME}/site-library/littler/examples/install2.r /usr/local/bin/install2.r
ln -s ${R_HOME}/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r
ln -s ${R_HOME}/site-library/littler/bin/r /usr/local/bin/r

## Clean up from R source install
cd / && rm -rf /tmp/* && rm -rf R-${R_VERSION} && rm -rf R-${R_VERSION}.tar.gz
apt-get remove --purge -y $BUILDDEPS && apt-get autoremove -y && apt-get autoclean -y
rm -rf /var/lib/apt/lists/*

echo "DONE R"
# Rstudio

DEFAULT_USER=${DEFAULT_USER:-rstudio}

# install s6 supervisor
S6_VERSION=${1:-${S6_VERSION:-"v2.1.0.2"}}

ARCH=$(dpkg --print-architecture)

if [ "$ARCH" = "arm64" ]; then
    ARCH=aarch64
fi

DOWNLOAD_FILE=s6-overlay-${ARCH}.tar.gz

exit
# Set up S6 init system
wget -P /tmp/ "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/${DOWNLOAD_FILE}"
## need the modified double tar now, see https://github.com/just-containers/s6-overlay/issues/288
tar hzxf /tmp/$DOWNLOAD_FILE -C / --exclude=usr/bin/execlineb
tar hzxf /tmp/$DOWNLOAD_FILE -C /usr ./bin/execlineb

# Clean up
rm -rf /var/lib/apt/lists/*
rm -f /tmp/$DOWNLOAD_FILE

export PATH=/usr/lib/rstudio-server/bin:$PATH

# Get RStudio. Use version from environment variable, or take version from
# first argument.
if [ -z "$1" ]; then
    RSTUDIO_VERSION_ARG=$RSTUDIO_VERSION
else
    RSTUDIO_VERSION_ARG=$1
fi

RSTUDIO_BASE_URL=https://download2.rstudio.org/server

if [ -z "$RSTUDIO_VERSION_ARG" ] || [ "$RSTUDIO_VERSION_ARG" = "latest" ]; then
    DOWNLOAD_VERSION=$(wget -qO - https://rstudio.com/products/rstudio/download-server/debian-ubuntu/ | \
                       grep -oP "(?<=rstudio-server-)[0-9]+\.[0-9]+\.[0-9]+-[0-9]+" -m 1)
else
    DOWNLOAD_VERSION=${RSTUDIO_VERSION_ARG/"+"/"-"}
fi

RSTUDIO_URL="${RSTUDIO_BASE_URL}/bionic/amd64/rstudio-server-${DOWNLOAD_VERSION}-amd64.deb"

wget "${RSTUDIO_URL}"
dpkg -i rstudio-server-*-amd64.deb && rm rstudio-server-*-amd64.deb
# https://github.com/rocker-org/rocker-versioned2/issues/137
rm -f /var/lib/rstudio-server/secure-cookie-key

## RStudio wants an /etc/R, will populate from $R_HOME/etc
mkdir -p /etc/R
echo "PATH=${PATH}" >> ${R_HOME}/etc/Renviron.site

## Fix Rstudio PATH when R is installed from source, /usr/local/bin/R
R_BIN=$(which R)
echo "rsession-which-r=${R_BIN}" > /etc/rstudio/rserver.conf
echo "lock-type=advisory" > /etc/rstudio/file-locks

## Disable authentication
cp /etc/rstudio/rserver.conf /etc/rstudio/disable_auth_rserver.conf
echo "auth-none=1" >> /etc/rstudio/disable_auth_rserver.conf

## RStudio init scripts
mkdir -p /etc/services.d/rstudio
# shellcheck disable=SC2016
echo '#!/usr/bin/with-contenv bash
## load /etc/environment vars first:
for line in $( cat /etc/environment ) ; do export $line > /dev/null; done
exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
> /etc/services.d/rstudio/run

echo '#!/bin/bash
rstudio-server stop' \
> /etc/services.d/rstudio/finish

# Log to stderr
LOGGING="[*]
log-level=warn
logger-type=stderr
"

printf "%s" "$LOGGING" > /etc/rstudio/logging.conf

# Create default user
DEFAULT_USER=${1:-${DEFAULT_USER:-"rstudio"}}

if id -u "${DEFAULT_USER}" >/dev/null 2>&1; then
    echo "User ${DEFAULT_USER} already exists"
else
    ## Need to configure non-root user for RStudio
    useradd -s /bin/bash -m "$DEFAULT_USER"
    echo "${DEFAULT_USER}:${DEFAULT_USER}" | chpasswd
    addgroup "${DEFAULT_USER}" staff

    ## Rocker's default RStudio settings, for better reproducibility
    mkdir -p "/home/${DEFAULT_USER}/.rstudio/monitored/user-settings"
    cat <<EOF >"/home/${DEFAULT_USER}/.rstudio/monitored/user-settings/user-settings"
alwaysSaveHistory="0"
loadRData="0"
saveAction="0"
EOF
    chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}"
fi

# If shiny server is installed, add user to the shiny group
if [ -x "$(command -v shiny-server)" ]; then
    adduser "${DEFAULT_USER}" shiny
fi

## configure git not to request password each time
if [ -x "$(command -v git)" ]; then
    git config --system credential.helper 'cache --timeout=3600'
    git config --system push.default simple
fi

# install user config initiation script
cp /opt/init_set_env.sh /etc/cont-init.d/01_set_env
cp /opt/init_userconf.sh /etc/cont-init.d/02_userconf
cp /opt/pam-helper.sh /usr/lib/rstudio-server/bin/pam-helper

USER_SETTINGS='alwaysSaveHistory="0"
loadRData="0"
saveAction="0"
'
USER_SETTINGS_FOLDER="/home/${DEFAULT_USER}/.rstudio/monitored/user-settings"
mkdir -p ${USER_SETTINGS_FOLDER} && \
    printf "%s" "$USER_SETTINGS" > ${USER_SETTINGS_FOLDER} && \
    chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}/.rstudio

## Pandoc

PANDOC_VERSION=${1:-${PANDOC_VERSION:-default}}
ARCH=$(dpkg --print-architecture)

if [ -x "$(command -v pandoc)" ]; then
    INSTALLED_PANDOC=$(pandoc --version 2>/dev/null | head -n 1 | grep -oP '[\d\.]+$')
fi

if [ "$INSTALLED_PANDOC" != "$PANDOC_VERSION" ]; then
    if [ -f "/usr/lib/rstudio-server/bin/pandoc/pandoc" ] &&
        { [ "$PANDOC_VERSION" = "$(/usr/lib/rstudio-server/bin/pandoc/pandoc --version | head -n 1 | grep -oP '[\d\.]+$')" ] ||
          [ "$PANDOC_VERSION" = "default" ]; }; then
        ln -fs /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin
        ln -fs /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin
    else
        if [ "$PANDOC_VERSION" = "default" ]; then
            PANDOC_DL_URL=$(wget -qO- https://api.github.com/repos/jgm/pandoc/releases/latest | grep -oP "(?<=\"browser_download_url\":\s\")https.*${ARCH}\.deb")
        else
            PANDOC_DL_URL=https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-${ARCH}.deb
        fi
        wget ${PANDOC_DL_URL} -O pandoc-${ARCH}.deb && dpkg -i pandoc-${ARCH}.deb && rm pandoc-${ARCH}.deb
    fi

  ## Symlink pandoc & standard pandoc templates for use system-wide
    PANDOC_TEMPLATES_VERSION=$(pandoc -v | grep -oP "(?<=pandoc\s)[0-9\.]+$")
    wget https://github.com/jgm/pandoc-templates/archive/${PANDOC_TEMPLATES_VERSION}.tar.gz -O pandoc-templates.tar.gz
    rm -fr /opt/pandoc/templates && mkdir -p /opt/pandoc/templates && tar xvf pandoc-templates.tar.gz
    cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates*
    rm -fr /root/.pandoc && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates
fi

# Clean up
rm -rf /var/lib/apt/lists/*

# Tidyverse

NCPUS=${NCPUS:--1}

install2.r --error --skipinstalled -n "$NCPUS" \
    tidyverse \
    devtools \
    rmarkdown \
    BiocManager \
    vroom \
    gert

## dplyr database backends
install2.r --error --skipmissing --skipinstalled -n "$NCPUS" \
    arrow \
    dbplyr \
    DBI \
    dtplyr \
    duckdb \
    nycflights13 \
    Lahman \
    RMariaDB \
    RPostgres \
    RSQLite \
    fst

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so

echo -e "DONE!"