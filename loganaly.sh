#!/bin/bash
KEYNAME=YourSShKeyName
CONFIGFILE=https://s3-us-west-2.amazonaws.com/testcloudfrontlog/conf/emrconf.json
LOGURI=s3://testcloudfrontlog/emrlog/
CODEDIR=s3://testcloudfrontlog/conf
LOGSOURCEDIR=s3://testcloudfrontlog/log
STAGINGDIR=s3://testcloudfrontlog/logbydate
#DATE=$(date -d "yesterday" +%Y%m%d)
DATE=20160712
#DATEE=$(date -d "yesterday" +%Y-%m-%d)
DATEE=2016-07-12
PARTDIR=s3://testcloudfrontlog/logpart
SQOOPFILE=s3://testcloudfrontlog/sqoopfile
DBHOST=your.db.ip.address
JDBCURL=jdbc:mysql://your.db.ip.address/loganalydb
DBUSER=yourUserName
DBPASS=yourPassword
AWSREGION=us-west-2
MASTERTYPE=m3.xlarge
CORETYPE=m3.xlarge
TASKTYPE=m3.xlarge
MASTERNUM=1
CORENUM=1
TASKNUM=1
PRICE=0.4
aws s3 rm $PARTDIR/datee=$DATEE --recursive
aws s3 rm $SQOOPFILE/$DATE --recursive
mysql -h$DBHOST -u$DBUSER -p$DBPASS --execute "DELETE FROM loganalydb.loganalytb WHERE tdate='$DATEE'"


aws --region $AWSREGION emr create-cluster --name "loganaly" --release-label emr-5.20.0 \
--applications Name=Hadoop Name=Hive Name=Presto Name=Sqoop \
--use-default-roles \
--ec2-attributes KeyName=$KEYNAME \
--termination-protected \
--auto-terminate \
--configurations $CONFIGFILE \
--enable-debugging \
--log-uri $LOGURI \
--steps \
Type=CUSTOM_JAR,Name="cpjar",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/cpjar.sh"," $CODEDIR"] \
Type=CUSTOM_JAR,Name="log2staging",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/log2logbydate.sh","$LOGSOURCEDIR","$STAGINGDIR","$DATE","$DATEE"] \
Type=Hive,Name="HiveStep",Args=[-f,$CODEDIR/hivetables.q,-d,PARTDIRh=$PARTDIR,-d,STAGINGDIRh=$STAGINGDIR,-d,DATEh=$DATE] \
Type=CUSTOM_JAR,Name="Presto2s3",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/presto2s3.sh","$SQOOPFILE","$DATE","$DATEE"] \
Type=CUSTOM_JAR,Name="s3tomysql",Jar=$CODEDIR/script-runner.jar,Args=["$CODEDIR/s3tomysql.sh","$JDBCURL","$DBUSER","$DBPASS","$SQOOPFILE","$DATE"] \
--instance-groups \
Name=Master,InstanceGroupType=MASTER,InstanceType=$MASTERTYPE,BidPrice=$PRICE,InstanceCount=$MASTERNUM \
Name=Core,InstanceGroupType=CORE,InstanceType=$CORETYPE,BidPrice=$PRICE,InstanceCount=$CORENUM \
Name=Task,InstanceGroupType=TASK,InstanceType=$TASKTYPE,BidPrice=$PRICE,InstanceCount=$TASKNUM

