create or replace TEMP view aggView5449559839501710215 as select l_orderkey as v10, COUNT(*) as annot from lineitem as lineitem where (l_commitdate < l_receiptdate) group by l_orderkey;
create or replace TEMP view aggJoin5229993910909611793 as select o_orderdate as v5, o_orderpriority as v6, annot from orders as orders, aggView5449559839501710215 where orders.o_orderkey=aggView5449559839501710215.v10 and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView6926902204086488024 as select v6, SUM(annot) as annot from aggJoin5229993910909611793 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView6926902204086488024 group by v6;
select sum(v6+v26) from res;