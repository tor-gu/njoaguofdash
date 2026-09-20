# A self-contained way to try the dashboard without installing the R stack.
#
#     docker build -t njoaguofdash .
#     docker run --rm -p 3838:3838 njoaguofdash
#
# then open http://localhost:3838
#
# rocker/shiny brings R, Shiny Server's runtime dependencies and pandoc, which
# the app needs at startup to render the About tab.
FROM rocker/shiny:4.4.1

# System libraries for sf (GDAL/GEOS/PROJ) and for the packages that build
# against curl/openssl/xml2.
RUN apt-get update && apt-get install -y --no-install-recommends \
      libgdal-dev \
      libgeos-dev \
      libproj-dev \
      libudunits2-dev \
      libcurl4-openssl-dev \
      libssl-dev \
      libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN install2.r --error --skipinstalled remotes

# Dependencies first, so edits to the package source do not invalidate the
# layer that takes all the time.
#
# Install against the repository the base image already pins, and let remotes
# upgrade whatever it needs to.
COPY DESCRIPTION /tmp/njoaguofdash/DESCRIPTION
RUN Rscript -e 'remotes::install_deps("/tmp/njoaguofdash", dependencies = NA, upgrade = "always")'

COPY . /tmp/njoaguofdash
RUN Rscript -e 'remotes::install_local("/tmp/njoaguofdash", upgrade = "never")' \
    && rm -rf /tmp/njoaguofdash

EXPOSE 3838

# host = 0.0.0.0 so the app is reachable from outside the container
CMD ["R", "-q", "-e", "shiny::runApp(njoaguofdash::njoaguofdashApp(), host = '0.0.0.0', port = 3838)"]
