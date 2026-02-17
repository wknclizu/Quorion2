create or replace TEMP view aggView3906495241873058375 as select l_orderkey as v10, COUNT(*) as annot from lineitem as lineitem where (l_commitdate < l_receiptdate) group by l_orderkey;
create or replace TEMP view aggJoin5798726512837735107 as select o_orderdate as v5, o_orderpriority as v6, annot from orders as orders, aggView3906495241873058375 where orders.o_orderkey=aggView3906495241873058375.v10 and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView8768876603091084860 as select v6, SUM(annot) as annot from aggJoin5798726512837735107 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView8768876603091084860 group by v6;
select sum(v6+v26) from res;