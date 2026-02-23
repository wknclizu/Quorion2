create or replace TEMP view supplierAux66 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView7654723818220445033 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (supplier_no) in (select v1 from supplierAux66);
create or replace TEMP view semiJoinView7148524572283484215 as select distinct v1, v9 from semiJoinView7654723818220445033 where (v9) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiEnum6100599807015800836 as select distinct v1, v9 from semiJoinView7148524572283484215, q15_inner as q15_inner where q15_inner.max_tr=semiJoinView7148524572283484215.v9;
create or replace TEMP view semiEnum6585132723144155284 as select v1, v3, v9, v5, v2 from semiEnum6100599807015800836 join supplierAux66 using(v1);
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum6585132723144155284;
select sum(v1+v2+v3+v5+v9) from res;
