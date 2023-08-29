IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'ObliDB2')
BEGIN
	CREATE DATABASE ObliDB2
END
GO

USE ObliDB2
GO

CREATE TABLE TAG(
	Id INT IDENTITY(1,1),
	Nombre NVARCHAR(30)

	CONSTRAINT PK_TAG PRIMARY KEY (Id),
	CONSTRAINT CK_TAG CHECK (Nombre in ('FRUTAL','SINFLOR','CONFLOR','SOMBRA','HIERBA','PERFUMA','TRONCODOBLADO','TRONCOROTO'))--Agregamos TRONCOROTO porque estaba en la consulta d
)

CREATE TABLE Plantas(
	Id INT IDENTITY(1,1),
	Nombre NVARCHAR(30) NOT NULL,
	FechaNacimiento DATETIME NOT NULL,
	Altura NUMERIC(5),
	UltimaMedida DATETIME,
	Precio DECIMAL(8,2)

	CONSTRAINT PK_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Altura CHECK (Altura < 12000),
	CONSTRAINT CK_FechaNacimiento CHECK (FechaNacimiento <= GETDATE()),
	CONSTRAINT CK_UltimaMedida_FechaNacimiento CHECK (UltimaMedida > FechaNacimiento),
	CONSTRAINT CK_PrecioPlanta CHECK (Precio > 0)
)

GO

CREATE TABLE PlantaTAG(
	IdPlanta INT,
	IdTAG INT

	CONSTRAINT PK_Planta_TAG PRIMARY KEY (IdPlanta, IdTAG),
	CONSTRAINT FK_IdPlanta FOREIGN KEY (IdPlanta) REFERENCES Plantas(Id),
	CONSTRAINT FK_IdTAG FOREIGN KEY (IdTAG) REFERENCES TAG(Id)
)

GO

CREATE TABLE Productos(
	Codigo NVARCHAR(5),
	Descripcion NVARCHAR(256) UNIQUE NOT NULL,
	Precio DECIMAL(8,2) NOT NULL

	CONSTRAINT PK_CodigoProducto PRIMARY KEY (Codigo),
	CONSTRAINT CK_Codigo CHECK (LEN(Codigo) = 5),
	CONSTRAINT CK_PrecioProducto CHECK (Precio > 0)
)

CREATE TABLE Mantenimientos(
	IdPlanta INT,
	FechaHora DATETIME,
	Descripcion NVARCHAR(256) NOT NULL

	CONSTRAINT PK_Mantenimiento PRIMARY KEY (IdPlanta, FechaHora),
	CONSTRAINT FK_IdPlanta_Mantenimiento FOREIGN KEY (IdPlanta) REFERENCES Plantas(Id),
	CONSTRAINT CK_Fecha_Mantenimiento CHECK (FechaHora <= GETDATE())
)
GO

CREATE TABLE Operativos(
	IdPlanta INT,
	FechaHora DATETIME,
	CantidadHoras DECIMAL(4,2) NOT NULL,
	Costo DECIMAL(8,2) NOT NULL

	CONSTRAINT PK_Operativo PRIMARY KEY (IdPlanta, FechaHora),
	CONSTRAINT FK_Operativo FOREIGN KEY (IdPlanta, FechaHora) REFERENCES Mantenimientos(IdPlanta, FechaHora),
	CONSTRAINT CK_CostoOperativo CHECK (Costo > 0),
	CONSTRAINT CK_CantidadHorasOperativo CHECK (CantidadHoras > 0)
)

CREATE TABLE Nutrientes(
	IdPlanta INT,
	FechaHora DATETIME

	CONSTRAINT PK_Nutrientes PRIMARY KEY (IdPlanta, FechaHora),
	CONSTRAINT FK_Nutrientes FOREIGN KEY (IdPlanta, FechaHora) REFERENCES Mantenimientos(IdPlanta, FechaHora),
)

GO

CREATE TABLE ProductoNutriente(
	IdPlanta INT,
	FechaHora DATETIME,
	Codigo NVARCHAR(5),
	Cantidad INT NOT NULL,
	Precio DECIMAL(8,2) NOT NULL

	CONSTRAINT PK_ProductoNutriente PRIMARY KEY (IdPlanta, FechaHora, Codigo),
	CONSTRAINT FK_ProductoNutriente_Nutriente FOREIGN KEY (IdPlanta, FechaHora) REFERENCES Nutrientes(IdPlanta, FechaHora),
	CONSTRAINT FK_ProductoNutriente_Producto FOREIGN KEY (Codigo) REFERENCES Productos(Codigo),
	CONSTRAINT CK_Cantidad CHECK (Cantidad > 0),
	CONSTRAINT CK_Precio_ProductoNutriente CHECK (Precio > 0)
)

GO

CREATE TABLE AuditoriaProducto(
	Id INT IDENTITY(1,1),
	Host NVARCHAR(50),
	FechaHora DATETIME,
	Usuario NVARCHAR(50),
	Operacion NVARCHAR(50),
	CodigoAnterior NVARCHAR(5),
	CodigoActual NVARCHAR(5),
	DescripcionAnterior NVARCHAR(256),
	DescripcionActual NVARCHAR(256),
	PrecioAnterior DECIMAL(8,2),
	PrecioActual DECIMAL(8,2),
	Observaciones NVARCHAR(256),

	CONSTRAINT PK_AuditoriaProducto PRIMARY KEY (Id)
)
GO

CREATE INDEX I_Mantenimientos_IdPlanta ON Mantenimientos(IdPlanta)

CREATE INDEX I_Nutrientes_IdPlanta ON Nutrientes(IdPlanta)

CREATE INDEX I_Operativos_IdPlanta ON Operativos(IdPlanta)

CREATE INDEX I_PlantaTAG_IdPlanta ON PlantaTAG(IdPlanta)

CREATE INDEX I_PlantaTAG_IdTAG ON PlantaTAG(IdTAG)

CREATE INDEX I_ProductoNutriente_IdPlanta ON ProductoNutriente(IdPlanta)

CREATE INDEX I_ProductoNutriente_Codigo ON ProductoNutriente(Codigo)

CREATE INDEX I_TAG_Nombre ON TAG(Nombre) --No es Foreign Key, pero se usa en consultas.