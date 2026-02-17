create or replace TEMP view aggView4122537308892931192 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin9182377285292619133 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView4122537308892931192 where orders.o_custkey=aggView4122537308892931192.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView3968051097838734229 as select v16, v13, v18, COUNT(*) as annot from aggJoin9182377285292619133 group by v16,v13,v18;
create or replace TEMP view aggView8425514108326380854 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35 from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin477691851152621822 as select v16, v13, v18, v35 * aggView3968051097838734229.annot as v35 from aggView3968051097838734229 join aggView8425514108326380854 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin477691851152621822 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;