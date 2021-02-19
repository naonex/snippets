--Rev.2021.02.19

--フラグ[ON=1,OFF=0,ERROR=9]
--（CASE :flg WHEN 1 THEN `ON` WHEN 0 THEN `OFF` ELSE `ERROR` END ~ WHERE :flg in (1,0)）
variable flg number;
declare
    W_FLG         NUMBER;
    W_ON          NUMBER := 777;
    W_OFF         NUMBER := 666;
begin
    SELECT TARGET_VALUE INTO W_FLG FROM TARGET_TABLE WHERE KEY = 555;

    CASE W_FLG WHEN W_ON  THEN :flg := 1;
               WHEN W_OFF THEN :flg := 0;
               ELSE            :flg := 9;
    END CASE;
end;
/
print :flg;

UPDATE TARGET_TABLE_2
   SET TARGET_VALUE_2 = CASE :flg WHEN 1 THEN 'TARGET_VALUE is ON' WHEN 0 THEN 'TARGET_VALUE is OFF' ELSE 'TARGET_VALUE is ERROR' END
 WHERE :flg in (1,0);
