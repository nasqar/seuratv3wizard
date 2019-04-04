# Install R version 3.5
FROM r-base:3.5.0

# Install Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev \
    libsodium-dev \
    libxml2-dev \
    libv8-3.14-dev

# Download and install ShinyServer (latest version)
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

# seuratwizard
RUN R -e "install.packages('devtools')"
RUN apt-get update && apt-get install -y libhdf5-dev libpython-dev python-pip
RUN R -e "devtools::install_github('nasqar/seuratv3wizard', upgrade_dependencies = FALSE,subdir = NULL)"
RUN R -e "devtools::install_github(repo = 'satijalab/seurat', ref = 'release/3.0', force=T)"
RUN R -e "devtools::install_github(repo = 'ChristophH/sctransform')"
RUN pip install cellbrowser
RUN pip install umap-learn

# Copy configuration files into the Docker image
COPY docker_files/shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY docker_files/shiny-server.sh /usr/bin/shiny-server.sh

# Make the ShinyApp available at port 80
EXPOSE 80

CMD ["/usr/bin/shiny-server.sh"]
