create or replace TEMP view aggView3232261857224740530 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin2078740094911283937 as select s_suppkey as v2 from supplier as supplier, aggView3232261857224740530 where supplier.s_nationkey=aggView3232261857224740530.v9;
create or replace TEMP view aggView6187782379207181471 as select v2, COUNT(*) as annot from aggJoin2078740094911283937 group by v2;
create or replace TEMP view aggJoin1636691462126839786 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView6187782379207181471 where partsupp.ps_suppkey=aggView6187782379207181471.v2;
create or replace TEMP view aggView1959209632241497572 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin1636691462126839786 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView1959209632241497572 group by v1;
select sum(v1+v18) from res;