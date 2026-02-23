create or replace TEMP view aggView7761981618029069313 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35, COUNT(*) as annot from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin1984045075262641217 as select o_orderkey as v18, o_custkey as v1, o_orderdate as v13, o_shippriority as v16, v35, annot from orders as orders, aggView7761981618029069313 where orders.o_orderkey=aggView7761981618029069313.v18 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView7457824504634814912 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin29415351150308584 as select v18, v13, v16, v35 from aggJoin1984045075262641217 join aggView7457824504634814912 using(v1);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin29415351150308584 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;