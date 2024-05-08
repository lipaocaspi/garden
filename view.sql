CREATE VIEW datos_empleados AS
SELECT p.nombre_puesto, e.nombre, e.apellido1, e.apellido2, e.email
FROM puesto AS p, empleado AS e
WHERE p.codigo_puesto = e.codigo_puesto;

CREATE VIEW pedidos_rechazados AS
SELECT p.codigo_pedido, p.fecha_pedido, p.fecha_esperada, p.fecha_entrega, p.comentarios, p.codigo_cliente, e.nombre_estado
FROM pedido AS p, estado AS e
WHERE p.codigo_estado = e.codigo_estado AND e.nombre_estado = 'Rechazado';

CREATE VIEW pagos_paypal AS
SELECT p.id_transaccion, p.fecha_pago, p.total, p.codigo_cliente, f.nombre_forma
FROM pago AS p, forma_pago AS f
WHERE p.codigo_forma = f.codigo_forma AND f.nombre_forma = 'Paypal';

CREATE VIEW representantes_clientes AS
SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS primer_apellido, e.apellido2 AS segundo_apellido
FROM cliente AS c
INNER JOIN empleado AS e
ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

CREATE VIEW empleados_jefes AS
SELECT e1.nombre AS nombre_empleado, e1.apellido1 AS apellido_empleado, e2.nombre AS nombre_jefe, e2.apellido1 AS apellido_jefe
FROM empleado AS e1
INNER JOIN empleado AS e2
ON e1.codigo_jefe = e2.codigo_empleado;

CREATE VIEW empleados_sin_clientes AS
SELECT e.nombre, e.apellido1, e.apellido2, p.nombre_puesto, t.numero_telefono
FROM empleado AS e, puesto AS p, oficina AS o, telefono AS t
WHERE e.codigo_puesto = p.codigo_puesto
AND e.codigo_oficina = o.codigo_oficina
AND o.codigo_oficina = t.codigo_oficina
AND e.codigo_empleado NOT IN (
	SELECT c.codigo_empleado_rep_ventas
    FROM cliente AS c
);

CREATE VIEW pagos_por_año AS
SELECT YEAR(p.fecha_pago) AS año_pago, SUM(p.total) AS total_pagos
FROM pago AS p
GROUP BY YEAR(p.fecha_pago);

CREATE VIEW representantes_numero_clientes AS
SELECT e.nombre AS nombre_representante, e.apellido1 AS apellido_representante, COUNT(c.codigo_cliente) AS numero_clientes
FROM empleado AS e
INNER JOIN cliente AS c
ON c.codigo_empleado_rep_ventas = e.codigo_empleado
GROUP BY e.nombre, e.apellido1;

CREATE VIEW pedidos_entregados AS
SELECT p.codigo_pedido, p.fecha_pedido, p.fecha_esperada, p.fecha_entrega, p.comentarios, p.codigo_cliente, e.nombre_estado
FROM pedido AS p, estado AS e
WHERE p.codigo_estado = e.codigo_estado AND e.nombre_estado = 'Entregado';

CREATE VIEW clientes_pagos AS
SELECT DISTINCT(c.nombre_cliente), e.nombre AS nombre_representante, e.apellido1 AS apellido_representante
FROM cliente AS c
INNER JOIN empleado AS e
ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN pago AS p
ON p.codigo_cliente = c.codigo_cliente;