create or replace TEMP view aggView2144105497318514421 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin3027131766725859793 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView2144105497318514421 where lineitem.l_partkey=aggView2144105497318514421.v17;
create or replace TEMP view aggView3602464327571396165 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin7787907321548659282 as select v5, v6, v27 from aggJoin3027131766725859793 join aggView3602464327571396165 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin7787907321548659282;
select sum(v29) from res;