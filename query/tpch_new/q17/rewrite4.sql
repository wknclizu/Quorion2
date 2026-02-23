create or replace TEMP view aggView1941119144337669762 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin5057711506241195899 as select p_partkey as v17, p_brand as v20, p_container as v23, v28, v5, annot from part as part, aggView1941119144337669762 where part.p_partkey=aggView1941119144337669762.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView837722605336667585 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin6294472702550442241 as select v20, v23, v28, v5, annot, v27 from aggJoin5057711506241195899 join aggView837722605336667585 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin6294472702550442241;
select sum(v29) from res;