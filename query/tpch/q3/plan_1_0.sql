create or replace TEMP view aggView3272554285779179098 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin921377333193566382 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView3272554285779179098 where orders.o_custkey=aggView3272554285779179098.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view aggView3359376727042368148 as select v18, v16, v13, COUNT(*) as annot from aggJoin921377333193566382 group by v18,v16,v13;
create or replace TEMP view aggView5166120365539875105 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35 from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin2777145145414289628 as select v18, v16, v13, v35 * aggView3359376727042368148.annot as v35 from aggView3359376727042368148 join aggView5166120365539875105 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from aggJoin2777145145414289628 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;