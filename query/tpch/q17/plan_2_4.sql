create or replace TEMP view aggView2431080029542225585 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin6054214298652220927 as select p_partkey as v17, p_brand as v20, p_container as v23, v27 from part as part, aggView2431080029542225585 where part.p_partkey=aggView2431080029542225585.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView2425273278329904811 as select v17, COUNT(*) as annot, v27 from aggJoin6054214298652220927 group by v17,v27;
create or replace TEMP view aggJoin5052381746863493491 as select l_quantity as v5, l_extendedprice as v6, v27, annot from lineitem as lineitem, aggView2425273278329904811 where lineitem.l_partkey=aggView2425273278329904811.v17 and l_quantity>v27;
create or replace TEMP view res as select (SUM((v6)* annot) / 7.0) as v29 from aggJoin5052381746863493491;
select sum(v29) from res;