    SET LINE 100
    SET SERVEROUTPUT ON
    -- Rev.2020.10.22 �������x�m�F�p
    DECLARE
        W_LOOP_COUNT  NUMBER :=0;
        W_ONE_COUNT   NUMBER :=0;
        W_TWO_COUNT   NUMBER :=0;
        W_THREE_COUNT NUMBER :=0;
        W_FOUR_COUNT  NUMBER :=0;

        -- �m������p
        -- �����i0�ȏ�1�����j�̏����_�ȉ�������(0)���A�(1)����2���T���؂Ŋm����ݒ肷��
        --�i��F50%='0'=�����_���ʂ������A25%='10'=�����_���ʂ���A���ʂ������A��100%=''�j
        W_BASE                    VARCHAR2(100);
        W_BASE_TREE               VARCHAR2(100);
        --�D��x�F(ONE > TWO > THREE > FOUR)
        W_PRIORITY_FLAG           BOOLEAN;
        --ONE�̊m���i'11111'=3.125%�j
        W_TREE_ONE     CONSTANT   VARCHAR2(100) := '11111';
        -- TWO�̊m���i'0000000'=0.78125%�j��TWO���i'000000'=1.5625%�j�ɂ��邱�Ƃ�THREE�EFOUR��0%�ɂł���
        W_TREE_TWO  CONSTANT      VARCHAR2(100) := '0000000';
        -- THREE�EFOUR�̊m���i'0000001*'=0.390625%�j
        W_TREE_THREE     CONSTANT VARCHAR2(100) := '00000010';
        W_TREE_FOUR    CONSTANT   VARCHAR2(100) := '00000011';

        -- ��L������2���T���؂��A0��1���ɕ΂�m����2�����z�ƂȂ�i�΂�̌v�Z���́A�u1�̑��� - (���� / 2)�v�j
        W_BIAS                   NUMBER :=0;
        -- ���ȉ��̊m���R�����g�͊m��100%(38���������΂�Ȃ�)�̎��̒l
        -- ONE��FOUR���̂ݎg�p����̂ł���΁A���̕��A�����⏉���΂肪�ϓ����A���ۂ̊m���͈قȂ邱�ƂɂȂ�
        W_BIAS_BEROW_ONE_COUNT   NUMBER :=0; -- ��68.6449% 1�ȉ��i�}�C�i�X�܂ށj
        W_BIAS_TWO_COUNT         NUMBER :=0; -- ��10.4705%
        W_BIAS_THREE_COUNT       NUMBER :=0; -- ��8.09086%
        W_BIAS_FOUR_COUNT        NUMBER :=0; -- ��5.62842%
        W_BIAS_FIVE_COUNT        NUMBER :=0; -- ��3.51776%
        W_BIAS_SIX_COUNT         NUMBER :=0; -- ��1.96995%
        W_BIAS_OTHER_COUNT       NUMBER :=0; -- ��1.67762% 7�ȏ�

    --=======================
    BEGIN
    --=======================

        FOR j IN 1..10000 LOOP
            W_PRIORITY_FLAG := FALSE;

            -- RANDOM�擾���͏����_�ȉ���38�ʂ܂ŏo�́i�Ōオ0���Əȗ�����Ă��܂��j
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
