create or replace TEMP view semiUp3989038268770473170 as select l_partkey as v2, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select p_partkey from part AS part) and (l_shipdate >= DATE '1995-08-31') and (l_shipdate < DATE '1995-09-30');
create or replace TEMP view semiDown8788038296678959790 as select p_partkey as v2, p_type as v21 from part AS part where (p_partkey) in (select v2 from semiUp3989038268770473170);
create or replace TEMP view aggView3951447896288455319 as select v2, CASE WHEN v21 LIKE 'PROMO%' THEN 1 ELSE 0 END as caseCond from semiDown8788038296678959790;
create or replace TEMP view aggJoin8356559826492704900 as select v6, v7, caseCond from semiUp3989038268770473170 join aggView3951447896288455319 using(v2);
create or replace TEMP view res as select ((100.0 * SUM(CASE WHEN (v21 LIKE 'PROMO%') THEN (v6 * (1 - v7)) ELSE 0.0 END) as v30) / SUM((v6 * (1 - v7))) as v30) as v30 from aggJoin8356559826492704900;
select sum(v30) / SUM((v6 * (1 - v7)))) from res;
