USE ObliDB2
GO
--Inicio Consulta a
SELECT p.Nombre, m.Descripcion
FROM Plantas p, Mantenimientos m, (SELECT MAX(FechaHora) AS MaxFecha FROM Mantenimientos) f
WHERE p.Id = m.IdPlanta AND (YEAR(m.FechaHora) = YEAR(GETDATE())) AND (m.FechaHora = f.MaxFecha)

--Fin Consulta a

--Inicio Consulta b
SELECT p.Id, p.Nombre, COUNT(*) AS CountMantenimientos
FROM Plantas p, Mantenimientos m
WHERE p.Id = m.IdPlanta
GROUP BY p.Id, p.Nombre
HAVING COUNT(*) >= ALL((SELECT COUNT(*) AS CountMantenimientos FROM Mantenimientos GROUP BY IdPlanta))

--Fin Consulta b

--Inicio Consulta c
SELECT p.Id, p.Nombre, p.FechaNacimiento, p.Altura, p.UltimaMedida, p.Precio
FROM Plantas p
WHERE YEAR(p.FechaNacimiento) <= 2019
GROUP BY p.Id, p.Nombre, p.FechaNacimiento, p.Altura, p.UltimaMedida, p.Precio
HAVING (SELECT (CASE WHEN o.TotOp IS NULL THEN 0 WHEN o.TotOp IS NOT NULL THEN o.TotOp END) + (CASE WHEN pn.TotNut IS NULL THEN 0 WHEN pn.TotNut IS NOT NULL THEN pn.TotNut END) AS Tot
		FROM (SELECT SUM(Costo) AS TotOp
			  FROM Operativos
			  WHERE YEAR(FechaHora) = YEAR(GETDATE()) AND p.Id = IdPlanta) o,
			 (SELECT SUM(Cantidad*Precio) AS TotNut
			  FROM ProductoNutriente 
			  WHERE YEAR(FechaHora) = YEAR(GETDATE()) AND p.Id = IdPlanta) pn
		) > (SELECT (CASE WHEN o.TotOp IS NULL THEN 0 WHEN o.TotOp IS NOT NULL THEN o.TotOp END) + (CASE WHEN pn.TotNut IS NULL THEN 0 WHEN pn.TotNut IS NOT NULL THEN pn.TotNut END) AS Tot
				 FROM (SELECT SUM(Costo) AS TotOp
					   FROM Operativos
					   WHERE YEAR(FechaHora) = YEAR(GETDATE()) - 1 AND p.Id = IdPlanta) o,
					  (SELECT SUM(Cantidad*Precio) AS TotNut
					   FROM ProductoNutriente 
					   WHERE YEAR(FechaHora) = YEAR(GETDATE()) - 1 AND p.Id = IdPlanta) pn
				)*0.2

--Fin Consulta c

--Inicio Consulta d
select p.* 
from PlantaTAG pt, Plantas p, TAG t 
where pt.IdPlanta=p.Id and pt.IdTAG=t.id and t.Nombre='FRUTAL' and pt.IdPlanta in (select IdPlanta from PlantaTAG pt, Plantas p, TAG t 
																					where pt.IdPlanta=p.Id and pt.IdTAG=t.id and t.Nombre='PERFUMA')
																and pt.IdPlanta not in(select IdPlanta from PlantaTAG pt, Plantas p, TAG t 
																						where pt.IdPlanta=p.Id and pt.IdTAG=t.id and t.Nombre='TRONCOROTO')
																and p.Altura>50 
																and p.Precio IS NOT NULL

--Fin Consulta d

--Inicio Consulta e
SELECT DISTINCT p.*
FROM Plantas p, Mantenimientos m, (SELECT IdPlanta
								   FROM ProductoNutriente
								   GROUP BY IdPlanta
								   HAVING COUNT(DISTINCT CODIGO) = (SELECT COUNT(*) FROM Productos)
								   ) pn
WHERE p.Id = m.IdPlanta AND p.Id = pn.IdPlanta

--Fin Consulta e

--Inicio Consulta f
SELECT p.Id, (o.Costos + pr.Precios) as CostoTotal
FROM Plantas p, (SELECT IdPlanta, SUM(Costo) as Costos
				FROM Operativos
				GROUP BY IdPlanta) o,
				(SELECT IdPlanta, SUM(Precio) as Precios
				FROM ProductoNutriente
				GROUP BY IdPlanta) pr
WHERE p.Id = o.IdPlanta AND  p.Id = pr.IdPlanta AND DATEDIFF (YEAR,FechaNacimiento,getdate())>=2 AND p.precio<200 AND ((o.Costos + pr.Precios) > 100)

--Fin Consulta f