create or replace TEMP view aggView5163373152890668204 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin2534174697803811296 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView5163373152890668204 where lineitem.l_partkey=aggView5163373152890668204.v17;
create or replace TEMP view aggView7126426459209709136 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin6272345427622566552 as select v5, v6, v27 from aggJoin2534174697803811296 join aggView7126426459209709136 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin6272345427622566552;
select sum(v29) from res;