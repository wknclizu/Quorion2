create or replace TEMP view bag879 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag879Aux35 as select v2, v3 from bag879;
create or replace TEMP view minView2685856225532581433 as select v2_quantity_sum as mfR8689240776401357845 from q20_inner2;
create or replace TEMP view joinView4059276929393600430 as select distinct v2 from bag879Aux35, minView2685856225532581433 where v3>mfR8689240776401357845;
create or replace TEMP view res as select distinct v2 from joinView4059276929393600430;
select sum(v2) from res;
