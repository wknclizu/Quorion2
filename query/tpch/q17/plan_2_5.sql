create or replace TEMP view aggView5767070409180901558 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin887235598480413795 as select p_partkey as v17, p_brand as v20, p_container as v23, v27 from part as part, aggView5767070409180901558 where part.p_partkey=aggView5767070409180901558.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView3834516254992094972 as select v17, COUNT(*) as annot, v27 from aggJoin887235598480413795 group by v17,v27;
create or replace TEMP view aggJoin3189795108979289443 as select l_quantity as v5, l_extendedprice as v6, v27, annot from lineitem as lineitem, aggView3834516254992094972 where lineitem.l_partkey=aggView3834516254992094972.v17 and l_quantity>v27;
create or replace TEMP view res as select (SUM((v6)* annot) / 7.0) as v29 from aggJoin3189795108979289443;
select sum(v29) from res;