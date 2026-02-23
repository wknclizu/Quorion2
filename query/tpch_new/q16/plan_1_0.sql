create or replace TEMP view aggView3490236256031912210 as select ps_partkey as v6, COUNT(*) as annot from partsupp as partsupp group by ps_partkey;
create or replace TEMP view aggJoin8361004109309698207 as select p_brand as v9, p_type as v10, p_size as v11, annot from part as part, aggView3490236256031912210 where part.p_partkey=aggView3490236256031912210.v6 and (p_brand <> 'Brand#45') and (p_type NOT LIKE 'MEDIUM POLISHED%') and (p_size IN (49,14,23,45,19,3,36,9));
create or replace TEMP view aggView1421517524526167591 as select v9, v10, v11, SUM(annot) as annot from aggJoin8361004109309698207 group by v9,v10,v11;
create or replace TEMP view res as select v9, v10, v11, SUM(annot) as v15 from aggView1421517524526167591 group by v9, v10, v11;
select sum(v9+v10+v11+v15) from res;