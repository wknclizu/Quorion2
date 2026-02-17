create or replace TEMP view semiUp8908516482558707870 as select p_partkey as v17 from part AS part where (p_partkey) in (select l_partkey from lineitem AS lineitem where (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'))) and (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15);
create or replace TEMP view semiDown1577660868212421272 as select l_partkey as v17, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select v17 from semiUp8908516482558707870) and (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'));
create or replace TEMP view aggView8053446241013202418 as select v17, SUM(v6 * (1 - v7)) as v27, COUNT(*) as annot from semiDown1577660868212421272 group by v17;
create or replace TEMP view aggJoin2510969246362303728 as select v27 from semiUp8908516482558707870 join aggView8053446241013202418 using(v17);
create or replace TEMP view res as select SUM(v27) as v27 from aggJoin2510969246362303728;
select sum(v27) from res;
