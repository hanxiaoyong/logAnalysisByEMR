#!/bin/bash
JDBCURL=$1
DBUSER=$2
DBPASS=$3
SQOOPFILE=$4
DATE=$5
sqoop export --connect $JDBCURL --username $DBUSER --password $DBPASS --table loganalytb --fields-terminated-by ',' --enclosed-by '\"' --export-dir $SQOOPFILE/$DATE/

