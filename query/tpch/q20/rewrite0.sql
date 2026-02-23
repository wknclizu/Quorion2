create or replace TEMP view bag297158 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag297158Aux91 as select v2, v3 from bag297158;
create or replace TEMP view minView4082787223083820484 as select v2_quantity_sum as mfR3628648733494425185 from q20_inner2;
create or replace TEMP view joinView8374281746821532701 as select distinct v2 from bag297158Aux91, minView4082787223083820484 where v3>mfR3628648733494425185;
create or replace TEMP view res as select distinct v2 from joinView8374281746821532701;
select sum(v2) from res;
