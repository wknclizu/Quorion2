create or replace TEMP view aggView2158039462107542784 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin4304522607687869075 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView2158039462107542784 where orders.o_custkey=aggView2158039462107542784.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView8663482709271165316 as select v16, v13, v18, COUNT(*) as annot from aggJoin4304522607687869075 group by v16,v13,v18;
create or replace TEMP view aggView8540821023131881041 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35 from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin7858622502617863730 as select v16, v13, v18, v35 * aggView8663482709271165316.annot as v35 from aggView8663482709271165316 join aggView8540821023131881041 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin7858622502617863730 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;