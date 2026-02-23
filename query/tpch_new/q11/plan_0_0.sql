create or replace TEMP view aggView1971589163732801120 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin5568132281171411534 as select s_suppkey as v2 from supplier as supplier, aggView1971589163732801120 where supplier.s_nationkey=aggView1971589163732801120.v9;
create or replace TEMP view aggView8120444609106715534 as select v2, COUNT(*) as annot from aggJoin5568132281171411534 group by v2;
create or replace TEMP view aggJoin7370574230896674992 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView8120444609106715534 where partsupp.ps_suppkey=aggView8120444609106715534.v2;
create or replace TEMP view aggView3133711712567698252 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin7370574230896674992 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView3133711712567698252 group by v1;
select sum(v1+v18) from res;