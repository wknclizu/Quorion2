create or replace TEMP view aggView5997044355597796457 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin621565001730791790 as select p_partkey as v17, p_brand as v20, p_container as v23, v28, v5, annot from part as part, aggView5997044355597796457 where part.p_partkey=aggView5997044355597796457.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView1721041966459617115 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin3517890040400389409 as select v20, v23, v28, v5, annot, v27 from aggJoin621565001730791790 join aggView1721041966459617115 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin3517890040400389409;
select sum(v29) from res;