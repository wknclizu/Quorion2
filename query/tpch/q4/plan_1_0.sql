create or replace TEMP view aggView8223973208254373673 as select l_orderkey as v10, COUNT(*) as annot from lineitem as lineitem where (l_commitdate < l_receiptdate) group by l_orderkey;
create or replace TEMP view aggJoin2531654630964409542 as select o_orderdate as v5, o_orderpriority as v6, annot from orders as orders, aggView8223973208254373673 where orders.o_orderkey=aggView8223973208254373673.v10 and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView4131853971762626819 as select v6, SUM(annot) as annot from aggJoin2531654630964409542 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView4131853971762626819 group by v6;
select sum(v6+v26) from res;