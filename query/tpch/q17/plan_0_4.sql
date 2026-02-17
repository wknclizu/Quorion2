create or replace TEMP view aggView3201377714809883503 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin2474262077783922226 as select p_partkey as v17, p_brand as v20, p_container as v23, v27 from part as part, aggView3201377714809883503 where part.p_partkey=aggView3201377714809883503.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView5620940334293485295 as select v17, COUNT(*) as annot, v27 from aggJoin2474262077783922226 group by v17,v27;
create or replace TEMP view aggJoin5485197545558043086 as select l_quantity as v5, l_extendedprice as v6, v27, annot from lineitem as lineitem, aggView5620940334293485295 where lineitem.l_partkey=aggView5620940334293485295.v17 and l_quantity>v27;
create or replace TEMP view res as select (SUM((v6)* annot) / 7.0) as v29 from aggJoin5485197545558043086;
select sum(v29) from res;