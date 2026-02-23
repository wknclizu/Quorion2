create or replace TEMP view semiUp1345284801420347650 as select p_partkey as v2, p_type as v21 from part AS part where (p_partkey) in (select l_partkey from lineitem AS lineitem where (l_shipdate >= DATE '1995-08-31') and (l_shipdate < DATE '1995-09-30'));
create or replace TEMP view semiDown4317613266369443548 as select l_partkey as v2, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select v2 from semiUp1345284801420347650) and (l_shipdate >= DATE '1995-08-31') and (l_shipdate < DATE '1995-09-30');
create or replace TEMP view aggView1085877253242376255 as select v2, v6 * (1 - v7) as caseRes, SUM(v6 * (1 - v7)) as v29, COUNT(*) as annot from semiDown4317613266369443548 group by v2,caseRes;
create or replace TEMP view aggJoin1717551338788896273 as select v21, caseRes, v29, annot from semiUp1345284801420347650 join aggView1085877253242376255 using(v2);
create or replace TEMP view res as select ((100.0 * SUM(CASE WHEN (v21 LIKE 'PROMO%') THEN (v6 * (1 - v7)) ELSE 0.0 END*annot) as v30) / SUM(v30) as ) as v30 from aggJoin1717551338788896273;
select sum(v30) / SUM(v30)) from res;
