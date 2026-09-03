# Sistema de producción y ventas — base de datos relacional

Modelo relacional en **MySQL** para una empresa de confección: ubicación geográfica, clientes, empleados, proveedores, órdenes de producción, inventario de prendas y ventas.

Este repositorio documenta el diseño del esquema, las relaciones entre entidades y un conjunto de consultas SQL sobre el modelo. Forma parte de mi portafolio como proyecto de bases de datos relacionales.

## Contexto

El punto de partida fue un **diagrama entidad-relación (DER)** de un caso de producción textil. A partir de ese modelo se implementó el esquema en SQL: tablas, claves primarias, claves foráneas y tablas intermedias para relaciones muchos a muchos.

El objetivo no es una aplicación con interfaz, sino demostrar cómo se traduce un DER a un esquema normalizado y cómo se consultan los datos con joins, filtros y agrupaciones.

![Diagrama entidad-relación](https://raw.githubusercontent.com/CampusLands/DER/main/DER.jpg)

## Qué cubre el modelo

| Área | Entidades principales | Para qué sirve |
| --- | --- | --- |
| Ubicación | `pais`, `departamento`, `municipio` | Jerarquía geográfica de empresas, clientes, empleados y proveedores |
| Organización | `empresa`, `cargos`, `empleado` | Datos de la empresa y el personal |
| Actores | `cliente`, `proveedor`, `tipo_persona` | Quién compra, quién suministra |
| Producción | `orden`, `detalle_orden`, `prenda`, `estado` | Órdenes de confección y estado del proceso |
| Producto | `color`, `genero`, `tipo_proteccion`, `talla` | Atributos de cada prenda |
| Insumos | `insumo`, `insumo_proveedor`, `insumo_prendas` | Materiales, quién los provee y cuánto usa cada prenda |
| Inventario | `inventario`, `inventario_talla` | Stock por prenda y talla |
| Comercial | `venta`, `detalle_venta`, `forma_pago` | Ventas, líneas de detalle y medio de pago |

### Relaciones destacadas

- **Uno a muchos:** un municipio tiene muchos clientes; un empleado registra muchas ventas; una orden tiene varios detalles.
- **Muchos a muchos:** un proveedor puede suministrar varios insumos (`insumo_proveedor`); una prenda usa varios insumos (`insumo_prendas`); un ítem de inventario puede existir en varias tallas (`inventario_talla`).
- **Catálogos:** cargos, formas de pago, colores, estados y tipos de persona se modelan como tablas de referencia para evitar datos duplicados.

## Cómo se construyó

1. **Análisis del DER:** identificar entidades, atributos y cardinalidades (1:N y N:M).
2. **Traducción a tablas:** cada entidad fuerte se convierte en tabla; las relaciones N:M se resuelven con tablas puente.
3. **Integridad referencial:** `PRIMARY KEY`, `AUTO_INCREMENT` y `FOREIGN KEY` para mantener consistencia entre registros.
4. **Consultas:** joins (`INNER JOIN`), filtros (`WHERE`), funciones de fecha (`YEAR`) y agregaciones (`COUNT`, `GROUP BY`) sobre el esquema.

## Tecnologías

- **MySQL** — motor relacional
- **SQL DDL** — creación de la base `produccion` y de las tablas (`database.sql`)
- **SQL DML / DQL** — consultas de negocio (`consultas.sql`)

## Estructura del repositorio

```
.
├── database.sql    # CREATE DATABASE y CREATE TABLE
├── consultas.sql   # Consultas de ejemplo
└── README.md
```

## Cómo ejecutarlo

Requisitos: MySQL (o MariaDB) instalado y un cliente (`mysql`, MySQL Workbench, DBeaver, etc.).

```bash
mysql -u root -p < database.sql
```

Luego abre `consultas.sql` y ejecuta las sentencias sobre la base `produccion`. El script de esquema no incluye datos de prueba: las consultas asumen que las tablas ya tienen registros.

## Consultas de ejemplo

Las mismas sentencias están en [`consultas.sql`](consultas.sql).

**1. Ventas del año 2023**

```sql
SELECT * FROM venta WHERE YEAR(Fecha) = 2023;
```

**2. Empleados con cargo y municipio**

```sql
SELECT empleado.Id, empleado.nombre, empleado.fecha_ingreso, cargos.descripcion, municipio.nombre
FROM empleado
INNER JOIN cargos ON empleado.IdCargoFk = cargos.Id
INNER JOIN municipio ON empleado.IdMunicipioFk = municipio.Id;
```

**3. Ventas con cliente y forma de pago**

```sql
SELECT venta.Id, venta.Fecha, cliente.nombre, forma_pago.descripcion
FROM venta
INNER JOIN cliente ON venta.IdClienteFk = cliente.Id
INNER JOIN forma_pago ON venta.IdFormaPagoFk = forma_pago.Id;
```

**4. Detalle de órdenes con empleado y cliente**

```sql
SELECT orden.Id, orden.fecha, detalle_orden.cantidad_producir, detalle_orden.cantidad_producida,
       empleado.nombre AS Empleado, cliente.nombre AS cliente
FROM orden
INNER JOIN detalle_orden ON orden.Id = detalle_orden.IdOrdenFk
INNER JOIN empleado ON orden.IdEmpleadoFk = empleado.Id
INNER JOIN cliente ON orden.IdClienteFk = cliente.Id;
```

**5. Prendas en inventario con talla y color**

```sql
SELECT p.Id, p.Nombre, p.ValorUnitCop, p.ValorUnitUsd, e.descripcion AS Estado,
       t.descripcion AS Talla, c.Descripcion AS Color
FROM prenda p
INNER JOIN estado e ON p.IdEstadoFk = e.Id
INNER JOIN inventario ON p.Id = inventario.IdPrendaFk
INNER JOIN inventario_talla i ON inventario.Id = i.IdInvFk
INNER JOIN talla t ON i.IdTallaFk = t.Id
INNER JOIN detalle_orden d ON p.Id = d.IdPrendaFk
INNER JOIN color c ON d.IdColorFk = c.Id;
```

**6. Proveedores e insumos que suministran**

```sql
SELECT p.Id, p.NitProveedor, p.Nombre, i.nombre AS Insumo
FROM proveedor p
INNER JOIN insumo_proveedor ip ON p.Id = ip.IdProveedorFk
INNER JOIN insumo i ON ip.IdInsumoFk = i.Id;
```

**7. Cantidad de ventas por empleado**

```sql
SELECT e.nombre, COUNT(*) AS cantidad_ventas
FROM empleado e
INNER JOIN venta v ON e.Id = v.IdEmpleadoFk
GROUP BY e.Id;
```

**8. Órdenes en proceso, con cliente y empleado**

```sql
SELECT o.Id, o.fecha, e.descripcion AS Estado, c.nombre AS Cliente, em.nombre AS Empleado
FROM orden o
INNER JOIN estado e ON o.IdEstadoFk = e.Id
INNER JOIN cliente c ON o.IdClienteFk = c.Id
INNER JOIN empleado em ON o.IdEmpleadoFk = em.Id
WHERE e.descripcion = "En proceso";
```

**9. Empresa, representante legal y municipio**

```sql
SELECT e.Id, e.razon_social AS Nombre, e.representante_legal, m.nombre AS Municipio
FROM empresa e
INNER JOIN municipio m ON e.IdMunicipioFk = m.Id;
```

**10. Prendas e insumos asociados (cantidad por prenda)**

```sql
SELECT p.Id, p.Nombre, p.ValorUnitCop, p.ValorUnitUsd, p.Codigo, i.Cantidad AS Stock
FROM prenda p
INNER JOIN insumo_prendas i ON p.Id = i.IdPrendaFk;
```

**11. Clientes con compra en una fecha concreta**

```sql
SELECT c.Id, c.nombre, v.Fecha AS Fecha_compra, do.cantidad_producida AS Cantidad
FROM cliente c
INNER JOIN venta v ON c.Id = v.IdClienteFk
INNER JOIN orden o ON c.Id = o.IdClienteFk
INNER JOIN detalle_orden do ON o.Id = do.IdOrdenFk
WHERE v.Fecha = "2023-08-10";
```

## Qué demuestra este proyecto

- Modelado relacional a partir de un DER (normalización, claves y cardinalidades).
- Integridad referencial con claves foráneas en MySQL.
- Consultas con joins, filtros y agregaciones sobre un dominio de producción y ventas.
