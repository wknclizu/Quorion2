create or replace TEMP view aggView7387929532791851716 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin6700045224999560027 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView7387929532791851716 where lineitem.l_partkey=aggView7387929532791851716.v17;
create or replace TEMP view aggView1758234192776146834 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin6899079672250808917 as select v5, v6, v27 from aggJoin6700045224999560027 join aggView1758234192776146834 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin6899079672250808917;
select sum(v29) from res;