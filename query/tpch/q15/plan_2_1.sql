create or replace TEMP view supplierAux55 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView7782197350697667303 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView3637523815579490426 as select distinct v1, v9 from semiJoinView7782197350697667303 where (v1) in (select v1 from supplierAux55);
create or replace TEMP view semiEnum965366573652099553 as select distinct v2, v5, v3, v1, v9 from semiJoinView3637523815579490426 join supplierAux55 using(v1);
create or replace TEMP view semiEnum2274848517045453232 as select v2, v5, v3, v1, v9 from semiEnum965366573652099553, q15_inner as q15_inner where q15_inner.max_tr=semiEnum965366573652099553.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum2274848517045453232;
select sum(v1+v2+v3+v5+v9) from res;
