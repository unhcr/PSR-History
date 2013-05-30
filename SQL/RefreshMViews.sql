drop index IX_QPOCSE_YEAR;
drop index IX_QPOCSE_COU_RES;
drop index IX_QPOCSE_COU_OGN;

execute dbms_mview.refresh('QRY_ASR_POC_SUMMARY_EN');

create index IX_QPOCSE_YEAR on QRY_ASR_POC_SUMMARY_EN (ASR_YEAR);
create index IX_QPOCSE_COU_RES on QRY_ASR_POC_SUMMARY_EN (COU_CODE_RESIDENCE);
create index IX_QPOCSE_COU_OGN on QRY_ASR_POC_SUMMARY_EN (COU_CODE_ORIGIN);

drop index IX_QPOCDE_YEAR;
drop index IX_QPOCDE_COU_RES;
drop index IX_QPOCDE_COU_OGN;
drop index IX_QPOCDE_COU_PTC;

execute dbms_mview.refresh('QRY_ASR_POC_DETAILS_EN');

create index IX_QPOCDE_YEAR on QRY_ASR_POC_DETAILS_EN (ASR_YEAR);
create index IX_QPOCDE_COU_RES on QRY_ASR_POC_DETAILS_EN (COU_CODE_RESIDENCE);
create index IX_QPOCDE_COU_OGN on QRY_ASR_POC_DETAILS_EN (COU_CODE_ORIGIN);
create index IX_QPOCDE_COU_PTC on QRY_ASR_POC_DETAILS_EN (POPULATION_TYPE_CODE);

drop index IX_QDEME_YEAR;
drop index IX_QDEME_COU_RES;
drop index IX_QDEME_COU_OGN;

execute dbms_mview.refresh('QRY_ASR_DEMOGRAPHICS_EN');

create index IX_QDEME_YEAR on QRY_ASR_DEMOGRAPHICS_EN (ASR_YEAR);
create index IX_QDEME_COU_RES on QRY_ASR_DEMOGRAPHICS_EN (COU_CODE_RESIDENCE);
create index IX_QDEME_COU_OGN on QRY_ASR_DEMOGRAPHICS_EN (COU_CODE_ORIGIN);

drop index IX_QRSDE_YEAR;
drop index IX_QRSDE_COU_ASY;
drop index IX_QRSDE_COU_OGN;

execute dbms_mview.refresh('QRY_ASR_RSD_EN');

create index IX_QRSDE_YEAR on QRY_ASR_RSD_EN (ASR_YEAR);
create index IX_QRSDE_COU_ASY on QRY_ASR_RSD_EN (COU_CODE_ASYLUM);
create index IX_QRSDE_COU_OGN on QRY_ASR_RSD_EN (COU_CODE_ORIGIN);