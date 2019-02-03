#!/bin/bash
LOGSOURCEDIR=$1
STAGINGDIR=$2
DATE=$3
DATEE=$4
aws s3 cp $LOGSOURCEDIR/ $STAGINGDIR/$DATE/ --exclude "*" --include "*.$DATEE*" --recursive

