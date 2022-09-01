# Dimalis: a new way of analysing your timelapse images fast and efficiently

<p align="center">
  <img width="500" height="300" src="https://github.com/Helena-todd/Dimalis/blob/master/dimalis_pipeline.png">
</p>

Dimalis is wrapped in a docker structure, which facilitates its installation on any operating system and allows to perform image denoising, single cell segmentation and cell tracking by running one line of code only!

### Here's a user-friendly step-by-step protocol to analyse cells in your images using Dimalis:

#### Step 1: Install the Docker Desktop App

- **On Mac:** You will find the download link and instructions on this website: [Docker Desktop Mac install](https://docs.docker.com/desktop/mac/install/)
- **On Windows:** You will find the download link and instructions on this website: [Docker Desktop Windows install](https://docs.docker.com/desktop/windows/install/)

Once you have completed the installation, you can lauch the Docker Desktop App

#### Step 2: Dowlnoad Dimalis on your computer

Git clone or download the Helena-todd/Dimalis repository.

You should now have a Dimalis folder on your computer. This folder contains:
- A Docker_structure sub-folder. Everything necessary to build the Dimalis docker image is stored there.
- A test_images/exported subfolder. We provided a few images from a timelapse to help you test Dimalis. 

#### Step 3: Build the Dimalis docker image on your computer

Open a command line:
- **On Mac:** you will find it in your Applications/Utilities/Terminal
- **On Windows:** you will find it by typing "Command Prompt" in the Power User Menu

Move to the Dimalis/Docker_structure directory on your computer by typing "cd" followed by the path to the directory:
- **On Mac:** 
> cd path_to_Dimalis/Docker_structure_directory
(e.g. cd /Users/Helena/Documents/Dimalis/Docker_structure)
- **On Windows:** 
> cd path_to_Dimalis\Docker_structure_directory
(e.g. cd C:\Users\Helena\Documents\Dimalis\Docker_structure)

Build the image by typing:
> docker build . –t dimalis

The docker App should now start building the docker image on your computer. 
(if not, make sure that you did not forget to launch the Docker Desktop App)

After a while, (this process can take a few minutes), all the steps should be completed. Dimalis is now ready to use!
