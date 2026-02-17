create or replace TEMP view aggView1633856796938653923 as select ps_partkey as v6, COUNT(*) as annot from partsupp as partsupp group by ps_partkey;
create or replace TEMP view aggJoin1645491211268101310 as select p_brand as v9, p_type as v10, p_size as v11, annot from part as part, aggView1633856796938653923 where part.p_partkey=aggView1633856796938653923.v6 and (p_brand <> 'Brand#45') and (p_type NOT LIKE 'MEDIUM POLISHED%') and (p_size IN (49,14,23,45,19,3,36,9));
create or replace TEMP view aggView467111455142151323 as select v10, v9, v11, SUM(annot) as annot from aggJoin1645491211268101310 group by v10,v9,v11;
create or replace TEMP view res as select v9, v10, v11, SUM(annot) as v15 from aggView467111455142151323 group by v9, v10, v11;
select sum(v9+v10+v11+v15) from res;