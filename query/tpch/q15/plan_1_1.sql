create or replace TEMP view supplierAux47 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView7459678207152390122 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView3424079669943377659 as select distinct v1, v2, v3, v5 from supplierAux47 where (v1) in (select v1 from semiJoinView7459678207152390122);
create or replace TEMP view semiEnum2575491920181798767 as select distinct v2, v1, v3, v9, v5 from semiJoinView3424079669943377659 join semiJoinView7459678207152390122 using(v1);
create or replace TEMP view semiEnum2328670132302609200 as select v2, v1, v3, v9, v5 from semiEnum2575491920181798767, q15_inner as q15_inner where q15_inner.max_tr=semiEnum2575491920181798767.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum2328670132302609200;
select sum(v1+v2+v3+v5+v9) from res;
