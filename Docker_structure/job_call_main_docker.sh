#Call script arguments: /home/test_images/  0.0001  29.5  50    30    skip_denoising
#                       ${1}                ${2}    ${3}  ${4}  ${5}  ${6}

DATA_PATH=${1}
DENOISING_SD=${2}
CELL_DIAM=${3}
MAX_DIST=${4}
MAX_ANGLE=${5}
APPLY_DENOISING=${6}

export DATA_PATH
export DENOISING_SD
export CELL_DIAM
export MAX_DIST
export MAX_ANGLE
export APPLY_DENOISING

# Move to the folder containing the Raw images
cd $DATA_PATH/exported/

# List image files
imgNames="$(ls |grep .tif)"

# Create folder that will contain the denoised images
mkdir -p $DATA_PATH/BM3D/$DENOISING_SD

# Loop over the files, create export name, pass those names to the python bm3d script
for MYIMG in ${imgNames}
do
export MYIMG
# create export image name, to give to the python script
MYDENOISEDIMG="denoised_$MYIMG"
export MYDENOISEDIMG

############################
#####       BM3D       #####
############################

if [[ $APPLY_DENOISING -eq 0 ]]
then
    # Copy paste raw images to the BM3D directory #, adding a denoised_ prefix
    echo "Skipping cell denoising"
    bm3ddir="$DATA_PATH/BM3D/$DENOISING_SD"
    cp * ${bm3ddir}
    
elif [[ $APPLY_DENOISING -eq 1 ]]
then
    echo "Denoising cells using the BM3D algorithm "
    # call bm3d python script
    python3 /home/scripts/python_bm3d_script_bash.py $MYIMG $MYDENOISEDIMG ${1}/exported $DENOISING_SD
    # Move images to the directory where they should be
    bm3ddir="$DATA_PATH/BM3D/$DENOISING_SD"
    mv denoised* $DATA_PATH/BM3D/$DENOISING_SD
else
    echo "Please use one of the two denoising options, either 0 (skip denoising) or 1 (denoise) "
fi

done # ends image loop

############################
#####     Omnipose     #####
############################
echo "Segmenting cells in images using the Omnipose algorithm "
# Launch omnipose on the denoised bm3d images
python3 -m cellpose --dir ${bm3ddir} --pretrained_model /home/scripts/bact_omnitorch_0 --diameter $CELL_DIAM --mask_threshold 2.1 --save_tif --verbose

# Create folder for Omnipose outputs, corrsponding to the selected sigma value
mkdir -p $DATA_PATH/Omnipose/$CELL_DIAM

# Move segmented images to the Omnipose directory
cd $DATA_PATH/BM3D/$DENOISING_SD
mv *cp_masks.tif $DATA_PATH/Omnipose/$CELL_DIAM

##################################
#####    extract features    #####
##################################
echo "Extracting features from the cell masks into tables "

cd $DATA_PATH/Omnipose/$CELL_DIAM

# Create folder for feature table outputs
mkdir -p $DATA_PATH/feature_tables/
ft_dir="$DATA_PATH/feature_tables/"

# Launch script to extract features
python3 /home/scripts/extract_features_regionprops.py ${ft_dir}

######################################
#####    STrack cell tracking    #####
######################################

echo "Tracking cells using STrack "

cd $DATA_PATH/Omnipose/$CELL_DIAM

# Create folder for STrack outputs
mkdir -p $DATA_PATH/STrack/
strack_dir="$DATA_PATH/STrack/"

# Launch script to extract features
python3 /home/scripts/strack_script_v4.py $MAX_DIST $MAX_ANGLE ${strack_dir}

cd $DATA_PATH/STrack/

# Launch script to merge STrack results into 2 excel tables
python3 -W ignore /home/scripts/strack_merge_tables.py ${strack_dir}

# Launch script to merge all results (STrack, features, fluo features) into one table
python3 -W ignore /home/scripts/merge_all_tables.py $DATA_PATH
