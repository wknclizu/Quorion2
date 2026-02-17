create or replace TEMP view aggView8944887417811271441 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin8764365595682313233 as select s_suppkey as v2 from supplier as supplier, aggView8944887417811271441 where supplier.s_nationkey=aggView8944887417811271441.v9;
create or replace TEMP view aggView6644510113925587056 as select v2, COUNT(*) as annot from aggJoin8764365595682313233 group by v2;
create or replace TEMP view aggJoin6511130473647914758 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView6644510113925587056 where partsupp.ps_suppkey=aggView6644510113925587056.v2;
create or replace TEMP view aggView5818450960346628261 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin6511130473647914758 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView5818450960346628261 group by v1;
select sum(v1+v18) from res;