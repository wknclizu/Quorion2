create or replace TEMP view aggView24166165477773847 as select ps_partkey as v6, COUNT(*) as annot from partsupp as partsupp group by ps_partkey;
create or replace TEMP view aggJoin357886081083786260 as select p_brand as v9, p_type as v10, p_size as v11, annot from part as part, aggView24166165477773847 where part.p_partkey=aggView24166165477773847.v6 and (p_brand <> 'Brand#45') and (p_type NOT LIKE 'MEDIUM POLISHED%') and (p_size IN (49,14,23,45,19,3,36,9));
create or replace TEMP view aggView5898306278043146952 as select v9, v11, v10, SUM(annot) as annot from aggJoin357886081083786260 group by v9,v11,v10;
create or replace TEMP view res as select v9, v10, v11, SUM(annot) as v15 from aggView5898306278043146952 group by v9, v10, v11;
select sum(v9+v10+v11+v15) from res;