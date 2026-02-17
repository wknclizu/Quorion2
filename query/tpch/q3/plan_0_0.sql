create or replace TEMP view aggView2720381476340352219 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin178645496158843380 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView2720381476340352219 where orders.o_custkey=aggView2720381476340352219.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView5668044425069311606 as select v16, v13, v18, COUNT(*) as annot from aggJoin178645496158843380 group by v16,v13,v18;
create or replace TEMP view aggView937135150286308954 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35 from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin8621597499003535742 as select v16, v13, v18, v35 * aggView5668044425069311606.annot as v35 from aggView5668044425069311606 join aggView937135150286308954 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin8621597499003535742 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;