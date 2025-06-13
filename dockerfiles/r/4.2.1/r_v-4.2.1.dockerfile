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
        && rm -rf /var/lib/apt/lists/*

# Install Quarto
RUN curl -L -o /tmp/quarto.deb https://quarto.org/download/latest/quarto-linux-amd64.deb && \
    gdebi -n /tmp/quarto.deb && \
    rm /tmp/quarto.deb

# Copy package lists
COPY pkgs_cran.txt pkgs_gh.txt /tmp/

# Install R packages from CRAN
RUN R -e "install.packages(readLines('/tmp/pkgs_cran.txt'), repos='https://cran.rstudio.com/')"

# Install R packages from GitHub
RUN R -e "remotes::install_github(readLines('/tmp/pkgs_gh.txt'))"

# Set up environment
ENV PATH="/usr/local/bin:$PATH"
