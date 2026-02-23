create or replace TEMP view semiUp8087712013145869943 as select l_partkey as v2, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select p_partkey from part AS part) and (l_shipdate >= DATE '1995-08-31') and (l_shipdate < DATE '1995-09-30');
create or replace TEMP view semiDown7393980764345025695 as select p_partkey as v2, p_type as v21 from part AS part where (p_partkey) in (select v2 from semiUp8087712013145869943);
create or replace TEMP view aggView3813396832264891927 as select v2, CASE WHEN v21 LIKE 'PROMO%' THEN 1 ELSE 0 END as caseCond from semiDown7393980764345025695;
create or replace TEMP view aggJoin9011943332872977417 as select v6, v7, caseCond from semiUp8087712013145869943 join aggView3813396832264891927 using(v2);
create or replace TEMP view res as select ((100.0 * SUM(CASE WHEN (v21 LIKE 'PROMO%') THEN (v6 * (1 - v7)) ELSE 0.0 END) as v30) / SUM((v6 * (1 - v7))) as v30) as v30 from aggJoin9011943332872977417;
select sum(v30) / SUM((v6 * (1 - v7)))) from res;
