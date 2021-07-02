# Specify base image
FROM continuumio/miniconda3

# Specify image location of volume to store PDF and CSV files
VOLUME ["/pymscrape_data"]

# Setup conda
COPY . /pymscrape_src/
RUN conda env create -f /pymscrape_src/pymscrape.yml
RUN echo "conda activate pymscrape" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Setup Chrome
RUN apt-get update
RUN apt update

# Install inkscape
RUN apt-get update
RUN apt-get install -y inkscape

# Install QGIS
RUN apt-get install -y qgis

# Setup user for container
ARG USER_ID
ARG GROUP_ID
RUN groupadd -r -g $GROUP_ID pymscrape
RUN useradd --no-log-init -r -g pymscrape -u $USER_ID pymscrape
USER pymscrape

# Code to run when container initialised
ENTRYPOINT ["/pymscrape_src/entrypoint.sh"]
