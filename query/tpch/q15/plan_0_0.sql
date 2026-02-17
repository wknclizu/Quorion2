create or replace TEMP view supplierAux98 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView32578438503784991 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView8450733444508287419 as select distinct v1, v2, v3, v5 from supplierAux98 where (v1) in (select v1 from semiJoinView32578438503784991);
create or replace TEMP view semiEnum8217875807042526453 as select distinct v2, v1, v5, v3, v9 from semiJoinView8450733444508287419 join semiJoinView32578438503784991 using(v1);
create or replace TEMP view semiEnum3226958819228034433 as select v2, v1, v9, v3, v5 from semiEnum8217875807042526453, q15_inner as q15_inner where q15_inner.max_tr=semiEnum8217875807042526453.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum3226958819228034433;
select sum(v1+v2+v3+v5+v9) from res;
