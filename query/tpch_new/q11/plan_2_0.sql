create or replace TEMP view aggView8829705142994633763 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin70569951207163095 as select s_suppkey as v2 from supplier as supplier, aggView8829705142994633763 where supplier.s_nationkey=aggView8829705142994633763.v9;
create or replace TEMP view aggView7981938154687708955 as select v2, COUNT(*) as annot from aggJoin70569951207163095 group by v2;
create or replace TEMP view aggJoin3736132137329560722 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView7981938154687708955 where partsupp.ps_suppkey=aggView7981938154687708955.v2;
create or replace TEMP view aggView6196367375959546190 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin3736132137329560722 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView6196367375959546190 group by v1;
select sum(v1+v18) from res;