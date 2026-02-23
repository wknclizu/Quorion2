create or replace TEMP view semiUp6454609126201463101 as select l_partkey as v2, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select p_partkey from part AS part) and (l_shipdate >= DATE '1995-08-31') and (l_shipdate < DATE '1995-09-30');
create or replace TEMP view semiDown4423427601796714178 as select p_partkey as v2, p_type as v21 from part AS part where (p_partkey) in (select v2 from semiUp6454609126201463101);
create or replace TEMP view aggView1164677209991518981 as select v2, CASE WHEN v21 LIKE 'PROMO%' THEN 1 ELSE 0 END as caseCond from semiDown4423427601796714178;
create or replace TEMP view aggJoin4024913551823473498 as select v6, v7, caseCond from semiUp6454609126201463101 join aggView1164677209991518981 using(v2);
create or replace TEMP view res as select ((100.0 * SUM(CASE WHEN (v21 LIKE 'PROMO%') THEN (v6 * (1 - v7)) ELSE 0.0 END) as v30) / SUM((v6 * (1 - v7))) as v30) as v30 from aggJoin4024913551823473498;
select sum(v30) / SUM((v6 * (1 - v7)))) from res;
