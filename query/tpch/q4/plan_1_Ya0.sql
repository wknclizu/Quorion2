create or replace TEMP view semiUp2303820442602428242 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select l_orderkey from lineitem AS lineitem where (l_commitdate < l_receiptdate)) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view ordersAux8 as select v6 from semiUp2303820442602428242;
create or replace TEMP view semiDown7734978935964569021 as select v10, v6 from semiUp2303820442602428242 where (v6) in (select v6 from ordersAux8);
create or replace TEMP view semiDown8462888079599475612 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select v10 from semiDown7734978935964569021) and (l_commitdate < l_receiptdate);
create or replace TEMP view aggView7813460168002271034 as select v10, COUNT(*) as annot from semiDown8462888079599475612 group by v10;
create or replace TEMP view aggJoin7666806771294230115 as select v6, annot from semiDown7734978935964569021 join aggView7813460168002271034 using(v10);
create or replace TEMP view aggView2285002079957018275 as select v6, SUM(annot) as annot from aggJoin7666806771294230115 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView2285002079957018275 group by v6;
select sum(v6+v26) from res;
