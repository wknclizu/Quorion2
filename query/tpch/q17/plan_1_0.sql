create or replace TEMP view aggView1000941344999929479 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin4183551221505425460 as select p_partkey as v17, p_brand as v20, p_container as v23, v27 from part as part, aggView1000941344999929479 where part.p_partkey=aggView1000941344999929479.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView6542214011280716151 as select v17, COUNT(*) as annot, v27 from aggJoin4183551221505425460 group by v17,v27;
create or replace TEMP view aggJoin2776607659686093874 as select l_quantity as v5, l_extendedprice as v6, v27, annot from lineitem as lineitem, aggView6542214011280716151 where lineitem.l_partkey=aggView6542214011280716151.v17 and l_quantity>v27;
create or replace TEMP view res as select (SUM((v6)* annot) / 7.0) as v29 from aggJoin2776607659686093874;
select sum(v29) from res;