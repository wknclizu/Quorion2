create or replace TEMP view aggView7314132885504704083 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin6381145308248832882 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView7314132885504704083 where lineitem.l_partkey=aggView7314132885504704083.v17;
create or replace TEMP view aggView8591728417464756834 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin2623092411997259421 as select v5, v6, v27 from aggJoin6381145308248832882 join aggView8591728417464756834 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin2623092411997259421;
select sum(v29) from res;