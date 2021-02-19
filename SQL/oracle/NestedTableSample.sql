-- NestedTableSample
-- Rev.2020.04.08

SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 1000;

DECLARE

    --日時取得カーソル
    CURSOR CUR_DATETIME IS
    SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS') AS DATETIME FROM DUAL;

    ---------------------------
    -- ■□    変 数    □■ --
    ---------------------------
    W_PROGRAMID           VARCHAR2(30) := 'NestedTableSample';            -- プログラムID
    W_MACHINENAME         VARCHAR2(30) := SYS_CONTEXT('USERENV','HOST');  -- マシン名

    -- ログ出力
    W_STARTTIME           VARCHAR2(26);          -- 開始時間
    W_ENDTIME             VARCHAR2(26);          -- 終了時間
    
    W_RET                 PLS_INTEGER;           -- 処理結果
    W_ERRMSGNO            NUMBER;                -- エラーメッセージNO

    W_LAST_DDL_TIME       VARCHAR2(26);          -- オブジェクトの最終更新日時

    --結合テーブル配列
    TYPE ARRAY IS TABLE OF VARCHAR2(30);
    TARGET_TABLES ARRAY
        := ARRAY(
            --Targets1
            'Target11',
            'Target12',
            --Targets2
            'Target21',
            'Target22'
        );

BEGIN

    FOR REC IN CUR_DATETIME LOOP W_STARTTIME := REC.DATETIME; END LOOP;
    DBMS_OUTPUT.PUT_LINE('【StartTime_DB】' || W_STARTTIME);
    DBMS_OUTPUT.NEW_LINE;

    DBMS_OUTPUT.PUT_LINE('【Before_LAST_DDL_TIME】');
	FOR i IN TARGET_TABLES.first..TARGET_TABLES.last LOOP
        EXECUTE IMMEDIATE 'SELECT TO_CHAR(LAST_DDL_TIME,''YYYY/MM/DD HH24:MI:SS'') 
                             FROM USER_OBJECTS 
                            WHERE OBJECT_NAME = ''' || TARGET_TABLES(i) || ''''
                             INTO W_LAST_DDL_TIME;
    	DBMS_OUTPUT.PUT_LINE(TARGET_TABLES(i) || '：' || W_LAST_DDL_TIME);
	END LOOP;

    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Executing ALTER...');
	FOR i IN TARGET_TABLES.first..TARGET_TABLES.last LOOP
        EXECUTE IMMEDIATE 'ALTER INDEX ' || TARGET_TABLES(i) || ' REBUILD';
	END LOOP;
    DBMS_OUTPUT.NEW_LINE;

    DBMS_OUTPUT.PUT_LINE('【After_LAST_DDL_TIME】');
	FOR i IN TARGET_TABLES.first..TARGET_TABLES.last LOOP
        EXECUTE IMMEDIATE 'SELECT TO_CHAR(LAST_DDL_TIME,''YYYY/MM/DD HH24:MI:SS'') 
                             FROM USER_OBJECTS 
                            WHERE OBJECT_NAME = ''' || TARGET_TABLES(i) || ''''
                             INTO W_LAST_DDL_TIME;
    	DBMS_OUTPUT.PUT_LINE(TARGET_TABLES(i) || '：' || W_LAST_DDL_TIME);
	END LOOP;

    FOR REC IN CUR_DATETIME LOOP W_ENDTIME := REC.DATETIME; END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('【EndTime_DB】' || W_ENDTIME);

    COMMIT;

-----------------------------------------------------------
EXCEPTION   --エラー
-----------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;

END;
/
EXIT
