create or replace TEMP view aggView8763096220696969622 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin6560227653016923334 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView8763096220696969622 where lineitem.l_partkey=aggView8763096220696969622.v17;
create or replace TEMP view aggView666070696114380499 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin6522638048532777810 as select v5, v6, v27 from aggJoin6560227653016923334 join aggView666070696114380499 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin6522638048532777810;
select sum(v29) from res;