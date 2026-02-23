create or replace TEMP view semiUp3988549666901029711 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select l_orderkey from lineitem AS lineitem where (l_commitdate < l_receiptdate)) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view semiDown3501875531692879861 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select v10 from semiUp3988549666901029711) and (l_commitdate < l_receiptdate);
create or replace TEMP view aggView4039814677295987897 as select v10, COUNT(*) as annot from semiDown3501875531692879861 group by v10;
create or replace TEMP view aggJoin5867972577691481504 as select v6, annot from semiUp3988549666901029711 join aggView4039814677295987897 using(v10);
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggJoin5867972577691481504 group by v6;
select sum(v6+v26) from res;
