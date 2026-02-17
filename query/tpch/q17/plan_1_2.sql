create or replace TEMP view aggView8385670536336836787 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin4023845410936332689 as select p_partkey as v17, p_brand as v20, p_container as v23, v27 from part as part, aggView8385670536336836787 where part.p_partkey=aggView8385670536336836787.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView8118077079985231073 as select v17, COUNT(*) as annot, v27 from aggJoin4023845410936332689 group by v17,v27;
create or replace TEMP view aggJoin535006983596332695 as select l_quantity as v5, l_extendedprice as v6, v27, annot from lineitem as lineitem, aggView8118077079985231073 where lineitem.l_partkey=aggView8118077079985231073.v17 and l_quantity>v27;
create or replace TEMP view res as select (SUM((v6)* annot) / 7.0) as v29 from aggJoin535006983596332695;
select sum(v29) from res;