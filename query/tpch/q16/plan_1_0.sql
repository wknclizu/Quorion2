create or replace TEMP view aggView3426040592535232356 as select ps_partkey as v6, COUNT(*) as annot from partsupp as partsupp group by ps_partkey;
create or replace TEMP view aggJoin7435773464061010853 as select p_brand as v9, p_type as v10, p_size as v11, annot from part as part, aggView3426040592535232356 where part.p_partkey=aggView3426040592535232356.v6 and (p_brand <> 'Brand#45') and (p_type NOT LIKE 'MEDIUM POLISHED%') and (p_size IN (49,14,23,45,19,3,36,9));
create or replace TEMP view aggView129065993336029426 as select v11, v10, v9, SUM(annot) as annot from aggJoin7435773464061010853 group by v11,v10,v9;
create or replace TEMP view res as select v9, v10, v11, SUM(annot) as v15 from aggView129065993336029426 group by v9, v10, v11;
select sum(v9+v10+v11+v15) from res;