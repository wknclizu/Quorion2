create or replace TEMP view aggView3094153895455100637 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin9081763081914960214 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView3094153895455100637 where lineitem.l_partkey=aggView3094153895455100637.v17;
create or replace TEMP view aggView6813138031638221138 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin6697152150646143525 as select v5, v6, v27 from aggJoin9081763081914960214 join aggView6813138031638221138 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin6697152150646143525;
select sum(v29) from res;