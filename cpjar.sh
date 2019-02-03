#!/bin/bash
CODEDIR=$1
sudo aws s3 cp $CODEDIR/mysql-connector-java-5.1.38-bin.jar /usr/lib/sqoop/lib/

