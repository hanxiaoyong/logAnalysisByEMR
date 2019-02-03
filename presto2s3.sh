#!/bin/bash
TIME=$(date +%H%M%S)
SQOOPFILE=$1
DATE=$2
DATEE=$3
sudo presto-cli --catalog hive --schema default --execute "SELECT NULL as id, csuristem, SUM(scbytes) as totalbyte, CAST('$DATEE' AS varchar) as date FROM cloudfrontlogpart WHERE CAST(datee AS varchar) = CAST('$DATEE' AS varchar) GROUP BY csuristem order by totalbyte desc" --output-format CSV > ~/cdnfilestat.csv
aws s3 cp ~/cdnfilestat.csv $SQOOPFILE/$DATE/cdnfilestat$TIME.csv

