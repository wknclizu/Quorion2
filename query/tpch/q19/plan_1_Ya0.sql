create or replace TEMP view semiUp198850049626106524 as select l_partkey as v17, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select p_partkey from part AS part where (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15)) and (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'));
create or replace TEMP view semiDown3647816476816364901 as select p_partkey as v17 from part AS part where (p_partkey) in (select v17 from semiUp198850049626106524) and (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15);
create or replace TEMP view aggView59556629871414364 as select v17 from semiDown3647816476816364901;
create or replace TEMP view aggJoin3171072997079735978 as select v6, v7 from semiUp198850049626106524 join aggView59556629871414364 using(v17);
create or replace TEMP view res as select SUM((v6 * (1 - v7))) as v27 from aggJoin3171072997079735978;
select sum(v27) from res;
