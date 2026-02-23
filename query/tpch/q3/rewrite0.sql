create or replace TEMP view aggView9067554240583533127 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin5911384516354468830 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView9067554240583533127 where orders.o_custkey=aggView9067554240583533127.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView965108465609021599 as select v16, v13, v18, COUNT(*) as annot from aggJoin5911384516354468830 group by v16,v13,v18;
create or replace TEMP view aggView5264952263238373541 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35 from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin3237119572976639453 as select v16, v13, v18, v35 * aggView965108465609021599.annot as v35 from aggView965108465609021599 join aggView5264952263238373541 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin3237119572976639453 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;