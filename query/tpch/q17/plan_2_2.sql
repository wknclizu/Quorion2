create or replace TEMP view aggView530212516838285742 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin2581207899014485985 as select v1_partkey as v17, v1_quantity_avg as v27, v28, v5, annot from q17_inner as q17_inner, aggView530212516838285742 where q17_inner.v1_partkey=aggView530212516838285742.v17 and v5>v1_quantity_avg;
create or replace TEMP view aggView4650405790458227786 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin2913223173718842061 as select v27, v28, v5, annot from aggJoin2581207899014485985 join aggView4650405790458227786 using(v17);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin2913223173718842061;
select sum(v29) from res;