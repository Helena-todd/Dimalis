# Dimalis: a new way of analysing your timelapse images fast and efficiently

<p align="center">
  <img width="500" height="300" src="https://github.com/Helena-todd/Dimalis/blob/main/dimalis_pipeline.png">
</p>

Dimalis is wrapped in a docker structure, which facilitates its installation on any operating system and allows to perform image denoising, single cell segmentation and cell tracking by running one line of code only!

## Here's a user-friendly step-by-step protocol to analyse cells in your images using Dimalis:

### Step 1: Install the Docker Desktop App

- **On Mac:** You will find the download link and instructions on this website: [Docker Desktop Mac install](https://docs.docker.com/desktop/mac/install/)
- **On Windows:** You will find the download link and instructions on this website: [Docker Desktop Windows install](https://docs.docker.com/desktop/windows/install/)

Once you have completed the installation, you can lauch the Docker Desktop App

### Step 2: Dowlnoad Dimalis on your computer

Git clone or download the Helena-todd/Dimalis repository.

You should now have a Dimalis folder on your computer. This folder contains:
- A Docker_structure sub-folder. Everything necessary to build the Dimalis docker image is stored there.
- A test_images/exported subfolder. We provided a few images from a timelapse to help you test Dimalis. 

### Step 3: Build the Dimalis docker image on your computer

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

### Step 4: Use docker-Dimalis to segment, track, and extract features from cells in the test images

Dimalis takes a few parameters as input:
- *[data_path]* the path to the raw images
- *[denoising_sd]* the standard deviation of noise to attenuate (denoising parameter)
- *[cell_diam]* the average diameter of cells, in pixels (cell segmentation parameter)
- *[max_dist]* the maximum distance to look for descendance in a cell's surrounding (tracking parameter)
- *[max_angle]* the maximum angle allowed for cell division (tracking parameter)
- *[apply_denoising]* this last parameter defines whether to apply denoising on the images (1) or to skip denoising (0), as denoising can be time-consuming and is not always necessary.

As a first try, we advise to test Dimalis with the default parameters that we provide, even on your own images. We have thoroughly tested this combination of parameters on numerous timelapses and found that they were adequate to track cells of variable size and shape. If Dimalis returns sub-optimal results, you can later try to change the parameter values. Here are some guidelines on how the parameters can be adjusted:
- *[denoising_sd]* if your images are highly noisy (i.e. salt and pepper noise), you can try to increase this parameter. We typically set this value between 0.0001 (low denoising) and 0.1 (high denoising).
- *[cell_diam]* if the size of cells in your images differs significantly from our test_images, you can try to lower this parameter (if cells are smaller in your images) or to increase it (if cells are bigger in your images). 
- *[max_dist]* if cells tend to move significantly between two timepoints in your timelapse, you can increase this parameter (i.e. you can allow a cell displacement of 100 pixels as opposed to the 50 pixels we defined by default).
- *[max_angle]* if your cells rotate a lot after cell division, you can increase this parameter (i.e. you can allow an angle of 45° between a mother cell and its 2 daughter cells, as opposed to the 30° that we defined as default).

Now that you have built the docker-Dimalis image, you can use it to analyse cells in images, by typing:
- **On Mac:** 
> docker run -v *[data_path]*:/home/test_images/ dimalis /home/test_images/ *[denoising_sd]* *[cell_diam]* *[max_dist]* *[max_angle]* *[apply_denoising]*
(e.g. docker run -v /Users/Helena/Documents/Dimalis/test_images/:/home/test_images/ dimalis /home/test_images/ 0.0001 29.5 50 30 1)
- **On Windows:** 
> docker run -v *[data_path]*:/home/test_images/ dimalis /home/test_images/ *[denoising_sd]* *[cell_diam]* *[max_dist]* *[max_angle]* *[apply_denoising]*
(e.g. docker run -v C:\Users\Helena\Documents\Dimalis\test_images\:/home/test_images/ dimalis /home/test_images/ 0.0001 29.5 50 30 1)

The -v option allows you to couple a folder on your local computer to a folder in the docker image. The results of Dimalis will thus be directly outputted in the path you provided, in specific subfolders for the denoising, segmentation and tracking results.

After running the docker run command, four new subfolders will be generated in the path you provided:

The BM3D subfolder will contain the denoised images (if you chose to apply denoising), or the original images (if you chose to skip denoising).

The Omnipose subfolder will contain the segmented masks images.

The feature_tables subfolder will contain one CSV table per image, in which each row corresponds to one cell, and the columns contain characteristics that were measured in these cells (i.e. cell area in pixels, cell minimum and maximum diameter, cell circularity, ...).

The STrack subfolder will contain the tracking results. For each image - 1 (the cells in the 1st image cannot be tracked by definition), STrack returns:
- a CSV table, that contains the links from cells in the previous to cells in the current image
- a PNG image, in which these links are represented as red lines

Two summary tables are also outputted:
- the complete_tracking_table.xlsx table (in the STrack folder), contains all the tracks between all cells, for all timepoints in your timelapse
- the final_merged_table.xlsx contains all measurements that were extracted from these cells, for all timepoints

### Step 5: Use Dimalis to analyse cells in your own images

You can either replace the images in the test_images folder by your own phase contrast images, or provide a different path in the "docker run" command. Always make sure that your image directory contains an /exported subfolder that contains the images that you wish to apply Dimalis on.
