SELECT lastnik, 10000*count(*) AS vrednost
FROM traktor
GROUP BY lastnik;
CREATE VIEW traktor_premozenje AS 
SELECT lastnik, 10000*count(*) AS vrednost
FROM traktor
GROUP BY lastnik;
CREATE VIEW deli_premozenje AS
SELECT lastnik, 100* sum(stevilo) AS vrednost
FROM deli
GROUP BY lastnik;
SELECT lastnik, deli_premozenje.vrednost, traktor_premozenje.vrednost
FROM traktor_premozenje
FULL JOIN deli_premozenje USING (lastnik);
SELECT lastnik, coalesce(deli_premozenje.vrednost, 0)+ coalesce(traktor_premozenje.vrednost, 0) AS premozenje
FROM traktor_premozenje
FULL JOIN deli_premozenje USING (lastnik);
SELECT *
FROM traktor_premozenje 
UNION
SELECT *
from deli_premozenje;
SELECT *
FROM traktor_premozenje 
UNION ALL
SELECT *
from deli_premozenje;
SELECT lastnik, sum(vrednost) AS premozenje
FROM (
SELECT *
FROM traktor_premozenje 
UNION ALL
SELECT *
from deli_premozenje
) AS premozenje
GROUP BY lastnik;
SELECT lastnik, sum(vrednost) AS premozenje
FROM (
  SELECT * FROM traktor_premozenje 
  UNION ALL
  SELECT * FROM deli_premozenje
) AS premozenje
GROUP BY lastnik;
SELECT lastnik, coalesce(sum(vrednost), 0) AS premozenje
FROM oseba LEFT JOIN (
  SELECT * FROM traktor_premozenje 
  UNION ALL
  SELECT * FROM deli_premozenje
) AS premozenje ON oseba.id = premozenje.lastnik
GROUP BY premozenje.lastnik;
SELECT lastnik, coalesce(sum(vrednost), 0) AS premozenje
FROM oseba LEFT JOIN (
  SELECT * FROM traktor_premozenje 
  UNION ALL
  SELECT * FROM deli_premozenje
) AS premozenje ON oseba.id = premozenje.lastnik
GROUP BY premozenje.lastnik;
SELECT * FROM oseba
WHERE NOT EXISTS (
 SELECT id FROM traktor
 JOIN otroci ON lastnik = otrok
 WHERE barva = 'rdeca' AND stars = oseba.id
);
SELECT * FROM oseba
WHERE NOT EXISTS (
 SELECT id FROM traktor
 JOIN otroci ON lastnik = otrok
 WHERE barva = 'rdeca' AND stars = oseba.id
);
SELECT lastnik, sum(stevilo) AS stevilo 
FROM deli
WHERE znamka NOT IN (
 SELECT znamka FROM traktor
 WHERE lastnik = deli.lastnik
)
GROUP BY lastnik;
SELECT lastnik, count(DISTINCT znamka) FROM traktor
GROUP BY lastnik;
SELECT lastnik, count(DISTINCT znamka) AS stveilo FROM traktor
GROUP BY lastnik;
SELECT lastnik, count(DISTINCT znamka) AS stevilo FROM traktor
GROUP BY lastnik
ORDER BY stevilo DESC
LIMIT 1;
SELECT lastnik, count(DISTINCT znamka) AS stevilo FROM traktor
GROUP BY lastnik
ORDER BY stevilo DESC;
SELECT lastnik, count(DISTINCT znamka) AS stevilo FROM traktor
GROUP BY lastnik;
WITH razlicne_znamke AS(
SELECT lastnik, count(DISTINCT znamka) AS stevilo FROM traktor
GROUP BY lastnik
)
SELECT oseba.* FROM oseba
JOIN razlicne_znamke ON oseba.id = lastnik 
WHERE stevilo >= ALL(
 SELECT stevilo from razlicne_znamke
);
WITH razlicne_znamke AS(
SELECT lastnik, count(DISTINCT znamka) AS stevilo FROM traktor
GROUP BY lastnik
)
SELECT oseba.* FROM oseba
JOIN razlicne_znamke ON oseba.id = lastnik 
WHERE stevilo >= ALL(
 SELECT stevilo from razlicne_znamke
);
SELECT * FROM oseba
WHERE EXISTS (
 SELECT otrok FROM otroci
 WHERE stars = oseba.id
) AND EXISTS (
 SELECT id FROM znamka
 WHERE id = ALL(
  SELECT znamka FROM traktor
  RIGHT JOIN otroci 
  ON otrok = lastnik AND znamka = znamka.id
  WHERE stars = oseba.id));
SELECT id, id AS clan FROM oseba 
UNION
SELECT otrok AS id, stars AS clan FROM otroci;
WITH druzine AS(
 SELECT id, id AS clan FROM oseba 
 UNION
 SELECT otrok AS id, stars AS clan FROM otroci
-- za vsak id smo dobili sebe pa še starše
)
SELECT clan, sum(stevilo/dosegljivost) AS razpolozljivi
FROM druzine 
JOIN deli ON lastnik = id 
--deli, ki so članu na razpolago
--treba ugotovit kolikim osebam so te deli razpoložljivi
JOIN(
 SELECT id, count(*) AS dosegljivost FROM druzine
 GROUP BY id
) AS dosegljivost USING (id)
GROUP BY clan;
WITH druzine AS(
 SELECT id, id AS clan FROM oseba 
 UNION
 SELECT otrok AS id, stars AS clan FROM otroci
-- za vsak id smo dobili sebe pa še starše
)
SELECT clan, sum(stevilo/dosegljivost::real) AS razpolozljivi
FROM druzine 
JOIN deli ON lastnik = id 
--deli, ki so članu na razpolago
--treba ugotovit kolikim osebam so te deli razpoložljivi
JOIN(
 SELECT id, count(*) AS dosegljivost FROM druzine
 GROUP BY id
) AS dosegljivost USING (id)
GROUP BY clan;
SELECT oseba.* FROM oseba
JOIN traktor AS t1 ON oseba.id = t1.lastnik
JOIN traktor AS t2 ON oseba.id = t2.lastnik
WHERE t1.id <> t2.id;
SELECT DISTINCT oseba.* FROM oseba
JOIN traktor AS t1 ON oseba.id = t1.lastnik
JOIN traktor AS t2 ON oseba.id = t2.lastnik
WHERE t1.id <> t2.id;
