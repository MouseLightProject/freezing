Mouselight freezing/thawing code

Code for lossy-compressing raw .tif tiles to .mj2 (freezing), and for
uncompressing .mj2 tiles back to .tifs (thawing).  This code works for
both raw tile folders and octree folders.  Any ktx/ folder in
the root input folder will be ignored when freezing.

To run tests, cd into the source code folder, start Matlab, then do

modpath

to add all the needed code to the Matlab path.

After that, do

test_all();

to run the tests.  They take several hours to run.

An example script to freeze a single sample (either raw tiles or
octree) is in

freeze_2022_05_30.m

An example of a thawing script is in

thaw_2017_12_19_sample.m

To run such a script on the Janelia cluster, ssh into
login1/login2/submit, then do e.g.:

bsub -P mouselight \
     -n 1 \
     -oo freeze-2022-05-30-round-1.out.txt \
     -eo freeze-2022-05-30-round-1.err.txt \
     /misc/local/matlab-2019a/bin/matlab -batch "modpath; freeze_2022_05_30"


ALT
2022-05-22
