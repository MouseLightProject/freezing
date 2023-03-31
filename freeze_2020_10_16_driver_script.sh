cd /groups/mousebrainmicro/mousebrainmicro/scripts/freezing/
out=freeze-2022-10-16.out.txt
bsub -P mouselight -n 8 -oo $out -eo $out /misc/local/matlab-2019a/bin/matlab -nodisplay -batch "modpath; freeze_2020_10_16"
