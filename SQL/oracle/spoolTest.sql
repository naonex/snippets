--REV.2019.10.31

SET SERVEROUTPUT ON;
SET LINESIZE 1000;
SET PAGESIZE 1000;
--フォーマット設定
SET NUMWIDTH 11;
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY/MM/DD HH24:MI:SS';

--検索対象をセット
variable target number;
execute :target := 777;


SPOOL .\log\target.log
SELECT *
  FROM TARGET_TABLE
 WHERE :target = TARGET_COLUMN
;
SPOOL off