create or replace TEMP view bag9296 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag9296Aux93 as select v2, v3 from bag9296;
create or replace TEMP view minView5968447628131732872 as select v2_quantity_sum as mfR8962564678083273023 from q20_inner2;
create or replace TEMP view joinView6224018107247970540 as select distinct v2 from bag9296Aux93, minView5968447628131732872 where v3>mfR8962564678083273023;
create or replace TEMP view res as select distinct v2 from joinView6224018107247970540;
select sum(v2) from res;
