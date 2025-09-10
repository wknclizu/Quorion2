create or replace TEMP view aggView5291321203369000482 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin4681812425416140650 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView5291321203369000482 where lineitem.l_partkey=aggView5291321203369000482.v17;
create or replace TEMP view aggView95361566290976735 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin6776112232405471676 as select v5, v6, v27 from aggJoin4681812425416140650 join aggView95361566290976735 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin6776112232405471676;
select sum(v29) from res;