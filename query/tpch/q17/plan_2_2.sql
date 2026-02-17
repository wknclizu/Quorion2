create or replace TEMP view aggView7828076333893393412 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin5671845716676492953 as select v1_partkey as v17, v1_quantity_avg as v27, v28, v5, annot from q17_inner as q17_inner, aggView7828076333893393412 where q17_inner.v1_partkey=aggView7828076333893393412.v17 and v5>v1_quantity_avg;
create or replace TEMP view aggView4577303792341188566 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin4773928089823484626 as select v27, v28, v5, annot from aggJoin5671845716676492953 join aggView4577303792341188566 using(v17);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin4773928089823484626;
select sum(v29) from res;