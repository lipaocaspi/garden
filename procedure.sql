DELIMITER $$
CREATE PROCEDURE insert_gama_producto(
	IN gama VARCHAR(50),
    IN descripcion_texto TEXT,
    IN descripcion_html TEXT,
    IN imagen VARCHAR(256)
)
BEGIN
	INSERT INTO gama_producto
    VALUES (gama, descripcion_texto, descripcion_html, imagen);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_producto_codigo(
	IN codigo1 VARCHAR(15),
    IN codigo2 VARCHAR(15)
)
BEGIN
	SELECT DISTINCT(p.nombre), p.gama
	FROM producto AS p
	WHERE p.codigo_producto LIKE CONCAT(codigo1, '%') OR p.codigo_producto LIKE CONCAT(codigo2, '%');
END $$
DELIMITER ;

CALL buscar_producto_codigo('FR', 'OR');

DELIMITER $$
CREATE PROCEDURE insert_proveedor(
	IN codigo_proveedor INT,
  	IN nombre_proveedor VARCHAR(50)
)
BEGIN
	INSERT INTO proveedor
    VALUES (codigo_proveedor, nombre_proveedor);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_pago_año(
	IN año VARCHAR(15),
    IN forma VARCHAR(15)
)
BEGIN
	SELECT p.id_transaccion, p.fecha_pago, p.total, p.codigo_cliente, p.codigo_forma
    FROM pago AS p, forma_pago AS f
    WHERE p.codigo_forma = f.codigo_forma AND f.nombre_forma = forma AND YEAR(p.fecha_pago) = año;
END $$
DELIMITER ;

CALL buscar_pago_año('2008', 'PayPal');

DELIMITER $$
CREATE PROCEDURE insert_forma_pago(
	IN codigo_forma VARCHAR(5),
  	IN nombre_forma VARCHAR(40)
)
BEGIN
	INSERT INTO forma_pago
    VALUES (codigo_forma, nombre_forma);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_empleados_jefe(
	IN nombre VARCHAR(50),
    IN apellido VARCHAR(50)
)
BEGIN
	SELECT e.nombre, e.apellido1, e.apellido2, e.email
    FROM empleado AS e
    WHERE e.codigo_jefe = (
        SELECT e.codigo_empleado
        FROM empleado AS e
        WHERE e.nombre = nombre AND e.apellido1 = apellido
	);
END $$
DELIMITER ;

CALL buscar_empleados_jefe('Alberto', 'Soria');

DELIMITER $$
CREATE PROCEDURE insert_pago(
	IN id_transaccion VARCHAR(50),
  	IN fecha_pago DATE,
  	IN total DECIMAL(15,2),
  	IN codigo_cliente INT,
  	IN codigo_forma VARCHAR(5)
)
BEGIN
	INSERT INTO pago
    VALUES (id_transaccion, fecha_pago, total, codigo_cliente, codigo_forma);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE numero_clientes()
BEGIN
	SELECT COUNT(c.codigo_cliente) AS numero_clientes
    FROM cliente AS c;
END $$
DELIMITER ;

CALL numero_clientes();

DELIMITER $$
CREATE PROCEDURE insert_tipo_direccion(
	IN codigo_tipo VARCHAR(5),
  	IN nombre_tipo VARCHAR(30)
)
BEGIN
	INSERT INTO tipo_direccion
    VALUES (codigo_tipo, nombre_tipo);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE numero_clientes_ciudad(
	IN nombre VARCHAR(50)
)
BEGIN
	SELECT COUNT(c.codigo_cliente) AS numero_clientes
    FROM cliente AS c
    INNER JOIN direccion AS d
    ON d.codigo_cliente = c.codigo_cliente
    INNER JOIN ciudad AS ci
    ON ci.codigo_ciudad = d.codigo_ciudad
    WHERE ci.nombre_ciudad = nombre;
END $$
DELIMITER ;

CALL numero_clientes_ciudad('Madrid');