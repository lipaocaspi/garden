CREATE DATABASE gardenDB;
USE gardenDB;
-- -----------------------------------------------------
-- gama_producto
-- -----------------------------------------------------
CREATE TABLE gama_producto (
  gama VARCHAR(50) NOT NULL,
  descripcion_texto TEXT,
  descripcion_html TEXT,
  imagen VARCHAR(256),
  CONSTRAINT PK_gama_producto PRIMARY KEY (gama)
);

-- -----------------------------------------------------
-- dimension
-- -----------------------------------------------------
CREATE TABLE dimension (
  codigo_dimension VARCHAR(5) NOT NULL,
  alto DECIMAL(15,2),
  ancho DECIMAL(15,2),
  largo DECIMAL(15,2),
  CONSTRAINT PK_dimension PRIMARY KEY (codigo_dimension)
);

-- -----------------------------------------------------
-- proveedor
-- -----------------------------------------------------
CREATE TABLE proveedor (
  codigo_proveedor INT NOT NULL,
  nombre_proveedor VARCHAR(50) NOT NULL,
  CONSTRAINT PK_proveedor PRIMARY KEY (codigo_proveedor)
);

-- -----------------------------------------------------
-- producto
-- -----------------------------------------------------
CREATE TABLE producto (
  codigo_producto VARCHAR(15) NOT NULL,
  nombre VARCHAR(70) NOT NULL,
  gama VARCHAR(50) NOT NULL,
  descripcion TEXT,
  cantidad_en_stock SMALLINT(6) NOT NULL,
  precio_venta DECIMAL(15,2) NOT NULL,
  precio_proveedor DECIMAL(15,2),
  codigo_dimension VARCHAR(5) NOT NULL,
  codigo_proveedor INT NOT NULL,
  CONSTRAINT PK_producto PRIMARY KEY (codigo_producto),
  CONSTRAINT FK_producto_gama_producto
    FOREIGN KEY (gama)
    REFERENCES gama_producto(gama),
  CONSTRAINT FK_producto_dimension
    FOREIGN KEY (codigo_dimension)
    REFERENCES dimension(codigo_dimension),
  CONSTRAINT FK_producto_proveedor
    FOREIGN KEY (codigo_proveedor)
    REFERENCES proveedor(codigo_proveedor)
);

-- -----------------------------------------------------
-- pais
-- -----------------------------------------------------
CREATE TABLE pais (
  codigo_pais VARCHAR(10) NOT NULL,
  nombre_pais VARCHAR(50) NOT NULL,
  CONSTRAINT PK_pais PRIMARY KEY (codigo_pais)
);

-- -----------------------------------------------------
-- region
-- -----------------------------------------------------
CREATE TABLE region (
  codigo_region VARCHAR(10) NOT NULL,
  nombre_region VARCHAR(50) NOT NULL,
  codigo_pais VARCHAR(10) NOT NULL,
  CONSTRAINT PK_region PRIMARY KEY (codigo_region),
  CONSTRAINT FK_region_pais
    FOREIGN KEY (codigo_pais)
    REFERENCES pais(codigo_pais)
);

-- -----------------------------------------------------
-- ciudad
-- -----------------------------------------------------
CREATE TABLE ciudad (
  codigo_ciudad VARCHAR(10) NOT NULL,
  nombre_ciudad VARCHAR(50) NOT NULL,
  codigo_region VARCHAR(10) NOT NULL,
  CONSTRAINT PK_ciudad PRIMARY KEY (codigo_ciudad),
  CONSTRAINT FK_ciudad_region
    FOREIGN KEY (codigo_region)
    REFERENCES region(codigo_region)
);

-- -----------------------------------------------------
-- tipo_direccion
-- -----------------------------------------------------
CREATE TABLE tipo_direccion (
  codigo_tipo VARCHAR(5) NOT NULL,
  nombre_tipo VARCHAR(30) NOT NULL,
  CONSTRAINT PK_tipo_direccion PRIMARY KEY (codigo_tipo)
);

-- -----------------------------------------------------
-- oficina
-- -----------------------------------------------------
CREATE TABLE oficina (
  codigo_oficina VARCHAR(10) NOT NULL,
  nombre_oficina VARCHAR(30) NOT NULL,
  CONSTRAINT PK_oficina PRIMARY KEY (codigo_oficina)
);

-- -----------------------------------------------------
-- puesto
-- -----------------------------------------------------
CREATE TABLE puesto (
  codigo_puesto VARCHAR(5) NOT NULL,
  nombre_puesto VARCHAR(50) NOT NULL,
  CONSTRAINT PK_puesto PRIMARY KEY (codigo_puesto)
);

-- -----------------------------------------------------
-- extension
-- -----------------------------------------------------
CREATE TABLE extension (
  codigo_extension VARCHAR(5) NOT NULL,
  numero_extension VARCHAR(10) NOT NULL,
  CONSTRAINT PK_extension PRIMARY KEY (codigo_extension)
);

-- -----------------------------------------------------
-- empleado
-- -----------------------------------------------------
CREATE TABLE empleado (
  codigo_empleado INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50),
  email VARCHAR(100) NOT NULL,
  codigo_oficina VARCHAR(10) NOT NULL,
  codigo_jefe INT,
  codigo_puesto VARCHAR(5) NOT NULL,
  codigo_extension VARCHAR(5) NOT NULL,
  CONSTRAINT PK_empleado PRIMARY KEY (codigo_empleado),
  CONSTRAINT FK_empleado_empleado
    FOREIGN KEY (codigo_jefe)
    REFERENCES empleado(codigo_empleado),
  CONSTRAINT FK_empleado_oficina
    FOREIGN KEY (codigo_oficina)
    REFERENCES oficina(codigo_oficina),
  CONSTRAINT FK_empleado_puesto
    FOREIGN KEY (codigo_puesto)
    REFERENCES puesto(codigo_puesto),
  CONSTRAINT FK_empleado_extension
    FOREIGN KEY (codigo_extension)
    REFERENCES extension(codigo_extension)
);

-- -----------------------------------------------------
-- cliente
-- -----------------------------------------------------
CREATE TABLE cliente (
  codigo_cliente INT NOT NULL,
  nombre_cliente VARCHAR(50) NOT NULL,
  codigo_empleado_rep_ventas INT,
  limite_credito DECIMAL(15,2),
  CONSTRAINT PK_cliente PRIMARY KEY (codigo_cliente),
  CONSTRAINT FK_cliente_empleado
    FOREIGN KEY (codigo_empleado_rep_ventas)
    REFERENCES empleado(codigo_empleado)
);

-- -----------------------------------------------------
-- direccion
-- -----------------------------------------------------
CREATE TABLE direccion (
  codigo_direccion VARCHAR(5) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50),
  codigo_postal VARCHAR(10),
  codigo_ciudad VARCHAR(10) NOT NULL,
  codigo_tipo VARCHAR(5) NOT NULL,
  CONSTRAINT PK_direccion PRIMARY KEY (codigo_direccion),
  CONSTRAINT FK_direccion_ciudad
    FOREIGN KEY (codigo_ciudad)
    REFERENCES ciudad(codigo_ciudad),
  CONSTRAINT FK_direccion_tipo_direccion
    FOREIGN KEY (codigo_tipo)
    REFERENCES tipo_direccion(codigo_tipo)
);

-- -----------------------------------------------------
-- direccion_oficina
-- -----------------------------------------------------
CREATE TABLE direccion_oficina (
  codigo_direccion_oficina VARCHAR(5) NOT NULL,
  direccion_codigo_direccion VARCHAR(5) NOT NULL,
  oficina_codigo_oficina VARCHAR(10) NOT NULL,
  CONSTRAINT PK_direccion_oficina PRIMARY KEY (codigo_direccion_oficina),
  CONSTRAINT FK_direccion_oficina_direccion
    FOREIGN KEY (direccion_codigo_direccion)
    REFERENCES direccion(codigo_direccion),
  CONSTRAINT FK_direccion_oficina_oficina
    FOREIGN KEY (oficina_codigo_oficina)
    REFERENCES oficina(codigo_oficina)
);

-- -----------------------------------------------------
-- direccion_cliente
-- -----------------------------------------------------
CREATE TABLE direccion_cliente (
  codigo_direccion_cliente VARCHAR(5) NOT NULL,
  direccion_codigo_direccion VARCHAR(5) NOT NULL,
  cliente_codigo_cliente INT NOT NULL,
  CONSTRAINT PK_direccion_cliente PRIMARY KEY (codigo_direccion_cliente),
  CONSTRAINT FK_direccion_cliente_direccion
    FOREIGN KEY (direccion_codigo_direccion)
    REFERENCES direccion(codigo_direccion),
  CONSTRAINT FK_direccion_cliente_cliente
    FOREIGN KEY (cliente_codigo_cliente)
    REFERENCES cliente(codigo_cliente)
);

-- -----------------------------------------------------
-- contacto
-- -----------------------------------------------------
/* 1FN, 2FN, 3FN */
CREATE TABLE contacto (
  codigo_contacto INT NOT NULL,
  nombre_contacto VARCHAR(30),
  apellido_contacto VARCHAR(30),
  fax VARCHAR(15) NOT NULL,
  codigo_cliente INT NOT NULL,
  CONSTRAINT PK_contacto PRIMARY KEY (codigo_contacto),
  CONSTRAINT FK_contacto_cliente
    FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo_cliente)
);

-- -----------------------------------------------------
-- estado
-- -----------------------------------------------------
CREATE TABLE estado (
  codigo_estado VARCHAR(5) NOT NULL,
  nombre_estado VARCHAR(15) NOT NULL,
  CONSTRAINT PK_estado PRIMARY KEY (codigo_estado)
);

-- -----------------------------------------------------
-- pedido
-- -----------------------------------------------------
CREATE TABLE pedido (
  codigo_pedido INT NOT NULL,
  fecha_pedido DATE NOT NULL,
  fecha_esperada DATE NOT NULL,
  fecha_entrega DATE,
  comentarios TEXT,
  codigo_cliente INT NOT NULL,
  codigo_estado VARCHAR(5) NOT NULL,
  CONSTRAINT PK_pedido PRIMARY KEY (codigo_pedido),
  CONSTRAINT FK_pedido_cliente
    FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo_cliente),
  CONSTRAINT FK_pedido_estado
    FOREIGN KEY (codigo_estado)
    REFERENCES estado(codigo_estado)
);

-- -----------------------------------------------------
-- detalle_pedido
-- -----------------------------------------------------
CREATE TABLE detalle_pedido (
  pedido_codigo_pedido INT NOT NULL,
  producto_codigo_producto VARCHAR(15) NOT NULL,
  cantidad INT NOT NULL,
  precio_unidad DECIMAL(15,2) NOT NULL,
  numero_linea SMALLINT(6) NOT NULL,
  CONSTRAINT PK_detalle_pedido PRIMARY KEY (pedido_codigo_pedido, producto_codigo_producto),
  CONSTRAINT FK_detalle_pedido_producto
    FOREIGN KEY (producto_codigo_producto)
    REFERENCES producto(codigo_producto),
  CONSTRAINT FK_detalle_pedido_pedido
    FOREIGN KEY (pedido_codigo_pedido)
    REFERENCES pedido(codigo_pedido)
);

-- -----------------------------------------------------
-- forma_pago
-- -----------------------------------------------------
CREATE TABLE forma_pago (
  codigo_forma VARCHAR(5) NOT NULL,
  nombre_forma VARCHAR(40) NOT NULL,
  CONSTRAINT PK_forma_pago PRIMARY KEY (codigo_forma)
);

-- -----------------------------------------------------
-- pago
-- -----------------------------------------------------
CREATE TABLE pago (
  id_transaccion VARCHAR(50) NOT NULL,
  fecha_pago DATE NOT NULL,
  total DECIMAL(15,2) NOT NULL,
  codigo_cliente INT NOT NULL,
  codigo_forma VARCHAR(5) NOT NULL,
  CONSTRAINT PK_pago PRIMARY KEY (id_transaccion),
  CONSTRAINT FK_pago_cliente
    FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo_cliente),
  CONSTRAINT FK_pago_tipo_pago
    FOREIGN KEY (codigo_forma)
    REFERENCES forma_pago(codigo_forma)
);

-- -----------------------------------------------------
-- tipo_telefono
-- -----------------------------------------------------
CREATE TABLE tipo_telefono (
  codigo_tipo VARCHAR(5) NOT NULL,
  nombre_tipo VARCHAR(20) NOT NULL,
  CONSTRAINT PK_tipo_telefono PRIMARY KEY (codigo_tipo)
);

-- -----------------------------------------------------
-- telefono
-- -----------------------------------------------------
CREATE TABLE telefono (
  codigo_telefono VARCHAR(5) NOT NULL,
  numero_telefono VARCHAR(20) NOT NULL,
  codigo_tipo VARCHAR(5) NOT NULL,
  codigo_oficina VARCHAR(10),
  codigo_contacto INT,
  CONSTRAINT PK_telefono PRIMARY KEY (codigo_telefono),
  CONSTRAINT FK_telefono_tipo_telefono
    FOREIGN KEY (codigo_tipo)
    REFERENCES tipo_telefono(codigo_tipo),
  CONSTRAINT FK_telefono_oficina
    FOREIGN KEY (codigo_oficina)
    REFERENCES oficina(codigo_oficina),
  CONSTRAINT FK_telefono_contacto
    FOREIGN KEY (codigo_contacto)
    REFERENCES contacto(codigo_contacto),
  CHECK (codigo_oficina IS NULL OR codigo_contacto IS NULL)
);

-- -----------------------------------------------------
-- telefono_contacto
-- -----------------------------------------------------
CREATE TABLE telefono_contacto (
  codigo_telefono_contacto VARCHAR(5) NOT NULL,
  contacto_codigo_contacto INT NOT NULL,
  telefono_codigo_telefono VARCHAR(5) NOT NULL,
  CONSTRAINT PK_telefono_contacto PRIMARY KEY (codigo_telefono_contacto),
  CONSTRAINT FK_telefono_contacto_contacto
    FOREIGN KEY (contacto_codigo_contacto)
    REFERENCES contacto(codigo_contacto),
  CONSTRAINT FK_telefono_contacto_telefono
    FOREIGN KEY (telefono_codigo_telefono)
    REFERENCES telefono(codigo_telefono)
);

-- -----------------------------------------------------
-- telefono_oficina
-- -----------------------------------------------------
CREATE TABLE telefono_oficina (
  codigo_telefono_oficina VARCHAR(5) NOT NULL,
  oficina_codigo_oficina VARCHAR(10) NOT NULL,
  telefono_codigo_telefono VARCHAR(5) NOT NULL,
  CONSTRAINT PK_telefono_oficina PRIMARY KEY (codigo_telefono_oficina),
  CONSTRAINT FK_telefono_oficina_oficina
    FOREIGN KEY (oficina_codigo_oficina)
    REFERENCES oficina(codigo_oficina),
  CONSTRAINT FK_telefono_oficina_telefono
    FOREIGN KEY (telefono_codigo_telefono)
    REFERENCES telefono(codigo_telefono)
);