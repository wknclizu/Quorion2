create or replace TEMP view semiUp3377087811079646465 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select l_orderkey from lineitem AS lineitem where (l_commitdate < l_receiptdate)) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view ordersAux56 as select v6 from semiUp3377087811079646465;
create or replace TEMP view semiDown6290610511350560884 as select v10, v6 from semiUp3377087811079646465 where (v6) in (select v6 from ordersAux56);
create or replace TEMP view semiDown6626257731234725676 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select v10 from semiDown6290610511350560884) and (l_commitdate < l_receiptdate);
create or replace TEMP view aggView6060240931325336079 as select v10, COUNT(*) as annot from semiDown6626257731234725676 group by v10;
create or replace TEMP view aggJoin1030091399635929531 as select v6, annot from semiDown6290610511350560884 join aggView6060240931325336079 using(v10);
create or replace TEMP view aggView6251590701300709692 as select v6, SUM(annot) as annot from aggJoin1030091399635929531 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView6251590701300709692 group by v6;
select sum(v6+v26) from res;
