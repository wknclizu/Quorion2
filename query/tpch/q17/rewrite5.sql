create or replace TEMP view aggView6226370328659649469 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin6732508328511727731 as select v1_partkey as v17, v1_quantity_avg as v27, v28, v5, annot from q17_inner as q17_inner, aggView6226370328659649469 where q17_inner.v1_partkey=aggView6226370328659649469.v17 and v5>v1_quantity_avg;
create or replace TEMP view aggView5027329607645386372 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin6590265497334603199 as select v27, v28, v5, annot from aggJoin6732508328511727731 join aggView5027329607645386372 using(v17);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin6590265497334603199;
select sum(v29) from res;