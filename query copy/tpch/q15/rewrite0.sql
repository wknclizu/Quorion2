create or replace TEMP view supplierAux79 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView3743727140837768076 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (supplier_no) in (select v1 from supplierAux79);
create or replace TEMP view semiJoinView1563940333914718234 as select distinct v1, v9 from semiJoinView3743727140837768076 where (v9) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiEnum1839493337272301420 as select distinct v1, v9 from semiJoinView1563940333914718234, q15_inner as q15_inner where q15_inner.max_tr=semiJoinView1563940333914718234.v9;
create or replace TEMP view semiEnum1509118608288213165 as select v9, v5, v1, v2, v3 from semiEnum1839493337272301420 join supplierAux79 using(v1);
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum1509118608288213165;
select sum(v1+v2+v3+v5+v9) from res;
