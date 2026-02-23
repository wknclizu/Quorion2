create or replace TEMP view semiUp3304895222936516813 as select p_partkey as v2, p_type as v21 from part AS part where (p_partkey) in (select l_partkey from lineitem AS lineitem where (l_shipdate >= DATE '1995-08-31') and (l_shipdate < DATE '1995-09-30'));
create or replace TEMP view semiDown2194053817846721454 as select l_partkey as v2, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select v2 from semiUp3304895222936516813) and (l_shipdate >= DATE '1995-08-31') and (l_shipdate < DATE '1995-09-30');
create or replace TEMP view aggView3471019430450067177 as select v2, v6 * (1 - v7) as caseRes, SUM(v6 * (1 - v7)) as v29, COUNT(*) as annot from semiDown2194053817846721454 group by v2,caseRes;
create or replace TEMP view aggJoin540415167615706802 as select v21, caseRes, v29, annot from semiUp3304895222936516813 join aggView3471019430450067177 using(v2);
create or replace TEMP view res as select ((100.0 * SUM(CASE WHEN (v21 LIKE 'PROMO%') THEN (v6 * (1 - v7)) ELSE 0.0 END*annot) as v30) / SUM(v30) as ) as v30 from aggJoin540415167615706802;
select sum(v30) / SUM(v30)) from res;
