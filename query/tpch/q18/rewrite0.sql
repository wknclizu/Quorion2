create or replace view aggView1683278748266230770 as select c_custkey as v1, c_name as v2 from customer as customer;
create or replace view aggView4721243977647391725 as select o_custkey as v1, o_orderdate as v13, o_totalprice as v12, o_orderkey as v9 from orders as orders;
create or replace view aggView4213819352168940129 as select l_orderkey as v9, SUM(l_quantity) as v35, COUNT(*) as annot from lineitem as lineitem group by l_orderkey;
create or replace view aggJoin4762026079443031324 as select v1, v13, v12, v9, v35, annot from aggView4721243977647391725 join aggView4213819352168940129 using(v9);
create or replace view semiJoinView2409668602299922408 as select v1, v13, v12, v9, v35, annot from aggJoin4762026079443031324 where (v1) in (select v1 from aggView1683278748266230770);
create or replace view semiJoinView2052961220870837156 as select distinct v1, v13, v12, v9, v35, annot from semiJoinView2409668602299922408 where (v9) in (select v1_orderkey from q18_inner AS q18_inner);
create or replace view semiEnum8179729653355970754 as select distinct v1, v13, v12, v35, annot, v9 from semiJoinView2052961220870837156, q18_inner as q18_inner where q18_inner.v1_orderkey=semiJoinView2052961220870837156.v9;
create or replace view semiEnum5919709870232541232 as select v35, v2, v1, v13, v12, v9 from semiEnum8179729653355970754 join aggView1683278748266230770 using(v1);
select v2, v1, v9, v13, v12, v35 from semiEnum5919709870232541232;