create or replace TEMP view semiUp98505940599002295 as select l_partkey as v17, l_extendedprice as v6, l_discount as v7 from lineitem AS lineitem where (l_partkey) in (select p_partkey from part AS part where (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15)) and (l_quantity >= 21) and (l_shipinstruct = 'DELIVER IN PERSON') and (l_quantity <= (21 + 10)) and (l_shipmode IN ('AIR','AIR REG'));
create or replace TEMP view semiDown817604571042035102 as select p_partkey as v17 from part AS part where (p_partkey) in (select v17 from semiUp98505940599002295) and (p_brand = 'Brand#34') and (p_size >= 1) and (p_container IN ('LG CASE','LG BOX','LG PACK','LG PKG')) and (p_size <= 15);
create or replace TEMP view aggView5828402117016183290 as select v17 from semiDown817604571042035102;
create or replace TEMP view aggJoin6370530148582462773 as select v6, v7 from semiUp98505940599002295 join aggView5828402117016183290 using(v17);
create or replace TEMP view res as select SUM((v6 * (1 - v7))) as v27 from aggJoin6370530148582462773;
select sum(v27) from res;
