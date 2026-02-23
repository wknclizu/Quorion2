create or replace TEMP view supplierAux85 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView1776506904380527077 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView8268698801489588109 as select distinct v1, v2, v3, v5 from supplierAux85 where (v1) in (select v1 from semiJoinView1776506904380527077);
create or replace TEMP view semiEnum7564687594111801526 as select distinct v3, v5, v9, v1, v2 from semiJoinView8268698801489588109 join semiJoinView1776506904380527077 using(v1);
create or replace TEMP view semiEnum4472679810864190862 as select v3, v5, v9, v1, v2 from semiEnum7564687594111801526, q15_inner as q15_inner where q15_inner.max_tr=semiEnum7564687594111801526.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum4472679810864190862;
select sum(v1+v2+v3+v5+v9) from res;
