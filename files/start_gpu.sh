#!/bin/sh
#
# preparation of the gpu machine file
#
# usage: start_gpu.sh
#
# taken from: https://github.com/HPCKP/GPU-Integration-for-GridEngine/
#

GPUNUM=3
GPUDIR=/opt/sge/gpu/var

for ((i=0;i<$GPUNUM;i++)); do
    mkdir $GPUDIR/$i >/dev/null 2>&1 && echo $i > "$TMPDIR/gpumachine" && exit 0
done

echo "ERROR: there are no free GPUs, check $GPUDIR"
exit -1

