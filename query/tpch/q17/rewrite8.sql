create or replace TEMP view aggView5899598334416251927 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin5544834985375085525 as select p_partkey as v17, p_brand as v20, p_container as v23, v28, v5, annot from part as part, aggView5899598334416251927 where part.p_partkey=aggView5899598334416251927.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView389855738467392727 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin1769610672334516343 as select v20, v23, v28, v5, annot, v27 from aggJoin5544834985375085525 join aggView389855738467392727 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin1769610672334516343;
select sum(v29) from res;