drop index IX_QPOCSE_YEAR;
drop index IX_QPOCSE_LOC_ASY;
drop index IX_QPOCSE_LOC_ORG;

execute dbms_mview.refresh('QRY_ASR_POC_SUMMARY_EN');

create index IX_QPOCSE_YEAR on QRY_ASR_POC_SUMMARY_EN (ASR_YEAR);
create index IX_QPOCSE_LOC_ASY on QRY_ASR_POC_SUMMARY_EN (LOC_ID_ASYLUM_COUNTRY);
create index IX_QPOCSE_LOC_ORG on QRY_ASR_POC_SUMMARY_EN (LOC_ID_ORIGIN_COUNTRY);

drop index IX_QPOCDE_YEAR;
drop index IX_QPOCDE_LOC_ASY;
drop index IX_QPOCDE_LOC_OGN;

execute dbms_mview.refresh('QRY_ASR_POC_DETAILS_EN');

create index IX_QPOCDE_YEAR on QRY_ASR_POC_DETAILS_EN (ASR_YEAR);
create index IX_QPOCDE_LOC_ASY on QRY_ASR_POC_DETAILS_EN (LOC_ID_ASYLUM_COUNTRY);
create index IX_QPOCDE_LOC_OGN on QRY_ASR_POC_DETAILS_EN (LOC_ID_ORIGIN_COUNTRY);

drop index IX_QDEME_YEAR;
drop index IX_QDEME_LOC_ASY;

execute dbms_mview.refresh('QRY_ASR_DEMOGRAPHICS_EN');

create index IX_QDEME_YEAR on QRY_ASR_DEMOGRAPHICS_EN (ASR_YEAR);
create index IX_QDEME_LOC_ASY on QRY_ASR_DEMOGRAPHICS_EN (LOC_ID_ASYLUM_COUNTRY);

drop index IX_QRSDE_YEAR;
drop index IX_QRSDE_LOC_ASY;
drop index IX_QRSDE_LOC_OGN;

execute dbms_mview.refresh('QRY_ASR_RSD_EN');

create index IX_QRSDE_YEAR on QRY_ASR_RSD_EN (ASR_YEAR);
create index IX_QRSDE_LOC_ASY on QRY_ASR_RSD_EN (LOC_ID_ASYLUM_COUNTRY);
create index IX_QRSDE_LOC_OGN on QRY_ASR_RSD_EN (LOC_ID_ORIGIN_COUNTRY);