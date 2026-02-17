create or replace TEMP view bag1392 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag1392Aux100 as select v2, v3 from bag1392;
create or replace TEMP view minView441134690937048116 as select v2_quantity_sum as mfR2741271684228076294 from q20_inner2;
create or replace TEMP view joinView4806626119689953492 as select distinct v2 from bag1392Aux100, minView441134690937048116 where v3>mfR2741271684228076294;
create or replace TEMP view res as select distinct v2 from joinView4806626119689953492;
select sum(v2) from res;
