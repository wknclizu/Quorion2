create or replace TEMP view bag1378 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag1378Aux51 as select v2, v3 from bag1378;
create or replace TEMP view minView8390508843664985170 as select v2_quantity_sum as mfR4719717404155639518 from q20_inner2;
create or replace TEMP view joinView6320117709773139181 as select distinct v2 from bag1378Aux51, minView8390508843664985170 where v3>mfR4719717404155639518;
create or replace TEMP view res as select distinct v2 from joinView6320117709773139181;
select sum(v2) from res;
