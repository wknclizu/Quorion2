create or replace TEMP view aggView6965308852774426843 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin1227000263594489194 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView6965308852774426843 where lineitem.l_partkey=aggView6965308852774426843.v17;
create or replace TEMP view aggView7322353698305734974 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin4006158170721746893 as select v5, v6, v27 from aggJoin1227000263594489194 join aggView7322353698305734974 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin4006158170721746893;
select sum(v29) from res;