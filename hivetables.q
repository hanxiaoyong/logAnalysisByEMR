CREATE TABLE IF NOT EXISTS cloudfrontlogpart ( 
time STRING, xedgelocation STRING, scbytes  INT, cip STRING, csmethod STRING, csHost STRING, csuristem STRING, scstatus INT, csReferer STRING, csUserAgent STRING, csuriquery STRING, csCookie STRING, xedgeresulttype STRING, xedgerequestid STRING, xhostheader STRING, csprotocol STRING, csbytes STRING, timetaken STRING, xforwardedfor STRING, sslprotocol STRING, sslcipher STRING, xedgeresponseresulttype STRING
)
PARTITIONED BY (datee Date)
LOCATION '${PARTDIRh}';

CREATE EXTERNAL TABLE IF NOT EXISTS cloudfrontlog${DATEh} (
date1 Date, time STRING, xedgelocation STRING, scbytes  INT, cip STRING, csmethod STRING, csHost STRING, csuristem STRING, scstatus INT, csReferer STRING, csUserAgent STRING, csuriquery STRING, csCookie STRING, xedgeresulttype STRING, xedgerequestid STRING, xhostheader STRING, csprotocol STRING, csbytes STRING, timetaken STRING, xforwardedfor STRING, sslprotocol STRING, sslcipher STRING, xedgeresponseresulttype STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LOCATION '${STAGINGDIRh}/${DATEh}/' 
tblproperties("skip.header.line.count"="2");

--make dynamic insert available
set hive.exec.dynamic.partition.mode=nonstrict;

--insert into talbe.
INSERT INTO TABLE cloudfrontlogpart PARTITION (datee)
SELECT  time, xedgelocation, scbytes, cip, csmethod, csHost, csuristem, scstatus, csReferer, csUserAgent, csuriquery, csCookie, xedgeresulttype, xedgerequestid, xhostheader, csprotocol, csbytes, timetaken, xforwardedfor, sslprotocol, sslcipher, xedgeresponseresulttype, date1 
FROM cloudfrontlog${DATEh};

--delete the staging table
DROP TABLE cloudfrontlog${DATEh};

