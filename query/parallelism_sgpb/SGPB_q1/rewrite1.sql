create or replace view g3 as select Graph.src as v4, Graph.dst as v6, v10 from Graph, (SELECT src, COUNT(*) AS v10 FROM Graph GROUP BY src) AS c2 where Graph.dst = c2.src;
create or replace view semiJoinView3909535377947813990 as select src as v2, dst as v4 from Graph AS g2 where (dst) in (select v4 from g3);
create or replace view g1 as select Graph.src as v7, Graph.dst as v2, v8 from Graph, (SELECT src, COUNT(*) AS v8 FROM Graph GROUP BY src) AS c1 where Graph.src = c1.src and v8<2;
create or replace view semiJoinView430260019452849920 as select v7, v2, v8 from g1 where (v2) in (select v2 from semiJoinView3909535377947813990);
create or replace view semiEnum3589851949763290081 as select v2, v7, v8, v4 from semiJoinView430260019452849920 join semiJoinView3909535377947813990 using(v2);
create or replace view semiEnum1200320528613366840 as select v2, v7, v6, v10, v8, v4 from semiEnum3589851949763290081 join g3 using(v4);
select v7, v2, v4, v6, v8, v10 from semiEnum1200320528613366840;
