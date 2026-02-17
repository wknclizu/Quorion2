create or replace TEMP view aggView7870029290539526307 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin1072161711309238418 as select s_suppkey as v2 from supplier as supplier, aggView7870029290539526307 where supplier.s_nationkey=aggView7870029290539526307.v9;
create or replace TEMP view aggView7945743740189294544 as select v2, COUNT(*) as annot from aggJoin1072161711309238418 group by v2;
create or replace TEMP view aggJoin549926753333570803 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView7945743740189294544 where partsupp.ps_suppkey=aggView7945743740189294544.v2;
create or replace TEMP view aggView6137070848741530839 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin549926753333570803 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView6137070848741530839 group by v1;
select sum(v1+v18) from res;