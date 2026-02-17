create or replace TEMP view semiUp6270770993454161427 as select p_partkey as v17 from part AS part where (p_partkey) in (select l_partkey from lineitem AS lineitem where (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'))) and (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15);
create or replace TEMP view semiDown615132580888780872 as select l_partkey as v17, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select v17 from semiUp6270770993454161427) and (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'));
create or replace TEMP view aggView4695759093724663012 as select v17, SUM(v6 * (1 - v7)) as v27, COUNT(*) as annot from semiDown615132580888780872 group by v17;
create or replace TEMP view aggJoin7955951957661121319 as select v27 from semiUp6270770993454161427 join aggView4695759093724663012 using(v17);
create or replace TEMP view res as select SUM(v27) as v27 from aggJoin7955951957661121319;
select sum(v27) from res;
