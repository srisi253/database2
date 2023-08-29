USE ObliDB2
GO

INSERT INTO Plantas VALUES('Begonia rex', DATEADD(yy, -3, GETDATE()), 50, GETDATE(), 50)
INSERT INTO Plantas VALUES('Begonia rex 1', DATEADD(yy, -2, GETDATE()), 50, GETDATE(), 50)
INSERT INTO Plantas VALUES('Begonia rex 2', DATEADD(yy, -2, GETDATE()), 50, GETDATE(), 300)
INSERT INTO Plantas VALUES('Begonia rex 3', DATEADD(yy, -1, GETDATE()), 50, GETDATE(), 50)
INSERT INTO Plantas VALUES('Asplenium nidus', DATEADD(yy, -4, GETDATE()), 50, GETDATE(), 50)
INSERT INTO Plantas VALUES('Asplenium nidus 1', DATEADD(yy, -3, GETDATE()), 50, GETDATE(), 16)
INSERT INTO Plantas VALUES('Asplenium nidus 2', DATEADD(yy, -4, GETDATE()), 50, GETDATE(), 300)
INSERT INTO Plantas VALUES('Asplenium nidus 3', DATEADD(yy, -5, GETDATE()), 50, GETDATE(), 100)
INSERT INTO Plantas VALUES('H. rosa-sinensis', DATEADD(yy, -4, GETDATE()), 20, GETDATE(), 50)
INSERT INTO Plantas VALUES('H. rosa-sinensis 1', DATEADD(yy, -3, GETDATE()), 30, GETDATE(), 16)
INSERT INTO Plantas VALUES('H. rosa-sinensis 2', DATEADD(yy, -4, GETDATE()), 51, GETDATE(), 300)
INSERT INTO Plantas VALUES('H. rosa-sinensis 3', DATEADD(yy, -5, GETDATE()), 100, GETDATE(), 100)
INSERT INTO Plantas VALUES('Mangifera indica', DATEADD(yy, -4, GETDATE()), 20, GETDATE(), 50)
INSERT INTO Plantas VALUES('Mangifera indica 1', DATEADD(yy, -3, GETDATE()), 30, GETDATE(), 16)
INSERT INTO Plantas VALUES('Mangifera indica 2', DATEADD(yy, -4, GETDATE()), 51, GETDATE(), 300)
INSERT INTO Plantas VALUES('Mangifera indica 3', DATEADD(yy, -5, GETDATE()), 100, GETDATE(), 100)
INSERT INTO Plantas VALUES('Jazmin', DATEADD(yy, -5, GETDATE()), 110, GETDATE(), 250)
INSERT INTO Plantas VALUES('Olivo', DATEADD(yy, -5, GETDATE()), 120, GETDATE(), 700)


INSERT INTO TAG VALUES
('FRUTAL'),
('SINFLOR'),
('CONFLOR'),
('SOMBRA'),
('HIERBA'),
('PERFUMA'),
('TRONCODOBLADO'),
('TRONCOROTO')

INSERT INTO Productos VALUES('P0001', 'Detalle producto 1', 900.00)
INSERT INTO Productos VALUES('P0002', 'Detalle producto 2', 700.00)
INSERT INTO Productos VALUES('P0003', 'Detalle producto 3', 300.00)
INSERT INTO Productos VALUES('P0004', 'Detalle producto 4', 20.00)
INSERT INTO Productos VALUES('P0005', 'Detalle producto 5', 20.00)

INSERT INTO PlantaTAG VALUES
(1,1),
(1,6),
(1,8),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,1),
(9,2),
(10,3),
(11,4),
(12,5),
(17,6),
(17,1),
(18,1)

INSERT INTO Mantenimientos VALUES(1, DATEADD(dd, -4, GETDATE()), 'Mantenimiento 1 Planta 1')
INSERT INTO Mantenimientos VALUES(1, DATEADD(dd, -3, GETDATE()), 'Mantenimiento 2 Planta 1')
INSERT INTO Mantenimientos VALUES(1, DATEADD(dd, -2, GETDATE()), 'Mantenimiento 3 Planta 1')
INSERT INTO Mantenimientos VALUES(1, DATEADD(dd, -1, GETDATE()), 'Mantenimiento 4 Planta 1')
INSERT INTO Mantenimientos VALUES(2, DATEADD(yy, -2, GETDATE()), 'Mantenimiento 1 Planta 2')
INSERT INTO Mantenimientos VALUES(2, DATEADD(yy, -1, GETDATE()), 'Mantenimiento 2 Planta 2')
INSERT INTO Mantenimientos VALUES(3, DATEADD(dd, -2, GETDATE()), 'Mantenimiento 1 Planta 3')
INSERT INTO Mantenimientos VALUES(3, DATEADD(dd, -1, GETDATE()), 'Mantenimiento 2 Planta 3')
INSERT INTO Mantenimientos VALUES(1, DATEADD(yy, -1, GETDATE()), 'Mantenimiento 5 Planta 1')
INSERT INTO Mantenimientos VALUES(1, DATEADD(dd, -1, DATEADD(yy, -1, GETDATE())), 'Mantenimiento 6 Planta 1')

INSERT INTO Nutrientes VALUES
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 1')),
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 2 Planta 1')),
(2,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 2')),
(3,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 3'))

INSERT INTO Operativos VALUES
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 3 Planta 1'),12.25, 101.23),
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 4 Planta 1'),2.5, 91.50),
(2,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 2 Planta 2'),10.25, 901.56),
(3,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 3'),21.75, 25.51),
(1, (SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 5 Planta 1'),12,15),
(1, (SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 6 Planta 1'),12,15)

INSERT INTO ProductoNutriente VALUES
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 1'),'P0005',12, 101.23),
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 1'),'P0002',2, 91.50),
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 1'),'P0003',10, 901.56),
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 1'),'P0004',21, 25.51),
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 1'),'P0001',12, 101.23),
(1,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 2 Planta 1'),'P0002',2, 91.50),
(2,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 2'),'P0003',10, 901.56),
(3,(SELECT FechaHora FROM mantenimientos WHERE Descripcion = 'Mantenimiento 1 Planta 3'),'P0004',21, 25.51)