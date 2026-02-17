create or replace TEMP view semiUp3230704275631967037 as select l_partkey as v17, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select p_partkey from part AS part where (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15)) and (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'));
create or replace TEMP view semiDown7104397495378545356 as select p_partkey as v17 from part AS part where (p_partkey) in (select v17 from semiUp3230704275631967037) and (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15);
create or replace TEMP view aggView599319707980314633 as select v17 from semiDown7104397495378545356;
create or replace TEMP view aggJoin6277308181172006222 as select v6, v7 from semiUp3230704275631967037 join aggView599319707980314633 using(v17);
create or replace TEMP view res as select SUM((v6 * (1 - v7))) as v27 from aggJoin6277308181172006222;
select sum(v27) from res;
