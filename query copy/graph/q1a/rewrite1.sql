create or replace TEMP view g3 as select Graph.src as v4, Graph.dst as v6, v10 from Graph, (SELECT src, COUNT(*) AS v10 FROM Graph GROUP BY src) AS c2 where Graph.dst = c2.src;
create or replace TEMP view semiJoinView8748205427509042695 as select src as v2, dst as v4 from Graph AS g2 where (dst) in (select v4 from g3);
create or replace TEMP view g1 as select Graph.src as v7, Graph.dst as v2, v8 from Graph, (SELECT src, COUNT(*) AS v8 FROM Graph GROUP BY src) AS c1 where Graph.src = c1.src and v8<2;
create or replace TEMP view semiJoinView6917205316328204839 as select v2, v4 from semiJoinView8748205427509042695 where (v2) in (select v2 from g1);
create or replace TEMP view semiEnum4454462241885352679 as select v4, v8, v2, v7 from semiJoinView6917205316328204839 join g1 using(v2);
create or replace TEMP view semiEnum7398883750181993350 as select v7, v6, v4, v10, v2, v8 from semiEnum4454462241885352679 join g3 using(v4);
select sum(v7+v2+v4+v6+v8+v10) from semiEnum7398883750181993350;
