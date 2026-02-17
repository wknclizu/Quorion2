create or replace TEMP view aggView8170264877390264824 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin1831850740006679611 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView8170264877390264824 where orders.o_custkey=aggView8170264877390264824.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView2134460372807318465 as select v16, v13, v18, COUNT(*) as annot from aggJoin1831850740006679611 group by v16,v13,v18;
create or replace TEMP view aggView7725783257328090074 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35 from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin5457952952876005858 as select v16, v13, v18, v35 * aggView2134460372807318465.annot as v35 from aggView2134460372807318465 join aggView7725783257328090074 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin5457952952876005858 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;