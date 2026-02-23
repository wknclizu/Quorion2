create or replace TEMP view aggView3937465466721551434 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin656826041179110321 as select v1_partkey as v17, v1_quantity_avg as v27, v28, v5, annot from q17_inner as q17_inner, aggView3937465466721551434 where q17_inner.v1_partkey=aggView3937465466721551434.v17 and v5>v1_quantity_avg;
create or replace TEMP view aggView7567561047769506292 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin3960930717465188759 as select v27, v28, v5, annot from aggJoin656826041179110321 join aggView7567561047769506292 using(v17);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin3960930717465188759;
select sum(v29) from res;