create or replace TEMP view aggView3017986114763228659 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin6931184389294950674 as select s_suppkey as v2 from supplier as supplier, aggView3017986114763228659 where supplier.s_nationkey=aggView3017986114763228659.v9;
create or replace TEMP view aggView5462235733973725354 as select v2, COUNT(*) as annot from aggJoin6931184389294950674 group by v2;
create or replace TEMP view aggJoin1581044489428288708 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView5462235733973725354 where partsupp.ps_suppkey=aggView5462235733973725354.v2;
create or replace TEMP view aggView6730301872814436317 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin1581044489428288708 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView6730301872814436317 group by v1;
select sum(v1+v18) from res;