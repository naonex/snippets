    SET LINE 100
    SET SERVEROUTPUT ON
    -- Rev.2020.10.22 乱数精度確認用
    DECLARE
        W_LOOP_COUNT  NUMBER :=0;
        W_ONE_COUNT   NUMBER :=0;
        W_TWO_COUNT   NUMBER :=0;
        W_THREE_COUNT NUMBER :=0;
        W_FOUR_COUNT  NUMBER :=0;

        -- 確率判定用
        -- 乱数（0以上1未満）の小数点以下が偶数(0)か、奇数(1)かの2分探索木で確率を設定する
        --（例：50%='0'=小数点第一位が偶数、25%='10'=小数点第一位が奇数、第二位が偶数、※100%=''）
        W_BASE                    VARCHAR2(100);
        W_BASE_TREE               VARCHAR2(100);
        --優先度：(ONE > TWO > THREE > FOUR)
        W_PRIORITY_FLAG           BOOLEAN;
        --ONEの確率（'11111'=3.125%）
        W_TREE_ONE     CONSTANT   VARCHAR2(100) := '11111';
        -- TWOの確率（'0000000'=0.78125%）※TWOを（'000000'=1.5625%）にすることでTHREE・FOURを0%にできる
        W_TREE_TWO  CONSTANT      VARCHAR2(100) := '0000000';
        -- THREE・FOURの確率（'0000001*'=0.390625%）
        W_TREE_THREE     CONSTANT VARCHAR2(100) := '00000010';
        W_TREE_FOUR    CONSTANT   VARCHAR2(100) := '00000011';

        -- 上記乱数の2分探索木が、0か1かに偏る確率は2項分布となる（偏りの計算式は、「1の総数 - (総数 / 2)」）
        W_BIAS                   NUMBER :=0;
        -- ※以下の確率コメントは確率100%(38桁かつ初期偏りなし)の時の値
        -- ONEやFOUR時のみ使用するのであれば、その分、桁数や初期偏りが変動し、実際の確率は異なることになる
        W_BIAS_BEROW_ONE_COUNT   NUMBER :=0; -- 約68.6449% 1以下（マイナス含む）
        W_BIAS_TWO_COUNT         NUMBER :=0; -- 約10.4705%
        W_BIAS_THREE_COUNT       NUMBER :=0; -- 約8.09086%
        W_BIAS_FOUR_COUNT        NUMBER :=0; -- 約5.62842%
        W_BIAS_FIVE_COUNT        NUMBER :=0; -- 約3.51776%
        W_BIAS_SIX_COUNT         NUMBER :=0; -- 約1.96995%
        W_BIAS_OTHER_COUNT       NUMBER :=0; -- 約1.67762% 7以上

    --=======================
    BEGIN
    --=======================

        FOR j IN 1..10000 LOOP
            W_PRIORITY_FLAG := FALSE;

            -- RANDOM取得時は小数点以下第38位まで出力（最後が0だと省略されてしまう）
            SELECT base, tree , TRUNC(tree_reg - (tree_len / 2)) AS bias INTO W_BASE, W_BASE_TREE, W_BIAS FROM (
                SELECT base, tree, LENGTH(tree) AS tree_len, REGEXP_COUNT(tree,'1') AS tree_reg FROM (
                    SELECT base ,SUBSTR(TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(base,2,0),3,1),4,0),5,1),6,0),7,1),8,0),9,1),3) AS tree
                      FROM (SELECT TO_CHAR(DBMS_RANDOM.VALUE,'.00000000000000000000000000000000000000') AS base FROM DUAL)
                )
            );
            --DBMS_OUTPUT.PUT_LINE(W_BASE || ',' || W_BASE_TREE || ',' || W_BIAS);
            W_LOOP_COUNT := W_LOOP_COUNT + 1;
            
            IF NOT(W_PRIORITY_FLAG) AND W_BASE_TREE LIKE W_TREE_ONE || '%' THEN
                --DBMS_OUTPUT.PUT_LINE(W_TREE_ONE || '%');
                W_ONE_COUNT := W_ONE_COUNT + 1;
                W_PRIORITY_FLAG := TRUE;
            END IF;
            IF NOT(W_PRIORITY_FLAG) AND W_BASE_TREE LIKE W_TREE_TWO || '%' THEN
                --DBMS_OUTPUT.PUT_LINE(W_TREE_TWO || '%');
                W_TWO_COUNT := W_TWO_COUNT + 1;
                W_PRIORITY_FLAG := TRUE;
            END IF;
            IF NOT(W_PRIORITY_FLAG) AND W_BASE_TREE LIKE W_TREE_THREE || '%' THEN
                --DBMS_OUTPUT.PUT_LINE(W_TREE_THREE || '%');
                W_THREE_COUNT := W_THREE_COUNT + 1;
                W_PRIORITY_FLAG := TRUE;
            END IF;
            IF NOT(W_PRIORITY_FLAG) AND W_BASE_TREE LIKE W_TREE_FOUR || '%' THEN
                --DBMS_OUTPUT.PUT_LINE(W_TREE_FOUR || '%');
                W_FOUR_COUNT := W_FOUR_COUNT + 1;
                W_PRIORITY_FLAG := TRUE;
            END IF;

            IF W_BIAS <= 1 THEN
                W_BIAS_BEROW_ONE_COUNT := W_BIAS_BEROW_ONE_COUNT + 1;
            ELSIF W_BIAS = 2 THEN
                W_BIAS_TWO_COUNT := W_BIAS_TWO_COUNT + 1;
            ELSIF W_BIAS = 3 THEN
                W_BIAS_THREE_COUNT := W_BIAS_THREE_COUNT + 1;
            ELSIF W_BIAS = 4 THEN
                W_BIAS_FOUR_COUNT := W_BIAS_FOUR_COUNT + 1;
            ELSIF W_BIAS = 5 THEN
                W_BIAS_FIVE_COUNT := W_BIAS_FIVE_COUNT + 1; 
            ELSIF W_BIAS = 6 THEN
                W_BIAS_SIX_COUNT := W_BIAS_SIX_COUNT + 1;
            ELSE
                W_BIAS_OTHER_COUNT := W_BIAS_OTHER_COUNT + 1;
            END IF;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE('W_LOOP_COUNT :' || W_LOOP_COUNT );
        DBMS_OUTPUT.PUT_LINE('W_ONE_COUNT  :' || W_ONE_COUNT  );
        DBMS_OUTPUT.PUT_LINE('W_TWO_COUNT  :' || W_TWO_COUNT  );
        DBMS_OUTPUT.PUT_LINE('W_THREE_COUNT:' || W_THREE_COUNT);
        DBMS_OUTPUT.PUT_LINE('W_FOUR_COUNT :' || W_FOUR_COUNT );

        DBMS_OUTPUT.PUT_LINE('W_BIAS_BEROW_ONE_COUNT : ' || W_BIAS_BEROW_ONE_COUNT);
        DBMS_OUTPUT.PUT_LINE('W_BIAS_TWO_COUNT       : ' || W_BIAS_TWO_COUNT      );
        DBMS_OUTPUT.PUT_LINE('W_BIAS_THREE_COUNT     : ' || W_BIAS_THREE_COUNT    );
        DBMS_OUTPUT.PUT_LINE('W_BIAS_FOUR_COUNT      : ' || W_BIAS_FOUR_COUNT     );
        DBMS_OUTPUT.PUT_LINE('W_BIAS_FIVE_COUNT      : ' || W_BIAS_FIVE_COUNT     );
        DBMS_OUTPUT.PUT_LINE('W_BIAS_SIX_COUNT       : ' || W_BIAS_SIX_COUNT      );
        DBMS_OUTPUT.PUT_LINE('W_BIAS_OTHER_COUNT     : ' || W_BIAS_OTHER_COUNT    );

    END;
/
exit
