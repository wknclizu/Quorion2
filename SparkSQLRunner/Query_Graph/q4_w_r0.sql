create or replace TEMP view g3 as select wiki.src as v4, wiki.dst as v6, v10 from wiki, (SELECT src, COUNT(*) AS v10 FROM wiki GROUP BY src) AS c2 where wiki.dst = c2.src;
create or replace TEMP view g3Aux8 as select v4, v6, v10 from g3;
create or replace TEMP view g1 as select wiki.src as v7, wiki.dst as v2, v8 from wiki, (SELECT src, COUNT(*) AS v8 FROM wiki GROUP BY src) AS c1 where wiki.src = c1.src;
create or replace TEMP view minView7866219079596252654 as select v2, min(v8) as mfL2980243762834534920 from g1 group by v2;
create or replace TEMP view joinView3477189909482605523 as select src as v2, dst as v4, mfL2980243762834534920 from wiki AS g2, minView7866219079596252654 where g2.src=minView7866219079596252654.v2;
create or replace TEMP view minView7843625574988200631 as select v4, min(mfL2980243762834534920) as mfL3832499091458830745 from joinView3477189909482605523 group by v4;
create or replace TEMP view joinView9075487642549331275 as select v4, v6 from g3Aux8 join minView7843625574988200631 using(v4) where mfL3832499091458830745<v10;
select distinct v4, v6 from joinView9075487642549331275;
