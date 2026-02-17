create or replace TEMP view supplierAux47 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView5462045806187854633 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView7925609962544485063 as select distinct v1, v2, v3, v5 from supplierAux47 where (v1) in (select v1 from semiJoinView5462045806187854633);
create or replace TEMP view semiEnum7153429744020737591 as select distinct v9, v5, v1, v3, v2 from semiJoinView7925609962544485063 join semiJoinView5462045806187854633 using(v1);
create or replace TEMP view semiEnum4921466425516711141 as select v9, v5, v3, v1, v2 from semiEnum7153429744020737591, q15_inner as q15_inner where q15_inner.max_tr=semiEnum7153429744020737591.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum4921466425516711141;
select sum(v1+v2+v3+v5+v9) from res;
