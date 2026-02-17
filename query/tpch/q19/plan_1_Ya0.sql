create or replace TEMP view semiUp803574689547678609 as select p_partkey as v17 from part AS part where (p_partkey) in (select l_partkey from lineitem AS lineitem where (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'))) and (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15);
create or replace TEMP view semiDown473423550914465298 as select l_partkey as v17, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select v17 from semiUp803574689547678609) and (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'));
create or replace TEMP view aggView4002601881950910637 as select v17, SUM(v6 * (1 - v7)) as v27, COUNT(*) as annot from semiDown473423550914465298 group by v17;
create or replace TEMP view aggJoin6497575527438612874 as select v27 from semiUp803574689547678609 join aggView4002601881950910637 using(v17);
create or replace TEMP view res as select SUM(v27) as v27 from aggJoin6497575527438612874;
select sum(v27) from res;
