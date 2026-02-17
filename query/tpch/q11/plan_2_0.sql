create or replace TEMP view aggView9147341268148853274 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin4985186131749925009 as select s_suppkey as v2 from supplier as supplier, aggView9147341268148853274 where supplier.s_nationkey=aggView9147341268148853274.v9;
create or replace TEMP view aggView6532409096073121205 as select v2, COUNT(*) as annot from aggJoin4985186131749925009 group by v2;
create or replace TEMP view aggJoin2472625233425043643 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView6532409096073121205 where partsupp.ps_suppkey=aggView6532409096073121205.v2;
create or replace TEMP view aggView3210824086972956328 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin2472625233425043643 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView3210824086972956328 group by v1;
select sum(v1+v18) from res;