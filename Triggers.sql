USE ObliDB2
GO
--Inicio Trigger para restriccion de letra: 
/*
Se registra la fecha-hora en la que fue medida por última vez ( si la altura de la planta
está registrada, esta fecha-hora no puede ser nula y tampoco puede ser menor a la fecha de
nacimiento)
*/
CREATE TRIGGER Tr_UltimaMedidaNull ON Plantas INSTEAD OF INSERT, UPDATE
AS
	BEGIN
		SET NOCOUNT ON
		DECLARE @Id INT
		DECLARE @Nombre NVARCHAR(30)
		DECLARE @FechaNacimiento DATETIME
		DECLARE @Altura NUMERIC(5,0)
		DECLARE @UltimaMedida DATETIME
		DECLARE @Precio DECIMAL(8,2)

		SELECT @Id = Id, @Nombre = Nombre, @FechaNacimiento = FechaNacimiento, @Altura = Altura, @UltimaMedida = UltimaMedida, @Precio = Precio
		FROM inserted

		IF(@Altura IS NOT NULL)
			BEGIN
				IF (@UltimaMedida IS NOT NULL AND @UltimaMedida > @FechaNacimiento)
					BEGIN
						IF EXISTS(SELECT * FROM deleted)--update
							BEGIN
								UPDATE Plantas
								SET Nombre = @Nombre, FechaNacimiento = @FechaNacimiento, Altura = @Altura, UltimaMedida = @UltimaMedida, Precio = @Precio
								WHERE Id = @Id

								PRINT 'Modificado correctamente'
							END
						ELSE--insert
							BEGIN
								INSERT INTO Plantas
								VALUES(@Nombre, @FechaNacimiento, @Altura, @UltimaMedida, @Precio)
								PRINT 'Insertado correctamente'
							END
					END
				ELSE
					BEGIN
						PRINT 'Si la altura no es vacia, se debe especificar la fecha de la ultima medida. La misma debe ser mayor que la fecha de nacimiento de la planta.'
					END
			END
		ELSE 
			BEGIN
				IF (@UltimaMedida IS NULL)
					BEGIN
						IF EXISTS(SELECT * FROM deleted)
							BEGIN
								UPDATE Plantas
								SET Nombre = @Nombre, FechaNacimiento = @FechaNacimiento, Altura = @Altura, UltimaMedida = @UltimaMedida, Precio = @Precio
								WHERE Id = @Id

								PRINT 'Modificado correctamente'
							END
						ELSE
							BEGIN
								INSERT INTO Plantas
								VALUES(@Nombre, @FechaNacimiento, @Altura, @UltimaMedida, @Precio)
								PRINT 'Insertado correctamente'
							END
					END
				ELSE
					BEGIN
						PRINT 'La altura es vacia pero la ultima medida no lo es.'
					END
			END
	END
GO

--Fin Trigger para restriccion de letra

--Trigger 4a
--Inicio trigger Insert en Auditoria
CREATE TRIGGER Tr_AuditarProductosInsert ON Productos AFTER INSERT
AS 
	BEGIN
		INSERT INTO AuditoriaProducto	SELECT HOST_NAME(), GETDATE(), (SELECT SYSTEM_USER), 'Insert', NULL, Codigo, NULL, Descripcion, NULL, Precio, 'Se inserto el producto ' + Codigo
										FROM inserted
		END
GO

--Fin trigger Insert en Auditoria

--Inicio trigger Delete en Auditoria
CREATE TRIGGER Tr_AuditarProductosDelete ON Productos AFTER DELETE
AS 
	BEGIN
		INSERT INTO AuditoriaProducto	SELECT HOST_NAME(), GETDATE(), (SELECT SYSTEM_USER), 'Delete', Codigo, NULL, Descripcion, NULL, Precio, NULL, 'Se borro el producto ' + Codigo
										FROM deleted
	END
GO

--Fin trigger Delete en Auditoria

--Inicio trigger Update en Auditoria
CREATE TRIGGER Tr_AuditarProductosUpdate ON Productos AFTER UPDATE
AS 
	BEGIN

		INSERT INTO AuditoriaProducto	SELECT HOST_NAME(), GETDATE(), (SELECT SYSTEM_USER), 'Update', d.Codigo, i.Codigo, d.Descripcion, i.Descripcion, d.Precio, i.Precio, 'Se modifico el producto ' + i.Codigo
										FROM deleted d, inserted i
	END
GO

--Fin trigger Update en Auditoria

--Inicio Trigger 4b
CREATE TRIGGER Tr_InsertMantenimiento ON Mantenimientos INSTEAD OF INSERT
AS
	BEGIN
		DECLARE @FechaNacimientoPlanta DATETIME
		DECLARE @IdPlanta INT
		DECLARE @Descripcion NVARCHAR(256)
		DECLARE @FechaHora DATETIME

		SELECT @IdPlanta = IdPlanta, @FechaHora = FechaHora, @Descripcion = Descripcion
		FROM inserted

		SELECT @FechaNacimientoPlanta = FechaNacimiento
		FROM Plantas
		WHERE Id = @IdPlanta

		IF(@FechaNacimientoPlanta <= @FechaHora)
			BEGIN
				INSERT INTO Mantenimientos
				VALUES(@IdPlanta, @FechaHora, @Descripcion)
				
				SELECT * FROM Mantenimientos WHERE IdPlanta = @IdPlanta AND FechaHora = @FechaHora
			END
		ELSE
			BEGIN
				PRINT 'Fecha de mantenimiento menor a la fecha de nacimiento de la planta'
			END
	END
GO

--Fin Trigger 4b