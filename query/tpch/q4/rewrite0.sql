create or replace TEMP view aggView7049719846443673858 as select l_orderkey as v10, COUNT(*) as annot from lineitem as lineitem where (l_commitdate < l_receiptdate) group by l_orderkey;
create or replace TEMP view aggJoin5323078247259838310 as select o_orderdate as v5, o_orderpriority as v6, annot from orders as orders, aggView7049719846443673858 where orders.o_orderkey=aggView7049719846443673858.v10 and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView8819919940915184622 as select v6, SUM(annot) as annot from aggJoin5323078247259838310 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView8819919940915184622 group by v6;
select sum(v6+v26) from res;