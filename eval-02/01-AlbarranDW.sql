--AlbarranDW
--
CREATE DATABASE AlbarranDW;

--DimensionCliente
--
CREATE TABLE
	AlbarranDW.dbo.DimensionCliente (
		IdCliente int NOT NULL,
		NombresApellidos nvarchar (765) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		EstadoCivil nvarchar (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		Sexo nvarchar (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		FechaNacimiento date NULL,
		CONSTRAINT DimensionClientePK PRIMARY KEY (IdCliente)
	);

--DimensionEmpleado
--
CREATE TABLE
	AlbarranDW.dbo.DimensionEmpleado (
		IdEmpleado int NOT NULL,
		NombreEmpleado nvarchar (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		Cargo nvarchar (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT DimensionEmpleadoPK PRIMARY KEY (IdEmpleado)
	);

--DimensionTiempo
--
CREATE TABLE
	AlbarranDW.dbo.DimensionTiempo (
		IdDimensionTiempo int IDENTITY (1, 1) NOT NULL,
		Fecha date NOT NULL,
		Año int NOT NULL,
		Semana int NOT NULL,
		Mes int NOT NULL,
		CONSTRAINT DimensionTiempoUN UNIQUE (IdDimensionTiempo)
	);

--DimensionSucursal
--
CREATE TABLE
	AlbarranDW.dbo.DimensionSucursal (
		IdSucursal int NOT NULL,
		Nombre nvarchar (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		Comuna nvarchar (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT DimensionSucursalPK PRIMARY KEY (IdSucursal)
	);

--HechoVenta
--
CREATE TABLE
	AlbarranDW.dbo.HechoVenta (
		IdVenta int NOT NULL,
		MontoVenta int NOT NULL,
		IdCliente int NOT NULL,
		IdEmpleado int NOT NULL,
		IdSucursal int NOT NULL,
		CantidadDeProductos int NOT NULL,
		IdDimensionTiempo int NOT NULL,
		CONSTRAINT HechoVentaPK PRIMARY KEY (IdVenta),
		CONSTRAINT DimensionClienteFK FOREIGN KEY (IdCliente) REFERENCES AlbarranDW.dbo.DimensionCliente (IdCliente),
		CONSTRAINT DimensionEmpleadoFK FOREIGN KEY (IdEmpleado) REFERENCES AlbarranDW.dbo.DimensionEmpleado (IdEmpleado),
		CONSTRAINT DimensionSucursalFK FOREIGN KEY (IdSucursal) REFERENCES AlbarranDW.dbo.DimensionSucursal (IdSucursal),
		CONSTRAINT DimensionTiempoFK FOREIGN KEY (IdDimensionTiempo) REFERENCES AlbarranDW.dbo.DimensionTiempo (IdDimensionTiempo)
	);

--DimensionDetalleVenta
--
CREATE TABLE
	AlbarranDW.dbo.DimensionDetalleVenta (
		IdDetalleVenta int IDENTITY (1, 1) NOT NULL,
		NombreDeProducto nvarchar (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		PrecioUnitarioDeProducto int NOT NULL,
		CantidadDeProducto int NOT NULL,
		CategoriaDeProducto nvarchar (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		IdVenta int NOT NULL,
		CONSTRAINT DimensionDetalleVentaPK PRIMARY KEY (IdDetalleVenta),
		CONSTRAINT HechoVentaFK FOREIGN KEY (IdVenta) REFERENCES AlbarranDW.dbo.HechoVenta (IdVenta)
	);