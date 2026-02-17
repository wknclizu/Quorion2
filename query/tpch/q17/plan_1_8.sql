create or replace TEMP view aggView2134224688268979908 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin5246832268172894387 as select p_partkey as v17, p_brand as v20, p_container as v23, v28, v5, annot from part as part, aggView2134224688268979908 where part.p_partkey=aggView2134224688268979908.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView8515942655705773085 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin378436210129200511 as select v20, v23, v28, v5, annot, v27 from aggJoin5246832268172894387 join aggView8515942655705773085 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin378436210129200511;
select sum(v29) from res;