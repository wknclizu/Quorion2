create or replace TEMP view supplierAux39 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView4348046755450397857 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView4142297150774471985 as select distinct v1, v9 from semiJoinView4348046755450397857 where (v1) in (select v1 from supplierAux39);
create or replace TEMP view semiEnum7312093322007369183 as select distinct v3, v1, v5, v9, v2 from semiJoinView4142297150774471985 join supplierAux39 using(v1);
create or replace TEMP view semiEnum3578949434367098605 as select v1, v5, v3, v9, v2 from semiEnum7312093322007369183, q15_inner as q15_inner where q15_inner.max_tr=semiEnum7312093322007369183.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum3578949434367098605;
select sum(v1+v2+v3+v5+v9) from res;
