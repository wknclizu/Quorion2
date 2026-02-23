create or replace TEMP view supplierAux18 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView4822610790632994731 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView6364586486329059 as select distinct v1, v2, v3, v5 from supplierAux18 where (v1) in (select v1 from semiJoinView4822610790632994731);
create or replace TEMP view semiEnum1668038854678752806 as select distinct v1, v3, v9, v5, v2 from semiJoinView6364586486329059 join semiJoinView4822610790632994731 using(v1);
create or replace TEMP view semiEnum4379295755348640930 as select v1, v3, v9, v5, v2 from semiEnum1668038854678752806, q15_inner as q15_inner where q15_inner.max_tr=semiEnum1668038854678752806.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum4379295755348640930;
select sum(v1+v2+v3+v5+v9) from res;
