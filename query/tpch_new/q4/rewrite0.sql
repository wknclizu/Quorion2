create or replace TEMP view aggView178493821889620444 as select l_orderkey as v10, COUNT(*) as annot from lineitem as lineitem where (l_commitdate < l_receiptdate) group by l_orderkey;
create or replace TEMP view aggJoin5975136272828820472 as select o_orderdate as v5, o_orderpriority as v6, annot from orders as orders, aggView178493821889620444 where orders.o_orderkey=aggView178493821889620444.v10 and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView5429265319672359033 as select v6, SUM(annot) as annot from aggJoin5975136272828820472 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView5429265319672359033 group by v6;
select sum(v6+v26) from res;