-- NestedTableSample2
-- Rev.2021.04.16

declare
    
    --テーブル列型も可能
    TYPE ARRAY IS TABLE OF TEST_TABLE%ROWTYPE;
    
    TARGET_TABLES ARRAY;
    TEST_TABLE_1 TEST_TABLE%ROWTYPE;
    TEST_TABLE_2 TEST_TABLE%ROWTYPE;
    
    PROCEDURE testProc(i_array IN ARRAY)
    IS
    BEGIN
        FOR i IN i_array.first..i_array.last LOOP
            DBMS_OUTPUT.PUT_LINE(i_array(i).TESTNAME);
        END LOOP;
    END testProc;
    
begin
    
    select * into TEST_TABLE_1 from TEST_TABLE where TESTCD = 1;
    select * into TEST_TABLE_2 from TEST_TABLE where TESTCD = 2;
    
    testProc(ARRAY(TEST_TABLE_1,TEST_TABLE_2));
    /*
    TARGET_TABLES := ARRAY(TEST_TABLE_1,TEST_TABLE_2);
    FOR i IN TARGET_TABLES.first..TARGET_TABLES.last LOOP
        DBMS_OUTPUT.PUT_LINE(TARGET_TABLES(i).TESTNAME);
    END LOOP;
    */
end;
