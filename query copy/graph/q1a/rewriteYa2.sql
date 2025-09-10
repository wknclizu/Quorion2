create or replace TEMP view g1 as select Graph.src as v7, Graph.dst as v2, v8 from Graph, (SELECT src, COUNT(*) AS v8 FROM Graph GROUP BY src) AS c1 where Graph.src = c1.src and v8<2;
create or replace TEMP view semiUp4177661257974815597 as select src as v2, dst as v4 from Graph AS g2 where (src) in (select v2 from g1);
create or replace TEMP view g3 as select Graph.src as v4, Graph.dst as v6, v10 from Graph, (SELECT src, COUNT(*) AS v10 FROM Graph GROUP BY src) AS c2 where Graph.dst = c2.src;
create or replace TEMP view semiUp9130534140631837715 as select v4, v6, v10 from g3 where (v4) in (select v4 from semiUp4177661257974815597);
create or replace TEMP view semiDown6805072193605187733 as select v2, v4 from semiUp4177661257974815597 where (v4) in (select v4 from semiUp9130534140631837715);
create or replace TEMP view semiDown266959294583440988 as select v7, v2, v8 from g1 where (v2) in (select v2 from semiDown6805072193605187733);
create or replace TEMP view joinView6848780539144889868 as select v2, v4, v7, v8 from semiDown6805072193605187733 join semiDown266959294583440988 using(v2);
create or replace TEMP view joinView1416487543398745842 as select v4, v6, v10, v2, v7, v8 from semiUp9130534140631837715 join joinView6848780539144889868 using(v4);
select sum(v7+v2+v4+v6+v8+v10) from joinView1416487543398745842;
