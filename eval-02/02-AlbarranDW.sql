-- DimensionCliente
--
SELECT
	cli.cliente_id AS IdCliente,
	cli.nombre + ' ' + cli.appaterno + ' ' + cli.apmaterno as NombreApellidos,
	cli.estado_civil AS EstadoCivil,
	CASE cli.sexo
		WHEN 'M' THEN 'Masculino'
		WHEN 'F' THEN 'Femenino'
		ELSE 'Otro sexo'
	END AS Sexo,
	CAST(cli.fecha_nacimiento AS date) AS FechaNacimiento
FROM
	Albarran.dbo.clientes as cli;

-- DimsensionEmpleado
--
SELECT
	e.empleado_id AS IdEmpleado,
	e.nombre + ' ' + e.appaterno + ' ' + e.apmaterno AS NombreEmpleado,
	c.nombre AS Cargo
FROM
	Albarran.dbo.empleados AS e
	INNER JOIN Albarran.dbo.cargos c ON e.cargo_id = c.cargo_id;

-- DimensionSucursal
--
SELECT
	su.sucursal_id AS IdSucursal,
	su.sucursal AS Nombre,
	co.comuna
FROM
	Albarran.dbo.sucursales AS su
	INNER JOIN Albarran.dbo.comunas co on su.comuna_id = co.comuna_id;

-- Dimension Tiempo
--
SELECT DISTINCT
	CAST(v.fecha AS date) AS Fecha,
	YEAR (v.fecha) AS Año,
	MONTH (v.fecha) AS Mes,
	DATEPART (ISOWK, v.fecha) AS Semana
FROM
	ventas v;

-- HechoVenta
--
SELECT
	v.venta_id AS IdVenta,
	(sum(dv.cantidad) * dv.precio_unitario) AS MontoVenta,
	v.cliente_id AS IdCliente,
	v.vendedor_id AS IdEmpleado,
	v.sucursal_id AS IdSucursal,
	sum(dv.cantidad) AS CantidadDeProductos,
	dt.IdDimensionTiempo
FROM
	Albarran.dbo.ventas v
	INNER JOIN Albarran.dbo.detalle_ventas dv ON v.venta_id = dv.venta_id
	INNER JOIN AlbarranDW.dbo.DimensionTiempo dt ON cast(v.fecha as date) = dt.Fecha
GROUP BY
	v.venta_id,
	dv.precio_unitario,
	dv.cantidad,
	v.cliente_id,
	v.vendedor_id,
	v.sucursal_id,
	dt.IdDimensionTiempo;

-- DimensionDetalleVenta
--
SELECT
	pr.nombre AS NombreDeProducto,
	pr.precio AS PrecioUnitario,
	dv.cantidad AS CantidadDeProductos,
	ca.categoria AS CategoriaDeProducto,
	ve.venta_id AS IdVenta
FROM
	detalle_ventas AS dv
	INNER JOIN Albarran.dbo.productos AS pr ON dv.producto_id = pr.producto_id
	INNER JOIN Albarran.dbo.categorias ca ON pr.categoria_id = ca.categoria_id
	INNER JOIN Albarran.dbo.ventas AS ve ON ve.venta_id = dv.venta_id;