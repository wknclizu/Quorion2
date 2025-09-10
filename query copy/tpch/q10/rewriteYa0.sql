create or replace view semiUp6714693642086752185 as select c_custkey as v1, c_name as v2, c_address as v3, c_nationkey as v4, c_phone as v5, c_acctbal as v6, c_comment as v8 from customer AS customer where (c_nationkey) in (select n_nationkey from nation AS nation);
create or replace view semiUp7102525963518450131 as select o_orderkey as v18, o_custkey as v1 from orders AS orders where (o_custkey) in (select v1 from semiUp6714693642086752185) and o_orderdate>=DATE '1993-10-01' and o_orderdate<DATE '1994-01-01';
create or replace view semiUp798781366637703055 as select l_orderkey as v18, l_extendedprice as v23, l_discount as v24 from lineitem AS lineitem where (l_orderkey) in (select v18 from semiUp7102525963518450131) and l_returnflag= 'R';
create or replace view semiDown1995597969602611748 as select v18, v1 from semiUp7102525963518450131 where (v18) in (select v18 from semiUp798781366637703055);
create or replace view semiDown8471389481081557950 as select v1, v2, v3, v4, v5, v6, v8 from semiUp6714693642086752185 where (v1) in (select v1 from semiDown1995597969602611748);
create or replace view semiDown975367866570647415 as select n_nationkey as v4, n_name as v35 from nation AS nation where (n_nationkey) in (select v4 from semiDown8471389481081557950);
create or replace view aggView8149126106861596409 as select v4, v35 from semiDown975367866570647415;
create or replace view aggJoin2682916059153640337 as select v1, v2, v3, v5, v6, v8, v35 from semiDown8471389481081557950 join aggView8149126106861596409 using(v4);
create or replace view aggView4360752537211565060 as select v1, v8, v3, v6, v35, v2, v5, COUNT(*) as annot from aggJoin2682916059153640337 group by v1,v8,v3,v6,v35,v2,v5;
create or replace view aggJoin3815053148100460071 as select v18, v1, v8, v3, v6, v35, v2, v5, annot from semiDown1995597969602611748 join aggView4360752537211565060 using(v1);
create or replace view aggView4962407609771166868 as select v18, v8, v1, v3, v6, v35, v2, v5, SUM(annot) as annot from aggJoin3815053148100460071 group by v18,v8,v1,v3,v6,v35,v2,v5;
create or replace view aggJoin1789393171142871926 as select v23, v24, v8, v1, v3, v6, v35, v2, v5, annot from semiUp798781366637703055 join aggView4962407609771166868 using(v18);
select v1, v2, SUM((v23 * (1 - v24))*annot) as v39, v6, v35, v3, v5, v8 from aggJoin1789393171142871926 group by v1, v2, v6, v5, v35, v3, v8;

