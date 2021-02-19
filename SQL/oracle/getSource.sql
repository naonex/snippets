-- ���^�f�[�^�o��
-- REV.2019.04.25

WHENEVER SQLERROR EXIT FAILURE ROLLBACK

set echo off
set termout off
set heading off
set pagesize 0
set linesize 10000
set trimout on
set trimspool on
set feedback off
set long 1048576
set longchunksize 1024
SET VERIFY OFF

spool &3\&1\&2..sql

--STORAGE������O
execute dbms_metadata.set_transform_param(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false);

select CASE WHEN OBJECT_TYPE = 'TABLE' THEN  --TABLESPACE���w��傾�������o���i�v���C�}���L�[���e�[�u���j
                (SUBSTR(METADATA,1,INSTR(METADATA,' PCTFREE ')) ||
                 SUBSTR(METADATA,INSTR(METADATA,' TABLESPACE ')+1,INSTR(METADATA,' SEGMENT CREATION IMMEDIATE ')-INSTR(METADATA,' TABLESPACE ')) ||
                 SUBSTR(METADATA,INSTR(METADATA,' TABLESPACE ',INSTR(METADATA,' SEGMENT CREATION IMMEDIATE '))+1)
                 )
            WHEN OBJECT_TYPE = 'INDEX' OR OBJECT_TYPE = 'MATERIALIZED_VIEW_LOG' THEN  --TABLESPACE���w��傾�������o��
                (SUBSTR(METADATA,1,INSTR(METADATA,' PCTFREE ')) ||
                 SUBSTR(METADATA,INSTR(METADATA,' TABLESPACE ')+1)
                 )
            ELSE METADATA 
       END as OUTPUT_LINE
from (select dbms_metadata.get_ddl('&1','&2') as METADATA ,'&1' as OBJECT_TYPE from dual);

spool off

EXIT