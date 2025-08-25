create or replace view g1 as select Graph.src as v7, Graph.dst as v2, v8 from Graph, (SELECT src, COUNT(*) AS v8 FROM Graph GROUP BY src) AS c1 where Graph.src = c1.src and v8<2;
create or replace view semiJoinView7627369833810680766 as select src as v2, dst as v4 from Graph AS g2 where (src) in (select v2 from g1);
create or replace view g3 as select Graph.src as v4, Graph.dst as v6, v10 from Graph, (SELECT src, COUNT(*) AS v10 FROM Graph GROUP BY src) AS c2 where Graph.dst = c2.src;
create or replace view semiJoinView6077623104081581704 as select v4, v6, v10 from g3 where (v4) in (select v4 from semiJoinView7627369833810680766);
create or replace view semiEnum2569224710753344310 as select v2, v6, v10, v4 from semiJoinView6077623104081581704 join semiJoinView7627369833810680766 using(v4);
create or replace view semiEnum6682564033682477993 as select v2, v7, v6, v10, v8, v4 from semiEnum2569224710753344310 join g1 using(v2);
select v7, v2, v4, v6, v8, v10 from semiEnum6682564033682477993;
