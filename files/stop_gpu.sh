#!/bin/sh
#
# preparation of the gpu machine file
#
# usage: stop_gpu.sh
#
# taken from: https://github.com/HPCKP/GPU-Integration-for-GridEngine/
#

GPUDIR=/opt/sge/gpu/var
FREEGPU="`cat $TMPDIR/gpumachine`"
if [ $FREEGPU != -1 ]; then
    rmdir $GPUDIR/$FREEGPU
fi
exit 0
