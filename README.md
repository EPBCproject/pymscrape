Copyright Ewan Short. All rights reserved.<br>
Concept of automated GIS data extraction for conservation applications by
Kim Garratt, Annica Schoo and the Australian Conservation Foundation 2021.<br>
Software design and development by Ewan Short 2021. <br>
<eshort0401@gmail.com>, <https://github.com/eshort0401> <br>

# Introduction
This repository contains python software for the efficient extraction of GIS
data from map images in PDF files. The software does the following.
1. Identify pages in a PDF document potentially containing maps by searching for
large images, and optionally containing search terms like "legend" or "map".
1. Allow the user to associate physical coordinates with map images by specifying
the coordinates of a small number of distinct pixels (at least three), then performing
simple linear interpolation.
1. Extract SVG data from map images if present, and convert this to KML format using the coordinates
obtained above.
1. Remove the SVG layer, then create KML polygons for regions of interest within
the remaining flat BMP map image. This is performed by allowing the user to select
representative blocks for regions of interest, then performing image segmentation
using a random forest classifier.    

## Known Issues
1. Forthcoming.

# Docker Setup
pymscrape may be run through [Docker](https://www.docker.com/). Docker is a convenient tool for isolating the configuration needed to run a piece of software from the rest of your system. Note that running pymscrape through Docker is currently only supported for UNIX systems, as the Docker containers are themselves UNIX based. (In principle it
is possible to also run these containers from Docker on Windows using WSL2,
but this is not yet working.)

If not using Docker, skip to the Normal Setup section below.

## Installation
1. Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop).
1. Download or clone the pymscrape repository.
1. Open the terminal and navigate to the repository directory  by typing

    ```
    cd <parent_dir>/pymscrape
    ```

    where `<parent_dir>` is the full path to the directory containing the
    pymscrape folder.
1. Type the following command into the terminal to build the Docker
image.

    ```
    docker build -t pymscrape:1.0 --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
    ```

    1. Note that `$(id -u)` and `$(id -g)` tell pymscrape to use the host user's
    ID numbers for the user created in the UNIX container. This ensures any new files created by pymscrape are owned by the host user. Note that these ID numbers can can be changed to those of other users or groups if required.
    1. By default, pymscrape will give read, write and execute rights for any created files to everyone after the website data has been downloaded. These permissions can be changed by altering the `chmod ...` lines in `entrypoint.sh` to, for instance, only give write access to the host user.
1. WARNING! Configuring GUI apps to run on docker is complex, highly system dependent, and may introduce security risks. If running on a UNIX system with X11 (like Ubuntu), you can perform the following proof of concept test, but this comes with SECURITY RISKS. First allow access to your display by opening the terminal and typing

    ```
    xhost local:root
    ```

    Run the pymscrape Docker container with

    ```
    docker run -it --rm \
    --mount "type=bind,src=<parent_dir>/pymscrape,dst=/pymscrape_data" \
    -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix pymscrape:1.0
    ```

    The pymscrape main menu window should appear. Once you have finished testing,
    close the pymscrape window. The container should stop. You should then run

    ```
    xhost -local:root
    ```

    to revoke access to your display. BE WARNED that other systems may be
    able to access your display during the time between running the two `xhost`
    commands. There are much [better ways](https://medium.com/dot-debug/running-chrome-in-a-docker-container-a55e7f4da4a8)
    to run GUI apps through Docker, but which method you choose will depend highly on your system.  

## Launching pymscrape
1. See the above instructions on running the Docker container with an attached
display, but note the security risks.

# Normal Setup
pymscrape can also be run without Docker, but additional dependencies must be
downloaded and installed.

## Supported Systems
- Unix systems (i.e. Linux and Mac).
- Windows 10. (Currently, operating system calls on Windows use the Windows Powershell,
which only ships by default with Windows 10. Future versions may support
older versions of Windows.)

## Installation
1. Click the green "Code" button above, then "Download ZIP". (Advanced users should use GIT.)
    1. Extract the ZIP file. You should end up with a folder called pymscrape.
    On windows, the recommended location for this directory is
    `C:\Users\<username>\Documents\pymscrape`, replacing `<username>` with your own Windows user name.  
1. Download the [miniconda](https://docs.conda.io/en/latest/miniconda.html) installer.
    1. You most likely want the most recent, 64 bit version for your system.
    1. Run the installer. All the default installation settings are most likely fine.
    1. miniconda includes python itself, and makes it *much* easier to
  manage open source python packages.
1. Open the terminal (UNIX) or the Anaconda Powershell Prompt (Windows 10) and navigate to the pymscrape directory by typing `cd <base_dir>`, where `<base_dir>` is the full path to the pymscrape folder. If using UNIX, type

    ```
    conda env create -f pymscrape.yml
    ```

    If using Windows 10, type
    ```
    conda env create -f pymscrape_windows.yml
    ```
    This will download other necessary python packages, and put them into an
    conda environment called pymscrape. Environments make it possible to run
    different versions of python with different combinations of packages on the same system. If the environment could not be created using the YML file given above, try instead
    ```
    conda env create -f pymscrape_unfrozen.yml
    ```
    This will allow conda to try to choose the best versions of each piece of python software for your system, rather than using the fixed versions specified in the other YML files.

    Once created, activate your new pymscrape conda environment by typing
    ```
    conda activate pymscrape
    ```
    1. On Windows systems, the python package `bezier` needs to be installed manually due to an [open issue](https://github.com/dhermes/bezier/issues/237) with bezier's prebuilt binaries on Windows 10. Open the Powershell and type

        ```
        $BEZIER_NO_EXTENSION=$true
        <path-to-miniconda>\miniconda3\envs\pymscrape\Scripts\pip3 install --upgrade bezier --no-binary=bezier
        ```

        where `<path-to-miniconda>` is the full path to miniconda. It will usually be something like `C:\Users\<username>`, where `<username>` is your Windows 10 username.
1. Download and install [Inkscape v. 1.1](https://inkscape.org/release/inkscape-1.1/) for your system.
1. Download and install [QGIS v. 2.18.17](https://www.qgis.org/en/site/forusers/alldownloads.html) for your system.
1. Depending on your system, you may also need to add the Inkscape and QGIS executables
to you path environment. 
    1. On Windows 10, this can be accomplished by typing "environment"
    into the Windows search bar, then clicking the "Edit the system environment variables"
    result that appears.

## Launching pymscrape
1. Open the terminal (UNIX) or Anaconda Powershell Prompt (Windows 10).
1. Activate the conda environment by typing

    ```
    conda activate pymscrape
    ```

    This tells the shell to use the python configuration defined above.
1. Run the following command in the terminal (UNIX) or Anaconda Powershell
Prompt (Windows 10) to launch the pymscrape main menu,

    ```
    python <base_dir>/pymscrape_script.py <save_dir>
    ```

    where `<base_dir>` is the full path to the pymscrape folder, and
    `<save_dir>` is the directory where you wish to save extracted KML files.
    If `<save_dir>` is different from `<base_dir>`, you will need to copy the
    `reference.qgs` file from `<base_dir>` to `<save_dir>`. Note that
    `<save_dir>` can be the same as `<base_dir>` if so desired.
