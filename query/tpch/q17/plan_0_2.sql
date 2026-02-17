create or replace TEMP view aggView4879175119930666 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin297908901903411483 as select p_partkey as v17, p_brand as v20, p_container as v23, v28, v5, annot from part as part, aggView4879175119930666 where part.p_partkey=aggView4879175119930666.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView8925133538335873318 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin2629137903964802341 as select v20, v23, v28, v5, annot, v27 from aggJoin297908901903411483 join aggView8925133538335873318 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin2629137903964802341;
select sum(v29) from res;