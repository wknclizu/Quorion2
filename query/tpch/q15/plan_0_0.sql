create or replace TEMP view supplierAux16 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView8526651027586920226 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView4777571784501343100 as select distinct v1, v2, v3, v5 from supplierAux16 where (v1) in (select v1 from semiJoinView8526651027586920226);
create or replace TEMP view semiEnum3695361210216634325 as select distinct v2, v9, v5, v3, v1 from semiJoinView4777571784501343100 join semiJoinView8526651027586920226 using(v1);
create or replace TEMP view semiEnum8120660935892537345 as select v2, v9, v5, v3, v1 from semiEnum3695361210216634325, q15_inner as q15_inner where q15_inner.max_tr=semiEnum3695361210216634325.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum8120660935892537345;
select sum(v1+v2+v3+v5+v9) from res;
