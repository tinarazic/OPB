ALTER TABLE traktor ALTER lastnik SET NOT NULL;
ALTER TABLE traktor ALTER znamka SET NOT NULL;
ALTER TABLE deli ALTER lastnik SET NOT NULL;
ALTER TABLE deli ALTER znamka SET NOT NULL;
SELECT * FROM oseba
JOIN traktor ON oseba.id = traktor.id;
SELECT * FROM oseba
JOIN traktor ON oseba.id = traktor.lastnik;
SELECT * FROM oseba
LEFT JOIN traktor ON oseba.id = traktor.lastnik;
SELECT * FROM oseba
LEFT JOIN traktor ON oseba.id = traktor.lastnik
WHERE traktor.id = NULL;
SELECT * FROM oseba
LEFT JOIN traktor ON oseba.id = traktor.lastnik
WHERE traktor.id IS NULL;
SELECT ime FROM oseba
LEFT JOIN traktor ON oseba.id = traktor.lastnik
WHERE traktor.id IS NULL;
SELECT stars.ime, otrok.ime
FROM oseba AS stars
JOIN otroci ON stars.id = otroci.stars
JOIN oseba AS otrok ON otroci.otrok = otrok.id;
SELECT stars.*
FROM oseba AS stars
JOIN otroci ON stars.id = otroci.stars
JOIN oseba AS otrok ON otroci.otrok = otrok.id
JOIN traktor ON lastnik = otrok.id
WHERE nakup < otrok.rojstvo + '10 years'::INTERVAL;
SELECT DISTINCT stars.*
FROM oseba AS stars
JOIN otroci ON stars.id = otroci.stars
JOIN oseba AS otrok ON otroci.otrok = otrok.id
JOIN traktor ON lastnik = otrok.id
WHERE nakup < otrok.rojstvo + '10 years'::INTERVAL;
SELECT otrok.ime AS otrok, stari_stars.ime AS stari_stars 
FROM oseba AS stari_stars
JOIN otroci AS o1 ON stari_stars.id = o1.stars
JOIN otroci AS o2 ON o1.otrok = o2.stars
RIGHT JOIN oseba AS otrok ON o2.otrok = otrok.id;
SELECT otrok.ime AS otrok, stari_stars.ime AS stari_stars 
FROM oseba AS otrok
LEFT JOIN otroci AS o2 ON o2.otrok = otrok.id
JOIN otroci AS o1 ON o1.otrok = o2.stars
JOIN oseba AS stari_stars ON stari_stars.id = o1.stars;
SELECT otrok.ime AS otrok, stari_stars.ime AS stari_stars 
FROM oseba AS otrok
LEFT JOIN otroci AS o2 ON o2.otrok = otrok.id
LEFT JOIN otroci AS o1 ON o1.otrok = o2.stars
LEFT JOIN oseba AS stari_stars ON stari_stars.id = o1.stars;
SELECT otrok.ime AS otrok, stari_stars.ime AS stari_stars 
FROM oseba AS otrok
LEFT JOIN otroci AS o2 ON o2.otrok = otrok.id
LEFT JOIN otroci AS o1 ON o1.otrok = o2.stars
LEFT JOIN oseba AS stari_stars ON stari_stars.id = o1.stars;
SELECT stars, count(*)
FROM otroci
GROUP BY stars;
SELECT stars, count(*)
FROM otroci
GROUP BY stars;
SELECT ime, count(*)
FROM znamka
JOIN traktor ON znamka.id = traktor.znamka
GROUP BY ime;
SELECT ime, count(*)
FROM znamka
LEFT JOIN traktor ON znamka.id = traktor.znamka
GROUP BY ime;
SELECT ime, count(traktor.id)
FROM znamka
LEFT JOIN traktor ON znamka.id = traktor.znamka
GROUP BY ime;
SELECT oseba.id, oseba.ime, sum(stevilo)
FROM oseba
LEFT JOIN deli ON lastnik = oseba.id
GROUP BY oseba.id, oseba.ime;
SELECT oseba.id, oseba.ime, sum(stevilo)
FROM oseba
LEFT JOIN deli ON lastnik = oseba.id
GROUP BY oseba.id, oseba.ime;
SELECT oseba.id, oseba.ime, coalesce(sum(stevilo),0)
FROM oseba
LEFT JOIN deli ON lastnik = oseba.id
GROUP BY oseba.id, oseba.ime;
SELECT oseba.id, oseba.ime, coalesce(sum(stevilo),0) AS stevilo_delov
FROM oseba
LEFT JOIN deli ON lastnik = oseba.id
GROUP BY oseba.id, oseba.ime
HAVING coalesce(sum(stevilo),0) <= 1;
SELECT oseba.id, ime, sum(now() - nakup) / 96 AS izkusnje FROM oseba
JOIN traktor ON lastnik = oseba.id 
GROUP BY oseba.id, ime
ORDER BY sum(now() - nakup) DESC
LIMIT 1;
SELECT oseba.id, ime, sum(now() - nakup) / 96 AS izkusnje FROM oseba
JOIN traktor ON lastnik = oseba.id 
GROUP BY oseba.id, ime
ORDER BY sum(now() - nakup) DESC;
SELECT oseba.id, ime, sum(now() - nakup) / 96 AS izkusnje FROM oseba
JOIN traktor ON lastnik = oseba.id 
GROUP BY oseba.id, ime
ORDER BY sum(now() - nakup) DESC;
SELECT *
FROM deli
JOIN traktor USING (znamka);
SELECT tip, count(DISTINCT id)
FROM deli JOIN traktor USING (znamka)
GROUP BY tip;
SELECT rojstvo, extract(day FROM rojstvo), extract(month FROM rojstvo)
FROM oseba;
SELECT extract(day FROM rojstvo) || '. ' || extract(month FROM rojstvo) || '.' AS rojstni_dan
FROM oseba;
SELECT extract(day FROM rojstvo) || '. ' || extract(month FROM rojstvo) || '.' AS rojstni_dan
FROM oseba
GROUP BY rojstni_dan
HAVING count(*) <=2;
SELECT extract(day FROM rojstvo) || '. ' || extract(month FROM rojstvo) || '.' AS rojstni_dan
FROM oseba
GROUP BY rojstni_dan
HAVING count(*) >=2;
SELECT extract(day FROM rojstvo) || '. ' || extract(month FROM rojstvo) || '.' AS rojstni_dan
FROM oseba;
SELECT extract(day FROM o1.rojstvo) || '. ' || extract(month FROM o1.rojstvo) || '.' AS rojstni_dan
FROM oseba AS o1 JOIN oseba AS o2 
ON extract(day FROM o1.rojstvo) = extract(day FROM o2.rojstvo) 
AND extract(month FROM o1.rojstvo) = extract(month FROM o2.rojstvo);
SELECT extract(day FROM o1.rojstvo) || '. ' || extract(month FROM o1.rojstvo) || '.' AS rojstni_dan
FROM oseba AS o1 JOIN oseba AS o2 
ON extract(day FROM o1.rojstvo) = extract(day FROM o2.rojstvo) 
AND extract(month FROM o1.rojstvo) = extract(month FROM o2.rojstvo)
WHERE o1.id <> o2.id;
SELECT DISTINCT extract(day FROM o1.rojstvo) || '. ' || extract(month FROM o1.rojstvo) || '.' AS rojstni_dan
FROM oseba AS o1 JOIN oseba AS o2 
ON extract(day FROM o1.rojstvo) = extract(day FROM o2.rojstvo) 
AND extract(month FROM o1.rojstvo) = extract(month FROM o2.rojstvo)
WHERE o1.id <> o2.id;
