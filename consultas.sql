SELECT * FROM venta WHERE YEAR(Fecha) = 2023;

SELECT empleado.Id, empleado.nombre, empleado.fecha_ingreso, cargos.descripcion, municipio.nombre
FROM empleado
INNER JOIN cargos ON empleado.IdCargoFk = cargos.Id
INNER JOIN municipio ON empleado.IdMunicipioFk = municipio.Id;

SELECT venta.Id, venta.Fecha, cliente.nombre, forma_pago.descripcion
FROM venta
INNER JOIN cliente ON venta.IdClienteFk = cliente.Id
INNER JOIN forma_pago ON venta.IdFormaPagoFk = forma_pago.Id;

SELECT orden.Id, orden.fecha, detalle_orden.cantidad_producir, detalle_orden.cantidad_producida, empleado.nombre AS Empleado, cliente.nombre AS cliente
FROM orden
INNER JOIN detalle_orden ON orden.Id = detalle_orden.IdOrdenFk
INNER JOIN empleado ON orden.IdEmpleadoFk = empleado.Id
INNER JOIN cliente ON orden.IdClienteFk = cliente.Id;

SELECT p.Id, p.Nombre, p.ValorUnitCop, p.ValorUnitUsd, e.descripcion AS Estado, t.descripcion AS Talla, c.Descripcion AS Color
FROM prenda p
INNER JOIN estado e ON p.IdEstadoFk = e.Id
INNER JOIN inventario ON p.Id = inventario.IdPrendaFk
INNER JOIN inventario_talla i ON inventario.Id = i.IdInvFk
INNER JOIN talla t ON i.IdTallaFk = t.Id
INNER JOIN detalle_orden d ON p.Id = d.IdPrendaFk
INNER JOIN color c ON d.IdColorFk = c.Id;

SELECT p.Id, p.NitProveedor, p.Nombre, i.nombre AS Insumo
FROM proveedor p
INNER JOIN insumo_proveedor ip ON p.Id = ip.IdProveedorFk
INNER JOIN insumo i ON ip.IdInsumoFk = i.Id;

SELECT e.nombre, COUNT(*) AS cantidad_ventas
FROM empleado e
INNER JOIN venta v ON e.Id = v.IdEmpleadoFk
GROUP BY e.Id;

SELECT  o.Id, o.fecha, e.descripcion AS Estado, c.nombre AS Cliente, em.nombre AS Empleado 
FROM orden o
INNER JOIN estado e ON o.IdEstadoFk = e.Id
INNER JOIN cliente c ON o.IdClienteFk = c.Id
INNER JOIN empleado em ON o.IdEmpleadoFk = em.Id
WHERE e.descripcion = "En proceso";

SELECT e.Id, e.razon_social as Nombre, e.representante_legal, m.nombre AS Municipio
FROM empresa e
INNER JOIN municipio m ON e.IdMunicipioFk = m.Id;

SELECT p.Id, p.Nombre, p.ValorUnitCop, p.ValorUnitUsd, p.Codigo, i.Cantidad AS Stock
FROM prenda p
INNER JOIN insumo_prendas i ON p.Id = i.IdPrendaFk;

SELECT c.Id, c.nombre, v.Fecha as Fecha_compra, do.cantidad_producida AS Cantidad
FROM cliente c
INNER JOIN venta v ON c.Id = v.IdClienteFk
INNER JOIN orden o ON c.Id = o.IdClienteFk
INNER JOIN detalle_orden do ON o.Id = do.IdOrdenFk
WHERE v.Fecha = "2023-08-10";