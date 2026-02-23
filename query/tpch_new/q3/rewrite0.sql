create or replace TEMP view aggView2350918618702623410 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin2517003173311600759 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView2350918618702623410 where orders.o_custkey=aggView2350918618702623410.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView3740786431170332196 as select v16, v13, v18, COUNT(*) as annot from aggJoin2517003173311600759 group by v16,v13,v18;
create or replace TEMP view aggView2943602575934544156 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35 from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin8484792398874449927 as select v16, v13, v18, v35 * aggView3740786431170332196.annot as v35 from aggView3740786431170332196 join aggView2943602575934544156 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin8484792398874449927 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;