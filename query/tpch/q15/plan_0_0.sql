create or replace TEMP view supplierAux65 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView6147301982021505328 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (supplier_no) in (select v1 from supplierAux65);
create or replace TEMP view semiJoinView4828469985728292440 as select distinct v1, v9 from semiJoinView6147301982021505328 where (v9) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiEnum3306196806876084574 as select distinct v9, v1 from semiJoinView4828469985728292440, q15_inner as q15_inner where q15_inner.max_tr=semiJoinView4828469985728292440.v9;
create or replace TEMP view semiEnum7872092752807888636 as select v5, v3, v1, v9, v2 from semiEnum3306196806876084574 join supplierAux65 using(v1);
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum7872092752807888636;
select sum(v1+v2+v3+v5+v9) from res;
