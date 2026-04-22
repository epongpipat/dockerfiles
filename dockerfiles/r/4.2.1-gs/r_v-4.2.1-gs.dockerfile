FROM rocker/r-ver:4.2.1

# Install system dependencies, including CMake and NLopt
RUN apt-get update && apt-get install -y \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
        cmake \
        libnlopt-dev \
        curl \
        gdebi-core \
        libgdal-dev \
        libgeos-dev \
        libproj-dev \
        libsqlite3-dev \
        libudunits2-dev \
        libuv1-dev \
        libnode-dev \
        libv8-dev \
        && rm -rf /var/lib/apt/lists/*

# Install Quarto
RUN curl -L -o /tmp/quarto.deb https://quarto.org/download/latest/quarto-linux-amd64.deb && \
    gdebi -n /tmp/quarto.deb && \
    rm /tmp/quarto.deb

# Copy package lists
COPY pkgs_cran.txt pkgs_gh.txt /tmp/

RUN R -e "options(warn = 2); \
    install.packages('stringi', type = 'source', repos = 'https://cran.rstudio.com/');"

# Install R packages from CRAN
# RUN R -e "options(warn = 2); install.packages(readLines('/tmp/pkgs_cran.txt'), repos='https://cran.rstudio.com/')"
RUN R -e "options(warn = 2); \
    # Point to a snapshot from late 2022/early 2023 compatible with R 4.2.1 \
    # We also use the __linux__ path to get fast binaries for Debian Bullseye \
    options(repos = c(CRAN = 'https://packagemanager.rstudio.com/cran/__linux__/bullseye/2023-01-01')); \
    pkgs <- readLines('/tmp/pkgs_cran.txt'); \
    # Filter out base packages (like parallel) \
    base_pkgs <- rownames(installed.packages(priority='base')); \
    to_install <- setdiff(pkgs, base_pkgs); \
    install.packages(to_install)"

# Install R packages from GitHub
RUN R -e "options(warn = 2); \
    remotes::install_github(readLines('/tmp/pkgs_gh.txt'))"

# Set up environment
ENV PATH="/usr/local/bin:$PATH"
