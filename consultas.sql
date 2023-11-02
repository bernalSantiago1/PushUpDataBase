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