SELECT distinct g1.src AS src, g3.dst AS dst, c1.cnt AS cnt1, c2.cnt AS cnt2
FROM Graph AS g1, Graph AS g2, Graph AS g3,
    (SELECT src, COUNT(*) AS cnt FROM Graph GROUP BY src) AS c1,
    (SELECT src, COUNT(*) AS cnt FROM Graph GROUP BY src) AS c2
WHERE c1.src = g1.src AND g1.src = c2.src AND g1.dst = g2.src AND g2.dst = g3.src 
    AND c1.cnt < 2