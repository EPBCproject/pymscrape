#!/bin/bash --login
set -euo pipefail
conda activate pymscrape
# Run pymscrape.
python /pymscrape_src/pymscrape_script.py /pymscrape_data/
# Set file permissions to read, write, execute for everyone.
chmod a=rwx /pymscrape_data/map_data
