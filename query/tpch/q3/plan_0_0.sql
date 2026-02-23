create or replace TEMP view aggView4424108264072851147 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35, COUNT(*) as annot from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin8970214591771230256 as select o_orderkey as v18, o_custkey as v1, o_orderdate as v13, o_shippriority as v16, v35, annot from orders as orders, aggView4424108264072851147 where orders.o_orderkey=aggView4424108264072851147.v18 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view semiJoinView1854742147443514238 as select distinct c_custkey as v1 from customer AS customer where (c_custkey) in (select v1 from aggJoin8970214591771230256) and (c_mktsegment = 'BUILDING');
create or replace TEMP view semiEnum2849044934879635168 as select annot, v35, v18, v13, v16 from semiJoinView1854742147443514238 join aggJoin8970214591771230256 using(v1);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from semiEnum2849044934879635168 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;
