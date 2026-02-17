create or replace TEMP view aggView7214783076587784036 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin3217214426315122614 as select s_suppkey as v2 from supplier as supplier, aggView7214783076587784036 where supplier.s_nationkey=aggView7214783076587784036.v9;
create or replace TEMP view aggView6422800141250720677 as select v2, COUNT(*) as annot from aggJoin3217214426315122614 group by v2;
create or replace TEMP view aggJoin5588000996146813390 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView6422800141250720677 where partsupp.ps_suppkey=aggView6422800141250720677.v2;
create or replace TEMP view aggView1837762512033334522 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin5588000996146813390 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView1837762512033334522 group by v1;
select sum(v1+v18) from res;