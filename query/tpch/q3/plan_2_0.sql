create or replace TEMP view aggView5752801509116802077 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin3304630876088597310 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView5752801509116802077 where orders.o_custkey=aggView5752801509116802077.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView8626066037215851597 as select v16, v13, v18, COUNT(*) as annot from aggJoin3304630876088597310 group by v16,v13,v18;
create or replace TEMP view aggView4084464643770068534 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35 from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin4205786967738031993 as select v16, v13, v18, v35 * aggView8626066037215851597.annot as v35 from aggView8626066037215851597 join aggView4084464643770068534 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin4205786967738031993 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;