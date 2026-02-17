create or replace TEMP view aggView1281268339285672104 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin8396830151703906913 as select l_partkey as v17, l_quantity as v5, l_extendedprice as v6 from lineitem as lineitem, aggView1281268339285672104 where lineitem.l_partkey=aggView1281268339285672104.v17;
create or replace TEMP view aggView3811415992476811401 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin1859838401816419232 as select v5, v6, v27 from aggJoin8396830151703906913 join aggView3811415992476811401 using(v17) where (v5 > v27);
create or replace TEMP view res as select (SUM((v6)) / 7.0) as v29 from aggJoin1859838401816419232;
select sum(v29) from res;