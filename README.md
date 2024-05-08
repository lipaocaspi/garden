# gardenDB

#### Normalización

![DER](https://raw.githubusercontent.com/lipaocaspi/gardenDB/main/DER.png)

#### Creación BD

```sql
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
/* 1FN */
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
/* 1FN, 2FN */
CREATE TABLE proveedor (
  codigo_proveedor INT NOT NULL,
  nombre_proveedor VARCHAR(50) NOT NULL,
  CONSTRAINT PK_proveedor PRIMARY KEY (codigo_proveedor)
);

-- -----------------------------------------------------
-- producto
-- -----------------------------------------------------
/* 1FN, 2FN, 3FN y 4FN */
CREATE TABLE producto (
  codigo_producto VARCHAR(15) NOT NULL,
  nombre VARCHAR(70) NOT NULL,
  gama VARCHAR(50) NOT NULL,
  descripcion TEXT,
  cantidad_en_stock SMALLINT(6) NOT NULL,
  precio_venta DECIMAL(15,2) NOT NULL,
  precio_proveedor DECIMAL(15,2),
  codigo_dimension VARCHAR(5),
  codigo_proveedor INT,
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
/* 1FN */
CREATE TABLE pais (
  codigo_pais VARCHAR(10) NOT NULL,
  nombre_pais VARCHAR(50) NOT NULL,
  CONSTRAINT PK_pais PRIMARY KEY (codigo_pais)
);

-- -----------------------------------------------------
-- region
-- -----------------------------------------------------
/* 1FN */
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
/* 1FN */
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
/* 1FN */
CREATE TABLE tipo_direccion (
  codigo_tipo VARCHAR(5) NOT NULL,
  nombre_tipo VARCHAR(30) NOT NULL,
  CONSTRAINT PK_tipo_direccion PRIMARY KEY (codigo_tipo)
);

-- -----------------------------------------------------
-- oficina
-- -----------------------------------------------------
/* 1FN, 2FN, 3FN y 4FN */
CREATE TABLE oficina (
  codigo_oficina VARCHAR(10) NOT NULL,
  nombre_oficina VARCHAR(30) NOT NULL,
  CONSTRAINT PK_oficina PRIMARY KEY (codigo_oficina)
);

-- -----------------------------------------------------
-- puesto
-- -----------------------------------------------------
/* 1FN */
CREATE TABLE puesto (
  codigo_puesto VARCHAR(5) NOT NULL,
  nombre_puesto VARCHAR(50) NOT NULL,
  CONSTRAINT PK_puesto PRIMARY KEY (codigo_puesto)
);

-- -----------------------------------------------------
-- extension
-- -----------------------------------------------------
/* 1FN */
CREATE TABLE extension (
  codigo_extension VARCHAR(5) NOT NULL,
  numero_extension VARCHAR(10) NOT NULL,
  CONSTRAINT PK_extension PRIMARY KEY (codigo_extension)
);

-- -----------------------------------------------------
-- empleado
-- -----------------------------------------------------
/* 1FN, 2FN, 3FN y 4FN */
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
/* 1FN, 2FN, 3FN y 4FN */
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
/* 1FN, 2FN, 3FN y 4FN */
CREATE TABLE direccion (
  codigo_direccion VARCHAR(5) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50),
  codigo_postal VARCHAR(10),
  codigo_ciudad VARCHAR(10) NOT NULL,
  codigo_tipo VARCHAR(5) NOT NULL,
  codigo_cliente INT,
  codigo_oficina VARCHAR(10),
  CONSTRAINT PK_direccion PRIMARY KEY (codigo_direccion),
  CONSTRAINT FK_direccion_ciudad
    FOREIGN KEY (codigo_ciudad)
    REFERENCES ciudad(codigo_ciudad),
  CONSTRAINT FK_direccion_tipo_direccion
    FOREIGN KEY (codigo_tipo)
    REFERENCES tipo_direccion(codigo_tipo),
  CONSTRAINT FK_direccion_cliente
    FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo_cliente),
  CONSTRAINT FK_direccion_oficina
    FOREIGN KEY (codigo_oficina)
    REFERENCES oficina(codigo_oficina),
  CHECK (codigo_oficina IS NULL OR codigo_cliente IS NULL)
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
/* 1FN */
CREATE TABLE estado (
  codigo_estado VARCHAR(5) NOT NULL,
  nombre_estado VARCHAR(15) NOT NULL,
  CONSTRAINT PK_estado PRIMARY KEY (codigo_estado)
);

-- -----------------------------------------------------
-- pedido
-- -----------------------------------------------------
/* 1FN */
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
/* 1FN */
CREATE TABLE forma_pago (
  codigo_forma VARCHAR(5) NOT NULL,
  nombre_forma VARCHAR(40) NOT NULL,
  CONSTRAINT PK_forma_pago PRIMARY KEY (codigo_forma)
);

-- -----------------------------------------------------
-- pago
-- -----------------------------------------------------
/* 1FN */
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
/* 1FN */
CREATE TABLE tipo_telefono (
  codigo_tipo VARCHAR(5) NOT NULL,
  nombre_tipo VARCHAR(20) NOT NULL,
  CONSTRAINT PK_tipo_telefono PRIMARY KEY (codigo_tipo)
);

-- -----------------------------------------------------
-- telefono
-- -----------------------------------------------------
/* 1FN */
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
```



#### Inserción de datos

```sql
INSERT INTO gama_producto (gama, descripcion_texto, descripcion_html, imagen) 
VALUES
    ('Herbaceas','Plantas para jardin decorativas',NULL,NULL),
    ('Herramientas','Herramientas para todo tipo de acción',NULL,NULL),
    ('Aromáticas','Plantas aromáticas',NULL,NULL),
    ('Frutales','Árboles pequeños de producción frutal',NULL,NULL),
    ('Ornamentales','Plantas vistosas para la decoración del jardín',NULL,NULL);

INSERT INTO dimension (codigo_dimension, alto, largo, ancho)
VALUES
    ('1', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('2', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('3', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('4', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('5', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('6', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('7', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('8', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('9', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('10', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('11', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('12', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('13', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('14', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('15', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('16', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('17', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('18', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('19', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('20', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('21', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('22', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('23', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('24', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('25', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('26', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('27', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('28', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('29', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2)),
    ('30', ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2), ROUND(RAND() * 100, 2));
    
    
INSERT INTO proveedor (codigo_proveedor, nombre_proveedor)
VALUES
	(1, 'HiperGarden Tools'),
    (2, 'Murcia Seasons'),
    (3, 'Frutales Talavera S.A'),
    (4, 'NaranjasValencianas.com'),
    (5, 'Melocotones de Cieza S.A.'),
    (6, 'Jerte Distribuciones S.L.'),
    (7, 'Valencia Garden Service'),
    (8, 'Viveros EL OASIS');
    
INSERT INTO producto (codigo_producto, nombre, gama, descripcion, cantidad_en_stock, precio_venta, precio_proveedor, codigo_dimension, codigo_proveedor)
VALUES
	('11679','Sierra de Poda 400MM','Herramientas','Gracias a la poda se consigue manipular un poco la naturaleza, dándole la forma que más nos guste. Este trabajo básico de jardinería también facilita que las plantas crezcan de un modo más equilibrado, y que las flores y los frutos vuelvan cada año con regularidad. Lo mejor es dar forma cuando los ejemplares son jóvenes, de modo que exijan pocos cuidados cuando sean adultos. Además de saber cuándo y cómo hay que podar, tener unas herramientas adecuadas para esta labor es también de vital importancia.',15,14,11,'1',1),
	('21636','Pala','Herramientas','Palas de acero con cresta de corte en la punta para cortar bien el terreno. Buena penetración en tierras muy compactas.',15,14,13,'3',1),
	('22225','Rastrillo de Jardín','Herramientas','Fabuloso rastillo que le ayudará a eliminar piedras, hojas, ramas y otros elementos incómodos en su jardín.',15,12,11,'8',1),
	('30310','Azadón','Herramientas','Longitud:24cm. Herramienta fabricada en acero y pintura epoxi,alargando su durabilidad y preveniendo la corrosión.Diseño pensado para el ahorro de trabajo.',15,12,11,'6',1),
	('AR-001','Ajedrea','Aromáticas','Planta aromática que fresca se utiliza para condimentar carnes y ensaladas, y seca, para pastas, sopas y guisantes',140,1,0,'8',2),
	('AR-002','Lavándula Dentata','Aromáticas','Espliego de jardín, Alhucema rizada, Alhucema dentada, Cantueso rizado. Familia: Lamiaceae.Origen: España y Portugal. Mata de unos 60 cm de alto. Las hojas son aromáticas, dentadas y de color verde grisáceas.  Produce compactas espigas de flores pequeñas, ligeramente aromáticas, tubulares,de color azulado y con brácteas púrpuras.  Frutos: nuececillas alargadas encerradas en el tubo del cáliz.  Se utiliza en jardineria y no en perfumeria como otros cantuesos, espliegos y lavandas.  Tiene propiedades aromatizantes y calmantes. Adecuadas para la formación de setos bajos. Se dice que su aroma ahuyenta pulgones y otros insectos perjudiciales para las plantas vecinas.',140,1,0,'5',2),
	('AR-003','Mejorana','Aromáticas','Origanum majorana. No hay que confundirlo con el orégano. Su sabor se parece más al tomillo, pero es más dulce y aromático.Se usan las hojas frescas o secas, picadas, machacadas o en polvo, en sopas, rellenos, quiches y tartas, tortillas, platos con papas y, como aderezo, en ramilletes de hierbas.El sabor delicado de la mejorana se elimina durante la cocción, de manera que es mejor agregarla cuando el plato esté en su punto o en aquéllos que apenas necesitan cocción.',140,1,0,'5',2),
	('AR-004','Melissa ','Aromáticas','Es una planta perenne (dura varios años) conocida por el agradable y característico olor a limón que desprenden en verano. Nunca debe faltar en la huerta o jardín por su agradable aroma y por los variados usos que tiene: planta olorosa, condimentaria y medicinal. Su cultivo es muy fácil. Le va bien un suelo ligero, con buen drenaje y riego sin exceso. A pleno sol o por lo menos 5 horas de sol por día. Cada año, su abonado mineral correspondiente.En otoño, la melisa pierde el agradable olor a limón que desprende en verano sus flores azules y blancas. En este momento se debe cortar a unos 20 cm. del suelo. Brotará de forma densa en primavera.',140,1,0,'4',2),
	('AR-005','Mentha Sativa','Aromáticas','¿Quién no conoce la Hierbabuena? Se trata de una plantita muy aromática, agradable y cultivada extensamente por toda España. Es hierba perenne (por tanto vive varios años, no es anual). Puedes cultivarla en maceta o plantarla en la tierra del jardín o en un rincón del huerto. Lo más importante es que cuente con bastante agua. En primavera debes aportar fertilizantes minerales. Vive mejor en semisombra que a pleno sol.Si ves orugas o los agujeros en hojas consecuencia de su ataque, retíralas una a una a mano; no uses insecticidas químicos.',140,1,0,'9',2),
	('AR-006','Petrosilium Hortense (Peregil)','Aromáticas','Nombre científico o latino: Petroselinum hortense, Petroselinum crispum. Nombre común o vulgar: Perejil, Perejil rizado Familia: Umbelliferae (Umbelíferas). Origen: el origen del perejil se encuentra en el Mediterraneo. Esta naturalizada en casi toda Europa. Se utiliza como condimento y para adorno, pero también en ensaladas. Se suele regalar en las fruterías y verdulerías.El perejil lo hay de 2 tipos: de hojas planas y de hojas rizadas.',140,1,0,'7',2),
    ('AR-007','Salvia Mix','Aromáticas','La Salvia es un pequeño arbusto que llega hasta el metro de alto.Tiene una vida breve, de unos pocos años.En el jardín, como otras aromáticas, queda muy bien en una rocalla o para hacer una bordura perfumada a cada lado de un camino de Salvia. Abona después de cada corte y recorta el arbusto una vez pase la floración.',140,1,0,'3',2),
    ('AR-008','Thymus Citriodra (Tomillo limón)','Aromáticas','Nombre común o vulgar: Tomillo, Tremoncillo Familia: Labiatae (Labiadas).Origen: Región mediterránea.Arbustillo bajo, de 15 a 40 cm de altura. Las hojas son muy pequeñas, de unos 6 mm de longitud; según la variedad pueden ser verdes, verdes grisáceas, amarillas, o jaspeadas. Las flores aparecen de mediados de primavera hasta bien entrada la época estival y se presentan en racimos terminales que habitualmente son de color violeta o púrpura aunque también pueden ser blancas. Esta planta despide un intenso y típico aroma, que se incrementa con el roce. El tomillo resulta de gran belleza cuando está en flor. El tomillo atrae a avispas y abejas. En jardinería se usa como manchas, para hacer borduras, para aromatizar el ambiente, llenar huecos, cubrir rocas, para jardines en miniatura, etc. Arranque las flores y hojas secas del tallo y añadálos a un popurri, introdúzcalos en saquitos de hierbas o en la almohada.También puede usar las ramas secas con flores para añadir aroma y textura a cestos abiertos.',140,1,0,'6',2),
    ('AR-009','Thymus Vulgaris','Aromáticas','Nombre común o vulgar: Tomillo, Tremoncillo Familia: Labiatae (Labiadas). Origen: Región mediterránea. Arbustillo bajo, de 15 a 40 cm de altura. Las hojas son muy pequeñas, de unos 6 mm de longitud; según la variedad pueden ser verdes, verdes grisáceas, amarillas, o jaspeadas. Las flores aparecen de mediados de primavera hasta bien entrada la época estival y se presentan en racimos terminales que habitualmente son de color violeta o púrpura aunque también pueden ser blancas. Esta planta despide un intenso y típico aroma, que se incrementa con el roce. El tomillo resulta de gran belleza cuando está en flor. El tomillo atrae a avispas y abejas.\r\n En jardinería se usa como manchas, para hacer borduras, para aromatizar el ambiente, llenar huecos, cubrir rocas, para jardines en miniatura, etc. Arranque las flores y hojas secas del tallo y añadálos a un popurri, introdúzcalos en saquitos de hierbas o en la almohada. También puede usar las ramas secas con flores para añadir aroma y textura a cestos abiertos.',140,1,0,'4',2),
    ('AR-010','Santolina Chamaecyparys','Aromáticas','',140,1,0,'15',2),
    ('FR-1','Expositor Cítricos Mix','Frutales','',15,7,5,'4',3),
    ('FR-10','Limonero 2 años injerto','Frutales','El limonero, pertenece al grupo de los cítricos, teniendo su origen hace unos 20 millones de años en el sudeste asiático. Fue introducido por los árabes en el área mediterránea entre los años 1.000 a 1.200, habiendo experimentando numerosas modificaciones debidas tanto a la selección natural mediante hibridaciones espontáneas como a las producidas por el hombre, en este caso buscando las necesidades del mercado.',15,7,5,'23',4),
    ('FR-100','Nectarina','Frutales','Se trata de un árbol derivado por mutación de los melocotoneros comunes, y los únicos caracteres diferenciales son la ausencia de tomentosidad en la piel del fruto. La planta, si se deja crecer libremente, adopta un porte globoso con unas dimensiones medias de 4-6 metros',50,11,8,'4',3),
    ('FR-101','Nogal','Frutales','',50,13,10,'6',3),
    ('FR-102','Olea-Olivos','Frutales','Existen dos hipótesis sobre el origen del olivo, una que postula que proviene de las costas de Siria, Líbano e Israel y otra que considera que lo considera originario de Asia menor. La llegada a Europa probablemente tuvo lugar de mano de los Fenicios, en transito por Chipre, Creta, e Islas del Mar Egeo, pasando a Grecia y más tarde a Italia. Los primeros indicios de la presencia del olivo en las costas mediterráneas españolas coinciden con el dominio romano, aunque fueron posteriormente los árabes los que impulsaron su cultivo en Andalucía, convirtiendo a España en el primer país productor de aceite de oliva a nivel mundial.',50,18,14,'7',3),
    ('FR-103','Olea-Olivos','Frutales','Existen dos hipótesis sobre el origen del olivo, una que postula que proviene de las costas de Siria, Líbano e Israel y otra que considera que lo considera originario de Asia menor. La llegada a Europa probablemente tuvo lugar de mano de los Fenicios, en transito por Chipre, Creta, e Islas del Mar Egeo, pasando a Grecia y más tarde a Italia. Los primeros indicios de la presencia del olivo en las costas mediterráneas españolas coinciden con el dominio romano, aunque fueron posteriormente los árabes los que impulsaron su cultivo en Andalucía, convirtiendo a España en el primer país productor de aceite de oliva a nivel mundial.',50,25,20,'4',3),
    ('FR-104','Olea-Olivos','Frutales','Existen dos hipótesis sobre el origen del olivo, una que postula que proviene de las costas de Siria, Líbano e Israel y otra que considera que lo considera originario de Asia menor. La llegada a Europa probablemente tuvo lugar de mano de los Fenicios, en transito por Chipre, Creta, e Islas del Mar Egeo, pasando a Grecia y más tarde a Italia. Los primeros indicios de la presencia del olivo en las costas mediterráneas españolas coinciden con el dominio romano, aunque fueron posteriormente los árabes los que impulsaron su cultivo en Andalucía, convirtiendo a España en el primer país productor de aceite de oliva a nivel mundial.',50,49,39,'4',3),
    ('FR-105','Olea-Olivos','Frutales','Existen dos hipótesis sobre el origen del olivo, una que postula que proviene de las costas de Siria, Líbano e Israel y otra que considera que lo considera originario de Asia menor. La llegada a Europa probablemente tuvo lugar de mano de los Fenicios, en transito por Chipre, Creta, e Islas del Mar Egeo, pasando a Grecia y más tarde a Italia. Los primeros indicios de la presencia del olivo en las costas mediterráneas españolas coinciden con el dominio romano, aunque fueron posteriormente los árabes los que impulsaron su cultivo en Andalucía, convirtiendo a España en el primer país productor de aceite de oliva a nivel mundial.',50,70,56,'6',3),
    ('FR-106','Peral','Frutales','Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.',50,11,8,'4',3),
    ('FR-107','Peral','Frutales','Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.',50,22,17,'7',3),
    ('FR-108','Peral','Frutales','Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.',50,32,25,'6',3),
    ('FR-11','Limonero 30/40','Frutales','El limonero, pertenece al grupo de los cítricos, teniendo su origen hace unos 20 millones de años en el sudeste asiático. Fue introducido por los árabes en el área mediterránea entre los años 1.000 a 1.200, habiendo experimentando numerosas modificaciones debidas tanto a la selección natural mediante hibridaciones espontáneas como a las producidas por el',15,100,80,'17',4),
    ('FR-12','Kunquat ','Frutales','su nombre científico se origina en honor a un hoticultor escocés que recolectó especímenes en China, (\"Fortunella\"), Robert Fortune (1812-1880), y \"margarita\", del latín margaritus-a-um = perla, en alusión a sus pequeños y brillantes frutos. Se trata de un arbusto o árbol pequeño de 2-3 m de altura, inerme o con escasas espinas.Hojas lanceoladas de 4-8 (-15) cm de longitud, con el ápice redondeado y la base cuneada.Tienen el margen crenulado en su mitad superior, el haz verde brillante y el envés más pálido.Pecíolo ligeramente marginado.Flores perfumadas solitarias o agrupadas en inflorescencias axilares, blancas.El fruto es lo más característico, es el más pequeño de todos los cítricos y el único cuya cáscara se puede comer.Frutos pequeños, con semillas, de corteza fina, dulce, aromática y comestible, y de pulpa naranja amarillenta y ligeramente ácida.Sus frutos son muy pequeños y tienen un carácter principalmente ornamental.',15,21,16,'7',4),
    ('FR-13','Kunquat  EXTRA con FRUTA','Frutales','su nombre científico se origina en honor a un hoticultor escocés que recolectó especímenes en China, (\"Fortunella\"), Robert Fortune (1812-1880), y \"margarita\", del latín margaritus-a-um = perla, en alusión a sus pequeños y brillantes frutos. Se trata de un arbusto o árbol pequeño de 2-3 m de altura, inerme o con escasas espinas.Hojas lanceoladas de 4-8 (-15) cm de longitud, con el ápice redondeado y la base cuneada.Tienen el margen crenulado en su mitad superior, el haz verde brillante y el envés más pálido.Pecíolo ligeramente marginado.Flores perfumadas solitarias o agrupadas en inflorescencias axilares, blancas.El fruto es lo más característico, es el más pequeño de todos los cítricos y el único cuya cáscara se puede comer.Frutos pequeños, con semillas, de corteza fina, dulce, aromática y comestible, y de pulpa naranja amarillenta y ligeramente ácida.Sus frutos son muy pequeños y tienen un carácter principalmente ornamental.',15,57,45,'4',4),
    ('FR-14','Calamondin Mini','Frutales','Se trata de un pequeño arbolito de copa densa, con tendencia a la verticalidad, inerme o con cortas espinas. Sus hojas son pequeñas, elípticas de 5-10 cm de longitud, con los pecíolos estrechamente alados.Posee 1 o 2 flores en situación axilar, al final de las ramillas.Sus frutos son muy pequeños (3-3,5 cm de diámetro), con pocas semillas, esféricos u ovales, con la zona apical aplanada; corteza de color naranja-rojizo, muy fina y fácilmente separable de la pulpa, que es dulce, ácida y comestible..',15,10,8,'6',3),
    ('FR-15','Calamondin Copa ','Frutales','Se trata de un pequeño arbolito de copa densa, con tendencia a la verticalidad, inerme o con cortas espinas. Sus hojas son pequeñas, elípticas de 5-10 cm de longitud, con los pecíolos estrechamente alados.Posee 1 o 2 flores en situación axilar, al final de las ramillas.Sus frutos son muy pequeños (3-3,5 cm de diámetro), con pocas semillas, esféricos u ovales, con la zona apical aplanada; corteza de color naranja-rojizo, muy fina y fácilmente separable de la pulpa, que es dulce, ácida y comestible..',15,25,20,'7',3),
    ('FR-16','Calamondin Copa EXTRA Con FRUTA','Frutales','Se trata de un pequeño arbolito de copa densa, con tendencia a la verticalidad, inerme o con cortas espinas. Sus hojas son pequeñas, elípticas de 5-10 cm de longitud, con los pecíolos estrechamente alados.Posee 1 o 2 flores en situación axilar, al final de las ramillas.Sus frutos son muy pequeños (3-3,5 cm de diámetro), con pocas semillas, esféricos u ovales, con la zona apical aplanada; corteza de color naranja-rojizo, muy fina y fácilmente separable de la pulpa, que es dulce, ácida y comestible..',15,45,36,'4',3),
    ('FR-17','Rosal bajo 1Âª -En maceta-inicio brotación','Frutales','',15,2,1,'4',3),
    ('FR-18','ROSAL TREPADOR','Frutales','',350,4,3,'9',3),
    ('FR-19','Camelia Blanco, Chrysler Rojo, Soraya Naranja, ','Frutales','',350,4,3,'4',4),
    ('FR-2','Naranjo -Plantón joven 1 año injerto','Frutales','El naranjo es un árbol pequeño, que no supera los 3-5 metros de altura, con una copa compacta, cónica, transformada en esérica gracias a la poda. Su tronco es de color gris y liso, y las hojas son perennes, coriáceas, de un verde intenso y brillante, con forma oval o elíptico-lanceolada. Poseen, en el caso del naranjo amargo, un típico peciolo alado en forma de Â‘corazónÂ’, que en el naranjo dulce es más estrecho y menos patente.',15,6,4,'16',4),
    ('FR-20','Landora Amarillo, Rose Gaujard bicolor blanco-rojo','Frutales','',350,4,3,'4',3),
    ('FR-21','Kordes Perfect bicolor rojo-amarillo, Roundelay rojo fuerte','Frutales','',350,4,3,'4',3),
    ('FR-22','Pitimini rojo','Frutales','',350,4,3,'7',3),
    ('FR-23','Rosal copa ','Frutales','',400,8,6,'8',3),
    ('FR-24','Albaricoquero Corbato','Frutales','árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.',400,8,6,'4',5),
    ('FR-25','Albaricoquero Moniqui','Frutales','árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.',400,8,6,'5',5),
    ('FR-26','Albaricoquero Kurrot','Frutales','árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.',400,8,6,'6',5),
    ('FR-27','Cerezo Burlat','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',400,8,6,'4',6),
    ('FR-28','Cerezo Picota','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',400,8,6,'6',6),
    ('FR-29','Cerezo Napoleón','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',400,8,6,'7',6),
    ('FR-3','Naranjo 2 años injerto','Frutales','El naranjo es un árbol pequeño, que no supera los 3-5 metros de altura, con una copa compacta, cónica, transformada en esérica gracias a la poda. Su tronco es de color gris y liso, y las hojas son perennes, coriáceas, de un verde intenso y brillante, con forma oval o elíptico-lanceolada. Poseen, en el caso del naranjo amargo, un típico peciolo alado en forma de Â‘corazónÂ’, que en el naranjo dulce es más estrecho y menos patente.',15,7,5,'4',4),
    ('FR-30','Ciruelo R. Claudia Verde   ','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',400,8,6,'6',3),
    ('FR-31','Ciruelo Santa Rosa','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',400,8,6,'14',3),
    ('FR-32','Ciruelo Golden Japan','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',400,8,6,'15',3),
    ('FR-33','Ciruelo Friar','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',400,8,6,'16',3),
    ('FR-34','Ciruelo Reina C. De Ollins','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',400,8,6,'16',3),
    ('FR-35','Ciruelo Claudia Negra','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',400,8,6,'14',3),
    ('FR-36','Granado Mollar de Elche','Frutales','pequeño árbol caducifolio, a veces con porte arbustivo, de 3 a 6 m de altura, con el tronco retorcido. Madera dura y corteza escamosa de color grisáceo. Las ramitas jóvenes son más o menos cuadrangulares o angostas y de cuatro alas, posteriormente se vuelven redondas con corteza de color café grisáceo, la mayoría de las ramas, pero especialmente las pequeñas ramitas axilares, son en forma de espina o terminan en una espina aguda; la copa es extendida.',400,9,7,4,3),
    ('FR-37','Higuera Napolitana','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',400,9,7,'4',3),
    ('FR-38','Higuera Verdal','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',400,9,7,'2',3),
    ('FR-39','Higuera Breva','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',400,9,7,'1',3),
    ('FR-4','Naranjo calibre 8/10','Frutales','El naranjo es un árbol pequeño, que no supera los 3-5 metros de altura, con una copa compacta, cónica, transformada en esérica gracias a la poda. Su tronco es de color gris y liso, y las hojas son perennes, coriáceas, de un verde intenso y brillante, con forma oval o elíptico-lanceolada. Poseen, en el caso del naranjo amargo, un típico peciolo alado en forma de Â‘corazónÂ’, que en el naranjo dulce es más estrecho y menos patente.',15,29,23,'4',4),
    ('FR-40','Manzano Starking Delicious','Frutales','alcanza como máximo 10 m. de altura y tiene una copa globosa. Tronco derecho que normalmente alcanza de 2 a 2,5 m. de altura, con corteza cubierta de lenticelas, lisa, adherida, de color ceniciento verdoso sobre los ramos y escamosa y gris parda sobre las partes viejas del árbol. Tiene una vida de unos 60-80 años. Las ramas se insertan en ángulo abierto sobre el tallo, de color verde oscuro, a veces tendiendo a negruzco o violáceo. Los brotes jóvenes terminan con frecuencia en una espina',400,8,6,'6',3),
    ('FR-41','Manzano Reineta','Frutales','alcanza como máximo 10 m. de altura y tiene una copa globosa. Tronco derecho que normalmente alcanza de 2 a 2,5 m. de altura, con corteza cubierta de lenticelas, lisa, adherida, de color ceniciento verdoso sobre los ramos y escamosa y gris parda sobre las partes viejas del árbol. Tiene una vida de unos 60-80 años. Las ramas se insertan en ángulo abierto sobre el tallo, de color verde oscuro, a veces tendiendo a negruzco o violáceo. Los brotes jóvenes terminan con frecuencia en una espina',400,8,6,'4',3),
    ('FR-42','Manzano Golden Delicious','Frutales','alcanza como máximo 10 m. de altura y tiene una copa globosa. Tronco derecho que normalmente alcanza de 2 a 2,5 m. de altura, con corteza cubierta de lenticelas, lisa, adherida, de color ceniciento verdoso sobre los ramos y escamosa y gris parda sobre las partes viejas del árbol. Tiene una vida de unos 60-80 años. Las ramas se insertan en ángulo abierto sobre el tallo, de color verde oscuro, a veces tendiendo a negruzco o violáceo. Los brotes jóvenes terminan con frecuencia en una espina',400,8,6,'6',3),
    ('FR-43','Membrillero Gigante de Wranja','Frutales','',400,8,6,'4',3),
    ('FR-44','Melocotonero Spring Crest','Frutales','Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.\r\nEn Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.\r\nEn China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.',400,8,6,'4',5),
    ('FR-45','Melocotonero Amarillo de Agosto','Frutales','Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.\r\nEn Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.\r\nEn China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.',400,8,6,'6',5),
    ('FR-46','Melocotonero Federica','Frutales','Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.\r\nEn Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.\r\nEn China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.',400,8,6,'4',5),
    ('FR-47','Melocotonero Paraguayo','Frutales','Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.\r\nEn Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.\r\nEn China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.',400,8,6,'5',5),
    ('FR-48','Nogal Común','Frutales','',400,9,7,'6',3),
    ('FR-49','Parra Uva de Mesa','Frutales','',400,8,6,'16',3),
    ('FR-5','Mandarino -Plantón joven','Frutales','',15,6,4,'15',3),
    ('FR-50','Peral Castell','Frutales','Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.',400,8,6,'9',3),
    ('FR-51','Peral Williams','Frutales','Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.',400,8,6,'4',3),
    ('FR-52','Peral Conference','Frutales','Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.',400,8,6,'2',3),
    ('FR-53','Peral Blanq. de Aranjuez','Frutales','Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.',400,8,6,'3',3),
    ('FR-54','Níspero Tanaca','Frutales','Aunque originario del Sudeste de China, el níspero llegó a Europa procedente de Japón en el siglo XVIII como árbol ornamental. En el siglo XIX se inició el consumo de los frutos en toda el área mediterránea, donde se adaptó muy bien a las zonas de cultivo de los cítricos.El cultivo intensivo comenzó a desarrollarse a finales de los años 60 y principios de los 70, cuando comenzaron a implantarse las variedades y técnicas de cultivo actualmente utilizadas.',400,9,7,'4',3),
    ('FR-55','Olivo Cipresino','Frutales','Existen dos hipótesis sobre el origen del olivo, una que postula que proviene de las costas de Siria, Líbano e Israel y otra que considera que lo considera originario de Asia menor. La llegada a Europa probablemente tuvo lugar de mano de los Fenicios, en transito por Chipre, Creta, e Islas del Mar Egeo, pasando a Grecia y más tarde a Italia. Los primeros indicios de la presencia del olivo en las costas mediterráneas españolas coinciden con el dominio romano, aunque fueron posteriormente los árabes los que impulsaron su cultivo en Andalucía, convirtiendo a España en el primer país productor de aceite de oliva a nivel mundial.',400,8,6,'4',3),
    ('FR-56','Nectarina','Frutales','',400,8,6,'4',3),
    ('FR-57','Kaki Rojo Brillante','Frutales','De crecimiento algo lento los primeros años, llega a alcanzar hasta doce metros de altura o más, aunque en cultivo se prefiere algo más bajo (5-6). Tronco corto y copa extendida. Ramifica muy poco debido a la dominancia apical. Porte más o menos piramidal, aunque con la edad se hace más globoso.',400,9,7,'4',4),
    ('FR-58','Albaricoquero','Frutales','árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.',200,11,8,'4',5),
    ('FR-59','Albaricoquero','Frutales','árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.',200,22,17,'6',5),
    ('FR-6','Mandarino 2 años injerto','Frutales','',15,7,5,'4',3),
    ('FR-60','Albaricoquero','Frutales','árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.',200,32,25,'4',5),
    ('FR-61','Albaricoquero','Frutales','árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.',200,49,39,'2',5),
    ('FR-62','Albaricoquero','Frutales','árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.',200,70,56,'2',5),
    ('FR-63','Cerezo','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',300,11,8,'4',6),
    ('FR-64','Cerezo','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',15,22,17,'1',6),
    ('FR-65','Cerezo','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',200,32,25,'2',6),
    ('FR-66','Cerezo','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',50,49,39,'4',6),
    ('FR-67','Cerezo','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',50,70,56,'3',6),
    ('FR-68','Cerezo','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',50,80,64,'15',6),
    ('FR-69','Cerezo','Frutales','Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo \"Duke\", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado',50,91,72,'19',6),
    ('FR-7','Mandarino calibre 8/10','Frutales','',15,29,23,'15',3),
    ('FR-70','Ciruelo','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',50,11,8,'18',3),
    ('FR-71','Ciruelo','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',50,22,17,'26',3),
    ('FR-72','Ciruelo','Frutales','árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas',50,32,25,'15',3),
    ('FR-73','Granado','Frutales','pequeño árbol caducifolio, a veces con porte arbustivo, de 3 a 6 m de altura, con el tronco retorcido. Madera dura y corteza escamosa de color grisáceo. Las ramitas jóvenes son más o menos cuadrangulares o angostas y de cuatro alas, posteriormente se vuelven redondas con corteza de color café grisáceo, la mayoría de las ramas, pero especialmente las pequeñas ramitas axilares, son en forma de espina o terminan en una espina aguda; la copa es extendida.',50,13,10,'15',3),
    ('FR-74','Granado','Frutales','pequeño árbol caducifolio, a veces con porte arbustivo, de 3 a 6 m de altura, con el tronco retorcido. Madera dura y corteza escamosa de color grisáceo. Las ramitas jóvenes son más o menos cuadrangulares o angostas y de cuatro alas, posteriormente se vuelven redondas con corteza de color café grisáceo, la mayoría de las ramas, pero especialmente las pequeñas ramitas axilares, son en forma de espina o terminan en una espina aguda; la copa es extendida.',50,22,17,'15',3),
    ('FR-75','Granado','Frutales','pequeño árbol caducifolio, a veces con porte arbustivo, de 3 a 6 m de altura, con el tronco retorcido. Madera dura y corteza escamosa de color grisáceo. Las ramitas jóvenes son más o menos cuadrangulares o angostas y de cuatro alas, posteriormente se vuelven redondas con corteza de color café grisáceo, la mayoría de las ramas, pero especialmente las pequeñas ramitas axilares, son en forma de espina o terminan en una espina aguda; la copa es extendida.',50,32,25,'17',3),
    ('FR-76','Granado','Frutales','pequeño árbol caducifolio, a veces con porte arbustivo, de 3 a 6 m de altura, con el tronco retorcido. Madera dura y corteza escamosa de color grisáceo. Las ramitas jóvenes son más o menos cuadrangulares o angostas y de cuatro alas, posteriormente se vuelven redondas con corteza de color café grisáceo, la mayoría de las ramas, pero especialmente las pequeñas ramitas axilares, son en forma de espina o terminan en una espina aguda; la copa es extendida.',50,49,39,'19',3),
    ('FR-77','Granado','Frutales','pequeño árbol caducifolio, a veces con porte arbustivo, de 3 a 6 m de altura, con el tronco retorcido. Madera dura y corteza escamosa de color grisáceo. Las ramitas jóvenes son más o menos cuadrangulares o angostas y de cuatro alas, posteriormente se vuelven redondas con corteza de color café grisáceo, la mayoría de las ramas, pero especialmente las pequeñas ramitas axilares, son en forma de espina o terminan en una espina aguda; la copa es extendida.',50,70,56,'17',3),
    ('FR-78','Higuera','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',50,15,12,'16',3),
    ('FR-79','Higuera','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',50,22,17,'17',3),
    ('FR-8','Limonero -Plantón joven','Frutales','El limonero, pertenece al grupo de los cítricos, teniendo su origen hace unos 20 millones de años en el sudeste asiático. Fue introducido por los árabes en el área mediterránea entre los años 1.000 a 1.200, habiendo experimentando numerosas modificaciones debidas tanto a la selección natural mediante hibridaciones espontáneas como a las producidas por el',15,6,4,'17',4),
    ('FR-80','Higuera','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',50,32,25,'15',3),
    ('FR-81','Higuera','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',50,49,39,'16',3),
    ('FR-82','Higuera','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',50,70,56,'12',3),
    ('FR-83','Higuera','Frutales','La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.',50,80,64,'13',3),
    ('FR-84','Kaki','Frutales','De crecimiento algo lento los primeros años, llega a alcanzar hasta doce metros de altura o más, aunque en cultivo se prefiere algo más bajo (5-6). Tronco corto y copa extendida. Ramifica muy poco debido a la dominancia apical. Porte más o menos piramidal, aunque con la edad se hace más globoso.',50,13,10,'14',4),
    ('FR-85','Kaki','Frutales','De crecimiento algo lento los primeros años, llega a alcanzar hasta doce metros de altura o más, aunque en cultivo se prefiere algo más bajo (5-6). Tronco corto y copa extendida. Ramifica muy poco debido a la dominancia apical. Porte más o menos piramidal, aunque con la edad se hace más globoso.',50,70,56,'16',4),
    ('FR-86','Manzano','Frutales','alcanza como máximo 10 m. de altura y tiene una copa globosa. Tronco derecho que normalmente alcanza de 2 a 2,5 m. de altura, con corteza cubierta de lenticelas, lisa, adherida, de color ceniciento verdoso sobre los ramos y escamosa y gris parda sobre las partes viejas del árbol. Tiene una vida de unos 60-80 años. Las ramas se insertan en ángulo abierto sobre el tallo, de color verde oscuro, a veces tendiendo a negruzco o violáceo. Los brotes jóvenes terminan con frecuencia en una espina',50,11,8,'15',3),
    ('FR-87','Manzano','Frutales','alcanza como máximo 10 m. de altura y tiene una copa globosa. Tronco derecho que normalmente alcanza de 2 a 2,5 m. de altura, con corteza cubierta de lenticelas, lisa, adherida, de color ceniciento verdoso sobre los ramos y escamosa y gris parda sobre las partes viejas del árbol. Tiene una vida de unos 60-80 años. Las ramas se insertan en ángulo abierto sobre el tallo, de color verde oscuro, a veces tendiendo a negruzco o violáceo. Los brotes jóvenes terminan con frecuencia en una espina',50,22,17,'14',3),
    ('FR-88','Manzano','Frutales','alcanza como máximo 10 m. de altura y tiene una copa globosa. Tronco derecho que normalmente alcanza de 2 a 2,5 m. de altura, con corteza cubierta de lenticelas, lisa, adherida, de color ceniciento verdoso sobre los ramos y escamosa y gris parda sobre las partes viejas del árbol. Tiene una vida de unos 60-80 años. Las ramas se insertan en ángulo abierto sobre el tallo, de color verde oscuro, a veces tendiendo a negruzco o violáceo. Los brotes jóvenes terminan con frecuencia en una espina',50,32,25,'18',3),
    ('FR-89','Manzano','Frutales','alcanza como máximo 10 m. de altura y tiene una copa globosa. Tronco derecho que normalmente alcanza de 2 a 2,5 m. de altura, con corteza cubierta de lenticelas, lisa, adherida, de color ceniciento verdoso sobre los ramos y escamosa y gris parda sobre las partes viejas del árbol. Tiene una vida de unos 60-80 años. Las ramas se insertan en ángulo abierto sobre el tallo, de color verde oscuro, a veces tendiendo a negruzco o violáceo. Los brotes jóvenes terminan con frecuencia en una espina',50,49,39,'12',3),
    ('FR-9','Limonero calibre 8/10','Frutales','El limonero, pertenece al grupo de los cítricos, teniendo su origen hace unos 20 millones de años en el sudeste asiático. Fue introducido por los árabes en el área mediterránea entre los años 1.000 a 1.200, habiendo experimentando numerosas modificaciones debidas tanto a la selección natural mediante hibridaciones espontáneas como a las producidas por el',15,29,23,'13',4),
    ('FR-90','Níspero','Frutales','Aunque originario del Sudeste de China, el níspero llegó a Europa procedente de Japón en el siglo XVIII como árbol ornamental. En el siglo XIX se inició el consumo de los frutos en toda el área mediterránea, donde se adaptó muy bien a las zonas de cultivo de los cítricos.El cultivo intensivo comenzó a desarrollarse a finales de los años 60 y principios de los 70, cuando comenzaron a implantarse las variedades y técnicas de cultivo actualmente utilizadas.',50,70,56,'12',3),
    ('FR-91','Níspero','Frutales','Aunque originario del Sudeste de China, el níspero llegó a Europa procedente de Japón en el siglo XVIII como árbol ornamental. En el siglo XIX se inició el consumo de los frutos en toda el área mediterránea, donde se adaptó muy bien a las zonas de cultivo de los cítricos.El cultivo intensivo comenzó a desarrollarse a finales de los años 60 y principios de los 70, cuando comenzaron a implantarse las variedades y técnicas de cultivo actualmente utilizadas.',50,80,64,'19',3),
    ('FR-92','Melocotonero','Frutales','Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.\r\nEn Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.\r\nEn China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.',50,11,8,'18',5),
    ('FR-93','Melocotonero','Frutales','Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.\r\nEn Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.\r\nEn China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.',50,22,17,'16',5),
    ('FR-94','Melocotonero','Frutales','Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.\r\nEn Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.\r\nEn China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.',50,32,25,'16',5),
    ('FR-95','Melocotonero','Frutales','Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.\r\nEn Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.\r\nEn China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.',50,49,39,'16',5),
    ('FR-96','Membrillero','Frutales','arbolito caducifolio de 4-6 m de altura con el tronco tortuoso y la corteza lisa, grisácea, que se desprende en escamas con la edad. Copa irregular, con ramas inermes, flexuosas, parduzcas, punteadas. Ramillas jóvenes tomentosas',50,11,8,'17',3),
    ('FR-97','Membrillero','Frutales','arbolito caducifolio de 4-6 m de altura con el tronco tortuoso y la corteza lisa, grisácea, que se desprende en escamas con la edad. Copa irregular, con ramas inermes, flexuosas, parduzcas, punteadas. Ramillas jóvenes tomentosas',50,22,17,'22',3),
    ('FR-98','Membrillero','Frutales','arbolito caducifolio de 4-6 m de altura con el tronco tortuoso y la corteza lisa, grisácea, que se desprende en escamas con la edad. Copa irregular, con ramas inermes, flexuosas, parduzcas, punteadas. Ramillas jóvenes tomentosas',50,32,25,'22',3),
    ('FR-99','Membrillero','Frutales','arbolito caducifolio de 4-6 m de altura con el tronco tortuoso y la corteza lisa, grisácea, que se desprende en escamas con la edad. Copa irregular, con ramas inermes, flexuosas, parduzcas, punteadas. Ramillas jóvenes tomentosas',50,49,39,'12',3),
    ('OR-001','Arbustos Mix Maceta','Ornamentales','',25,5,4,'14',7),
    ('OR-100','Mimosa Injerto CLASICA Dealbata ','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,12,9,'14',8),
    ('OR-101','Expositor Mimosa Semilla Mix','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,6,4,'15',8),
    ('OR-102','Mimosa Semilla Bayleyana  ','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,6,4,'15',8),
    ('OR-103','Mimosa Semilla Bayleyana   ','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,10,8,'23',8),
    ('OR-104','Mimosa Semilla Cyanophylla    ','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,10,8,'29',8),
    ('OR-105','Mimosa Semilla Espectabilis  ','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,6,4,'29',8),
    ('OR-106','Mimosa Semilla Longifolia   ','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,10,8,'27',8),
    ('OR-107','Mimosa Semilla Floribunda 4 estaciones','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,6,4,'24',8),
    ('OR-108','Abelia Floribunda','Ornamentales','',100,5,4,'28',8),
    ('OR-109','Callistemom (Mix)','Ornamentales','Limpitatubos. arbolito de 6-7 m de altura. Ramas flexibles y colgantes (de ahí lo de \"llorón\")..',100,5,4,'29',8),
    ('OR-110','Callistemom (Mix)','Ornamentales','Limpitatubos. arbolito de 6-7 m de altura. Ramas flexibles y colgantes (de ahí lo de \"llorón\")..',100,2,1,'29',8),
    ('OR-111','Corylus Avellana \"Contorta\"','Ornamentales','',100,5,4,'24',8),
    ('OR-112','Escallonia (Mix)','Ornamentales','',120,5,4,'24',8),
    ('OR-113','Evonimus Emerald Gayeti','Ornamentales','',120,5,4,'25',8),
    ('OR-114','Evonimus Pulchellus','Ornamentales','',120,5,4,'26',8),
    ('OR-115','Forsytia Intermedia \"Lynwood\"','Ornamentales','',120,7,5,'27',8),
    ('OR-116','Hibiscus Syriacus  \"Diana\" -Blanco Puro','Ornamentales','Por su capacidad de soportar podas, pueden ser fácilmente moldeadas como bonsái en el transcurso de pocos años. Flores de muchos colores según la variedad, desde el blanco puro al rojo intenso, del amarillo al anaranjado. La flor apenas dura 1 día, pero continuamente aparecen nuevas y la floración se prolonga durante todo el periodo de crecimiento vegetativo.',120,7,5,'29',8),
    ('OR-117','Hibiscus Syriacus  \"Helene\" -Blanco-C.rojo','Ornamentales','Por su capacidad de soportar podas, pueden ser fácilmente moldeadas como bonsái en el transcurso de pocos años. Flores de muchos colores según la variedad, desde el blanco puro al rojo intenso, del amarillo al anaranjado. La flor apenas dura 1 día, pero continuamente aparecen nuevas y la floración se prolonga durante todo el periodo de crecimiento vegetativo.',120,7,5,'4',8),
    ('OR-118','Hibiscus Syriacus \"Pink Giant\" Rosa','Ornamentales','Por su capacidad de soportar podas, pueden ser fácilmente moldeadas como bonsái en el transcurso de pocos años. Flores de muchos colores según la variedad, desde el blanco puro al rojo intenso, del amarillo al anaranjado. La flor apenas dura 1 día, pero continuamente aparecen nuevas y la floración se prolonga durante todo el periodo de crecimiento vegetativo.',120,7,5,'14',8),
    ('OR-119','Laurus Nobilis Arbusto - Ramificado Bajo','Ornamentales','',120,5,4,'14',8),
    ('OR-120','Lonicera Nitida ','Ornamentales','',120,5,4,'6',8),
    ('OR-121','Lonicera Nitida \"Maigrum\"','Ornamentales','',120,5,4,'4',8),
    ('OR-122','Lonicera Pileata','Ornamentales','',120,5,4,'23',8),
    ('OR-123','Philadelphus \"Virginal\"','Ornamentales','',120,5,4,'12',8),
    ('OR-124','Prunus pisardii  ','Ornamentales','',120,5,4,'15',8),
    ('OR-125','Viburnum Tinus \"Eve Price\"','Ornamentales','',120,5,4,'14',8),
    ('OR-126','Weigelia \"Bristol Ruby\"','Ornamentales','',120,5,4,'13',8),
    ('OR-127','Camelia japonica','Ornamentales','Arbusto excepcional por su floración otoñal, invernal o primaveral. Flores: Las flores son solitarias, aparecen en el ápice de cada rama, y son con una corola simple o doble, y comprendiendo varios colores. Suelen medir unos 7-12 cm de diÃ metro y tienen 5 sépalos y 5 pétalos. Estambres numerosos unidos en la mitad o en 2/3 de su longitud.',50,7,5,'15',8),
    ('OR-128','Camelia japonica ejemplar','Ornamentales','Arbusto excepcional por su floración otoñal, invernal o primaveral. Flores: Las flores son solitarias, aparecen en el ápice de cada rama, y son con una corola simple o doble, y comprendiendo varios colores. Suelen medir unos 7-12 cm de diÃ metro y tienen 5 sépalos y 5 pétalos. Estambres numerosos unidos en la mitad o en 2/3 de su longitud.',50,98,78,'16',8),
    ('OR-129','Camelia japonica ejemplar','Ornamentales','Arbusto excepcional por su floración otoñal, invernal o primaveral. Flores: Las flores son solitarias, aparecen en el ápice de cada rama, y son con una corola simple o doble, y comprendiendo varios colores. Suelen medir unos 7-12 cm de diÃ metro y tienen 5 sépalos y 5 pétalos. Estambres numerosos unidos en la mitad o en 2/3 de su longitud.',50,110,88,'12',8),
    ('OR-130','Callistemom COPA','Ornamentales','Limpitatubos. arbolito de 6-7 m de altura. Ramas flexibles y colgantes (de ahí lo de \"llorón\")..',50,18,14,'14',8),
    ('OR-131','Leptospermum formado PIRAMIDE','Ornamentales','',50,18,14,'15',8),
    ('OR-132','Leptospermum COPA','Ornamentales','',50,18,14,'14',8),
    ('OR-133','Nerium oleander-CALIDAD \"GARDEN\"','Ornamentales','',50,2,1,'14',8),
    ('OR-134','Nerium Oleander Arbusto GRANDE','Ornamentales','',100,38,30,'16',8),
    ('OR-135','Nerium oleander COPA  Calibre 6/8','Ornamentales','',100,5,4,'20',8),
    ('OR-136','Nerium oleander ARBOL Calibre 8/10','Ornamentales','',100,18,14,'20',8),
    ('OR-137','ROSAL TREPADOR','Ornamentales','',100,4,3,'20',8),
    ('OR-138','Camelia Blanco, Chrysler Rojo, Soraya Naranja, ','Ornamentales','',100,4,3,'21',8),
    ('OR-139','Landora Amarillo, Rose Gaujard bicolor blanco-rojo','Ornamentales','',100,4,3,'22',8),
    ('OR-140','Kordes Perfect bicolor rojo-amarillo, Roundelay rojo fuerte','Ornamentales','',100,4,3,'23',8),
    ('OR-141','Pitimini rojo','Ornamentales','',100,4,3,'23',8),
    ('OR-142','Solanum Jazminoide','Ornamentales','',100,2,1,'25',8),
    ('OR-143','Wisteria Sinensis  azul, rosa, blanca','Ornamentales','',100,9,7,'26',8),
    ('OR-144','Wisteria Sinensis INJERTADAS DECÃ“','Ornamentales','',100,12,9,'26',8),
    ('OR-145','Bougamvillea Sanderiana Tutor','Ornamentales','',100,2,1,'24',8),
    ('OR-146','Bougamvillea Sanderiana Tutor','Ornamentales','',100,4,3,'25',8),
    ('OR-147','Bougamvillea Sanderiana Tutor','Ornamentales','',100,7,5,'2',8),
    ('OR-148','Bougamvillea Sanderiana Espaldera','Ornamentales','',100,7,5,'5',8),
    ('OR-149','Bougamvillea Sanderiana Espaldera','Ornamentales','',100,17,13,'4',8),
    ('OR-150','Bougamvillea roja, naranja','Ornamentales','',100,2,1,'4',8),
    ('OR-151','Bougamvillea Sanderiana, 3 tut. piramide','Ornamentales','',100,6,4,'4',8),
    ('OR-152','Expositor Árboles clima continental','Ornamentales','',100,6,4,'6',8),
    ('OR-153','Expositor Árboles clima mediterráneo','Ornamentales','',100,6,4,'7',8),
    ('OR-154','Expositor Árboles borde del mar','Ornamentales','',100,6,4,'6',8),
    ('OR-155','Acer Negundo  ','Ornamentales','',100,6,4,'4',8),
    ('OR-156','Acer platanoides  ','Ornamentales','',100,10,8,'6',8),
    ('OR-157','Acer Pseudoplatanus ','Ornamentales','',100,10,8,'4',8),
    ('OR-158','Brachychiton Acerifolius  ','Ornamentales','',100,6,4,'4',8),
    ('OR-159','Brachychiton Discolor  ','Ornamentales','',100,6,4,'26',8),
    ('OR-160','Brachychiton Rupestris','Ornamentales','',100,10,8,'21',8),
    ('OR-161','Cassia Corimbosa  ','Ornamentales','',100,6,4,'14',8),
    ('OR-162','Cassia Corimbosa ','Ornamentales','',100,10,8,'15',8),
    ('OR-163','Chitalpa Summer Bells   ','Ornamentales','',80,10,8,'4',8),
    ('OR-164','Erytrina Kafra','Ornamentales','',80,6,4,'4',8),
    ('OR-165','Erytrina Kafra','Ornamentales','',80,10,8,'6',8),
    ('OR-166','Eucalyptus Citriodora  ','Ornamentales','',80,6,4,'4',8),
    ('OR-167','Eucalyptus Ficifolia  ','Ornamentales','',80,6,4,'4',8),
    ('OR-168','Eucalyptus Ficifolia   ','Ornamentales','',80,10,8,'4',8),
    ('OR-169','Hibiscus Syriacus  Var. Injertadas 1 Tallo ','Ornamentales','',80,12,9,'4',8),
    ('OR-170','Lagunaria Patersonii  ','Ornamentales','',80,6,4,'5',8),
    ('OR-171','Lagunaria Patersonii   ','Ornamentales','',80,10,8,'4',8),
    ('OR-172','Lagunaria patersonii  calibre 8/10','Ornamentales','',80,18,14,'4',8),
    ('OR-173','Morus Alba  ','Ornamentales','',80,6,4,'4',8),
    ('OR-174','Morus Alba  calibre 8/10','Ornamentales','',80,18,14,'6',8),
    ('OR-175','Platanus Acerifolia   ','Ornamentales','',80,10,8,'5',8),
    ('OR-176','Prunus pisardii  ','Ornamentales','',80,10,8,'25',8),
    ('OR-177','Robinia Pseudoacacia Casque Rouge   ','Ornamentales','',80,15,12,'24',8),
    ('OR-178','Salix Babylonica  Pendula','Ornamentales','',80,6,4,'21',8),
    ('OR-179','Sesbania Punicea   ','Ornamentales','',80,6,4,'15',8),
    ('OR-180','Tamarix  Ramosissima Pink Cascade','Ornamentales','',80,6,4,'15',8),
    ('OR-181','Tamarix  Ramosissima Pink Cascade','Ornamentales','',80,10,8,'16',8),
    ('OR-182','Tecoma Stands   ','Ornamentales','',80,6,4,'12',8),
    ('OR-183','Tecoma Stands  ','Ornamentales','',80,10,8,'11',8),
    ('OR-184','Tipuana Tipu  ','Ornamentales','',80,6,4,'11',8),
    ('OR-185','Pleioblastus distichus-Bambú enano','Ornamentales','',80,6,4,'15',8),
    ('OR-186','Sasa palmata ','Ornamentales','',80,6,4,'15',8),
    ('OR-187','Sasa palmata ','Ornamentales','',80,10,8,'15',8),
    ('OR-188','Sasa palmata ','Ornamentales','',80,25,20,'5',8),
    ('OR-189','Phylostachys aurea','Ornamentales','',80,22,17,'6',8),
    ('OR-190','Phylostachys aurea','Ornamentales','',80,32,25,'4',8),
    ('OR-191','Phylostachys Bambusa Spectabilis','Ornamentales','',80,24,19,'4',8),
    ('OR-192','Phylostachys biseti','Ornamentales','',80,22,17,'4',8),
    ('OR-193','Phylostachys biseti','Ornamentales','',80,20,16,'6',8),
    ('OR-194','Pseudosasa japonica (Metake)','Ornamentales','',80,20,16,'4',8),
    ('OR-195','Pseudosasa japonica (Metake) ','Ornamentales','',80,6,4,'25',8),
    ('OR-196','Cedrus Deodara ','Ornamentales','',80,10,8,'14',8),
    ('OR-197','Cedrus Deodara \"Feeling Blue\" Novedad','Ornamentales','',80,12,9,'26',8),
    ('OR-198','Juniperus chinensis \"Blue Alps\"','Ornamentales','',80,4,3,'25',8),
    ('OR-199','Juniperus Chinensis Stricta','Ornamentales','',80,4,3,'24',8),
    ('OR-200','Juniperus horizontalis Wiltonii','Ornamentales','',80,4,3,'21',8),
    ('OR-201','Juniperus squamata \"Blue Star\"','Ornamentales','',80,4,3,'22',8),
    ('OR-202','Juniperus x media Phitzeriana verde','Ornamentales','',80,4,3,'23',8),
    ('OR-203','Pinus Canariensis','Ornamentales','',80,10,8,'25',8),
    ('OR-204','Pinus Halepensis','Ornamentales','',80,10,8,'26',8),
    ('OR-205','Pinus Pinea -Pino Piñonero','Ornamentales','',80,10,8,'27',8),
    ('OR-206','Thuja Esmeralda ','Ornamentales','',80,5,4,'4',8),
    ('OR-207','Tuja Occidentalis Woodwardii','Ornamentales','',80,4,3,'7',8),
    ('OR-208','Tuja orientalis \"Aurea nana\"','Ornamentales','',80,4,3,'8',8),
    ('OR-209','Archontophoenix Cunninghamiana','Ornamentales','',80,10,8,'2',8),
    ('OR-210','Beucarnea Recurvata','Ornamentales','',2,39,31,'4',8),
    ('OR-211','Beucarnea Recurvata','Ornamentales','',5,59,47,'4',8),
    ('OR-212','Bismarckia Nobilis','Ornamentales','',4,217,173,'6',8),
    ('OR-213','Bismarckia Nobilis','Ornamentales','',4,266,212,'4',8),
    ('OR-214','Brahea Armata','Ornamentales','',0,10,8,'4',8),
    ('OR-215','Brahea Armata','Ornamentales','',100,112,89,'2',8),
    ('OR-216','Brahea Edulis','Ornamentales','',100,19,15,'17',8),
    ('OR-217','Brahea Edulis','Ornamentales','',100,64,51,'14',8),
    ('OR-218','Butia Capitata','Ornamentales','',100,25,20,'16',8),
    ('OR-219','Butia Capitata','Ornamentales','',100,29,23,'19',8),
    ('OR-220','Butia Capitata','Ornamentales','',100,36,28,'14',8),
    ('OR-221','Butia Capitata','Ornamentales','',100,59,47,'13',8),
    ('OR-222','Butia Capitata','Ornamentales','',100,87,69,'4',8),
    ('OR-223','Chamaerops Humilis','Ornamentales','',100,4,3,'2',8),
    ('OR-224','Chamaerops Humilis','Ornamentales','',100,7,5,'6',8),
    ('OR-225','Chamaerops Humilis','Ornamentales','',100,10,8,'6',8),
    ('OR-226','Chamaerops Humilis','Ornamentales','',100,38,30,'13',8),
    ('OR-227','Chamaerops Humilis','Ornamentales','',100,64,51,'6',8),
    ('OR-228','Chamaerops Humilis \"Cerifera\"','Ornamentales','',100,32,25,'4',8),
    ('OR-229','Chrysalidocarpus Lutescens -ARECA','Ornamentales','',100,22,17,'4',8),
    ('OR-230','Cordyline Australis -DRACAENA','Ornamentales','',100,38,30,'6',8),
    ('OR-231','Cycas Revoluta','Ornamentales','',100,15,12,'6',8),
    ('OR-232','Cycas Revoluta','Ornamentales','',100,34,27,'7',8),
    ('OR-233','Dracaena Drago','Ornamentales','',1,13,10,'4',8),
    ('OR-234','Dracaena Drago','Ornamentales','',2,64,51,'4',8),
    ('OR-235','Dracaena Drago','Ornamentales','',2,92,73,'23',8),
    ('OR-236','Jubaea Chilensis','Ornamentales','',100,49,39,'22',8),
    ('OR-237','Livistonia Australis','Ornamentales','',50,19,15,'2',8),
    ('OR-238','Livistonia Decipiens','Ornamentales','',50,19,15,'4',8),
    ('OR-239','Livistonia Decipiens','Ornamentales','',50,49,39,'4',8),
    ('OR-240','Phoenix Canariensis','Ornamentales','',50,6,4,'6',8),
    ('OR-241','Phoenix Canariensis','Ornamentales','',50,19,15,'6',8),
    ('OR-242','Rhaphis Excelsa','Ornamentales','',50,21,16,'14',8),
    ('OR-243','Rhaphis Humilis','Ornamentales','',50,64,51,'14',8),
    ('OR-244','Sabal Minor','Ornamentales','',50,11,8,'21',8),
    ('OR-245','Sabal Minor','Ornamentales','',50,34,27,'25',8),
    ('OR-246','Trachycarpus Fortunei','Ornamentales','',50,18,14,'4',8),
    ('OR-247','Trachycarpus Fortunei','Ornamentales','',2,462,369,'4',8),
    ('OR-248','Washingtonia Robusta','Ornamentales','',15,3,2,'7',8),
    ('OR-249','Washingtonia Robusta','Ornamentales','',15,5,4,'9',8),
	('OR-250','Yucca Jewel','Ornamentales','',15,10,8,'8',8),
	('OR-251','Zamia Furfuracaea','Ornamentales','',15,168,134,'5',8),
	('OR-99','Mimosa DEALBATA Gaulois Astier','Ornamentales','Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...',100,14,11,'12',8);
 
INSERT INTO pais (codigo_pais, nombre_pais)
VALUES
    ('1', 'EEUU'),
    ('2', 'España'),
    ('3', 'Francia'),
    ('4', 'Australia'),
    ('5', 'Inglaterra'),
    ('6', 'Japón');

INSERT INTO region (codigo_region, nombre_region, codigo_pais)
VALUES
    ('1', 'Miami', '1'),
    ('2', 'Madrid', '2'),
    ('3', 'Barcelona', '2'),
    ('4', 'Islas Canarias', '2'),
    ('5', 'Cataluña', '2'),
    ('6', 'Canarias', '2'),
    ('7', 'Cadiz', '2'),
    ('8', 'Nueva Gales del Sur', '4'),
    ('9', 'Londres', '5'),
    ('10', 'MA', '1'),
    ('11', 'EMEA', '3'),
    ('12', 'EMEA', '5'),
    ('13', 'CA', '1'),
    ('14', 'APAC', '4'),
    ('15', 'Castilla-LaMancha', '2'),
    ('16', 'Chiyoda-Ku', '6');

INSERT INTO ciudad (codigo_ciudad, nombre_ciudad, codigo_region)
VALUES
    ('1', 'San Francisco', '13'),
    ('2', 'Miami', '1'),
    ('3', 'Nueva York', '13'),
    ('4', 'Fuenlabrada', '2'),
    ('5', 'Madrid', '2'),
    ('6', 'San Lorenzo del Escorial', '2'),
    ('7', 'Montornes del valles', '3'),
    ('8', 'Santa cruz de Tenerife', '4'),
    ('9', 'Barcelona', '5'),
    ('10', 'Canarias', '6'),
    ('11', 'Sotogrande', '7'),
    ('12', 'Humanes', '2'),
    ('13', 'Getafe', '2'),
    ('14', 'Paris', '11'),
    ('15', 'Sydney', '8'),
    ('16', 'Londres', '9'),
    ('17', 'Barcelona', '3'),
    ('18', 'Boston', '10'),
    ('19', 'Londres', '12'),
    ('20', 'Sydney', '14'),
    ('21', 'Talavera de la Reina', '15'),
    ('22', 'Tokyo', '16');

INSERT INTO tipo_direccion (codigo_tipo, nombre_tipo)
VALUES
    ('1', 'Hogar'),
    ('2', 'Trabajo');

INSERT INTO oficina (codigo_oficina, nombre_oficina)
VALUES
    ('BCN-ES','Barcelona-España'),
    ('BOS-USA','Boston-EEUU'),
    ('LON-UK','Londres-Inglaterra'),
    ('MAD-ES','Madrid-España'),
    ('PAR-FR','Paris-Francia'),
    ('SFC-USA','San Francisco-EEUU'),
    ('SYD-AU','Sydney-Australia'),
    ('TAL-ES','Talavera-España'),
    ('TOK-JP','Tokyo-Japón');

INSERT INTO puesto (codigo_puesto, nombre_puesto)
VALUES
    ('1', 'Director General'),
    ('2', 'Subdirector Marketing'),
    ('3', 'Subdirector Ventas'),
    ('4', 'Secretaria'),
    ('5', 'Representante Ventas'),
    ('6', 'Director Oficina');

INSERT INTO extension (codigo_extension, numero_extension)
VALUES
    ('1', '3897'),
    ('2', '2899'),
    ('3', '2837'),
    ('4', '2847'),
    ('5', '2844'),
    ('6', '2845'),
    ('7', '2444'),
    ('8', '2442'),
    ('9', '2518'),
    ('10', '2519'),
    ('11', '9981'),
    ('12', '9982'),
    ('13', '7454'),
    ('14', '7565'),
    ('15', '7665'),
    ('16', '8734'),
    ('17', '8735'),
    ('18', '3321'),
    ('19', '3322'),
    ('20', '3210'),
    ('21', '3211');

INSERT INTO empleado (codigo_empleado, nombre, apellido1, apellido2, email, codigo_oficina, codigo_jefe, codigo_puesto, codigo_extension)
VALUES
    (1,'Marcos','Magaña','Perez','marcos@jardineria.es','TAL-ES',NULL,'1','1'),
    (2,'Ruben','López','Martinez','rlopez@jardineria.es','TAL-ES',1,'2','2'),
    (3,'Alberto','Soria','Carrasco','asoria@jardineria.es','TAL-ES',2,'3','3'),
    (4,'Maria','Solís','Jerez','msolis@jardineria.es','TAL-ES',2,'4','4'),
    (5,'Felipe','Rosas','Marquez','frosas@jardineria.es','TAL-ES',3,'5','5'),
    (6,'Juan Carlos','Ortiz','Serrano','cortiz@jardineria.es','TAL-ES',3,'5','6'),
    (7,'Carlos','Soria','Jimenez','csoria@jardineria.es','MAD-ES',3,'6','7'),
    (8,'Mariano','López','Murcia','mlopez@jardineria.es','MAD-ES',7,'5','8'),
    (9,'Lucio','Campoamor','Martín','lcampoamor@jardineria.es','MAD-ES',7,'5','8'),
    (10,'Hilario','Rodriguez','Huertas','hrodriguez@jardineria.es','MAD-ES',7,'5','7'),
    (11,'Emmanuel','Magaña','Perez','manu@jardineria.es','BCN-ES',3,'6','9'),
    (12,'José Manuel','Martinez','De la Osa','jmmart@hotmail.es','BCN-ES',11,'5','10'),
    (13,'David','Palma','Aceituno','dpalma@jardineria.es','BCN-ES',11,'5','10'),
    (14,'Oscar','Palma','Aceituno','opalma@jardineria.es','BCN-ES',11,'5','10'),
    (15,'Francois','Fignon','','ffignon@gardening.com','PAR-FR',3,'6','11'),
    (16,'Lionel','Narvaez','','lnarvaez@gardening.com','PAR-FR',15,'5','12'),
    (17,'Laurent','Serra','','lserra@gardening.com','PAR-FR',15,'5','12'),
    (18,'Michael','Bolton','','mbolton@gardening.com','SFC-USA',3,'6','13'),
    (19,'Walter Santiago','Sanchez','Lopez','wssanchez@gardening.com','SFC-USA',18,'5','13'),
    (20,'Hilary','Washington','','hwashington@gardening.com','BOS-USA',3,'6','14'),
    (21,'Marcus','Paxton','','mpaxton@gardening.com','BOS-USA',20,'5','14'),
    (22,'Lorena','Paxton','','lpaxton@gardening.com','BOS-USA',20,'5','15'),
    (23,'Nei','Nishikori','','nnishikori@gardening.com','TOK-JP',3,'6','16'),
    (24,'Narumi','Riko','','nriko@gardening.com','TOK-JP',23,'5','16'),
    (25,'Takuma','Nomura','','tnomura@gardening.com','TOK-JP',23,'5','17'),
    (26,'Amy','Johnson','','ajohnson@gardening.com','LON-UK',3,'6','18'),
    (27,'Larry','Westfalls','','lwestfalls@gardening.com','LON-UK',26,'5','19'),
    (28,'John','Walton','','jwalton@gardening.com','LON-UK',26,'5','19'),
    (29,'Kevin','Fallmer','','kfalmer@gardening.com','SYD-AU',3,'6','20'),
    (30,'Julian','Bellinelli','','jbellinelli@gardening.com','SYD-AU',29,'5','21'),
    (31,'Mariko','Kishi','','mkishi@gardening.com','SYD-AU',29,'5','21');

INSERT INTO cliente (codigo_cliente, nombre_cliente, codigo_empleado_rep_ventas, limite_credito)
VALUES
    (1,'GoldFish Garden', 19, 3000),
    (3,'Gardening Associates', 19, 6000),
    (4,'Gerudo Valley', 22, 12000),
    (5,'Tendo Garden', 22, 600000),
    (6,'Lasas S.A.', 8, 154310),
    (7,'Beragua', 11, 20000),
    (8,'Club Golf Puerta del hierro', 11, 40000),
    (9,'Naturagua', 11, 32000),
    (10,'DaraDistribuciones', 11, 50000),
    (11,'Madrileña de riegos', 11, 20000),
    (12,'Lasas S.A.', 8, 154310),
    (13,'Camunas Jardines S.L.', 8, 16481),
    (14,'Dardena S.A.', 8, 321000),
    (15,'Jardin de Flores', 30, 40000),
    (16,'Flores Marivi', 5, 1500),
    (17,'Flowers, S.A', 5, 3500),
    (18,'Naturajardin', 30, 5050),
    (19,'Golf S.A.', 12, 30000),
    (20,'Americh Golf Management SL', 12, 20000),
    (21,'Aloha', 12, 50000),
    (22,'El Prat', 12, 30000),
    (23,'Sotogrande', 12, 60000),
    (24,'Vivero Humanes', 30, 7430),
    (25,'Fuenla City', 5, 4500),
    (26,'Jardines y Mansiones Cactus SL', 9, 76000),
    (27,'Jardinerías Matías SL', 9, 100500),
    (28,'Agrojardin', 30, 8040),
    (29,'Top Campo', 5, 5500),
    (30,'Jardineria Sara', 5, 7500),
    (31,'Campohermoso', 30, 3250),
    (32,'france telecom', 16, 10000),
    (33,'Musée du Louvre', 16, 30000),
    (35,'Tutifruti S.A', 31, 10000),
    (36,'Flores S.L.', 18, 6000),
    (37,'The Magic Garden', 18, 10000),
    (38,'El Jardin Viviente S.L', 31, 8000);

INSERT INTO direccion (codigo_direccion, linea_direccion1, linea_direccion2, codigo_postal, codigo_ciudad, codigo_tipo, codigo_cliente, codigo_oficina)
VALUES
    (1,'False Street 52 2 A',NULL,'24006', 1, 2, 1, NULL),
    (2,'Wall-e Avenue',NULL,'24010', 2, 2, 3, NULL),
    (3,'Oaks Avenue nº22',NULL,'85495', 3, 2, 4, NULL),
    (4,'Null Street nº69',NULL,'696969', 2, 2, 5, NULL),
    (5,'C/Leganes 15',NULL,'28945', 4, 2, 6, NULL),
    (6,'C/pintor segundo','Getafe','28942', 5, 2, 7, NULL),
    (7,'C/sinesio delgado','Madrid','28930', 5, 2, 8, NULL),
    (8,'C/majadahonda','Boadilla','28947', 5, 2, 9, NULL),
    (9,'C/azores','Fuenlabrada','28946', 5, 2, 10, NULL),
    (10,'C/Lagañas','Fuenlabrada','28943', 5, 2, 11, NULL),
    (11,'C/Leganes 15',NULL,'28945',4, 2, 12, NULL),
    (12,'C/Virgenes 45','C/Princesas 2 1ºB','28145', 6, 2, 13, NULL),
    (13,'C/Nueva York 74',NULL,'28003', 5, 2, 14, NULL),
    (14,'C/ Oña 34',NULL,'28950', 5, 2, 15, NULL),
    (15,'C/Leganes24',NULL,'28945', 4, 2, 16, NULL),
    (16,'C/Luis Salquillo4',NULL,'24586', 7, 2, 17, NULL),
    (17,'Plaza Magallón 15',NULL,'28011', 5, 2, 18, NULL),
    (18,'C/Estancado',NULL,'38297', 8, 2, 19, NULL),
    (19,'C/Letardo',NULL,'12320', 9, 2, 20, NULL),
    (20,'C/Roman 3',NULL,'35488', 10, 2, 21, NULL),
    (21,'Avenida Tibidabo',NULL,'12320', 9, 2, 22, NULL),
    (22,'C/Paseo del Parque',NULL,'11310', 11, 2, 23, NULL),
    (23,'C/Miguel Echegaray 54',NULL,'28970', 12, 2, 24, NULL),
    (24,'C/Callo 52',NULL,'28574', 4, 2, 25, NULL),
    (25,'Polígono Industrial Maspalomas, Nº52','Móstoles','29874', 5, 2, 26, NULL),
    (26,'C/Francisco Arce, Nº44','Bustarviejo','37845', 5, 2, 27, NULL),
    (27,'C/Mar Caspio 43',NULL,'28904', 13, 2, 28, NULL),
    (28,'C/Ibiza 32',NULL,'28574', 12, 2, 29, NULL),
    (29,'C/Lima 1',NULL,'27584', 4, 2, 30, NULL),
    (30,'C/Peru 78',NULL,'28945', 4, 2, 31, NULL),
    (31,'6 place d Alleray 15Ã¨me',NULL,'75010', 14, 2, 32, NULL),
    (32,'Quai du Louvre',NULL,'75058', 14, 2, 33, NULL),
    (33,'level 24, St. Martins Tower.-31 Market St.',NULL,'2000', 15, 2, 35, NULL),
    (34,'Avenida España',NULL,'29643', 5, 2, 36, NULL),
    (35,'Lihgting Park',NULL,'65930', 19, 2, 37, NULL),
    (36,'176 Cumberland Street The rocks',NULL,'2003', 20, 2, 38, NULL),
    (37,'Avenida Diagonal, 38','3A escalera Derecha','08019', 17, 2, NULL, 'BCN-ES'),
    (38,'1550 Court Place','Suite 102','02108', 18, 2, NULL, 'BOS-USA'),
    (39,'52 Old Broad Street','Ground Floor','EC2N 1HN', 19, 2, NULL, 'LON-UK'),
    (40,'Bulevar Indalecio Prieto, 32','','28032', 5, 2, NULL, 'MAD-ES'),
    (41,'29 Rue Jouffroy d''abbans','','75017', 14, 2, NULL, 'PAR-FR'),
    (42,'100 Market Street','Suite 300','94080', 1, 2, NULL, 'SFC-USA'),
    (43,'5-11 Wentworth Avenue','Floor #2','NSW 2010', 20, 2, NULL, 'SYD-AU'),
    (44,'Francisco Aguirre, 32','5º piso (exterior)','45632', 21, 2, NULL, 'TAL-ES'),
    (45,'4-1 Kioicho','','102-8578', 22, 2, NULL, 'TOK-JP');

INSERT INTO contacto (codigo_contacto, nombre_contacto, apellido_contacto, fax, codigo_cliente)
VALUES
    (1,'Daniel G','GoldFish','5556901746', 1),
    (3,'Anne','Wright','5557410346', 3),
    (4,'Link','Flaute','5552323128', 4),
    (5,'Akane','Tendo','55591233211', 5),
    (6,'Antonio','Lasas','34914851312', 6),
    (7,'Jose','Bermejo','916549872', 7),
    (8,'Paco','Lopez','919535678', 8),
    (9,'Guillermo','Rengifo','916428956', 9),
    (10,'David','Serrano','916421756', 10),
    (11,'Jose','Tacaño','916689215', 11),
    (12,'Antonio','Lasas','34914851312', 12),
    (13,'Pedro','Camunas','34914871541', 13),
    (14,'Juan','Rodriguez','34912484764', 14),
    (15,'Javier','Villar','914538776', 15),
    (16,'Maria','Rodriguez','912458657', 16),
    (17,'Beatriz','Fernandez','978453216', 17),
    (18,'Victoria','Cruz','916548735', 18),
    (19,'Luis','Martinez','912354475', 19),
    (20,'Mario','Suarez','964493063', 20),
    (21,'Cristian','Rodrigez','914489898', 21),
    (22,'Francisco','Camacho','916493211', 22),
    (23,'Maria','Santillana','914825645', 23),
    (24,'Federico','Gomez','916040875', 24),
    (25,'Tony','Muñoz Mena','915483754', 25),
    (26,'Eva María','Sánchez','914477777', 26),
    (27,'Matías','San Martín','917897474', 27),
    (28,'Benito','Lopez','916549264', 28),
    (29,'Joseluis','Sanchez','974315924', 29),
    (30,'Sara','Marquez','912475843', 30),
    (31,'Luis','Jimenez','916159116', 31),
    (32,'FraÃ§ois','Toulou','(33)5120578961', 32),
    (33,'Pierre','Delacroux','(33)0140205442', 33),
    (35,'Jacob','Jones','2 9283-1695', 35),
    (36,'Antonio','Romero','685249700', 36),
    (37,'Richard','Mcain','9364875882', 37),
    (38,'Justin','Smith','2 8005-7162', 38);

INSERT INTO estado (codigo_estado, nombre_estado)
VALUES
	('1', 'Entregado'),
    ('2', 'Pendiente'),
    ('3', 'Rechazado');

INSERT INTO pedido (codigo_pedido, fecha_pedido, fecha_esperada, fecha_entrega, comentarios, codigo_cliente, codigo_estado)
VALUES
    (1,'2006-01-17','2006-01-19','2006-01-19','Pagado a plazos',5,'1'),
    (2,'2007-10-23','2007-10-28','2007-10-26','La entrega llego antes de lo esperado',5,'1'),
    (3,'2008-06-20','2008-06-25',NULL,'Limite de credito superado',5,'3'),
    (4,'2009-01-20','2009-01-26',NULL,NULL,5,'2'),
    (8,'2008-11-09','2008-11-14','2008-11-14','El cliente paga la mitad con tarjeta y la otra mitad con efectivo, se le realizan dos facturas',1,'1'),
    (9,'2008-12-22','2008-12-27','2008-12-28','El cliente comprueba la integridad del paquete, todo correcto',1,'1'),
    (10,'2009-01-15','2009-01-20',NULL,'El cliente llama para confirmar la fecha - Esperando al proveedor',3,'2'),
    (11,'2009-01-20','2009-01-27',NULL,'El cliente requiere que el pedido se le entregue de 16:00h a 22:00h',1,'2'),
    (12,'2009-01-22','2009-01-27',NULL,'El cliente requiere que el pedido se le entregue de 9:00h a 13:00h',1,'2'),
    (13,'2009-01-12','2009-01-14','2009-01-15',NULL,7,'1'),
    (14,'2009-01-02','2009-01-02',null,'mal pago',7,'3'),
    (15,'2009-01-09','2009-01-12','2009-01-11',NULL,7,'1'),
    (16,'2009-01-06','2009-01-07','2009-01-15',NULL,7,'1'),
    (17,'2009-01-08','2009-01-09','2009-01-11','mal estado',7,'1'),
    (18,'2009-01-05','2009-01-06','2009-01-07',NULL,9,'1'),
    (19,'2009-01-18','2009-02-12',NULL,'entregar en murcia',9,'2'),
    (20,'2009-01-20','2009-02-15',NULL,NULL,9,'2'),
    (21,'2009-01-09','2009-01-09','2009-01-09','mal pago',9,'3'),
    (22,'2009-01-11','2009-01-11','2009-01-13',NULL,9,'1'),
    (23,'2008-12-30','2009-01-10',NULL,'El pedido fue anulado por el cliente',5,'3'),
    (24,'2008-07-14','2008-07-31','2008-07-25',NULL,14,'1'),
    (25,'2009-02-02','2009-02-08',NULL,'El cliente carece de saldo en la cuenta asociada',1,'3'),
    (26,'2009-02-06','2009-02-12',NULL,'El cliente anula la operacion para adquirir mas producto',3,'3'),
    (27,'2009-02-07','2009-02-13',NULL,'El pedido aparece como entregado pero no sabemos en que fecha',3,'1'),
    (28,'2009-02-10','2009-02-17','2009-02-20','El cliente se queja bastante de la espera asociada al producto',3,'1'),
    (29,'2008-08-01','2008-09-01','2008-09-01','El cliente no está conforme con el pedido',14,'3'),
    (30,'2008-08-03','2008-09-03','2008-08-31',NULL,13,'1'),
    (31,'2008-09-04','2008-09-30','2008-10-04','El cliente ha rechazado por llegar 5 dias tarde',13,'3'),
    (32,'2007-01-07','2007-01-19','2007-01-27','Entrega tardia, el cliente puso reclamacion',4,'1'),
    (33,'2007-05-20','2007-05-28',NULL,'El pedido fue anulado por el cliente',4,'3'),
    (34,'2007-06-20','2008-06-28','2008-06-28','Pagado a plazos',4,'1'),
    (35,'2008-03-10','2009-03-20',NULL,'Limite de credito superado',4,'3'),
    (36,'2008-10-15','2008-12-15','2008-12-10',NULL,14,'1'),
    (37,'2008-11-03','2009-11-13',NULL,'El pedido nunca llego a su destino',4,'2'),
    (38,'2009-03-05','2009-03-06','2009-03-07',NULL,19,'1'),
    (39,'2009-03-06','2009-03-07','2009-03-09',NULL,19,'2'),
    (40,'2009-03-09','2009-03-10','2009-03-13',NULL,19,'3'),
    (41,'2009-03-12','2009-03-13','2009-03-13',NULL,19,'1'),
    (42,'2009-03-22','2009-03-23','2009-03-27',NULL,19,'1'),
    (43,'2009-03-25','2009-03-26','2009-03-28',NULL,23,'2'),
    (44,'2009-03-26','2009-03-27','2009-03-30',NULL,23,'2'),
    (45,'2009-04-01','2009-03-04','2009-03-07',NULL,23,'1'),
    (46,'2009-04-03','2009-03-04','2009-03-05',NULL,23,'3'),
    (47,'2009-04-15','2009-03-17','2009-03-17',NULL,23,'1'),
    (48,'2008-03-17','2008-03-30','2008-03-29','Según el Cliente, el pedido llegó defectuoso',26,'1'),
    (49,'2008-07-12','2008-07-22','2008-07-30','El pedido llegó 1 día tarde, pero no hubo queja por parte de la empresa compradora',26,'1'),
    (50,'2008-03-17','2008-08-09',NULL,'Al parecer, el pedido se ha extraviado a la altura de Sotalbo (Ávila)',26,'2'),
    (51,'2008-10-01','2008-10-14','2008-10-14','Todo se entregó a tiempo y en perfecto estado, a pesar del pésimo estado de las carreteras.',26,'1'),
    (52,'2008-12-07','2008-12-21',NULL,'El transportista ha llamado a Eva María para indicarle que el pedido llegará más tarde de lo esperado.',26,'2'),
    (53,'2008-10-15','2008-11-15','2008-11-09','El pedido llega 6 dias antes',13,'1'),
    (54,'2009-01-11','2009-02-11',NULL,NULL,14,'2'),
    (55,'2008-12-10','2009-01-10','2009-01-11','Retrasado 1 dia por problemas de transporte',14,'1'),
    (56,'2008-12-19','2009-01-20',NULL,'El cliente a anulado el pedido el dia 2009-01-10',13,'3'),
    (57,'2009-01-05','2009-02-05',NULL,NULL,13,'2'),
    (58,'2009-01-24','2009-01-31','2009-01-30','Todo correcto',3,'1'),
    (59,'2008-11-09','2008-11-14','2008-11-14','El cliente paga la mitad con tarjeta y la otra mitad con efectivo, se le realizan dos facturas',1,'1'),
    (60,'2008-12-22','2008-12-27','2008-12-28','El cliente comprueba la integridad del paquete, todo correcto',1,'1'),
    (61,'2009-01-15','2009-01-20',NULL,'El cliente llama para confirmar la fecha - Esperando al proveedor',3,'2'),
    (62,'2009-01-20','2009-01-27',NULL,'El cliente requiere que el pedido se le entregue de 16:00h a 22:00h',1,'2'),
    (63,'2009-01-22','2009-01-27',NULL,'El cliente requiere que el pedido se le entregue de 9:00h a 13:00h',1,'2'),
    (64,'2009-01-24','2009-01-31','2009-01-30','Todo correcto',1,'1'),
    (65,'2009-02-02','2009-02-08',NULL,'El cliente carece de saldo en la cuenta asociada',1,'3'),
    (66,'2009-02-06','2009-02-12',NULL,'El cliente anula la operacion para adquirir mas producto',3,'3'),
    (67,'2009-02-07','2009-02-13',NULL,'El pedido aparece como entregado pero no sabemos en que fecha',3,'1'),
    (68,'2009-02-10','2009-02-17','2009-02-20','El cliente se queja bastante de la espera asociada al producto',3,'1'),
    (74,'2009-01-14','2009-01-22',NULL,'El pedido no llego el dia que queria el cliente por fallo del transporte',15,'3'),
    (75,'2009-01-11','2009-01-13','2009-01-13','El pedido llego perfectamente',15,'1'),
    (76,'2008-11-15','2008-11-23','2008-11-23',NULL,15,'1'),
    (77,'2009-01-03','2009-01-08',NULL,'El pedido no pudo ser entregado por problemas meteorologicos',15,'2'),
    (78,'2008-12-15','2008-12-17','2008-12-17','Fue entregado, pero faltaba mercancia que sera entregada otro dia',15,'1'),
    (79,'2009-01-12','2009-01-13','2009-01-13',NULL,28,'1'),
    (80,'2009-01-25','2009-01-26',NULL,'No terminó el pago',28,'2'),
    (81,'2009-01-18','2009-01-24',NULL,'Los producto estaban en mal estado',28,'3'),
    (82,'2009-01-20','2009-01-29','2009-01-29','El pedido llego un poco mas tarde de la hora fijada',28,'1'),
    (83,'2009-01-24','2009-01-28',NULL,NULL,28,'1'),
    (89,'2007-10-05','2007-12-13','2007-12-10','La entrega se realizo dias antes de la fecha esperada por lo que el cliente quedo satisfecho',35,'1'),
    (90,'2009-02-07','2008-02-17',NULL,'Debido a la nevada caída en la sierra, el pedido no podrá llegar hasta el día ',27,'2'),
    (91,'2009-03-18','2009-03-29','2009-03-27','Todo se entregó a su debido tiempo, incluso con un día de antelación',27,'1'),
    (92,'2009-04-19','2009-04-30','2009-05-03','El pedido se entregó tarde debido a la festividad celebrada en España durante esas fechas',27,'1'),
    (93,'2009-05-03','2009-05-30','2009-05-17','El pedido se entregó antes de lo esperado.',27,'1'),
    (94,'2009-10-18','2009-11-01',NULL,'El pedido está en camino.',27,'2'),
    (95,'2008-01-04','2008-01-19','2008-01-19',NULL,35,'1'),
    (96,'2008-03-20','2008-04-12','2008-04-13','La entrega se retraso un dia',35,'1'),
    (97,'2008-10-08','2008-11-25','2008-11-25',NULL,35,'1'),
    (98,'2009-01-08','2009-02-13',NULL,NULL,35,'2'),
    (99,'2009-02-15','2009-02-27',NULL,NULL,16,'2'),
    (100,'2009-01-10','2009-01-15','2009-01-15','El pedido llego perfectamente',16,'1'),
    (101,'2009-03-07','2009-03-27',NULL,'El pedido fue rechazado por el cliente',16,'3'),
    (102,'2008-12-28','2009-01-08','2009-01-08','Pago pendiente',16,'1'),
    (103,'2009-01-15','2009-01-20','2009-01-24',NULL,30,'2'),
    (104,'2009-03-02','2009-03-06','2009-03-06',NULL,30,'1'),
    (105,'2009-02-14','2009-02-20',NULL,'el producto ha sido rechazado por la pesima calidad',30,'3'),
    (106,'2009-05-13','2009-05-15','2009-05-20',NULL,30,'2'),
    (107,'2009-04-06','2009-04-10','2009-04-10',NULL,30,'1'),
    (108,'2009-04-09','2009-04-15','2009-04-15',NULL,16,'1'),
    (109,'2006-05-25','2006-07-28','2006-07-28',NULL,38,'1'),
    (110,'2007-03-19','2007-04-24','2007-04-24',NULL,38,'1'),
    (111,'2008-03-05','2008-03-30','2008-03-30',NULL,36,'1'),
    (112,'2009-03-05','2009-04-06','2009-05-07',NULL,36,'2'),
    (113,'2008-10-28','2008-11-09','2009-01-09','El producto ha sido rechazado por la tardanza de el envio',36,'3'),
    (114,'2009-01-15','2009-01-29','2009-01-31','El envio llego dos dias más tarde debido al mal tiempo',36,'1'),
    (115,'2008-11-29','2009-01-26','2009-02-27',NULL,36,'2'),
    (116,'2008-06-28','2008-08-01','2008-08-01',NULL,38,'1'),
    (117,'2008-08-25','2008-10-01',NULL,'El pedido ha sido rechazado por la acumulacion de pago pendientes del cliente',38,'3'),
    (118,'2009-02-15','2009-02-27',NULL,NULL,16,'2'),
    (119,'2009-01-10','2009-01-15','2009-01-15','El pedido llego perfectamente',16,'1'),
    (120,'2009-03-07','2009-03-27',NULL,'El pedido fue rechazado por el cliente',16,'3'),
    (121,'2008-12-28','2009-01-08','2009-01-08','Pago pendiente',16,'1'),
    (122,'2009-04-09','2009-04-15','2009-04-15',NULL,16,'1'),
    (123,'2009-01-15','2009-01-20','2009-01-24',NULL,30,'2'),
    (124,'2009-03-02','2009-03-06','2009-03-06',NULL,30,'1'),
    (125,'2009-02-14','2009-02-20',NULL,'el producto ha sido rechazado por la pesima calidad',30,'3'),
    (126,'2009-05-13','2009-05-15','2009-05-20',NULL,30,'2'),
    (127,'2009-04-06','2009-04-10','2009-04-10',NULL,30,'1'),
    (128,'2008-11-10','2008-12-10','2008-12-29','El pedido ha sido rechazado por el cliente por el retraso en la entrega',38,'3');

INSERT INTO detalle_pedido (pedido_codigo_pedido, producto_codigo_producto, cantidad, precio_unidad, numero_linea)
VALUES
    (1,'FR-67',10,70,3),
    (1,'OR-127',40,4,1),
    (1,'OR-141',25,4,2),
    (1,'OR-241',15,19,4),
    (1,'OR-99',23,14,5),
    (2,'FR-4',3,29,6),
    (2,'FR-40',7,8,7),
    (2,'OR-140',50,4,3),
    (2,'OR-141',20,5,2),
    (2,'OR-159',12,6,5),
    (2,'OR-227',67,64,1),
    (2,'OR-247',5,462,4),
    (3,'FR-48',120,9,6),
    (3,'OR-122',32,5,4),
    (3,'OR-123',11,5,5),
    (3,'OR-213',30,266,1),
    (3,'OR-217',15,65,2),
    (3,'OR-218',24,25,3),
    (4,'FR-31',12,8,7),
    (4,'FR-34',42,8,6),
    (4,'FR-40',42,9,8),
    (4,'OR-152',3,6,5),
    (4,'OR-155',4,6,3),
    (4,'OR-156',17,9,4),
    (4,'OR-157',38,10,2),
    (4,'OR-222',21,59,1),
    (8,'FR-106',3,11,1),
    (8,'FR-108',1,32,2),
    (8,'FR-11',10,100,3),
    (9,'AR-001',80,1,3),
    (9,'AR-008',450,1,2),
    (9,'FR-106',80,8,1),
    (9,'FR-69',15,91,2),
    (10,'FR-82',5,70,2),
    (10,'FR-91',30,75,1),
    (10,'OR-234',5,64,3),
    (11,'AR-006',180,1,3),
    (11,'OR-247',80,8,1),
    (12,'AR-009',290,1,1),
    (13,'11679',5,14,1),
    (13,'21636',12,14,2),
    (13,'FR-11',5,100,3),
    (14,'FR-100',8,11,2),
    (14,'FR-13',13,57,1),
    (15,'FR-84',4,13,3),
    (15,'OR-101',2,6,2),
    (15,'OR-156',6,10,1),
    (15,'OR-203',9,10,4),
    (16,'30310',12,12,1),
    (16,'FR-36',10,9,2),
    (17,'11679',5,14,1),
    (17,'22225',5,12,3),
    (17,'FR-37',5,9,2),
    (17,'FR-64',5,22,4),
    (17,'OR-136',5,18,5),
    (18,'22225',4,12,2),
    (18,'FR-22',2,4,1),
    (18,'OR-159',10,6,3),
    (19,'30310',9,12,5),
    (19,'FR-23',6,8,4),
    (19,'FR-75',1,32,2),
    (19,'FR-84',5,13,1),
    (19,'OR-208',20,4,3),
    (20,'11679',14,14,1),
    (20,'30310',8,12,2),
    (21,'21636',5,14,3),
    (21,'FR-18',22,4,1),
    (21,'FR-53',3,8,2),
    (22,'OR-240',1,6,1),
    (23,'AR-002',110,1,4),
    (23,'FR-107',50,22,3),
    (23,'FR-85',4,70,2),
    (23,'OR-249',30,5,1),
    (24,'22225',3,15,1),
    (24,'FR-1',4,7,4),
    (24,'FR-23',2,7,2),
    (24,'OR-241',10,20,3),
    (25,'FR-77',15,69,1),
    (25,'FR-9',4,30,3),
    (25,'FR-94',10,30,2),
    (26,'FR-15',9,25,3),
    (26,'OR-188',4,25,1),
    (26,'OR-218',14,25,2),
    (27,'OR-101',22,6,2),
    (27,'OR-102',22,6,3),
    (27,'OR-186',40,6,1),
    (28,'FR-11',8,99,3),
    (28,'OR-213',3,266,2),
    (28,'OR-247',1,462,1),
    (29,'FR-82',4,70,4),
    (29,'FR-9',4,28,1),
    (29,'FR-94',20,31,5),
    (29,'OR-129',2,111,2),
    (29,'OR-160',10,9,3),
    (30,'AR-004',10,1,6),
    (30,'FR-108',2,32,2),
    (30,'FR-12',2,19,3),
    (30,'FR-72',4,31,5),
    (30,'FR-89',10,45,1),
    (30,'OR-120',5,5,4),
    (31,'AR-009',25,2,3),
    (31,'FR-102',1,20,1),
    (31,'FR-4',6,29,2),
    (32,'11679',1,14,4),
    (32,'21636',4,15,5),
    (32,'22225',1,15,3),
    (32,'OR-128',29,100,2),
    (32,'OR-193',5,20,1),
    (33,'FR-17',423,2,4),
    (33,'FR-29',120,8,3),
    (33,'OR-214',212,10,2),
    (33,'OR-247',150,462,1),
    (34,'FR-3',56,7,4),
    (34,'FR-7',12,29,3),
    (34,'OR-172',20,18,1),
    (34,'OR-174',24,18,2),
    (35,'21636',12,14,4),
    (35,'FR-47',55,8,3),
    (35,'OR-165',3,10,2),
    (35,'OR-181',36,10,1),
    (35,'OR-225',72,10,5),
    (36,'30310',4,12,2),
    (36,'FR-1',2,7,3),
    (36,'OR-147',6,7,4),
    (36,'OR-203',1,12,5),
    (36,'OR-99',15,13,1),
    (37,'FR-105',4,70,1),
    (37,'FR-57',203,8,2),
    (37,'OR-176',38,10,3),
    (38,'11679',5,14,1),
    (38,'21636',2,14,2),
    (39,'22225',3,12,1),
    (39,'30310',6,12,2),
    (40,'AR-001',4,1,1),
    (40,'AR-002',8,1,2),
    (41,'AR-003',5,1,1),
    (41,'AR-004',5,1,2),
    (42,'AR-005',3,1,1),
    (42,'AR-006',1,1,2),
    (43,'AR-007',9,1,1),
    (44,'AR-008',5,1,1),
    (45,'AR-009',6,1,1),
    (45,'AR-010',4,1,2),
    (46,'FR-1',4,7,1),
    (46,'FR-10',8,7,2),
    (47,'FR-100',9,11,1),
    (47,'FR-101',5,13,2),
    (48,'FR-102',1,18,1),
    (48,'FR-103',1,25,2),
    (48,'OR-234',50,64,1),
    (48,'OR-236',45,49,2),
    (48,'OR-237',50,19,3),
    (49,'OR-204',50,10,1),
    (49,'OR-205',10,10,2),
    (49,'OR-206',5,5,3),
    (50,'OR-225',12,10,1),
    (50,'OR-226',15,38,2),
    (50,'OR-227',44,64,3),
    (51,'OR-209',50,10,1),
    (51,'OR-210',80,39,2),
    (51,'OR-211',70,59,3),
    (53,'FR-2',1,7,1),
    (53,'FR-85',1,70,3),
    (53,'FR-86',2,11,2),
    (53,'OR-116',6,7,4),
    (54,'11679',3,14,3),
    (54,'FR-100',45,10,2),
    (54,'FR-18',5,4,1),
    (54,'FR-79',3,22,4),
    (54,'OR-116',8,7,6),
    (54,'OR-123',3,5,5),
    (54,'OR-168',2,10,7),
    (55,'OR-115',9,7,1),
    (55,'OR-213',2,266,2),
    (55,'OR-227',6,64,5),
    (55,'OR-243',2,64,4),
    (55,'OR-247',1,462,3),
    (56,'OR-129',1,115,5),
    (56,'OR-130',10,18,6),
    (56,'OR-179',1,6,3),
    (56,'OR-196',3,10,4),
    (56,'OR-207',4,4,2),
    (56,'OR-250',3,10,1),
    (57,'FR-69',6,91,4),
    (57,'FR-81',3,49,3),
    (57,'FR-84',2,13,1),
    (57,'FR-94',6,9,2),
    (58,'OR-102',65,18,3),
    (58,'OR-139',80,4,1),
    (58,'OR-172',69,15,2),
    (58,'OR-177',150,15,4),
    (74,'FR-67',15,70,1),
    (74,'OR-227',34,64,2),
    (74,'OR-247',42,8,3),
    (75,'AR-006',60,1,2),
    (75,'FR-87',24,22,3),
    (75,'OR-157',46,10,1),
    (76,'AR-009',250,1,5),
    (76,'FR-79',40,22,3),
    (76,'FR-87',24,22,4),
    (76,'FR-94',35,9,1),
    (76,'OR-196',25,10,2),
    (77,'22225',34,12,2),
    (77,'30310',15,12,1),
    (78,'FR-53',25,8,2),
    (78,'FR-85',56,70,3),
    (78,'OR-157',42,10,4),
    (78,'OR-208',30,4,1),
    (79,'OR-240',50,6,1),
    (80,'FR-11',40,100,3),
    (80,'FR-36',47,9,2),
    (80,'OR-136',75,18,1),
    (81,'OR-208',30,4,1),
    (82,'OR-227',34,64,1),
    (83,'OR-208',30,4,1),
    (89,'FR-108',3,32,2),
    (89,'FR-3',15,7,6),
    (89,'FR-42',12,8,4),
    (89,'FR-66',5,49,1),
    (89,'FR-87',4,22,3),
    (89,'OR-157',8,10,5),
    (90,'AR-001',19,1,1),
    (90,'AR-002',10,1,2),
    (90,'AR-003',12,1,3),
    (91,'FR-100',52,11,1),
    (91,'FR-101',14,13,2),
    (91,'FR-102',35,18,3),
    (92,'FR-108',12,23,1),
    (92,'FR-11',20,100,2),
    (92,'FR-12',30,21,3),
    (93,'FR-54',25,9,1),
    (93,'FR-58',51,11,2),
    (93,'FR-60',3,32,3),
    (94,'11679',12,14,1),
    (94,'FR-11',33,100,3),
    (94,'FR-4',79,29,2),
    (95,'FR-10',9,7,2),
    (95,'FR-75',6,32,1),
    (95,'FR-82',5,70,3),
    (96,'FR-43',6,8,1),
    (96,'FR-6',16,7,4),
    (96,'FR-71',10,22,3),
    (96,'FR-90',4,70,2),
    (97,'FR-41',12,8,1),
    (97,'FR-54',14,9,2),
    (97,'OR-156',10,10,3),
    (98,'FR-33',14,8,4),
    (98,'FR-56',16,8,3),
    (98,'FR-60',8,32,1),
    (98,'FR-8',18,6,5),
    (98,'FR-85',6,70,2),
    (99,'OR-157',15,10,2),
    (99,'OR-227',30,64,1),
    (100,'FR-87',20,22,1),
    (100,'FR-94',40,9,2),
    (101,'AR-006',50,1,1),
    (101,'AR-009',159,1,2),
    (102,'22225',32,12,2),
    (102,'30310',23,12,1),
    (103,'FR-53',12,8,2),
    (103,'OR-208',52,4,1),
    (104,'FR-85',9,70,1),
    (104,'OR-157',113,10,2),
    (105,'OR-227',21,64,2),
    (105,'OR-240',27,6,1),
    (106,'AR-009',231,1,1),
    (106,'OR-136',47,18,2),
    (107,'30310',143,12,2),
    (107,'FR-11',15,100,1),
    (108,'FR-53',53,8,1),
    (108,'OR-208',59,4,2),
    (109,'FR-22',8,4,5),
    (109,'FR-36',12,9,3),
    (109,'FR-45',14,8,4),
    (109,'OR-104',20,10,1),
    (109,'OR-119',10,5,2),
    (109,'OR-125',3,5,6),
    (109,'OR-130',2,18,7),
    (110,'AR-010',6,1,3),
    (110,'FR-1',14,7,1),
    (110,'FR-16',1,45,2),
    (116,'21636',5,14,1),
    (116,'AR-001',32,1,2),
    (116,'AR-005',18,1,5),
    (116,'FR-33',13,8,3),
    (116,'OR-200',10,4,4),
    (117,'FR-78',2,15,1),
    (117,'FR-80',1,32,3),
    (117,'OR-146',17,4,2),
    (117,'OR-179',4,6,4),
    (128,'AR-004',15,1,1),
    (128,'OR-150',18,2,2),
    (52,'FR-67',10,70,1),
    (59,'FR-67',10,70,1),
    (60,'FR-67',10,70,1),
    (61,'FR-67',10,70,1),
    (62,'FR-67',10,70,1),
    (63,'FR-67',10,70,1),
    (64,'FR-67',10,70,1),
    (65,'FR-67',10,70,1),
    (66,'FR-67',10,70,1),
    (67,'FR-67',10,70,1),
    (68,'FR-67',10,70,1),
    (111,'FR-67',10,70,1),
    (112,'FR-67',10,70,1),
    (113,'FR-67',10,70,1),
    (114,'FR-67',10,70,1),
    (115,'FR-67',10,70,1),
    (118,'FR-67',10,70,1),
    (119,'FR-67',10,70,1),
    (120,'FR-67',10,70,1),
    (121,'FR-67',10,70,1),
    (122,'FR-67',10,70,1),
    (123,'FR-67',10,70,1),
    (124,'FR-67',10,70,1),
    (125,'FR-67',10,70,1),
    (126,'FR-67',10,70,1),
    (127,'FR-67',10,70,1);

INSERT INTO forma_pago (codigo_forma, nombre_forma)
VALUES
    ('1', 'PayPal'),
    ('2', 'Transferencia'),
    ('3', 'Cheque');

INSERT INTO pago (id_transaccion, fecha_pago, total, codigo_cliente, codigo_forma)
VALUES
    ('ak-std-000001','2008-11-10',2000,1,'1'),
    ('ak-std-000002','2008-12-10',2000,1,'1'),
    ('ak-std-000003','2009-01-16',5000,3,'1'),
    ('ak-std-000004','2009-02-16',5000,3,'1'),
    ('ak-std-000005','2009-02-19',926,3,'1'),
    ('ak-std-000006','2007-01-08',20000,4,'1'),
    ('ak-std-000007','2007-01-08',20000,4,'1'),
    ('ak-std-000008','2007-01-08',20000,4,'1'),
    ('ak-std-000009','2007-01-08',20000,4,'1'),
    ('ak-std-000010','2007-01-08',1849,4,'1'),
    ('ak-std-000011','2006-01-18',23794,5,'2'),
    ('ak-std-000012','2009-01-13',2390,7,'3'),
    ('ak-std-000013','2009-01-06',929,9,'1'),
    ('ak-std-000014','2008-08-04',2246,13,'1'),
    ('ak-std-000015','2008-07-15',4160,14,'1'),
    ('ak-std-000016','2009-01-15',2081,15,'1'),
    ('ak-std-000035','2009-02-15',10000,15,'1'),
    ('ak-std-000017','2009-02-16',4399,16,'1'),
    ('ak-std-000018','2009-03-06',232,19,'1'),
    ('ak-std-000019','2009-03-26',272,23,'1'),
    ('ak-std-000020','2008-03-18',18846,26,'1'),
    ('ak-std-000021','2009-02-08',10972,27,'1'),
    ('ak-std-000022','2009-01-13',8489,28,'1'),
    ('ak-std-000024','2009-01-16',7863,30,'1'),
    ('ak-std-000025','2007-10-06',3321,35,'1'),
    ('ak-std-000026','2006-05-26',1171,38,'1');
    
INSERT INTO tipo_telefono (codigo_tipo, nombre_tipo)
VALUES
	('1', 'Fijo'),
    ('2', 'Móvil');
    
INSERT INTO telefono (codigo_telefono, numero_telefono, codigo_tipo, codigo_oficina, codigo_contacto)
VALUES
	('1','+34 93 3561182', '1', 'BCN-ES', NULL),
	('2','+1 215 837 0825', '1', 'BOS-USA', NULL),
	('3','+44 20 78772041', '1', 'LON-UK', NULL),
	('4','+34 91 7514487', '1', 'MAD-ES', NULL),
	('5','+33 14 723 4404', '1', 'PAR-FR', NULL),
	('6','+1 650 219 4782', '1', 'SFC-USA', NULL),
	('7','+61 2 9264 2451', '1', 'SYD-AU', NULL),
	('8','+34 925 867231', '1', 'TAL-ES', NULL),
	('9','+81 33 224 5000', '1', 'TOK-JP', NULL),
    ('10','5556901745', '1', NULL, 1),
    ('11','5557410345', '1', NULL, 3),
    ('12','5552323129', '1', NULL, 4),
    ('13','55591233210', '1', NULL, 5),
    ('14','34916540145', '1', NULL, 6),
    ('15','654987321', '1', NULL, 7),
    ('16','62456810', '1', NULL, 8),
    ('17','689234750', '1', NULL, 9),
    ('18','675598001', '1', NULL, 10),
    ('19','655983045', '1', NULL, 11),
    ('20','34916540145', '1', NULL, 12),
    ('21','34914873241', '1', NULL, 13),
    ('22','34912453217', '1', NULL, 14),
    ('23','654865643', '1', NULL, 15),
    ('24','666555444', '1', NULL, 16),
    ('25','698754159', '1', NULL, 17),
    ('26','612343529', '1', NULL, 18),
    ('27','916458762', '1', NULL, 19),
    ('28','964493072', '1', NULL, 20),
    ('29','916485852', '1', NULL, 21),
    ('30','916882323', '1', NULL, 22),
    ('31','915576622', '1', NULL, 23),
    ('32','654987690', '1', NULL, 24),
    ('33','675842139', '1', NULL, 25),
    ('34','916877445', '1', NULL, 26),
    ('35','916544147', '1', NULL, 27),
    ('36','675432926', '1', NULL, 28),
    ('37','685746512', '1', NULL, 29),
    ('38','675124537', '1', NULL, 30),
    ('39','645925376', '1', NULL, 31),
    ('40','(33)5120578961', '1', NULL, 32),
    ('41','(33)0140205050', '1', NULL, 33),
    ('42','2 9261-2433', '1', NULL, 35),
    ('43','654352981', '1', NULL, 36),
    ('44','926523468', '1', NULL, 37),
    ('45','2 8005-7161', '1', NULL, 38);
```



#### Consultas SQL

##### Consultas sobre una tabla

1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

   ```sql
   SELECT o.codigo_oficina, c.nombre_ciudad
   FROM oficina AS o, ciudad AS c, direccion AS d
   WHERE d.codigo_ciudad = c.codigo_ciudad AND d.codigo_oficina = o.codigo_oficina;
   
   SELECT o.codigo_oficina, c.nombre_ciudad
   FROM direccion AS d
   INNER JOIN oficina AS o
   ON d.codigo_oficina = o.codigo_oficina
   INNER JOIN ciudad AS c
   ON d.codigo_ciudad = c.codigo_ciudad;
   
   +----------------+----------------------+
   | codigo_oficina | nombre_ciudad        |
   +----------------+----------------------+
   | BCN-ES         | Barcelona            |
   | BOS-USA        | Boston               |
   | LON-UK         | Londres              |
   | MAD-ES         | Madrid               |
   | PAR-FR         | Paris                |
   | SFC-USA        | San Francisco        |
   | SYD-AU         | Sydney               |
   | TAL-ES         | Talavera de la Reina |
   | TOK-JP         | Tokyo                |
   +----------------+----------------------+
   ```

   

2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

   ```sql
   SELECT c.nombre_ciudad, t.numero_telefono
   FROM ciudad AS c, region AS r, pais AS p, telefono AS t, direccion AS d, oficina AS o
   WHERE t.codigo_oficina = o.codigo_oficina 
   	AND o.codigo_oficina = d.codigo_oficina 
   	AND d.codigo_ciudad = c.codigo_ciudad 
   	AND c.codigo_region = r.codigo_region 
   	AND r.codigo_pais = p.codigo_pais 
   	AND p.nombre_pais = 'España';
   	
   +----------------------+-----------------+
   | nombre_ciudad        | numero_telefono |
   +----------------------+-----------------+
   | Talavera de la Reina | +34 925 867231  |
   | Madrid               | +34 91 7514487  |
   | Barcelona            | +34 93 3561182  |
   +----------------------+-----------------+
   ```

   

3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.

   ```sql
   SELECT e.nombre, e.apellido1, e.apellido2, e.email
   FROM empleado AS e
   WHERE codigo_jefe = 7;
   
   +---------+-----------+-----------+--------------------------+
   | nombre  | apellido1 | apellido2 | email                    |
   +---------+-----------+-----------+--------------------------+
   | Mariano | López     | Murcia    | mlopez@jardineria.es     |
   | Lucio   | Campoamor | Martín    | lcampoamor@jardineria.es |
   | Hilario | Rodriguez | Huertas   | hrodriguez@jardineria.es |
   +---------+-----------+-----------+--------------------------+
   ```

   

4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.

   ```sql
   SELECT p.nombre_puesto, e.nombre, e.apellido1, e.apellido2, e.email
   FROM puesto AS p, empleado AS e
   WHERE p.codigo_puesto = e.codigo_puesto AND e.codigo_jefe IS NULL;
   
   +------------------+--------+-----------+-----------+----------------------+
   | nombre_puesto    | nombre | apellido1 | apellido2 | email                |
   +------------------+--------+-----------+-----------+----------------------+
   | Director General | Marcos | Magaña    | Perez     | marcos@jardineria.es |
   +------------------+--------+-----------+-----------+----------------------+
   ```

   

5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.

   ```sql
   SELECT e.nombre, e.apellido1, e.apellido2, p.nombre_puesto
   FROM empleado AS e, puesto AS p
   WHERE e.codigo_puesto = p.codigo_puesto AND p.nombre_puesto <> 'Representante Ventas';
   
   +----------+------------+-----------+-----------------------+
   | nombre   | apellido1  | apellido2 | nombre_puesto         |
   +----------+------------+-----------+-----------------------+
   | Marcos   | Magaña     | Perez     | Director General      |
   | Ruben    | López      | Martinez  | Subdirector Marketing |
   | Alberto  | Soria      | Carrasco  | Subdirector Ventas    |
   | Maria    | Solís      | Jerez     | Secretaria            |
   | Carlos   | Soria      | Jimenez   | Director Oficina      |
   | Emmanuel | Magaña     | Perez     | Director Oficina      |
   | Francois | Fignon     |           | Director Oficina      |
   | Michael  | Bolton     |           | Director Oficina      |
   | Hilary   | Washington |           | Director Oficina      |
   | Nei      | Nishikori  |           | Director Oficina      |
   | Amy      | Johnson    |           | Director Oficina      |
   | Kevin    | Fallmer    |           | Director Oficina      |
   +----------+------------+-----------+-----------------------+
   ```

   

6. Devuelve un listado con el nombre de los todos los clientes españoles.

   ```sql
   SELECT c.nombre_cliente
   FROM cliente AS c, direccion AS d, ciudad AS ci, region AS r, pais AS p
   WHERE c.codigo_cliente = d.codigo_cliente 
   	AND d.codigo_ciudad = ci.codigo_ciudad 
   	AND ci.codigo_region = r.codigo_region 
   	AND r.codigo_pais = p.codigo_pais 
   	AND p.nombre_pais = 'España';
   	
   +--------------------------------+
   | nombre_cliente                 |
   +--------------------------------+
   | Vivero Humanes                 |
   | Top Campo                      |
   | Agrojardin                     |
   | Lasas S.A.                     |
   | Flores Marivi                  |
   | Fuenla City                    |
   | Jardineria Sara                |
   | Campohermoso                   |
   | Lasas S.A.                     |
   | Madrileña de riegos            |
   | Dardena S.A.                   |
   | Jardin de Flores               |
   | Naturajardin                   |
   | Jardines y Mansiones Cactus SL |
   | Jardinerías Matías SL          |
   | Flores S.L.                    |
   | Beragua                        |
   | Club Golf Puerta del hierro    |
   | Naturagua                      |
   | DaraDistribuciones             |
   | Camunas Jardines S.L.          |
   | Flowers, S.A                   |
   | Golf S.A.                      |
   | Americh Golf Management SL     |
   | El Prat                        |
   | Aloha                          |
   | Sotogrande                     |
   +--------------------------------+
   ```

   

7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.

   ```sql
   SELECT e.nombre_estado
   FROM estado AS e;
   
   +---------------+
   | nombre_estado |
   +---------------+
   | Entregado     |
   | Pendiente     |
   | Rechazado     |
   +---------------+
   ```

   

8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
   • Utilizando la función YEAR de MySQL.

   ```sql
   SELECT DISTINCT(c.codigo_cliente)
   FROM cliente AS c, pago AS p
   WHERE c.codigo_cliente = p.codigo_cliente AND YEAR(fecha_pago) = '2008';
   
   +----------------+
   | codigo_cliente |
   +----------------+
   |              1 |
   |             13 |
   |             14 |
   |             26 |
   +----------------+
   ```
   
   • Utilizando la función DATE_FORMAT de MySQL.
   
   ```sql
   SELECT DISTINCT(c.codigo_cliente)
   FROM cliente AS c, pago AS p
   WHERE c.codigo_cliente = p.codigo_cliente AND DATE_FORMAT(fecha_pago, '%Y') = '2008';
   
   +----------------+
   | codigo_cliente |
   +----------------+
   |              1 |
   |             13 |
   |             14 |
   |             26 |
   +----------------+
   ```
   
   • Sin utilizar ninguna de las funciones anteriores.
   
   ```sql
   SELECT DISTINCT(c.codigo_cliente)
   FROM cliente AS c, pago AS p
   WHERE c.codigo_cliente = p.codigo_cliente AND fecha_pago LIKE '%2008%';
   
   +----------------+
   | codigo_cliente |
   +----------------+
   |              1 |
   |             13 |
   |             14 |
   |             26 |
   +----------------+
   ```
   
   
   
9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.

   ```sql
   SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega
   FROM pedido AS p
   WHERE p.fecha_entrega > p.fecha_esperada;
   
   +---------------+----------------+----------------+---------------+
   | codigo_pedido | codigo_cliente | fecha_esperada | fecha_entrega |
   +---------------+----------------+----------------+---------------+
   |             9 |              1 | 2008-12-27     | 2008-12-28    |
   |            13 |              7 | 2009-01-14     | 2009-01-15    |
   |            16 |              7 | 2009-01-07     | 2009-01-15    |
   |            17 |              7 | 2009-01-09     | 2009-01-11    |
   |            18 |              9 | 2009-01-06     | 2009-01-07    |
   |            22 |              9 | 2009-01-11     | 2009-01-13    |
   |            28 |              3 | 2009-02-17     | 2009-02-20    |
   |            31 |             13 | 2008-09-30     | 2008-10-04    |
   |            32 |              4 | 2007-01-19     | 2007-01-27    |
   |            38 |             19 | 2009-03-06     | 2009-03-07    |
   |            39 |             19 | 2009-03-07     | 2009-03-09    |
   |            40 |             19 | 2009-03-10     | 2009-03-13    |
   |            42 |             19 | 2009-03-23     | 2009-03-27    |
   |            43 |             23 | 2009-03-26     | 2009-03-28    |
   |            44 |             23 | 2009-03-27     | 2009-03-30    |
   |            45 |             23 | 2009-03-04     | 2009-03-07    |
   |            46 |             23 | 2009-03-04     | 2009-03-05    |
   |            49 |             26 | 2008-07-22     | 2008-07-30    |
   |            55 |             14 | 2009-01-10     | 2009-01-11    |
   |            60 |              1 | 2008-12-27     | 2008-12-28    |
   |            68 |              3 | 2009-02-17     | 2009-02-20    |
   |            92 |             27 | 2009-04-30     | 2009-05-03    |
   |            96 |             35 | 2008-04-12     | 2008-04-13    |
   |           103 |             30 | 2009-01-20     | 2009-01-24    |
   |           106 |             30 | 2009-05-15     | 2009-05-20    |
   |           112 |             36 | 2009-04-06     | 2009-05-07    |
   |           113 |             36 | 2008-11-09     | 2009-01-09    |
   |           114 |             36 | 2009-01-29     | 2009-01-31    |
   |           115 |             36 | 2009-01-26     | 2009-02-27    |
   |           123 |             30 | 2009-01-20     | 2009-01-24    |
   |           126 |             30 | 2009-05-15     | 2009-05-20    |
   |           128 |             38 | 2008-12-10     | 2008-12-29    |
   +---------------+----------------+----------------+---------------+
   ```

   

10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
    • Utilizando la función ADDDATE de MySQL.

    ```sql
    SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega
    FROM pedido AS p
    WHERE ADDDATE(p.fecha_entrega, INTERVAL 2 DAY) <= p.fecha_esperada;
    
    +---------------+----------------+----------------+---------------+
    | codigo_pedido | codigo_cliente | fecha_esperada | fecha_entrega |
    +---------------+----------------+----------------+---------------+
    |             2 |              5 | 2007-10-28     | 2007-10-26    |
    |            24 |             14 | 2008-07-31     | 2008-07-25    |
    |            30 |             13 | 2008-09-03     | 2008-08-31    |
    |            36 |             14 | 2008-12-15     | 2008-12-10    |
    |            53 |             13 | 2008-11-15     | 2008-11-09    |
    |            89 |             35 | 2007-12-13     | 2007-12-10    |
    |            91 |             27 | 2009-03-29     | 2009-03-27    |
    |            93 |             27 | 2009-05-30     | 2009-05-17    |
    +---------------+----------------+----------------+---------------+
    ```
    
    • Utilizando la función DATEDIFF de MySQL.
    
    ```sql
    SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega
    FROM pedido AS p
    WHERE DATEDIFF(p.fecha_esperada, p.fecha_entrega) >= 2;
    
    +---------------+----------------+----------------+---------------+
    | codigo_pedido | codigo_cliente | fecha_esperada | fecha_entrega |
    +---------------+----------------+----------------+---------------+
    |             2 |              5 | 2007-10-28     | 2007-10-26    |
    |            24 |             14 | 2008-07-31     | 2008-07-25    |
    |            30 |             13 | 2008-09-03     | 2008-08-31    |
    |            36 |             14 | 2008-12-15     | 2008-12-10    |
    |            53 |             13 | 2008-11-15     | 2008-11-09    |
    |            89 |             35 | 2007-12-13     | 2007-12-10    |
    |            91 |             27 | 2009-03-29     | 2009-03-27    |
    |            93 |             27 | 2009-05-30     | 2009-05-17    |
    +---------------+----------------+----------------+---------------+
    ```
    
    • ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?
    
    ```sql
    SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega
    FROM pedido AS p
    WHERE (p.fecha_esperada - p.fecha_entrega) >= 2;
    
    +---------------+----------------+----------------+---------------+
    | codigo_pedido | codigo_cliente | fecha_esperada | fecha_entrega |
    +---------------+----------------+----------------+---------------+
    |             2 |              5 | 2007-10-28     | 2007-10-26    |
    |            24 |             14 | 2008-07-31     | 2008-07-25    |
    |            30 |             13 | 2008-09-03     | 2008-08-31    |
    |            36 |             14 | 2008-12-15     | 2008-12-10    |
    |            53 |             13 | 2008-11-15     | 2008-11-09    |
    |            89 |             35 | 2007-12-13     | 2007-12-10    |
    |            91 |             27 | 2009-03-29     | 2009-03-27    |
    |            93 |             27 | 2009-05-30     | 2009-05-17    |
    +---------------+----------------+----------------+---------------+
    ```
    
    
    
11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.

    ```sql
    SELECT p.codigo_pedido, p.fecha_pedido, p.fecha_esperada, p.fecha_entrega, p.comentarios, p.codigo_cliente, p.codigo_estado
    FROM pedido AS p, estado AS e
    WHERE p.codigo_estado = e.codigo_estado 
    	AND e.nombre_estado = 'Rechazado' 
    	AND (YEAR(p.fecha_esperada) = '2009' OR YEAR(p.fecha_entrega) = '2009');
    +---------------+--------------+----------------+---------------+--------------------------------------------------------------------------+----------------+---------------+
    | codigo_pedido | fecha_pedido | fecha_esperada | fecha_entrega | comentarios                                                              | codigo_cliente | codigo_estado |
    +---------------+--------------+----------------+---------------+--------------------------------------------------------------------------+----------------+---------------+
    |            14 | 2009-01-02   | 2009-01-02     | NULL          | mal pago                                                                 |              7 | 3             |
    |            21 | 2009-01-09   | 2009-01-09     | 2009-01-09    | mal pago                                                                 |              9 | 3             |
    |            23 | 2008-12-30   | 2009-01-10     | NULL          | El pedido fue anulado por el cliente                                     |              5 | 3             |
    |            25 | 2009-02-02   | 2009-02-08     | NULL          | El cliente carece de saldo en la cuenta asociada                         |              1 | 3             |
    |            26 | 2009-02-06   | 2009-02-12     | NULL          | El cliente anula la operacion para adquirir mas producto                 |              3 | 3             |
    |            35 | 2008-03-10   | 2009-03-20     | NULL          | Limite de credito superado                                               |              4 | 3             |
    |            40 | 2009-03-09   | 2009-03-10     | 2009-03-13    | NULL                                                                     |             19 | 3             |
    |            46 | 2009-04-03   | 2009-03-04     | 2009-03-05    | NULL                                                                     |             23 | 3             |
    |            56 | 2008-12-19   | 2009-01-20     | NULL          | El cliente a anulado el pedido el dia 2009-01-10                         |             13 | 3             |
    |            65 | 2009-02-02   | 2009-02-08     | NULL          | El cliente carece de saldo en la cuenta asociada                         |              1 | 3             |
    |            66 | 2009-02-06   | 2009-02-12     | NULL          | El cliente anula la operacion para adquirir mas producto                 |              3 | 3             |
    |            74 | 2009-01-14   | 2009-01-22     | NULL          | El pedido no llego el dia que queria el cliente por fallo del transporte |             15 | 3             |
    |            81 | 2009-01-18   | 2009-01-24     | NULL          | Los producto estaban en mal estado                                       |             28 | 3             |
    |           101 | 2009-03-07   | 2009-03-27     | NULL          | El pedido fue rechazado por el cliente                                   |             16 | 3             |
    |           105 | 2009-02-14   | 2009-02-20     | NULL          | el producto ha sido rechazado por la pesima calidad                      |             30 | 3             |
    |           113 | 2008-10-28   | 2008-11-09     | 2009-01-09    | El producto ha sido rechazado por la tardanza de el envio                |             36 | 3             |
    |           120 | 2009-03-07   | 2009-03-27     | NULL          | El pedido fue rechazado por el cliente                                   |             16 | 3             |
    |           125 | 2009-02-14   | 2009-02-20     | NULL          | el producto ha sido rechazado por la pesima calidad                      |             30 | 3             |
    +---------------+--------------+----------------+---------------+--------------------------------------------------------------------------+----------------+---------------+
    ```

    

12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.

    ```sql
    SELECT p.codigo_pedido, p.fecha_pedido, p.fecha_esperada, p.fecha_entrega, p.comentarios, p.codigo_cliente, p.codigo_estado
    FROM pedido AS p
    WHERE MONTH(p.fecha_entrega) = '01';
    
    +---------------+--------------+----------------+---------------+-----------------------------------------------------------+----------------+---------------+
    | codigo_pedido | fecha_pedido | fecha_esperada | fecha_entrega | comentarios                                               | codigo_cliente | codigo_estado |
    +---------------+--------------+----------------+---------------+-----------------------------------------------------------+----------------+---------------+
    |             1 | 2006-01-17   | 2006-01-19     | 2006-01-19    | Pagado a plazos                                           |              5 | 1             |
    |            13 | 2009-01-12   | 2009-01-14     | 2009-01-15    | NULL                                                      |              7 | 1             |
    |            15 | 2009-01-09   | 2009-01-12     | 2009-01-11    | NULL                                                      |              7 | 1             |
    |            16 | 2009-01-06   | 2009-01-07     | 2009-01-15    | NULL                                                      |              7 | 1             |
    |            17 | 2009-01-08   | 2009-01-09     | 2009-01-11    | mal estado                                                |              7 | 1             |
    |            18 | 2009-01-05   | 2009-01-06     | 2009-01-07    | NULL                                                      |              9 | 1             |
    |            21 | 2009-01-09   | 2009-01-09     | 2009-01-09    | mal pago                                                  |              9 | 3             |
    |            22 | 2009-01-11   | 2009-01-11     | 2009-01-13    | NULL                                                      |              9 | 1             |
    |            32 | 2007-01-07   | 2007-01-19     | 2007-01-27    | Entrega tardia, el cliente puso reclamacion               |              4 | 1             |
    |            55 | 2008-12-10   | 2009-01-10     | 2009-01-11    | Retrasado 1 dia por problemas de transporte               |             14 | 1             |
    |            58 | 2009-01-24   | 2009-01-31     | 2009-01-30    | Todo correcto                                             |              3 | 1             |
    |            64 | 2009-01-24   | 2009-01-31     | 2009-01-30    | Todo correcto                                             |              1 | 1             |
    |            75 | 2009-01-11   | 2009-01-13     | 2009-01-13    | El pedido llego perfectamente                             |             15 | 1             |
    |            79 | 2009-01-12   | 2009-01-13     | 2009-01-13    | NULL                                                      |             28 | 1             |
    |            82 | 2009-01-20   | 2009-01-29     | 2009-01-29    | El pedido llego un poco mas tarde de la hora fijada       |             28 | 1             |
    |            95 | 2008-01-04   | 2008-01-19     | 2008-01-19    | NULL                                                      |             35 | 1             |
    |           100 | 2009-01-10   | 2009-01-15     | 2009-01-15    | El pedido llego perfectamente                             |             16 | 1             |
    |           102 | 2008-12-28   | 2009-01-08     | 2009-01-08    | Pago pendiente                                            |             16 | 1             |
    |           103 | 2009-01-15   | 2009-01-20     | 2009-01-24    | NULL                                                      |             30 | 2             |
    |           113 | 2008-10-28   | 2008-11-09     | 2009-01-09    | El producto ha sido rechazado por la tardanza de el envio |             36 | 3             |
    |           114 | 2009-01-15   | 2009-01-29     | 2009-01-31    | El envio llego dos dias más tarde debido al mal tiempo    |             36 | 1             |
    |           119 | 2009-01-10   | 2009-01-15     | 2009-01-15    | El pedido llego perfectamente                             |             16 | 1             |
    |           121 | 2008-12-28   | 2009-01-08     | 2009-01-08    | Pago pendiente                                            |             16 | 1             |
    |           123 | 2009-01-15   | 2009-01-20     | 2009-01-24    | NULL                                                      |             30 | 2             |
    +---------------+--------------+----------------+---------------+-----------------------------------------------------------+----------------+---------------+
    ```

    

13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.

    ```sql
    SELECT p.id_transaccion, p.fecha_pago, p.total, p.codigo_cliente, p.codigo_forma
    FROM pago AS p, forma_pago AS f
    WHERE p.codigo_forma = f.codigo_forma AND f.nombre_forma = 'Paypal' AND YEAR(p.fecha_pago) = '2008'
    ORDER BY p.total DESC;
    
    +----------------+------------+----------+----------------+--------------+
    | id_transaccion | fecha_pago | total    | codigo_cliente | codigo_forma |
    +----------------+------------+----------+----------------+--------------+
    | ak-std-000020  | 2008-03-18 | 18846.00 |             26 | 1            |
    | ak-std-000015  | 2008-07-15 |  4160.00 |             14 | 1            |
    | ak-std-000014  | 2008-08-04 |  2246.00 |             13 | 1            |
    | ak-std-000001  | 2008-11-10 |  2000.00 |              1 | 1            |
    | ak-std-000002  | 2008-12-10 |  2000.00 |              1 | 1            |
    +----------------+------------+----------+----------------+--------------+
    ```

    

14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.

    ```sql
    SELECT f.nombre_forma
    FROM forma_pago AS f;
    
    +---------------+
    | nombre_forma  |
    +---------------+
    | PayPal        |
    | Transferencia |
    | Cheque        |
    +---------------+
    ```

    

15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.

    ```sql
    SELECT p.codigo_producto, p.nombre, p.gama, p.descripcion, p.cantidad_en_stock, p.precio_venta, p.precio_proveedor, p.codigo_dimension, p.codigo_proveedor
    FROM producto AS p
    WHERE p.gama = 'Ornamentales' AND p.cantidad_en_stock > 100
    ORDER BY p.precio_venta DESC;
    
    +-----------------+--------------------------------------------+--------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+--------------+------------------+------------------+------------------+
    | codigo_producto | nombre                                     | gama         | descripcion                                                                                                                                                                                                                                                                                                                                                                     | cantidad_en_stock | precio_venta | precio_proveedor | codigo_dimension | codigo_proveedor |
    +-----------------+--------------------------------------------+--------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+--------------+------------------+------------------+------------------+
    | OR-115          | Forsytia Intermedia "Lynwood"              | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         7.00 |             5.00 | 27               |                8 |
    | OR-116          | Hibiscus Syriacus  "Diana" -Blanco Puro    | Ornamentales | Por su capacidad de soportar podas, pueden ser fácilmente moldeadas como bonsái en el transcurso de pocos años. Flores de muchos colores según la variedad, desde el blanco puro al rojo intenso, del amarillo al anaranjado. La flor apenas dura 1 día, pero continuamente aparecen nuevas y la floración se prolonga durante todo el periodo de crecimiento vegetativo.       |               120 |         7.00 |             5.00 | 29               |                8 |
    | OR-117          | Hibiscus Syriacus  "Helene" -Blanco-C.rojo | Ornamentales | Por su capacidad de soportar podas, pueden ser fácilmente moldeadas como bonsái en el transcurso de pocos años. Flores de muchos colores según la variedad, desde el blanco puro al rojo intenso, del amarillo al anaranjado. La flor apenas dura 1 día, pero continuamente aparecen nuevas y la floración se prolonga durante todo el periodo de crecimiento vegetativo.       |               120 |         7.00 |             5.00 | 4                |                8 |
    | OR-118          | Hibiscus Syriacus "Pink Giant" Rosa        | Ornamentales | Por su capacidad de soportar podas, pueden ser fácilmente moldeadas como bonsái en el transcurso de pocos años. Flores de muchos colores según la variedad, desde el blanco puro al rojo intenso, del amarillo al anaranjado. La flor apenas dura 1 día, pero continuamente aparecen nuevas y la floración se prolonga durante todo el periodo de crecimiento vegetativo.       |               120 |         7.00 |             5.00 | 14               |                8 |
    | OR-112          | Escallonia (Mix)                           | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 24               |                8 |
    | OR-113          | Evonimus Emerald Gayeti                    | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 25               |                8 |
    | OR-114          | Evonimus Pulchellus                        | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 26               |                8 |
    | OR-119          | Laurus Nobilis Arbusto - Ramificado Bajo   | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 14               |                8 |
    | OR-120          | Lonicera Nitida                            | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 6                |                8 |
    | OR-121          | Lonicera Nitida "Maigrum"                  | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 4                |                8 |
    | OR-122          | Lonicera Pileata                           | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 23               |                8 |
    | OR-123          | Philadelphus "Virginal"                    | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 12               |                8 |
    | OR-124          | Prunus pisardii                            | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 15               |                8 |
    | OR-125          | Viburnum Tinus "Eve Price"                 | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 14               |                8 |
    | OR-126          | Weigelia "Bristol Ruby"                    | Ornamentales |                                                                                                                                                                                                                                                                                                                                                                                 |               120 |         5.00 |             4.00 | 13               |                8 |
    +-----------------+--------------------------------------------+--------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------+--------------+------------------+------------------+------------------+
    ```

    

16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.

    ```sql
    SELECT c.codigo_cliente, c.nombre_cliente, ci.nombre_ciudad, c.codigo_empleado_rep_ventas, c.limite_credito
    FROM cliente AS c, direccion AS d, ciudad AS ci
    WHERE c.codigo_cliente = d.codigo_cliente 
    	AND d.codigo_ciudad = ci.codigo_ciudad 
    	AND ci.nombre_ciudad = 'Madrid' 
    	AND c.codigo_empleado_rep_ventas IN (11, 30);
    	
    +----------------+-----------------------------+---------------+----------------------------+----------------+
    | codigo_cliente | nombre_cliente              | nombre_ciudad | codigo_empleado_rep_ventas | limite_credito |
    +----------------+-----------------------------+---------------+----------------------------+----------------+
    |             11 | Madrileña de riegos         | Madrid        |                         11 |       20000.00 |
    |             15 | Jardin de Flores            | Madrid        |                         30 |       40000.00 |
    |             18 | Naturajardin                | Madrid        |                         30 |        5050.00 |
    |              7 | Beragua                     | Madrid        |                         11 |       20000.00 |
    |              8 | Club Golf Puerta del hierro | Madrid        |                         11 |       40000.00 |
    |              9 | Naturagua                   | Madrid        |                         11 |       32000.00 |
    |             10 | DaraDistribuciones          | Madrid        |                         11 |       50000.00 |
    +----------------+-----------------------------+---------------+----------------------------+----------------+
    ```
    
    

##### Consultas multitabla (Composición interna)

1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

   ```sql
   SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS primer_apellido, e.apellido2 AS segundo_apellido
   FROM cliente AS c
   INNER JOIN empleado AS e
   ON c.codigo_empleado_rep_ventas = e.codigo_empleado;
   
   +--------------------------------+----------------------+-----------------+------------------+
   | nombre_cliente                 | nombre_representante | primer_apellido | segundo_apellido |
   +--------------------------------+----------------------+-----------------+------------------+
   | Flores Marivi                  | Felipe               | Rosas           | Marquez          |
   | Flowers, S.A                   | Felipe               | Rosas           | Marquez          |
   | Fuenla City                    | Felipe               | Rosas           | Marquez          |
   | Top Campo                      | Felipe               | Rosas           | Marquez          |
   | Jardineria Sara                | Felipe               | Rosas           | Marquez          |
   | Lasas S.A.                     | Mariano              | López           | Murcia           |
   | Lasas S.A.                     | Mariano              | López           | Murcia           |
   | Camunas Jardines S.L.          | Mariano              | López           | Murcia           |
   | Dardena S.A.                   | Mariano              | López           | Murcia           |
   | Jardines y Mansiones Cactus SL | Lucio                | Campoamor       | Martín           |
   | Jardinerías Matías SL          | Lucio                | Campoamor       | Martín           |
   | Beragua                        | Emmanuel             | Magaña          | Perez            |
   | Club Golf Puerta del hierro    | Emmanuel             | Magaña          | Perez            |
   | Naturagua                      | Emmanuel             | Magaña          | Perez            |
   | DaraDistribuciones             | Emmanuel             | Magaña          | Perez            |
   | Madrileña de riegos            | Emmanuel             | Magaña          | Perez            |
   | Golf S.A.                      | José Manuel          | Martinez        | De la Osa        |
   | Americh Golf Management SL     | José Manuel          | Martinez        | De la Osa        |
   | Aloha                          | José Manuel          | Martinez        | De la Osa        |
   | El Prat                        | José Manuel          | Martinez        | De la Osa        |
   | Sotogrande                     | José Manuel          | Martinez        | De la Osa        |
   | france telecom                 | Lionel               | Narvaez         |                  |
   | Musée du Louvre                | Lionel               | Narvaez         |                  |
   | Flores S.L.                    | Michael              | Bolton          |                  |
   | The Magic Garden               | Michael              | Bolton          |                  |
   | GoldFish Garden                | Walter Santiago      | Sanchez         | Lopez            |
   | Gardening Associates           | Walter Santiago      | Sanchez         | Lopez            |
   | Gerudo Valley                  | Lorena               | Paxton          |                  |
   | Tendo Garden                   | Lorena               | Paxton          |                  |
   | Jardin de Flores               | Julian               | Bellinelli      |                  |
   | Naturajardin                   | Julian               | Bellinelli      |                  |
   | Vivero Humanes                 | Julian               | Bellinelli      |                  |
   | Agrojardin                     | Julian               | Bellinelli      |                  |
   | Campohermoso                   | Julian               | Bellinelli      |                  |
   | Tutifruti S.A                  | Mariko               | Kishi           |                  |
   | El Jardin Viviente S.L         | Mariko               | Kishi           |                  |
   +--------------------------------+----------------------+-----------------+------------------+
   ```

   

2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.

   ```sql
   SELECT DISTINCT(c.nombre_cliente), e.nombre AS nombre_representante
   FROM cliente AS c
   INNER JOIN empleado AS e
   ON c.codigo_empleado_rep_ventas = e.codigo_empleado
   INNER JOIN pago AS p
   ON p.codigo_cliente = c.codigo_cliente;
   
   +--------------------------------+----------------------+
   | nombre_cliente                 | nombre_representante |
   +--------------------------------+----------------------+
   | GoldFish Garden                | Walter Santiago      |
   | Gardening Associates           | Walter Santiago      |
   | Gerudo Valley                  | Lorena               |
   | Tendo Garden                   | Lorena               |
   | Beragua                        | Emmanuel             |
   | Naturagua                      | Emmanuel             |
   | Camunas Jardines S.L.          | Mariano              |
   | Dardena S.A.                   | Mariano              |
   | Jardin de Flores               | Julian               |
   | Flores Marivi                  | Felipe               |
   | Golf S.A.                      | José Manuel          |
   | Sotogrande                     | José Manuel          |
   | Jardines y Mansiones Cactus SL | Lucio                |
   | Jardinerías Matías SL          | Lucio                |
   | Agrojardin                     | Julian               |
   | Jardineria Sara                | Felipe               |
   | Tutifruti S.A                  | Mariko               |
   | El Jardin Viviente S.L         | Mariko               |
   +--------------------------------+----------------------+
   ```


  

3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.

   ```sql
   SELECT DISTINCT(c.nombre_cliente), e.nombre AS nombre_representante
   FROM cliente AS c
   INNER JOIN empleado AS e
   ON c.codigo_empleado_rep_ventas = e.codigo_empleado
   WHERE c.codigo_cliente NOT IN (SELECT p.codigo_cliente FROM pago AS p);
   
   +-----------------------------+----------------------+
   | nombre_cliente              | nombre_representante |
   +-----------------------------+----------------------+
   | Flowers, S.A                | Felipe               |
   | Fuenla City                 | Felipe               |
   | Top Campo                   | Felipe               |
   | Lasas S.A.                  | Mariano              |
   | Club Golf Puerta del hierro | Emmanuel             |
   | DaraDistribuciones          | Emmanuel             |
   | Madrileña de riegos         | Emmanuel             |
   | Americh Golf Management SL  | José Manuel          |
   | Aloha                       | José Manuel          |
   | El Prat                     | José Manuel          |
   | france telecom              | Lionel               |
   | Musée du Louvre             | Lionel               |
   | Flores S.L.                 | Michael              |
   | The Magic Garden            | Michael              |
   | Naturajardin                | Julian               |
   | Vivero Humanes              | Julian               |
   | Campohermoso                | Julian               |
   +-----------------------------+----------------------+
   ```

  

4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

   ```sql
   SELECT DISTINCT(c.nombre_cliente), e.nombre AS nombre_representante, ci.nombre_ciudad
   FROM cliente AS c
   INNER JOIN empleado AS e
   ON c.codigo_empleado_rep_ventas = e.codigo_empleado
   INNER JOIN pago AS p
   ON p.codigo_cliente = c.codigo_cliente
   INNER JOIN oficina AS o
   ON o.codigo_oficina = e.codigo_oficina
   INNER JOIN direccion AS d
   ON d.codigo_oficina = o.codigo_oficina
   INNER JOIN ciudad AS ci
   ON ci.codigo_ciudad = d.codigo_ciudad;
   
   +--------------------------------+----------------------+----------------------+
   | nombre_cliente                 | nombre_representante | nombre_ciudad        |
   +--------------------------------+----------------------+----------------------+
   | Beragua                        | Emmanuel             | Barcelona            |
   | Naturagua                      | Emmanuel             | Barcelona            |
   | Golf S.A.                      | José Manuel          | Barcelona            |
   | Sotogrande                     | José Manuel          | Barcelona            |
   | Gerudo Valley                  | Lorena               | Boston               |
   | Tendo Garden                   | Lorena               | Boston               |
   | Camunas Jardines S.L.          | Mariano              | Madrid               |
   | Dardena S.A.                   | Mariano              | Madrid               |
   | Jardines y Mansiones Cactus SL | Lucio                | Madrid               |
   | Jardinerías Matías SL          | Lucio                | Madrid               |
   | GoldFish Garden                | Walter Santiago      | San Francisco        |
   | Gardening Associates           | Walter Santiago      | San Francisco        |
   | Jardin de Flores               | Julian               | Sydney               |
   | Agrojardin                     | Julian               | Sydney               |
   | Tutifruti S.A                  | Mariko               | Sydney               |
   | El Jardin Viviente S.L         | Mariko               | Sydney               |
   | Flores Marivi                  | Felipe               | Talavera de la Reina |
   | Jardineria Sara                | Felipe               | Talavera de la Reina |
   +--------------------------------+----------------------+----------------------+
   ```

  

5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

   ```sql
   SELECT DISTINCT(c.nombre_cliente), e.nombre AS nombre_representante, ci.nombre_ciudad
   FROM cliente AS c
   INNER JOIN empleado AS e
   ON c.codigo_empleado_rep_ventas = e.codigo_empleado
   INNER JOIN oficina AS o
   ON o.codigo_oficina = e.codigo_oficina
   INNER JOIN direccion AS d
   ON d.codigo_oficina = o.codigo_oficina
   INNER JOIN ciudad AS ci
   ON ci.codigo_ciudad = d.codigo_ciudad
   WHERE c.codigo_cliente NOT IN (SELECT p.codigo_cliente FROM pago AS p);
   
   +-----------------------------+----------------------+----------------------+
   | nombre_cliente              | nombre_representante | nombre_ciudad        |
   +-----------------------------+----------------------+----------------------+
   | Club Golf Puerta del hierro | Emmanuel             | Barcelona            |
   | DaraDistribuciones          | Emmanuel             | Barcelona            |
   | Madrileña de riegos         | Emmanuel             | Barcelona            |
   | Americh Golf Management SL  | José Manuel          | Barcelona            |
   | Aloha                       | José Manuel          | Barcelona            |
   | El Prat                     | José Manuel          | Barcelona            |
   | Lasas S.A.                  | Mariano              | Madrid               |
   | france telecom              | Lionel               | Paris                |
   | Musée du Louvre             | Lionel               | Paris                |
   | Flores S.L.                 | Michael              | San Francisco        |
   | The Magic Garden            | Michael              | San Francisco        |
   | Naturajardin                | Julian               | Sydney               |
   | Vivero Humanes              | Julian               | Sydney               |
   | Campohermoso                | Julian               | Sydney               |
   | Flowers, S.A                | Felipe               | Talavera de la Reina |
   | Fuenla City                 | Felipe               | Talavera de la Reina |
   | Top Campo                   | Felipe               | Talavera de la Reina |
   +-----------------------------+----------------------+----------------------+
   ```

     

6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.

   ```sql
   /* RESIGNACIÓN */
   SELECT d.linea_direccion1, d.linea_direccion2, c.nombre_ciudad
   FROM cliente AS cl
   INNER JOIN empleado AS e
   ON cl.codigo_empleado_rep_ventas = e.codigo_empleado
   INNER JOIN oficina AS o
   ON o.codigo_oficina = e.codigo_oficina
   INNER JOIN direccion AS d
   ON d.codigo_oficina = o.codigo_oficina
   INNER JOIN ciudad AS c
   ON c.codigo_ciudad = d.codigo_ciudad
   WHERE c.nombre_ciudad = 'Fuenlabrada';
   ```

     

7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

   ```sql
   SELECT c.nombre_cliente, e.nombre, e.apellido1, ci.nombre_ciudad AS nombre_ciudad_oficina
   FROM cliente AS c
   INNER JOIN empleado AS e
   ON e.codigo_empleado = c.codigo_empleado_rep_ventas
   INNER JOIN oficina AS o
   ON o.codigo_oficina = e.codigo_oficina
   INNER JOIN direccion AS d
   ON d.codigo_oficina = o.codigo_oficina
   INNER JOIN ciudad AS ci
   ON ci.codigo_ciudad = d.codigo_ciudad;
   
   +--------------------------------+-----------------+------------+-----------------------+
   | nombre_cliente                 | nombre          | apellido1  | nombre_ciudad_oficina |
   +--------------------------------+-----------------+------------+-----------------------+
   | Beragua                        | Emmanuel        | Magaña     | Barcelona             |
   | Club Golf Puerta del hierro    | Emmanuel        | Magaña     | Barcelona             |
   | Naturagua                      | Emmanuel        | Magaña     | Barcelona             |
   | DaraDistribuciones             | Emmanuel        | Magaña     | Barcelona             |
   | Madrileña de riegos            | Emmanuel        | Magaña     | Barcelona             |
   | Golf S.A.                      | José Manuel     | Martinez   | Barcelona             |
   | Americh Golf Management SL     | José Manuel     | Martinez   | Barcelona             |
   | Aloha                          | José Manuel     | Martinez   | Barcelona             |
   | El Prat                        | José Manuel     | Martinez   | Barcelona             |
   | Sotogrande                     | José Manuel     | Martinez   | Barcelona             |
   | Gerudo Valley                  | Lorena          | Paxton     | Boston                |
   | Tendo Garden                   | Lorena          | Paxton     | Boston                |
   | Lasas S.A.                     | Mariano         | López      | Madrid                |
   | Lasas S.A.                     | Mariano         | López      | Madrid                |
   | Camunas Jardines S.L.          | Mariano         | López      | Madrid                |
   | Dardena S.A.                   | Mariano         | López      | Madrid                |
   | Jardines y Mansiones Cactus SL | Lucio           | Campoamor  | Madrid                |
   | Jardinerías Matías SL          | Lucio           | Campoamor  | Madrid                |
   | france telecom                 | Lionel          | Narvaez    | Paris                 |
   | Musée du Louvre                | Lionel          | Narvaez    | Paris                 |
   | Flores S.L.                    | Michael         | Bolton     | San Francisco         |
   | The Magic Garden               | Michael         | Bolton     | San Francisco         |
   | GoldFish Garden                | Walter Santiago | Sanchez    | San Francisco         |
   | Gardening Associates           | Walter Santiago | Sanchez    | San Francisco         |
   | Jardin de Flores               | Julian          | Bellinelli | Sydney                |
   | Naturajardin                   | Julian          | Bellinelli | Sydney                |
   | Vivero Humanes                 | Julian          | Bellinelli | Sydney                |
   | Agrojardin                     | Julian          | Bellinelli | Sydney                |
   | Campohermoso                   | Julian          | Bellinelli | Sydney                |
   | Tutifruti S.A                  | Mariko          | Kishi      | Sydney                |
   | El Jardin Viviente S.L         | Mariko          | Kishi      | Sydney                |
   | Flores Marivi                  | Felipe          | Rosas      | Talavera de la Reina  |
   | Flowers, S.A                   | Felipe          | Rosas      | Talavera de la Reina  |
   | Fuenla City                    | Felipe          | Rosas      | Talavera de la Reina  |
   | Top Campo                      | Felipe          | Rosas      | Talavera de la Reina  |
   | Jardineria Sara                | Felipe          | Rosas      | Talavera de la Reina  |
   +--------------------------------+-----------------+------------+-----------------------+
   ```

     

8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.

   ```sql
   SELECT e1.nombre AS nombre_empleado, e1.apellido1 AS apellido_empleado, e2.nombre AS nombre_jefe, e2.apellido1 AS apellido_jefe
   FROM empleado AS e1
   INNER JOIN empleado AS e2
   ON e1.codigo_jefe = e2.codigo_empleado;
   
   +-----------------+-------------------+-------------+---------------+
   | nombre_empleado | apellido_empleado | nombre_jefe | apellido_jefe |
   +-----------------+-------------------+-------------+---------------+
   | Ruben           | López             | Marcos      | Magaña        |
   | Alberto         | Soria             | Ruben       | López         |
   | Maria           | Solís             | Ruben       | López         |
   | Felipe          | Rosas             | Alberto     | Soria         |
   | Juan Carlos     | Ortiz             | Alberto     | Soria         |
   | Carlos          | Soria             | Alberto     | Soria         |
   | Mariano         | López             | Carlos      | Soria         |
   | Lucio           | Campoamor         | Carlos      | Soria         |
   | Hilario         | Rodriguez         | Carlos      | Soria         |
   | Emmanuel        | Magaña            | Alberto     | Soria         |
   | José Manuel     | Martinez          | Emmanuel    | Magaña        |
   | David           | Palma             | Emmanuel    | Magaña        |
   | Oscar           | Palma             | Emmanuel    | Magaña        |
   | Francois        | Fignon            | Alberto     | Soria         |
   | Lionel          | Narvaez           | Francois    | Fignon        |
   | Laurent         | Serra             | Francois    | Fignon        |
   | Michael         | Bolton            | Alberto     | Soria         |
   | Walter Santiago | Sanchez           | Michael     | Bolton        |
   | Hilary          | Washington        | Alberto     | Soria         |
   | Marcus          | Paxton            | Hilary      | Washington    |
   | Lorena          | Paxton            | Hilary      | Washington    |
   | Nei             | Nishikori         | Alberto     | Soria         |
   | Narumi          | Riko              | Nei         | Nishikori     |
   | Takuma          | Nomura            | Nei         | Nishikori     |
   | Amy             | Johnson           | Alberto     | Soria         |
   | Larry           | Westfalls         | Amy         | Johnson       |
   | John            | Walton            | Amy         | Johnson       |
   | Kevin           | Fallmer           | Alberto     | Soria         |
   | Julian          | Bellinelli        | Kevin       | Fallmer       |
   | Mariko          | Kishi             | Kevin       | Fallmer       |
   +-----------------+-------------------+-------------+---------------+
   ```

  

9. Devuelve un listado que muestre el nombre de cada empleado, el nombre de su jefe y el nombre del jefe de sus jefe.

   ```sql
   SELECT e1.nombre AS nombre_empleado, e1.apellido1 AS apellido_empleado, e2.nombre AS nombre_jefe, e2.apellido1 AS apellido_jefe, e3.nombre AS nombre_jefe_jefe, e3.apellido1 AS apellido_jefe_jefe
   FROM empleado AS e1
   INNER JOIN empleado AS e2
   ON e1.codigo_jefe = e2.codigo_empleado
   INNER JOIN empleado AS e3
   ON e2.codigo_jefe = e3.codigo_empleado;
   
   +-----------------+-------------------+-------------+---------------+------------------+--------------------+
   | nombre_empleado | apellido_empleado | nombre_jefe | apellido_jefe | nombre_jefe_jefe | apellido_jefe_jefe |
   +-----------------+-------------------+-------------+---------------+------------------+--------------------+
   | Alberto         | Soria             | Ruben       | López         | Marcos           | Magaña             |
   | Maria           | Solís             | Ruben       | López         | Marcos           | Magaña             |
   | Felipe          | Rosas             | Alberto     | Soria         | Ruben            | López              |
   | Juan Carlos     | Ortiz             | Alberto     | Soria         | Ruben            | López              |
   | Carlos          | Soria             | Alberto     | Soria         | Ruben            | López              |
   | Mariano         | López             | Carlos      | Soria         | Alberto          | Soria              |
   | Lucio           | Campoamor         | Carlos      | Soria         | Alberto          | Soria              |
   | Hilario         | Rodriguez         | Carlos      | Soria         | Alberto          | Soria              |
   | Emmanuel        | Magaña            | Alberto     | Soria         | Ruben            | López              |
   | José Manuel     | Martinez          | Emmanuel    | Magaña        | Alberto          | Soria              |
   | David           | Palma             | Emmanuel    | Magaña        | Alberto          | Soria              |
   | Oscar           | Palma             | Emmanuel    | Magaña        | Alberto          | Soria              |
   | Francois        | Fignon            | Alberto     | Soria         | Ruben            | López              |
   | Lionel          | Narvaez           | Francois    | Fignon        | Alberto          | Soria              |
   | Laurent         | Serra             | Francois    | Fignon        | Alberto          | Soria              |
   | Michael         | Bolton            | Alberto     | Soria         | Ruben            | López              |
   | Walter Santiago | Sanchez           | Michael     | Bolton        | Alberto          | Soria              |
   | Hilary          | Washington        | Alberto     | Soria         | Ruben            | López              |
   | Marcus          | Paxton            | Hilary      | Washington    | Alberto          | Soria              |
   | Lorena          | Paxton            | Hilary      | Washington    | Alberto          | Soria              |
   | Nei             | Nishikori         | Alberto     | Soria         | Ruben            | López              |
   | Narumi          | Riko              | Nei         | Nishikori     | Alberto          | Soria              |
   | Takuma          | Nomura            | Nei         | Nishikori     | Alberto          | Soria              |
   | Amy             | Johnson           | Alberto     | Soria         | Ruben            | López              |
   | Larry           | Westfalls         | Amy         | Johnson       | Alberto          | Soria              |
   | John            | Walton            | Amy         | Johnson       | Alberto          | Soria              |
   | Kevin           | Fallmer           | Alberto     | Soria         | Ruben            | López              |
   | Julian          | Bellinelli        | Kevin       | Fallmer       | Alberto          | Soria              |
   | Mariko          | Kishi             | Kevin       | Fallmer       | Alberto          | Soria              |
   +-----------------+-------------------+-------------+---------------+------------------+--------------------+
   ```

  

10. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.

    ```sql
    SELECT DISTINCT(c.nombre_cliente)
    FROM cliente AS c
    INNER JOIN pedido AS p
    ON p.codigo_cliente = c.codigo_cliente
    WHERE (p.fecha_entrega > p.fecha_esperada);
    
    +--------------------------------+
    | nombre_cliente                 |
    +--------------------------------+
    | GoldFish Garden                |
    | Gardening Associates           |
    | Gerudo Valley                  |
    | Beragua                        |
    | Naturagua                      |
    | Camunas Jardines S.L.          |
    | Dardena S.A.                   |
    | Golf S.A.                      |
    | Sotogrande                     |
    | Jardines y Mansiones Cactus SL |
    | Jardinerías Matías SL          |
    | Jardineria Sara                |
    | Tutifruti S.A                  |
    | Flores S.L.                    |
    | El Jardin Viviente S.L         |
    +--------------------------------+
    ```

  

11. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.

    ```sql
    SELECT DISTINCT(c.nombre_cliente), g.gama
    FROM gama_producto AS g
    INNER JOIN producto AS p
    ON p.gama = g.gama
    INNER JOIN detalle_pedido AS dp
    ON dp.producto_codigo_producto = p.codigo_producto
    INNER JOIN pedido AS pe
    ON pe.codigo_pedido = dp.pedido_codigo_pedido
    INNER JOIN cliente AS c
    ON c.codigo_cliente = pe.codigo_cliente;
    
    +--------------------------------+--------------+
    | nombre_cliente                 | gama         |
    +--------------------------------+--------------+
    | GoldFish Garden                | Frutales     |
    | GoldFish Garden                | Aromáticas   |
    | GoldFish Garden                | Ornamentales |
    | Gardening Associates           | Frutales     |
    | Gardening Associates           | Ornamentales |
    | Gerudo Valley                  | Herramientas |
    | Gerudo Valley                  | Ornamentales |
    | Gerudo Valley                  | Frutales     |
    | Tendo Garden                   | Frutales     |
    | Tendo Garden                   | Ornamentales |
    | Tendo Garden                   | Aromáticas   |
    | Beragua                        | Herramientas |
    | Beragua                        | Frutales     |
    | Beragua                        | Ornamentales |
    | Naturagua                      | Herramientas |
    | Naturagua                      | Frutales     |
    | Naturagua                      | Ornamentales |
    | Camunas Jardines S.L.          | Aromáticas   |
    | Camunas Jardines S.L.          | Frutales     |
    | Camunas Jardines S.L.          | Ornamentales |
    | Dardena S.A.                   | Herramientas |
    | Dardena S.A.                   | Frutales     |
    | Dardena S.A.                   | Ornamentales |
    | Jardin de Flores               | Frutales     |
    | Jardin de Flores               | Ornamentales |
    | Jardin de Flores               | Aromáticas   |
    | Jardin de Flores               | Herramientas |
    | Flores Marivi                  | Ornamentales |
    | Flores Marivi                  | Frutales     |
    | Flores Marivi                  | Aromáticas   |
    | Flores Marivi                  | Herramientas |
    | Golf S.A.                      | Herramientas |
    | Golf S.A.                      | Aromáticas   |
    | Sotogrande                     | Aromáticas   |
    | Sotogrande                     | Frutales     |
    | Jardines y Mansiones Cactus SL | Frutales     |
    | Jardines y Mansiones Cactus SL | Ornamentales |
    | Jardinerías Matías SL          | Aromáticas   |
    | Jardinerías Matías SL          | Frutales     |
    | Jardinerías Matías SL          | Herramientas |
    | Agrojardin                     | Ornamentales |
    | Agrojardin                     | Frutales     |
    | Jardineria Sara                | Frutales     |
    | Jardineria Sara                | Ornamentales |
    | Jardineria Sara                | Aromáticas   |
    | Jardineria Sara                | Herramientas |
    | Tutifruti S.A                  | Frutales     |
    | Tutifruti S.A                  | Ornamentales |
    | Flores S.L.                    | Frutales     |
    | El Jardin Viviente S.L         | Frutales     |
    | El Jardin Viviente S.L         | Ornamentales |
    | El Jardin Viviente S.L         | Aromáticas   |
    | El Jardin Viviente S.L         | Herramientas |
    +--------------------------------+--------------+
    ```

   

##### Consultas multitabla (Composición externa)

1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

   ```sql
   SELECT c.nombre_cliente
   FROM cliente AS c
   LEFT JOIN pago AS p
   ON c.codigo_cliente = p.codigo_cliente
   WHERE p.codigo_cliente IS NULL;
   
   +-----------------------------+
   | nombre_cliente              |
   +-----------------------------+
   | Lasas S.A.                  |
   | Club Golf Puerta del hierro |
   | DaraDistribuciones          |
   | Madrileña de riegos         |
   | Lasas S.A.                  |
   | Flowers, S.A                |
   | Naturajardin                |
   | Americh Golf Management SL  |
   | Aloha                       |
   | El Prat                     |
   | Vivero Humanes              |
   | Fuenla City                 |
   | Top Campo                   |
   | Campohermoso                |
   | france telecom              |
   | Musée du Louvre             |
   | Flores S.L.                 |
   | The Magic Garden            |
   +-----------------------------+
   ```

   

2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.

   ```sql
   SELECT c.nombre_cliente
   FROM cliente AS c
   LEFT JOIN pedido AS p
   ON c.codigo_cliente = p.codigo_cliente
   WHERE p.codigo_cliente IS NULL;
   
   +-----------------------------+
   | nombre_cliente              |
   +-----------------------------+
   | Lasas S.A.                  |
   | Club Golf Puerta del hierro |
   | DaraDistribuciones          |
   | Madrileña de riegos         |
   | Lasas S.A.                  |
   | Flowers, S.A                |
   | Naturajardin                |
   | Americh Golf Management SL  |
   | Aloha                       |
   | El Prat                     |
   | Vivero Humanes              |
   | Fuenla City                 |
   | Top Campo                   |
   | Campohermoso                |
   | france telecom              |
   | Musée du Louvre             |
   | The Magic Garden            |
   +-----------------------------+
   ```

   


3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.

   ```sql
   SELECT c.nombre_cliente
   FROM cliente AS c
   LEFT JOIN pago AS pa
   ON c.codigo_cliente = pa.codigo_cliente
   LEFT JOIN pedido AS p
   ON c.codigo_cliente = p.codigo_cliente
   WHERE pa.codigo_cliente IS NULL AND p.codigo_cliente IS NULL;
   
   +-----------------------------+
   | nombre_cliente              |
   +-----------------------------+
   | Lasas S.A.                  |
   | Club Golf Puerta del hierro |
   | DaraDistribuciones          |
   | Madrileña de riegos         |
   | Lasas S.A.                  |
   | Flowers, S.A                |
   | Naturajardin                |
   | Americh Golf Management SL  |
   | Aloha                       |
   | El Prat                     |
   | Vivero Humanes              |
   | Fuenla City                 |
   | Top Campo                   |
   | Campohermoso                |
   | france telecom              |
   | Musée du Louvre             |
   | The Magic Garden            |
   +-----------------------------+
   ```

   


4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.

   ```sql
   SELECT e.nombre
   FROM empleado AS e
   LEFT JOIN oficina AS o
   ON e.codigo_oficina = o.codigo_oficina
   WHERE o.codigo_oficina IS NULL;
   
   Empty set (0,00 sec)
   ```

   


5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.

   ```sql
   SELECT e.nombre, e.apellido1
   FROM empleado AS e
   LEFT JOIN cliente AS c
   ON e.codigo_empleado = c.codigo_empleado_rep_ventas
   WHERE c.codigo_empleado_rep_ventas IS NULL;
   
   +-------------+------------+
   | nombre      | apellido1  |
   +-------------+------------+
   | Marcos      | Magaña     |
   | Ruben       | López      |
   | Alberto     | Soria      |
   | Maria       | Solís      |
   | Juan Carlos | Ortiz      |
   | Carlos      | Soria      |
   | Hilario     | Rodriguez  |
   | David       | Palma      |
   | Oscar       | Palma      |
   | Francois    | Fignon     |
   | Laurent     | Serra      |
   | Hilary      | Washington |
   | Marcus      | Paxton     |
   | Nei         | Nishikori  |
   | Narumi      | Riko       |
   | Takuma      | Nomura     |
   | Amy         | Johnson    |
   | Larry       | Westfalls  |
   | John        | Walton     |
   | Kevin       | Fallmer    |
   +-------------+------------+
   ```

   


6. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.

   ```sql
   SELECT e.nombre, e.apellido1, o.nombre_oficina
   FROM empleado AS e
   LEFT JOIN cliente AS c
   ON e.codigo_empleado = c.codigo_empleado_rep_ventas
   LEFT JOIN oficina AS o
   ON e.codigo_oficina = o.codigo_oficina
   WHERE c.codigo_empleado_rep_ventas IS NULL;
   
   +-------------+------------+--------------------+
   | nombre      | apellido1  | nombre_oficina     |
   +-------------+------------+--------------------+
   | Marcos      | Magaña     | Talavera-España    |
   | Ruben       | López      | Talavera-España    |
   | Alberto     | Soria      | Talavera-España    |
   | Maria       | Solís      | Talavera-España    |
   | Juan Carlos | Ortiz      | Talavera-España    |
   | Carlos      | Soria      | Madrid-España      |
   | Hilario     | Rodriguez  | Madrid-España      |
   | David       | Palma      | Barcelona-España   |
   | Oscar       | Palma      | Barcelona-España   |
   | Francois    | Fignon     | Paris-Francia      |
   | Laurent     | Serra      | Paris-Francia      |
   | Hilary      | Washington | Boston-EEUU        |
   | Marcus      | Paxton     | Boston-EEUU        |
   | Nei         | Nishikori  | Tokyo-Japón        |
   | Narumi      | Riko       | Tokyo-Japón        |
   | Takuma      | Nomura     | Tokyo-Japón        |
   | Amy         | Johnson    | Londres-Inglaterra |
   | Larry       | Westfalls  | Londres-Inglaterra |
   | John        | Walton     | Londres-Inglaterra |
   | Kevin       | Fallmer    | Sydney-Australia   |
   +-------------+------------+--------------------+
   ```

   


7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.

   ```sql
   SELECT e.nombre
   FROM empleado AS e
   LEFT JOIN oficina AS o
   ON e.codigo_oficina = o.codigo_oficina
   LEFT JOIN cliente AS c
   ON e.codigo_empleado = c.codigo_empleado_rep_ventas
   WHERE o.codigo_oficina IS NULL;
   
   Empty set (0,00 sec)
   ```

   


8. Devuelve un listado de los productos que nunca han aparecido en un pedido.

   ```sql
   SELECT DISTINCT(p.nombre)
   FROM producto AS p
   LEFT JOIN detalle_pedido AS dp
   ON p.codigo_producto = dp.producto_codigo_producto
   WHERE dp.producto_codigo_producto IS NULL;
   
   +-------------------------------------------------------------+
   | nombre                                                      |
   +-------------------------------------------------------------+
   | Olea-Olivos                                                 |
   | Calamondin Mini                                             |
   | Camelia Blanco, Chrysler Rojo, Soraya Naranja,              |
   | Landora Amarillo, Rose Gaujard bicolor blanco-rojo          |
   | Kordes Perfect bicolor rojo-amarillo, Roundelay rojo fuerte |
   | Albaricoquero Corbato                                       |
   | Albaricoquero Moniqui                                       |
   | Albaricoquero Kurrot                                        |
   | Cerezo Burlat                                               |
   | Cerezo Picota                                               |
   | Ciruelo R. Claudia Verde                                    |
   | Ciruelo Golden Japan                                        |
   | Ciruelo Claudia Negra                                       |
   | Higuera Verdal                                              |
   | Higuera Breva                                               |
   | Melocotonero Spring Crest                                   |
   | Melocotonero Federica                                       |
   | Parra Uva de Mesa                                           |
   | Mandarino -Plantón joven                                    |
   | Peral Castell                                               |
   | Peral Williams                                              |
   | Peral Conference                                            |
   | Olivo Cipresino                                             |
   | Albaricoquero                                               |
   | Cerezo                                                      |
   | Ciruelo                                                     |
   | Granado                                                     |
   | Higuera                                                     |
   | Manzano                                                     |
   | Melocotonero                                                |
   | Membrillero                                                 |
   | Arbustos Mix Maceta                                         |
   | Mimosa Injerto CLASICA Dealbata                             |
   | Mimosa Semilla Bayleyana                                    |
   | Mimosa Semilla Espectabilis                                 |
   | Mimosa Semilla Longifolia                                   |
   | Mimosa Semilla Floribunda 4 estaciones                      |
   | Abelia Floribunda                                           |
   | Callistemom (Mix)                                           |
   | Corylus Avellana "Contorta"                                 |
   | Escallonia (Mix)                                            |
   | Evonimus Emerald Gayeti                                     |
   | Evonimus Pulchellus                                         |
   | Hibiscus Syriacus  "Helene" -Blanco-C.rojo                  |
   | Hibiscus Syriacus "Pink Giant" Rosa                         |
   | Lonicera Nitida "Maigrum"                                   |
   | Prunus pisardii                                             |
   | Weigelia "Bristol Ruby"                                     |
   | Leptospermum formado PIRAMIDE                               |
   | Leptospermum COPA                                           |
   | Nerium oleander-CALIDAD "GARDEN"                            |
   | Nerium Oleander Arbusto GRANDE                              |
   | Nerium oleander COPA  Calibre 6/8                           |
   | ROSAL TREPADOR                                              |
   | Solanum Jazminoide                                          |
   | Wisteria Sinensis  azul, rosa, blanca                       |
   | Wisteria Sinensis INJERTADAS DECÃ“                          |
   | Bougamvillea Sanderiana Tutor                               |
   | Bougamvillea Sanderiana Espaldera                           |
   | Bougamvillea Sanderiana, 3 tut. piramide                    |
   | Expositor Árboles clima mediterráneo                        |
   | Expositor Árboles borde del mar                             |
   | Brachychiton Acerifolius                                    |
   | Cassia Corimbosa                                            |
   | Cassia Corimbosa                                            |
   | Chitalpa Summer Bells                                       |
   | Erytrina Kafra                                              |
   | Eucalyptus Citriodora                                       |
   | Eucalyptus Ficifolia                                        |
   | Hibiscus Syriacus  Var. Injertadas 1 Tallo                  |
   | Lagunaria Patersonii                                        |
   | Lagunaria Patersonii                                        |
   | Morus Alba                                                  |
   | Platanus Acerifolia                                         |
   | Salix Babylonica  Pendula                                   |
   | Tamarix  Ramosissima Pink Cascade                           |
   | Tecoma Stands                                               |
   | Tecoma Stands                                               |
   | Tipuana Tipu                                                |
   | Pleioblastus distichus-Bambú enano                          |
   | Sasa palmata                                                |
   | Phylostachys aurea                                          |
   | Phylostachys Bambusa Spectabilis                            |
   | Phylostachys biseti                                         |
   | Pseudosasa japonica (Metake)                                |
   | Pseudosasa japonica (Metake)                                |
   | Cedrus Deodara "Feeling Blue" Novedad                       |
   | Juniperus chinensis "Blue Alps"                             |
   | Juniperus Chinensis Stricta                                 |
   | Juniperus squamata "Blue Star"                              |
   | Juniperus x media Phitzeriana verde                         |
   | Bismarckia Nobilis                                          |
   | Brahea Armata                                               |
   | Brahea Edulis                                               |
   | Butia Capitata                                              |
   | Chamaerops Humilis                                          |
   | Chamaerops Humilis "Cerifera"                               |
   | Chrysalidocarpus Lutescens -ARECA                           |
   | Cordyline Australis -DRACAENA                               |
   | Cycas Revoluta                                              |
   | Dracaena Drago                                              |
   | Livistonia Decipiens                                        |
   | Rhaphis Excelsa                                             |
   | Sabal Minor                                                 |
   | Trachycarpus Fortunei                                       |
   | Washingtonia Robusta                                        |
   | Zamia Furfuracaea                                           |
   +-------------------------------------------------------------+
   ```

   

9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.

   ```sql
   SELECT DISTINCT(p.nombre), p.descripcion, gp.imagen
   FROM detalle_pedido AS dp
   RIGHT JOIN producto AS p
   ON dp.producto_codigo_producto = p.codigo_producto
   RIGHT JOIN gama_producto AS gp
   ON p.gama = gp.gama
   WHERE dp.producto_codigo_producto IS NULL;
   
   +-------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------+
   | nombre                                                      | descripcion                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | imagen |
   +-------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------+
   | Olea-Olivos                                                 | Existen dos hipótesis sobre el origen del olivo, una que postula que proviene de las costas de Siria, Líbano e Israel y otra que considera que lo considera originario de Asia menor. La llegada a Europa probablemente tuvo lugar de mano de los Fenicios, en transito por Chipre, Creta, e Islas del Mar Egeo, pasando a Grecia y más tarde a Italia. Los primeros indicios de la presencia del olivo en las costas mediterráneas españolas coinciden con el dominio romano, aunque fueron posteriormente los árabes los que impulsaron su cultivo en Andalucía, convirtiendo a España en el primer país productor de aceite de oliva a nivel mundial.                                                                                           | NULL   |
   | Calamondin Mini                                             | Se trata de un pequeño arbolito de copa densa, con tendencia a la verticalidad, inerme o con cortas espinas. Sus hojas son pequeñas, elípticas de 5-10 cm de longitud, con los pecíolos estrechamente alados.Posee 1 o 2 flores en situación axilar, al final de las ramillas.Sus frutos son muy pequeños (3-3,5 cm de diámetro), con pocas semillas, esféricos u ovales, con la zona apical aplanada; corteza de color naranja-rojizo, muy fina y fácilmente separable de la pulpa, que es dulce, ácida y comestible..                                                                                                                                                                                                                            | NULL   |
   | Camelia Blanco, Chrysler Rojo, Soraya Naranja,              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Landora Amarillo, Rose Gaujard bicolor blanco-rojo          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Kordes Perfect bicolor rojo-amarillo, Roundelay rojo fuerte |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Albaricoquero Corbato                                       | árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.                                                                                                                                                                                                                                                                                                                                                                                             | NULL   |
   | Albaricoquero Moniqui                                       | árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.                                                                                                                                                                                                                                                                                                                                                                                             | NULL   |
   | Albaricoquero Kurrot                                        | árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.                                                                                                                                                                                                                                                                                                                                                                                             | NULL   |
   | Cerezo Burlat                                               | Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo "Duke", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado                                                                                         | NULL   |
   | Cerezo Picota                                               | Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo "Duke", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado                                                                                         | NULL   |
   | Ciruelo R. Claudia Verde                                    | árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | NULL   |
   | Ciruelo Golden Japan                                        | árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | NULL   |
   | Ciruelo Claudia Negra                                       | árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | NULL   |
   | Higuera Verdal                                              | La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.                                                                                                                                                          | NULL   |
   | Higuera Breva                                               | La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.                                                                                                                                                          | NULL   |
   | Melocotonero Spring Crest                                   | Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.
   En Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.
   En China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.                                                                                                                                                                                                                       | NULL   |
   | Melocotonero Federica                                       | Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.
   En Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.
   En China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.                                                                                                                                                                                                                       | NULL   |
   | Parra Uva de Mesa                                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Mandarino -Plantón joven                                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Peral Castell                                               | Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.                                                                                                                                                                                                                                                                                                                                                           | NULL   |
   | Peral Williams                                              | Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.                                                                                                                                                                                                                                                                                                                                                           | NULL   |
   | Peral Conference                                            | Árbol piramidal, redondeado en su juventud, luego oval, que llega hasta 20 metros de altura y por término medio vive 65 años.Tronco alto, grueso, de corteza agrietada, gris, de la cual se destacan con frecuencia placas lenticulares.Las ramas se insertan formando ángulo agudo con el tronco (45º), de corteza lisa, primero verde y luego gris-violácea, con numerosas lenticelas.                                                                                                                                                                                                                                                                                                                                                           | NULL   |
   | Olivo Cipresino                                             | Existen dos hipótesis sobre el origen del olivo, una que postula que proviene de las costas de Siria, Líbano e Israel y otra que considera que lo considera originario de Asia menor. La llegada a Europa probablemente tuvo lugar de mano de los Fenicios, en transito por Chipre, Creta, e Islas del Mar Egeo, pasando a Grecia y más tarde a Italia. Los primeros indicios de la presencia del olivo en las costas mediterráneas españolas coinciden con el dominio romano, aunque fueron posteriormente los árabes los que impulsaron su cultivo en Andalucía, convirtiendo a España en el primer país productor de aceite de oliva a nivel mundial.                                                                                           | NULL   |
   | Albaricoquero                                               | árbol que puede pasar de los 6 m de altura, en la región mediterránea con ramas formando una copa redondeada. La corteza del tronco es pardo-violácea, agrietada; las ramas son rojizas y extendidas cuando jóvenes y las ramas secundarias son cortas, divergentes y escasas. Las yemas latentes son frecuentes especialmente sobre las ramas viejas.                                                                                                                                                                                                                                                                                                                                                                                             | NULL   |
   | Cerezo                                                      | Las principales especies de cerezo cultivadas en el mundo son el cerezo dulce (Prunus avium), el guindo (P. cerasus) y el cerezo "Duke", híbrido de los anteriores. Ambas especies son naturales del sureste de Europa y oeste de Asia. El cerezo dulce tuvo su origen probablemente en el mar Negro y en el mar Caspio, difundiéndose después hacia Europa y Asia, llevado por los pájaros y las migraciones humanas. Fue uno de los frutales más apreciados por los griegos y con el Imperio Romano se extendió a regiones muy diversas. En la actualidad, el cerezo se encuentra difundido por numerosas regiones y países del mundo con clima templado                                                                                         | NULL   |
   | Ciruelo                                                     | árbol de tamaño mediano que alcanza una altura máxima de 5-6 m. Tronco de corteza pardo-azulada, brillante, lisa o agrietada longitudinalmente. Produce ramas alternas, pequeñas, delgadas, unas veces lisas, glabras y otras pubescentes y vellosas                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | NULL   |
   | Granado                                                     | pequeño árbol caducifolio, a veces con porte arbustivo, de 3 a 6 m de altura, con el tronco retorcido. Madera dura y corteza escamosa de color grisáceo. Las ramitas jóvenes son más o menos cuadrangulares o angostas y de cuatro alas, posteriormente se vuelven redondas con corteza de color café grisáceo, la mayoría de las ramas, pero especialmente las pequeñas ramitas axilares, son en forma de espina o terminan en una espina aguda; la copa es extendida.                                                                                                                                                                                                                                                                            | NULL   |
   | Higuera                                                     | La higuera (Ficus carica L.) es un árbol típico de secano en los países mediterráneos. Su rusticidad y su fácil multiplicación hacen de la higuera un frutal muy apropiado para el cultivo extensivo.. Siempre ha sido considerado como árbol que no requiere cuidado alguno una vez plantado y arraigado, limitándose el hombre a recoger de él los frutos cuando maduran, unos para consumo en fresco y otros para conserva. Las únicas higueras con cuidados culturales esmerados, en muchas comarcas, son las brevales, por el interés económico de su primera cosecha, la de brevas.                                                                                                                                                          | NULL   |
   | Manzano                                                     | alcanza como máximo 10 m. de altura y tiene una copa globosa. Tronco derecho que normalmente alcanza de 2 a 2,5 m. de altura, con corteza cubierta de lenticelas, lisa, adherida, de color ceniciento verdoso sobre los ramos y escamosa y gris parda sobre las partes viejas del árbol. Tiene una vida de unos 60-80 años. Las ramas se insertan en ángulo abierto sobre el tallo, de color verde oscuro, a veces tendiendo a negruzco o violáceo. Los brotes jóvenes terminan con frecuencia en una espina                                                                                                                                                                                                                                       | NULL   |
   | Melocotonero                                                | Árbol caducifolio de porte bajo con corteza lisa, de color ceniciento. Sus hojas son alargadas con el margen ligeramente aserrado, de color verde brillante, algo más claras por el envés. El melocotonero está muy arraigado en la cultura asiática.
   En Japón, el noble heroe Momotaro, una especie de Cid japonés, nació del interior de un enorme melocotón que flotaba río abajo.
   En China se piensa que comer melocotón confiere longevidad al ser humano, ya que formaba parte de la dieta de sus dioses inmortales.                                                                                                                                                                                                                       | NULL   |
   | Membrillero                                                 | arbolito caducifolio de 4-6 m de altura con el tronco tortuoso y la corteza lisa, grisácea, que se desprende en escamas con la edad. Copa irregular, con ramas inermes, flexuosas, parduzcas, punteadas. Ramillas jóvenes tomentosas                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | NULL   |
   | NULL                                                        | NULL                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | NULL   |
   | Arbustos Mix Maceta                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Mimosa Injerto CLASICA Dealbata                             | Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...       | NULL   |
   | Mimosa Semilla Bayleyana                                    | Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...       | NULL   |
   | Mimosa Semilla Espectabilis                                 | Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...       | NULL   |
   | Mimosa Semilla Longifolia                                   | Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...       | NULL   |
   | Mimosa Semilla Floribunda 4 estaciones                      | Acacia dealbata. Nombre común o vulgar: Mimosa fina, Mimosa, Mimosa común, Mimosa plateada, Aromo francés. Familia: Mimosaceae. Origen: Australia, Sureste, (N. G. del Sur y Victoria). Arbol de follaje persistente muy usado en parques por su atractiva floración amarilla hacia fines del invierno. Altura: de 3 a 10 metros generalmente. Crecimiento rápido. Follaje perenne de tonos plateados, muy ornamental. Sus hojas son de textura fina, de color verde y sus flores amarillas que aparecen en racimos grandes. Florece de Enero a Marzo (Hemisferio Norte). Legumbre de 5-9 cm de longitud, recta o ligeramente curvada, con los bordes algo constreñidos entre las semillas, que se disponen en el fruto longitudinalmente...       | NULL   |
   | Abelia Floribunda                                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Callistemom (Mix)                                           | Limpitatubos. arbolito de 6-7 m de altura. Ramas flexibles y colgantes (de ahí lo de "llorón")..                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | NULL   |
   | Corylus Avellana "Contorta"                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Escallonia (Mix)                                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Evonimus Emerald Gayeti                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Evonimus Pulchellus                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Hibiscus Syriacus  "Helene" -Blanco-C.rojo                  | Por su capacidad de soportar podas, pueden ser fácilmente moldeadas como bonsái en el transcurso de pocos años. Flores de muchos colores según la variedad, desde el blanco puro al rojo intenso, del amarillo al anaranjado. La flor apenas dura 1 día, pero continuamente aparecen nuevas y la floración se prolonga durante todo el periodo de crecimiento vegetativo.                                                                                                                                                                                                                                                                                                                                                                          | NULL   |
   | Hibiscus Syriacus "Pink Giant" Rosa                         | Por su capacidad de soportar podas, pueden ser fácilmente moldeadas como bonsái en el transcurso de pocos años. Flores de muchos colores según la variedad, desde el blanco puro al rojo intenso, del amarillo al anaranjado. La flor apenas dura 1 día, pero continuamente aparecen nuevas y la floración se prolonga durante todo el periodo de crecimiento vegetativo.                                                                                                                                                                                                                                                                                                                                                                          | NULL   |
   | Lonicera Nitida "Maigrum"                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Prunus pisardii                                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Weigelia "Bristol Ruby"                                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Leptospermum formado PIRAMIDE                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Leptospermum COPA                                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Nerium oleander-CALIDAD "GARDEN"                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Nerium Oleander Arbusto GRANDE                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Nerium oleander COPA  Calibre 6/8                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | ROSAL TREPADOR                                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Solanum Jazminoide                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Wisteria Sinensis  azul, rosa, blanca                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Wisteria Sinensis INJERTADAS DECÃ“                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Bougamvillea Sanderiana Tutor                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Bougamvillea Sanderiana Espaldera                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Bougamvillea Sanderiana, 3 tut. piramide                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Expositor Árboles clima mediterráneo                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Expositor Árboles borde del mar                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Brachychiton Acerifolius                                    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Cassia Corimbosa                                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Cassia Corimbosa                                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Chitalpa Summer Bells                                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Erytrina Kafra                                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Eucalyptus Citriodora                                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Eucalyptus Ficifolia                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Hibiscus Syriacus  Var. Injertadas 1 Tallo                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Lagunaria Patersonii                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Lagunaria Patersonii                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Morus Alba                                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Platanus Acerifolia                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Salix Babylonica  Pendula                                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Tamarix  Ramosissima Pink Cascade                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Tecoma Stands                                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Tecoma Stands                                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Tipuana Tipu                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Pleioblastus distichus-Bambú enano                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Sasa palmata                                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Phylostachys aurea                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Phylostachys Bambusa Spectabilis                            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Phylostachys biseti                                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Pseudosasa japonica (Metake)                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Pseudosasa japonica (Metake)                                |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Cedrus Deodara "Feeling Blue" Novedad                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Juniperus chinensis "Blue Alps"                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Juniperus Chinensis Stricta                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Juniperus squamata "Blue Star"                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Juniperus x media Phitzeriana verde                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Bismarckia Nobilis                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Brahea Armata                                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Brahea Edulis                                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Butia Capitata                                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Chamaerops Humilis                                          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Chamaerops Humilis "Cerifera"                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Chrysalidocarpus Lutescens -ARECA                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Cordyline Australis -DRACAENA                               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Cycas Revoluta                                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Dracaena Drago                                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Livistonia Decipiens                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Rhaphis Excelsa                                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Sabal Minor                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Trachycarpus Fortunei                                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Washingtonia Robusta                                        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   | Zamia Furfuracaea                                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | NULL   |
   +-------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------+
   ```

   


10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

    ```sql
    /* RESIGNACIÓN */
    ```

    

11. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

    ```sql
    SELECT DISTINCT(c.nombre_cliente)
    FROM cliente AS c
    LEFT JOIN pedido AS p
    ON c.codigo_cliente = p.codigo_cliente
    LEFT JOIN pago AS pa
    ON c.codigo_cliente = pa.codigo_cliente
    WHERE p.codigo_cliente IS NOT NULL AND pa.codigo_cliente IS NULL;
    
    +----------------+
    | nombre_cliente |
    +----------------+
    | Flores S.L.    |
    +----------------+
    ```

    

12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.

    ```sql
    SELECT e1.nombre AS nombre_empleado, e1.apellido1 AS apellido1_empleado, e2.nombre AS nombre_jefe, e2.apellido1 AS apellido1_jefe
    FROM empleado AS e1
    LEFT JOIN cliente AS c 
    ON e1.codigo_empleado = c.codigo_empleado_rep_ventas
    LEFT JOIN empleado AS e2
    ON e1.codigo_jefe = e2.codigo_empleado
    WHERE c.codigo_empleado_rep_ventas IS NULL;
    
    +-----------------+--------------------+-------------+----------------+
    | nombre_empleado | apellido1_empleado | nombre_jefe | apellido1_jefe |
    +-----------------+--------------------+-------------+----------------+
    | Marcos          | Magaña             | NULL        | NULL           |
    | Ruben           | López              | Marcos      | Magaña         |
    | Alberto         | Soria              | Ruben       | López          |
    | Maria           | Solís              | Ruben       | López          |
    | Juan Carlos     | Ortiz              | Alberto     | Soria          |
    | Carlos          | Soria              | Alberto     | Soria          |
    | Hilario         | Rodriguez          | Carlos      | Soria          |
    | David           | Palma              | Emmanuel    | Magaña         |
    | Oscar           | Palma              | Emmanuel    | Magaña         |
    | Francois        | Fignon             | Alberto     | Soria          |
    | Laurent         | Serra              | Francois    | Fignon         |
    | Hilary          | Washington         | Alberto     | Soria          |
    | Marcus          | Paxton             | Hilary      | Washington     |
    | Nei             | Nishikori          | Alberto     | Soria          |
    | Narumi          | Riko               | Nei         | Nishikori      |
    | Takuma          | Nomura             | Nei         | Nishikori      |
    | Amy             | Johnson            | Alberto     | Soria          |
    | Larry           | Westfalls          | Amy         | Johnson        |
    | John            | Walton             | Amy         | Johnson        |
    | Kevin           | Fallmer            | Alberto     | Soria          |
    +-----------------+--------------------+-------------+----------------+
    ```
    
    

##### Consultas resumen

1. ¿Cuántos empleados hay en la compañía?

   ```sql
   SELECT COUNT(e.codigo_empleado) AS numero_empleados
   FROM empleado AS e;
   
   +------------------+
   | numero_empleados |
   +------------------+
   |               31 |
   +------------------+
   ```

   

2. ¿Cuántos clientes tiene cada país?

   ```sql
   SELECT p.nombre_pais, COUNT(c.codigo_cliente) AS numero_clientes
   FROM cliente AS c
   INNER JOIN direccion AS d
   ON d.codigo_cliente = c.codigo_cliente
   INNER JOIN ciudad AS ci
   ON ci.codigo_ciudad = d.codigo_ciudad
   INNER JOIN region AS r
   ON r.codigo_region = ci.codigo_region
   INNER JOIN pais AS p
   ON p.codigo_pais = r.codigo_pais
   GROUP BY p.nombre_pais;
   
   +-------------+-----------------+
   | nombre_pais | numero_clientes |
   +-------------+-----------------+
   | EEUU        |               4 |
   | España      |              27 |
   | Francia     |               2 |
   | Australia   |               2 |
   | Inglaterra  |               1 |
   +-------------+-----------------+
   ```

   

3. ¿Cuál fue el pago medio en 2009?

   ```sql
   SELECT AVG(p.total) AS pago_medio_2009
   FROM pago AS p
   WHERE YEAR(p.fecha_pago) = '2009';
   
   +-----------------+
   | pago_medio_2009 |
   +-----------------+
   |     4504.076923 |
   +-----------------+
   ```

   

4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.

   ```sql
   SELECT e.nombre_estado, COUNT(p.codigo_pedido) AS numero_pedidos
   FROM estado AS e
   INNER JOIN pedido AS p
   ON e.codigo_estado = p.codigo_estado
   GROUP BY e.nombre_estado
   ORDER BY COUNT(p.codigo_pedido) DESC;
   
   +---------------+----------------+
   | nombre_estado | numero_pedidos |
   +---------------+----------------+
   | Entregado     |             61 |
   | Pendiente     |             30 |
   | Rechazado     |             24 |
   +---------------+----------------+
   ```

   


5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.

   ```sql
   SELECT MAX(p.precio_venta) AS precio_mayor, MIN(p.precio_venta) AS precio_menor
   FROM producto AS p;
   
   +--------------+--------------+
   | precio_mayor | precio_menor |
   +--------------+--------------+
   |       462.00 |         1.00 |
   +--------------+--------------+
   ```

   


6. Calcula el número de clientes que tiene la empresa.

   ```sql
   SELECT COUNT(c.codigo_cliente) AS numero_clientes
   FROM cliente AS c;
   
   +-----------------+
   | numero_clientes |
   +-----------------+
   |              36 |
   +-----------------+
   ```

   

7. ¿Cuántos clientes existen con domicilio en la ciudad de Madrid?

   ```sql
   SELECT COUNT(c.codigo_cliente) AS clientes_madrid
   FROM cliente AS c
   INNER JOIN direccion AS d
   ON d.codigo_cliente = c.codigo_cliente
   INNER JOIN ciudad AS ci
   ON ci.codigo_ciudad = d.codigo_ciudad
   WHERE ci.nombre_ciudad = 'Madrid';
   
   +-----------------+
   | clientes_madrid |
   +-----------------+
   |              11 |
   +-----------------+
   ```

   

8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?

   ```sql
   SELECT ci.nombre_ciudad, COUNT(c.codigo_cliente) AS numero_clientes
   FROM cliente AS c
   INNER JOIN direccion AS d
   ON d.codigo_cliente = c.codigo_cliente
   INNER JOIN ciudad AS ci
   ON ci.codigo_ciudad = d.codigo_ciudad
   WHERE ci.nombre_ciudad LIKE 'M%'
   GROUP BY ci.nombre_ciudad;
   
   +----------------------+-----------------+
   | nombre_ciudad        | numero_clientes |
   +----------------------+-----------------+
   | Miami                |               2 |
   | Madrid               |              11 |
   | Montornes del valles |               1 |
   +----------------------+-----------------+
   ```

   


9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.

   ```sql
   SELECT e.nombre AS nombre_representante, e.apellido1 AS apellido_representante, COUNT(c.codigo_cliente) AS numero_clientes
   FROM empleado AS e
   INNER JOIN cliente AS c
   ON c.codigo_empleado_rep_ventas = e.codigo_empleado
   GROUP BY e.nombre, e.apellido1;
   
   +----------------------+------------------------+-----------------+
   | nombre_representante | apellido_representante | numero_clientes |
   +----------------------+------------------------+-----------------+
   | Felipe               | Rosas                  |               5 |
   | Mariano              | López                  |               4 |
   | Lucio                | Campoamor              |               2 |
   | Emmanuel             | Magaña                 |               5 |
   | José Manuel          | Martinez               |               5 |
   | Lionel               | Narvaez                |               2 |
   | Michael              | Bolton                 |               2 |
   | Walter Santiago      | Sanchez                |               2 |
   | Lorena               | Paxton                 |               2 |
   | Julian               | Bellinelli             |               5 |
   | Mariko               | Kishi                  |               2 |
   +----------------------+------------------------+-----------------+
   ```

   


10. Calcula el número de clientes que no tiene asignado representante de ventas.

    ```sql
    SELECT COUNT(c.codigo_cliente) AS clientes_sin_representante
    FROM cliente AS c
    WHERE c.codigo_empleado_rep_ventas IS NULL;
    
    +----------------------------+
    | clientes_sin_representante |
    +----------------------------+
    |                          0 |
    +----------------------------+
    ```

    

11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.

    ```sql
    SELECT c.nombre_contacto, c.apellido_contacto, MIN(p.fecha_pago) AS primer_pago, MAX(p.fecha_pago) AS ultimo_pago
    FROM contacto AS c
    INNER JOIN cliente AS cl
    ON cl.codigo_cliente = c.codigo_cliente
    INNER JOIN pago AS p
    ON p.codigo_cliente = cl.codigo_cliente
    GROUP BY c.nombre_contacto, c.apellido_contacto;
    
    +-----------------+-------------------+-------------+-------------+
    | nombre_contacto | apellido_contacto | primer_pago | ultimo_pago |
    +-----------------+-------------------+-------------+-------------+
    | Daniel G        | GoldFish          | 2008-11-10  | 2008-12-10  |
    | Anne            | Wright            | 2009-01-16  | 2009-02-19  |
    | Link            | Flaute            | 2007-01-08  | 2007-01-08  |
    | Akane           | Tendo             | 2006-01-18  | 2006-01-18  |
    | Jose            | Bermejo           | 2009-01-13  | 2009-01-13  |
    | Guillermo       | Rengifo           | 2009-01-06  | 2009-01-06  |
    | Pedro           | Camunas           | 2008-08-04  | 2008-08-04  |
    | Juan            | Rodriguez         | 2008-07-15  | 2008-07-15  |
    | Javier          | Villar            | 2009-01-15  | 2009-02-15  |
    | Maria           | Rodriguez         | 2009-02-16  | 2009-02-16  |
    | Luis            | Martinez          | 2009-03-06  | 2009-03-06  |
    | Maria           | Santillana        | 2009-03-26  | 2009-03-26  |
    | Eva María       | Sánchez           | 2008-03-18  | 2008-03-18  |
    | Matías          | San Martín        | 2009-02-08  | 2009-02-08  |
    | Benito          | Lopez             | 2009-01-13  | 2009-01-13  |
    | Sara            | Marquez           | 2009-01-16  | 2009-01-16  |
    | Jacob           | Jones             | 2007-10-06  | 2007-10-06  |
    | Justin          | Smith             | 2006-05-26  | 2006-05-26  |
    +-----------------+-------------------+-------------+-------------+
    ```

    

12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.

    ```sql
    /* RESIGNACIÓN */
    SELECT DISTINCT(dp.pedido_codigo_pedido), COUNT(DISTINCT(p.codigo_producto)) AS cantidad_productos_dif
    FROM producto AS p
    INNER JOIN detalle_pedido AS dp
    ON dp.producto_codigo_producto = p.codigo_producto
    GROUP BY dp.pedido_codigo_pedido;
    ```

    

13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.

    ```sql
    SELECT p.codigo_pedido, COUNT(dp.cantidad) AS total_productos
    FROM detalle_pedido AS dp
    INNER JOIN pedido AS p
    ON p.codigo_pedido = dp.pedido_codigo_pedido
    GROUP BY p.codigo_pedido;
    
    +---------------+-----------------+
    | codigo_pedido | total_productos |
    +---------------+-----------------+
    |             1 |               5 |
    |             2 |               7 |
    |             3 |               6 |
    |             4 |               8 |
    |             8 |               3 |
    |             9 |               4 |
    |            10 |               3 |
    |            11 |               2 |
    |            12 |               1 |
    |            13 |               3 |
    |            14 |               2 |
    |            15 |               4 |
    |            16 |               2 |
    |            17 |               5 |
    |            18 |               3 |
    |            19 |               5 |
    |            20 |               2 |
    |            21 |               3 |
    |            22 |               1 |
    |            23 |               4 |
    |            24 |               4 |
    |            25 |               3 |
    |            26 |               3 |
    |            27 |               3 |
    |            28 |               3 |
    |            29 |               5 |
    |            30 |               6 |
    |            31 |               3 |
    |            32 |               5 |
    |            33 |               4 |
    |            34 |               4 |
    |            35 |               5 |
    |            36 |               5 |
    |            37 |               3 |
    |            38 |               2 |
    |            39 |               2 |
    |            40 |               2 |
    |            41 |               2 |
    |            42 |               2 |
    |            43 |               1 |
    |            44 |               1 |
    |            45 |               2 |
    |            46 |               2 |
    |            47 |               2 |
    |            48 |               5 |
    |            49 |               3 |
    |            50 |               3 |
    |            51 |               3 |
    |            52 |               1 |
    |            53 |               4 |
    |            54 |               7 |
    |            55 |               5 |
    |            56 |               6 |
    |            57 |               4 |
    |            58 |               4 |
    |            59 |               1 |
    |            60 |               1 |
    |            61 |               1 |
    |            62 |               1 |
    |            63 |               1 |
    |            64 |               1 |
    |            65 |               1 |
    |            66 |               1 |
    |            67 |               1 |
    |            68 |               1 |
    |            74 |               3 |
    |            75 |               3 |
    |            76 |               5 |
    |            77 |               2 |
    |            78 |               4 |
    |            79 |               1 |
    |            80 |               3 |
    |            81 |               1 |
    |            82 |               1 |
    |            83 |               1 |
    |            89 |               6 |
    |            90 |               3 |
    |            91 |               3 |
    |            92 |               3 |
    |            93 |               3 |
    |            94 |               3 |
    |            95 |               3 |
    |            96 |               4 |
    |            97 |               3 |
    |            98 |               5 |
    |            99 |               2 |
    |           100 |               2 |
    |           101 |               2 |
    |           102 |               2 |
    |           103 |               2 |
    |           104 |               2 |
    |           105 |               2 |
    |           106 |               2 |
    |           107 |               2 |
    |           108 |               2 |
    |           109 |               7 |
    |           110 |               3 |
    |           111 |               1 |
    |           112 |               1 |
    |           113 |               1 |
    |           114 |               1 |
    |           115 |               1 |
    |           116 |               5 |
    |           117 |               4 |
    |           118 |               1 |
    |           119 |               1 |
    |           120 |               1 |
    |           121 |               1 |
    |           122 |               1 |
    |           123 |               1 |
    |           124 |               1 |
    |           125 |               1 |
    |           126 |               1 |
    |           127 |               1 |
    |           128 |               2 |
    +---------------+-----------------+
    ```

    

14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.

    ```sql
    SELECT p.nombre, COUNT(dp.cantidad) AS cantidad_vendida
    FROM producto AS p
    INNER JOIN detalle_pedido AS dp
    ON dp.producto_codigo_producto = p.codigo_producto
    GROUP BY p.nombre
    ORDER BY COUNT(dp.cantidad) DESC
    LIMIT 20;
    
    +------------------------------+------------------+
    | nombre                       | cantidad_vendida |
    +------------------------------+------------------+
    | Cerezo                       |               32 |
    | Chamaerops Humilis           |               10 |
    | Kaki                         |                8 |
    | Azadón                       |                8 |
    | Higuera                      |                8 |
    | Sierra de Poda 400MM         |                7 |
    | Limonero 30/40               |                7 |
    | Peral                        |                7 |
    | Rastrillo de Jardín          |                7 |
    | Pala                         |                6 |
    | Manzano                      |                6 |
    | Trachycarpus Fortunei        |                6 |
    | Thymus Vulgaris              |                6 |
    | Acer Pseudoplatanus          |                6 |
    | Tuja orientalis "Aurea nana" |                6 |
    | Olea-Olivos                  |                5 |
    | Phoenix Canariensis          |                5 |
    | Nectarina                    |                5 |
    | Melocotonero                 |                5 |
    | Pitimini rojo                |                4 |
    +------------------------------+------------------+
    ```

    

15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.

    ```sql
    SELECT dp.pedido_codigo_pedido, SUM((p.precio_venta*dp.cantidad)) AS base_imponible, SUM(((p.precio_venta*dp.cantidad)*0.21)) AS IVA, SUM(((p.precio_venta*dp.cantidad)+((p.precio_venta*dp.cantidad)*0.21))) AS total
    FROM detalle_pedido AS dp, producto AS p
    WHERE dp.producto_codigo_producto = p.codigo_producto
    GROUP BY dp.pedido_codigo_pedido;
    
    +----------------------+----------------+------------+------------+
    | pedido_codigo_pedido | base_imponible | IVA        | total      |
    +----------------------+----------------+------------+------------+
    |                    1 |        1687.00 |   354.2700 |  2041.2700 |
    |                    2 |        7093.00 |  1489.5300 |  8582.5300 |
    |                    3 |       10835.00 |  2275.3500 | 13110.3500 |
    |                    4 |        3187.00 |   669.2700 |  3856.2700 |
    |                    8 |        1065.00 |   223.6500 |  1288.6500 |
    |                    9 |        2775.00 |   582.7500 |  3357.7500 |
    |                   10 |        3070.00 |   644.7000 |  3714.7000 |
    |                   11 |       37140.00 |  7799.4000 | 44939.4000 |
    |                   12 |         290.00 |    60.9000 |   350.9000 |
    |                   13 |         738.00 |   154.9800 |   892.9800 |
    |                   14 |         829.00 |   174.0900 |  1003.0900 |
    |                   15 |         214.00 |    44.9400 |   258.9400 |
    |                   16 |         234.00 |    49.1400 |   283.1400 |
    |                   17 |         375.00 |    78.7500 |   453.7500 |
    |                   18 |         116.00 |    24.3600 |   140.3600 |
    |                   19 |         333.00 |    69.9300 |   402.9300 |
    |                   20 |         292.00 |    61.3200 |   353.3200 |
    |                   21 |         182.00 |    38.2200 |   220.2200 |
    |                   22 |           6.00 |     1.2600 |     7.2600 |
    |                   23 |        1640.00 |   344.4000 |  1984.4000 |
    |                   24 |         270.00 |    56.7000 |   326.7000 |
    |                   25 |        1486.00 |   312.0600 |  1798.0600 |
    |                   26 |         675.00 |   141.7500 |   816.7500 |
    |                   27 |         504.00 |   105.8400 |   609.8400 |
    |                   28 |        2060.00 |   432.6000 |  2492.6000 |
    |                   29 |        1356.00 |   284.7600 |  1640.7600 |
    |                   30 |         759.00 |   159.3900 |   918.3900 |
    |                   31 |         217.00 |    45.5700 |   262.5700 |
    |                   32 |        3024.00 |   635.0400 |  3659.0400 |
    |                   33 |       73226.00 | 15377.4600 | 88603.4600 |
    |                   34 |        1532.00 |   321.7200 |  1853.7200 |
    |                   35 |        1718.00 |   360.7800 |  2078.7800 |
    |                   36 |         324.00 |    68.0400 |   392.0400 |
    |                   37 |        2487.00 |   522.2700 |  3009.2700 |
    |                   38 |          98.00 |    20.5800 |   118.5800 |
    |                   39 |         108.00 |    22.6800 |   130.6800 |
    |                   40 |          12.00 |     2.5200 |    14.5200 |
    |                   41 |          10.00 |     2.1000 |    12.1000 |
    |                   42 |           4.00 |     0.8400 |     4.8400 |
    |                   43 |           9.00 |     1.8900 |    10.8900 |
    |                   44 |           5.00 |     1.0500 |     6.0500 |
    |                   45 |          10.00 |     2.1000 |    12.1000 |
    |                   46 |          84.00 |    17.6400 |   101.6400 |
    |                   47 |         164.00 |    34.4400 |   198.4400 |
    |                   48 |        6398.00 |  1343.5800 |  7741.5800 |
    |                   49 |         625.00 |   131.2500 |   756.2500 |
    |                   50 |        3506.00 |   736.2600 |  4242.2600 |
    |                   51 |        7750.00 |  1627.5000 |  9377.5000 |
    |                   52 |         700.00 |   147.0000 |   847.0000 |
    |                   53 |         140.00 |    29.4000 |   169.4000 |
    |                   54 |         714.00 |   149.9400 |   863.9400 |
    |                   55 |        1569.00 |   329.4900 |  1898.4900 |
    |                   56 |         372.00 |    78.1200 |   450.1200 |
    |                   57 |         911.00 |   191.3100 |  1102.3100 |
    |                   58 |        4202.00 |   882.4200 |  5084.4200 |
    |                   59 |         700.00 |   147.0000 |   847.0000 |
    |                   60 |         700.00 |   147.0000 |   847.0000 |
    |                   61 |         700.00 |   147.0000 |   847.0000 |
    |                   62 |         700.00 |   147.0000 |   847.0000 |
    |                   63 |         700.00 |   147.0000 |   847.0000 |
    |                   64 |         700.00 |   147.0000 |   847.0000 |
    |                   65 |         700.00 |   147.0000 |   847.0000 |
    |                   66 |         700.00 |   147.0000 |   847.0000 |
    |                   67 |         700.00 |   147.0000 |   847.0000 |
    |                   68 |         700.00 |   147.0000 |   847.0000 |
    |                   74 |       22630.00 |  4752.3000 | 27382.3000 |
    |                   75 |        1048.00 |   220.0800 |  1268.0800 |
    |                   76 |        3028.00 |   635.8800 |  3663.8800 |
    |                   77 |         588.00 |   123.4800 |   711.4800 |
    |                   78 |        4660.00 |   978.6000 |  5638.6000 |
    |                   79 |         300.00 |    63.0000 |   363.0000 |
    |                   80 |        5773.00 |  1212.3300 |  6985.3300 |
    |                   81 |         120.00 |    25.2000 |   145.2000 |
    |                   82 |        2176.00 |   456.9600 |  2632.9600 |
    |                   83 |         120.00 |    25.2000 |   145.2000 |
    |                   89 |         710.00 |   149.1000 |   859.1000 |
    |                   90 |          41.00 |     8.6100 |    49.6100 |
    |                   91 |        1384.00 |   290.6400 |  1674.6400 |
    |                   92 |        3014.00 |   632.9400 |  3646.9400 |
    |                   93 |         882.00 |   185.2200 |  1067.2200 |
    |                   94 |        5759.00 |  1209.3900 |  6968.3900 |
    |                   95 |         605.00 |   127.0500 |   732.0500 |
    |                   96 |         660.00 |   138.6000 |   798.6000 |
    |                   97 |         322.00 |    67.6200 |   389.6200 |
    |                   98 |        1024.00 |   215.0400 |  1239.0400 |
    |                   99 |        2070.00 |   434.7000 |  2504.7000 |
    |                  100 |        1720.00 |   361.2000 |  2081.2000 |
    |                  101 |         209.00 |    43.8900 |   252.8900 |
    |                  102 |         660.00 |   138.6000 |   798.6000 |
    |                  103 |         304.00 |    63.8400 |   367.8400 |
    |                  104 |        1760.00 |   369.6000 |  2129.6000 |
    |                  105 |        1506.00 |   316.2600 |  1822.2600 |
    |                  106 |        1077.00 |   226.1700 |  1303.1700 |
    |                  107 |        3216.00 |   675.3600 |  3891.3600 |
    |                  108 |         660.00 |   138.6000 |   798.6000 |
    |                  109 |         553.00 |   116.1300 |   669.1300 |
    |                  110 |         149.00 |    31.2900 |   180.2900 |
    |                  111 |         700.00 |   147.0000 |   847.0000 |
    |                  112 |         700.00 |   147.0000 |   847.0000 |
    |                  113 |         700.00 |   147.0000 |   847.0000 |
    |                  114 |         700.00 |   147.0000 |   847.0000 |
    |                  115 |         700.00 |   147.0000 |   847.0000 |
    |                  116 |         264.00 |    55.4400 |   319.4400 |
    |                  117 |         154.00 |    32.3400 |   186.3400 |
    |                  118 |         700.00 |   147.0000 |   847.0000 |
    |                  119 |         700.00 |   147.0000 |   847.0000 |
    |                  120 |         700.00 |   147.0000 |   847.0000 |
    |                  121 |         700.00 |   147.0000 |   847.0000 |
    |                  122 |         700.00 |   147.0000 |   847.0000 |
    |                  123 |         700.00 |   147.0000 |   847.0000 |
    |                  124 |         700.00 |   147.0000 |   847.0000 |
    |                  125 |         700.00 |   147.0000 |   847.0000 |
    |                  126 |         700.00 |   147.0000 |   847.0000 |
    |                  127 |         700.00 |   147.0000 |   847.0000 |
    |                  128 |          51.00 |    10.7100 |    61.7100 |
    +----------------------+----------------+------------+------------+
    ```

    

16. La misma información que en la pregunta anterior, pero agrupada por código de producto.

    ```sql
    SELECT dp.producto_codigo_producto, SUM((p.precio_venta*dp.cantidad)) AS base_imponible, SUM(((p.precio_venta*dp.cantidad)*0.21)) AS IVA, SUM(((p.precio_venta*dp.cantidad)+((p.precio_venta*dp.cantidad)*0.21))) AS total
    FROM detalle_pedido AS dp, producto AS p
    WHERE dp.producto_codigo_producto = p.codigo_producto
    GROUP BY dp.producto_codigo_producto;
    
    +--------------------------+----------------+------------+-------------+
    | producto_codigo_producto | base_imponible | IVA        | total       |
    +--------------------------+----------------+------------+-------------+
    | FR-67                    |       19950.00 |  4189.5000 |  24139.5000 |
    | OR-127                   |         280.00 |    58.8000 |    338.8000 |
    | OR-141                   |         180.00 |    37.8000 |    217.8000 |
    | OR-241                   |         475.00 |    99.7500 |    574.7500 |
    | OR-99                    |         532.00 |   111.7200 |    643.7200 |
    | FR-4                     |        2552.00 |   535.9200 |   3087.9200 |
    | FR-40                    |         392.00 |    82.3200 |    474.3200 |
    | OR-140                   |         200.00 |    42.0000 |    242.0000 |
    | OR-159                   |         132.00 |    27.7200 |    159.7200 |
    | OR-227                   |       15104.00 |  3171.8400 |  18275.8400 |
    | OR-247                   |      128898.00 | 27068.5800 | 155966.5800 |
    | FR-48                    |        1080.00 |   226.8000 |   1306.8000 |
    | OR-122                   |         160.00 |    33.6000 |    193.6000 |
    | OR-123                   |          70.00 |    14.7000 |     84.7000 |
    | OR-213                   |        9310.00 |  1955.1000 |  11265.1000 |
    | OR-217                   |         960.00 |   201.6000 |   1161.6000 |
    | OR-218                   |         950.00 |   199.5000 |   1149.5000 |
    | FR-31                    |          96.00 |    20.1600 |    116.1600 |
    | FR-34                    |         336.00 |    70.5600 |    406.5600 |
    | OR-152                   |          18.00 |     3.7800 |     21.7800 |
    | OR-155                   |          24.00 |     5.0400 |     29.0400 |
    | OR-156                   |         330.00 |    69.3000 |    399.3000 |
    | OR-157                   |        2620.00 |   550.2000 |   3170.2000 |
    | OR-222                   |        1827.00 |   383.6700 |   2210.6700 |
    | FR-106                   |         913.00 |   191.7300 |   1104.7300 |
    | FR-108                   |         576.00 |   120.9600 |    696.9600 |
    | FR-11                    |       13100.00 |  2751.0000 |  15851.0000 |
    | AR-001                   |         135.00 |    28.3500 |    163.3500 |
    | AR-008                   |         455.00 |    95.5500 |    550.5500 |
    | FR-69                    |        1911.00 |   401.3100 |   2312.3100 |
    | FR-82                    |         980.00 |   205.8000 |   1185.8000 |
    | FR-91                    |        2400.00 |   504.0000 |   2904.0000 |
    | OR-234                   |        3520.00 |   739.2000 |   4259.2000 |
    | AR-006                   |         291.00 |    61.1100 |    352.1100 |
    | AR-009                   |         961.00 |   201.8100 |   1162.8100 |
    | 11679                    |         630.00 |   132.3000 |    762.3000 |
    | 21636                    |         560.00 |   117.6000 |    677.6000 |
    | FR-100                   |        1254.00 |   263.3400 |   1517.3400 |
    | FR-13                    |         741.00 |   155.6100 |    896.6100 |
    | FR-84                    |         143.00 |    30.0300 |    173.0300 |
    | OR-101                   |         144.00 |    30.2400 |    174.2400 |
    | OR-203                   |         100.00 |    21.0000 |    121.0000 |
    | 30310                    |        2640.00 |   554.4000 |   3194.4000 |
    | FR-36                    |         621.00 |   130.4100 |    751.4100 |
    | 22225                    |         984.00 |   206.6400 |   1190.6400 |
    | FR-37                    |          45.00 |     9.4500 |     54.4500 |
    | FR-64                    |         110.00 |    23.1000 |    133.1000 |
    | OR-136                   |        2286.00 |   480.0600 |   2766.0600 |
    | FR-22                    |          40.00 |     8.4000 |     48.4000 |
    | FR-23                    |          64.00 |    13.4400 |     77.4400 |
    | FR-75                    |         224.00 |    47.0400 |    271.0400 |
    | OR-208                   |         884.00 |   185.6400 |   1069.6400 |
    | FR-18                    |         108.00 |    22.6800 |    130.6800 |
    | FR-53                    |         744.00 |   156.2400 |    900.2400 |
    | OR-240                   |         468.00 |    98.2800 |    566.2800 |
    | AR-002                   |         128.00 |    26.8800 |    154.8800 |
    | FR-107                   |        1100.00 |   231.0000 |   1331.0000 |
    | FR-85                    |        5320.00 |  1117.2000 |   6437.2000 |
    | OR-249                   |         150.00 |    31.5000 |    181.5000 |
    | FR-1                     |         168.00 |    35.2800 |    203.2800 |
    | FR-77                    |        1050.00 |   220.5000 |   1270.5000 |
    | FR-9                     |         232.00 |    48.7200 |    280.7200 |
    | FR-94                    |        3552.00 |   745.9200 |   4297.9200 |
    | FR-15                    |         225.00 |    47.2500 |    272.2500 |
    | OR-188                   |         100.00 |    21.0000 |    121.0000 |
    | OR-102                   |         522.00 |   109.6200 |    631.6200 |
    | OR-186                   |         240.00 |    50.4000 |    290.4000 |
    | OR-129                   |         330.00 |    69.3000 |    399.3000 |
    | OR-160                   |         100.00 |    21.0000 |    121.0000 |
    | AR-004                   |          30.00 |     6.3000 |     36.3000 |
    | FR-12                    |         672.00 |   141.1200 |    813.1200 |
    | FR-72                    |         128.00 |    26.8800 |    154.8800 |
    | FR-89                    |         490.00 |   102.9000 |    592.9000 |
    | OR-120                   |          25.00 |     5.2500 |     30.2500 |
    | FR-102                   |         666.00 |   139.8600 |    805.8600 |
    | OR-128                   |        2842.00 |   596.8200 |   3438.8200 |
    | OR-193                   |         100.00 |    21.0000 |    121.0000 |
    | FR-17                    |         846.00 |   177.6600 |   1023.6600 |
    | FR-29                    |         960.00 |   201.6000 |   1161.6000 |
    | OR-214                   |        2120.00 |   445.2000 |   2565.2000 |
    | FR-3                     |         497.00 |   104.3700 |    601.3700 |
    | FR-7                     |         348.00 |    73.0800 |    421.0800 |
    | OR-172                   |        1602.00 |   336.4200 |   1938.4200 |
    | OR-174                   |         432.00 |    90.7200 |    522.7200 |
    | FR-47                    |         440.00 |    92.4000 |    532.4000 |
    | OR-165                   |          30.00 |     6.3000 |     36.3000 |
    | OR-181                   |         360.00 |    75.6000 |    435.6000 |
    | OR-225                   |         840.00 |   176.4000 |   1016.4000 |
    | OR-147                   |          42.00 |     8.8200 |     50.8200 |
    | FR-105                   |         280.00 |    58.8000 |    338.8000 |
    | FR-57                    |        1827.00 |   383.6700 |   2210.6700 |
    | OR-176                   |         380.00 |    79.8000 |    459.8000 |
    | AR-003                   |          17.00 |     3.5700 |     20.5700 |
    | AR-005                   |          21.00 |     4.4100 |     25.4100 |
    | AR-007                   |           9.00 |     1.8900 |     10.8900 |
    | AR-010                   |          10.00 |     2.1000 |     12.1000 |
    | FR-10                    |         119.00 |    24.9900 |    143.9900 |
    | FR-101                   |         247.00 |    51.8700 |    298.8700 |
    | FR-103                   |          25.00 |     5.2500 |     30.2500 |
    | OR-236                   |        2205.00 |   463.0500 |   2668.0500 |
    | OR-237                   |         950.00 |   199.5000 |   1149.5000 |
    | OR-204                   |         500.00 |   105.0000 |    605.0000 |
    | OR-205                   |         100.00 |    21.0000 |    121.0000 |
    | OR-206                   |          25.00 |     5.2500 |     30.2500 |
    | OR-226                   |         570.00 |   119.7000 |    689.7000 |
    | OR-209                   |         500.00 |   105.0000 |    605.0000 |
    | OR-210                   |        3120.00 |   655.2000 |   3775.2000 |
    | OR-211                   |        4130.00 |   867.3000 |   4997.3000 |
    | FR-2                     |           6.00 |     1.2600 |      7.2600 |
    | FR-86                    |          22.00 |     4.6200 |     26.6200 |
    | OR-116                   |          98.00 |    20.5800 |    118.5800 |
    | FR-79                    |         946.00 |   198.6600 |   1144.6600 |
    | OR-168                   |          20.00 |     4.2000 |     24.2000 |
    | OR-115                   |          63.00 |    13.2300 |     76.2300 |
    | OR-243                   |         128.00 |    26.8800 |    154.8800 |
    | OR-130                   |         216.00 |    45.3600 |    261.3600 |
    | OR-179                   |          30.00 |     6.3000 |     36.3000 |
    | OR-196                   |         280.00 |    58.8000 |    338.8000 |
    | OR-207                   |          16.00 |     3.3600 |     19.3600 |
    | OR-250                   |          30.00 |     6.3000 |     36.3000 |
    | FR-81                    |         147.00 |    30.8700 |    177.8700 |
    | OR-139                   |         320.00 |    67.2000 |    387.2000 |
    | OR-177                   |        2250.00 |   472.5000 |   2722.5000 |
    | FR-87                    |        1584.00 |   332.6400 |   1916.6400 |
    | FR-42                    |          96.00 |    20.1600 |    116.1600 |
    | FR-66                    |         245.00 |    51.4500 |    296.4500 |
    | FR-54                    |         351.00 |    73.7100 |    424.7100 |
    | FR-58                    |         561.00 |   117.8100 |    678.8100 |
    | FR-60                    |         352.00 |    73.9200 |    425.9200 |
    | FR-43                    |          48.00 |    10.0800 |     58.0800 |
    | FR-6                     |         112.00 |    23.5200 |    135.5200 |
    | FR-71                    |         220.00 |    46.2000 |    266.2000 |
    | FR-90                    |         280.00 |    58.8000 |    338.8000 |
    | FR-41                    |          96.00 |    20.1600 |    116.1600 |
    | FR-33                    |         216.00 |    45.3600 |    261.3600 |
    | FR-56                    |         128.00 |    26.8800 |    154.8800 |
    | FR-8                     |         108.00 |    22.6800 |    130.6800 |
    | FR-45                    |         112.00 |    23.5200 |    135.5200 |
    | OR-104                   |         200.00 |    42.0000 |    242.0000 |
    | OR-119                   |          50.00 |    10.5000 |     60.5000 |
    | OR-125                   |          15.00 |     3.1500 |     18.1500 |
    | FR-16                    |          45.00 |     9.4500 |     54.4500 |
    | OR-200                   |          40.00 |     8.4000 |     48.4000 |
    | FR-78                    |          30.00 |     6.3000 |     36.3000 |
    | FR-80                    |          32.00 |     6.7200 |     38.7200 |
    | OR-146                   |          68.00 |    14.2800 |     82.2800 |
    | OR-150                   |          36.00 |     7.5600 |     43.5600 |
    +--------------------------+----------------+------------+-------------+
    ```

    

17. La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.

    ```sql
    SELECT dp.producto_codigo_producto, SUM((p.precio_venta*dp.cantidad)) AS base_imponible, SUM(((p.precio_venta*dp.cantidad)*0.21)) AS IVA, SUM(((p.precio_venta*dp.cantidad)+((p.precio_venta*dp.cantidad)*0.21))) AS total
    FROM detalle_pedido AS dp, producto AS p
    WHERE dp.producto_codigo_producto = p.codigo_producto AND p.codigo_producto LIKE 'OR%'
    GROUP BY dp.producto_codigo_producto;
    
    +--------------------------+----------------+------------+-------------+
    | producto_codigo_producto | base_imponible | IVA        | total       |
    +--------------------------+----------------+------------+-------------+
    | OR-127                   |         280.00 |    58.8000 |    338.8000 |
    | OR-141                   |         180.00 |    37.8000 |    217.8000 |
    | OR-241                   |         475.00 |    99.7500 |    574.7500 |
    | OR-99                    |         532.00 |   111.7200 |    643.7200 |
    | OR-140                   |         200.00 |    42.0000 |    242.0000 |
    | OR-159                   |         132.00 |    27.7200 |    159.7200 |
    | OR-227                   |       15104.00 |  3171.8400 |  18275.8400 |
    | OR-247                   |      128898.00 | 27068.5800 | 155966.5800 |
    | OR-122                   |         160.00 |    33.6000 |    193.6000 |
    | OR-123                   |          70.00 |    14.7000 |     84.7000 |
    | OR-213                   |        9310.00 |  1955.1000 |  11265.1000 |
    | OR-217                   |         960.00 |   201.6000 |   1161.6000 |
    | OR-218                   |         950.00 |   199.5000 |   1149.5000 |
    | OR-152                   |          18.00 |     3.7800 |     21.7800 |
    | OR-155                   |          24.00 |     5.0400 |     29.0400 |
    | OR-156                   |         330.00 |    69.3000 |    399.3000 |
    | OR-157                   |        2620.00 |   550.2000 |   3170.2000 |
    | OR-222                   |        1827.00 |   383.6700 |   2210.6700 |
    | OR-234                   |        3520.00 |   739.2000 |   4259.2000 |
    | OR-101                   |         144.00 |    30.2400 |    174.2400 |
    | OR-203                   |         100.00 |    21.0000 |    121.0000 |
    | OR-136                   |        2286.00 |   480.0600 |   2766.0600 |
    | OR-208                   |         884.00 |   185.6400 |   1069.6400 |
    | OR-240                   |         468.00 |    98.2800 |    566.2800 |
    | OR-249                   |         150.00 |    31.5000 |    181.5000 |
    | OR-188                   |         100.00 |    21.0000 |    121.0000 |
    | OR-102                   |         522.00 |   109.6200 |    631.6200 |
    | OR-186                   |         240.00 |    50.4000 |    290.4000 |
    | OR-129                   |         330.00 |    69.3000 |    399.3000 |
    | OR-160                   |         100.00 |    21.0000 |    121.0000 |
    | OR-120                   |          25.00 |     5.2500 |     30.2500 |
    | OR-128                   |        2842.00 |   596.8200 |   3438.8200 |
    | OR-193                   |         100.00 |    21.0000 |    121.0000 |
    | OR-214                   |        2120.00 |   445.2000 |   2565.2000 |
    | OR-172                   |        1602.00 |   336.4200 |   1938.4200 |
    | OR-174                   |         432.00 |    90.7200 |    522.7200 |
    | OR-165                   |          30.00 |     6.3000 |     36.3000 |
    | OR-181                   |         360.00 |    75.6000 |    435.6000 |
    | OR-225                   |         840.00 |   176.4000 |   1016.4000 |
    | OR-147                   |          42.00 |     8.8200 |     50.8200 |
    | OR-176                   |         380.00 |    79.8000 |    459.8000 |
    | OR-236                   |        2205.00 |   463.0500 |   2668.0500 |
    | OR-237                   |         950.00 |   199.5000 |   1149.5000 |
    | OR-204                   |         500.00 |   105.0000 |    605.0000 |
    | OR-205                   |         100.00 |    21.0000 |    121.0000 |
    | OR-206                   |          25.00 |     5.2500 |     30.2500 |
    | OR-226                   |         570.00 |   119.7000 |    689.7000 |
    | OR-209                   |         500.00 |   105.0000 |    605.0000 |
    | OR-210                   |        3120.00 |   655.2000 |   3775.2000 |
    | OR-211                   |        4130.00 |   867.3000 |   4997.3000 |
    | OR-116                   |          98.00 |    20.5800 |    118.5800 |
    | OR-168                   |          20.00 |     4.2000 |     24.2000 |
    | OR-115                   |          63.00 |    13.2300 |     76.2300 |
    | OR-243                   |         128.00 |    26.8800 |    154.8800 |
    | OR-130                   |         216.00 |    45.3600 |    261.3600 |
    | OR-179                   |          30.00 |     6.3000 |     36.3000 |
    | OR-196                   |         280.00 |    58.8000 |    338.8000 |
    | OR-207                   |          16.00 |     3.3600 |     19.3600 |
    | OR-250                   |          30.00 |     6.3000 |     36.3000 |
    | OR-139                   |         320.00 |    67.2000 |    387.2000 |
    | OR-177                   |        2250.00 |   472.5000 |   2722.5000 |
    | OR-104                   |         200.00 |    42.0000 |    242.0000 |
    | OR-119                   |          50.00 |    10.5000 |     60.5000 |
    | OR-125                   |          15.00 |     3.1500 |     18.1500 |
    | OR-200                   |          40.00 |     8.4000 |     48.4000 |
    | OR-146                   |          68.00 |    14.2800 |     82.2800 |
    | OR-150                   |          36.00 |     7.5600 |     43.5600 |
    +--------------------------+----------------+------------+-------------+
    ```

    

18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA).

    ```sql
    SELECT DISTINCT(p.nombre), SUM(dp.cantidad) AS cantidad, SUM((p.precio_venta*dp.cantidad)) AS total, SUM(((p.precio_venta*dp.cantidad)+((p.precio_venta*dp.cantidad)*0.21))) AS total_con_IVA
    FROM producto AS p
    INNER JOIN detalle_pedido AS dp
    ON dp.producto_codigo_producto = p.codigo_producto
    WHERE ((p.precio_venta*dp.cantidad)+((p.precio_venta*dp.cantidad)*0.21)) > 3000
    GROUP BY p.nombre;
    
    +---------------------------+----------+-----------+---------------+
    | nombre                    | cantidad | total     | total_con_IVA |
    +---------------------------+----------+-----------+---------------+
    | Chamaerops Humilis        |      111 |   7104.00 |     8595.8400 |
    | Bismarckia Nobilis        |       30 |   7980.00 |     9655.8000 |
    | Trachycarpus Fortunei     |      272 | 125664.00 |   152053.4400 |
    | Camelia japonica ejemplar |       29 |   2842.00 |     3438.8200 |
    | Dracaena Drago            |       50 |   3200.00 |     3872.0000 |
    | Beucarnea Recurvata       |      150 |   7250.00 |     8772.5000 |
    | Kaki                      |       56 |   3920.00 |     4743.2000 |
    | Limonero 30/40            |       73 |   7300.00 |     8833.0000 |
    +---------------------------+----------+-----------+---------------+
    ```

    

19. Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos.

    ```sql
    SELECT YEAR(p.fecha_pago) AS año_pago, SUM(p.total) AS total_pagos
    FROM pago AS p
    GROUP BY YEAR(p.fecha_pago);
    
    +----------+-------------+
    | año_pago | total_pagos |
    +----------+-------------+
    |     2008 |    29252.00 |
    |     2009 |    58553.00 |
    |     2007 |    85170.00 |
    |     2006 |    24965.00 |
    +----------+-------------+
    ```
    
    

##### Subconsultas

###### Con operadores básicos de comparación

1. Devuelve el nombre del cliente con mayor límite de crédito.

   ```sql
   SELECT c.nombre_cliente
   FROM cliente AS c
   WHERE c.limite_credito = (
   	SELECT MAX(c.limite_credito)
       FROM cliente AS c
   );
   
   +----------------+
   | nombre_cliente |
   +----------------+
   | Tendo Garden   |
   +----------------+
   ```

   

2. Devuelve el nombre del producto que tenga el precio de venta más caro.

   ```sql
   SELECT p.nombre
   FROM producto AS p
   WHERE p.precio_venta = (
   	SELECT MAX(p.precio_venta)
       FROM producto AS p
   );
   
   +-----------------------+
   | nombre                |
   +-----------------------+
   | Trachycarpus Fortunei |
   +-----------------------+
   ```

   

3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido).

   ```sql
   SELECT DISTINCT(p.nombre)
   FROM producto AS p, detalle_pedido AS dp
   WHERE p.nombre = (
   	SELECT DISTINCT(p.nombre)
       FROM producto AS p
       INNER JOIN detalle_pedido AS dp
       ON dp.producto_codigo_producto = p.codigo_producto
       GROUP BY p.nombre
       ORDER BY COUNT(dp.cantidad) DESC
       LIMIT 1
   );
   
   +--------+
   | nombre |
   +--------+
   | Cerezo |
   +--------+
   ```

     

4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).

   ```sql
   SELECT c.nombre_cliente
   FROM cliente AS c
   WHERE c.limite_credito > (
   	SELECT IFNULL(SUM(p.total), 0)
       FROM pago AS p
       WHERE p.codigo_cliente = c.codigo_cliente
   );
   
   +--------------------------------+
   | nombre_cliente                 |
   +--------------------------------+
   | Tendo Garden                   |
   | Lasas S.A.                     |
   | Beragua                        |
   | Club Golf Puerta del hierro    |
   | Naturagua                      |
   | DaraDistribuciones             |
   | Madrileña de riegos            |
   | Lasas S.A.                     |
   | Camunas Jardines S.L.          |
   | Dardena S.A.                   |
   | Jardin de Flores               |
   | Flowers, S.A                   |
   | Naturajardin                   |
   | Golf S.A.                      |
   | Americh Golf Management SL     |
   | Aloha                          |
   | El Prat                        |
   | Sotogrande                     |
   | Vivero Humanes                 |
   | Fuenla City                    |
   | Jardines y Mansiones Cactus SL |
   | Jardinerías Matías SL          |
   | Top Campo                      |
   | Campohermoso                   |
   | france telecom                 |
   | Musée du Louvre                |
   | Tutifruti S.A                  |
   | Flores S.L.                    |
   | The Magic Garden               |
   | El Jardin Viviente S.L         |
   +--------------------------------+
   ```

   


5. Devuelve el producto que más unidades tiene en stock.

   ```sql
   SELECT p.nombre
   FROM producto AS p
   WHERE p.cantidad_en_stock = (
   	SELECT MAX(p.cantidad_en_stock)
       FROM producto AS p
   );
   
   +---------------------------------+
   | nombre                          |
   +---------------------------------+
   | Rosal copa                      |
   | Albaricoquero Corbato           |
   | Albaricoquero Moniqui           |
   | Albaricoquero Kurrot            |
   | Cerezo Burlat                   |
   | Cerezo Picota                   |
   | Cerezo Napoleón                 |
   | Ciruelo R. Claudia Verde        |
   | Ciruelo Santa Rosa              |
   | Ciruelo Golden Japan            |
   | Ciruelo Friar                   |
   | Ciruelo Reina C. De Ollins      |
   | Ciruelo Claudia Negra           |
   | Granado Mollar de Elche         |
   | Higuera Napolitana              |
   | Higuera Verdal                  |
   | Higuera Breva                   |
   | Manzano Starking Delicious      |
   | Manzano Reineta                 |
   | Manzano Golden Delicious        |
   | Membrillero Gigante de Wranja   |
   | Melocotonero Spring Crest       |
   | Melocotonero Amarillo de Agosto |
   | Melocotonero Federica           |
   | Melocotonero Paraguayo          |
   | Nogal Común                     |
   | Parra Uva de Mesa               |
   | Peral Castell                   |
   | Peral Williams                  |
   | Peral Conference                |
   | Peral Blanq. de Aranjuez        |
   | Níspero Tanaca                  |
   | Olivo Cipresino                 |
   | Nectarina                       |
   | Kaki Rojo Brillante             |
   +---------------------------------+
   ```

   

6. Devuelve el producto que menos unidades tiene en stock.

   ```sql
   SELECT p.nombre
   FROM producto AS p
   WHERE p.cantidad_en_stock = (
   	SELECT MIN(p.cantidad_en_stock)
       FROM producto AS p
   );
   
   +---------------+
   | nombre        |
   +---------------+
   | Brahea Armata |
   +---------------+
   ```

   

7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.

   ```sql
   SELECT e.nombre, e.apellido1, e.apellido2, e.email
   FROM empleado AS e
   WHERE e.codigo_jefe = (
   	SELECT e.codigo_empleado
       FROM empleado AS e
       WHERE e.nombre = 'Alberto' AND e.apellido1 = 'Soria'
   );
   
   +-------------+------------+-----------+---------------------------+
   | nombre      | apellido1  | apellido2 | email                     |
   +-------------+------------+-----------+---------------------------+
   | Felipe      | Rosas      | Marquez   | frosas@jardineria.es      |
   | Juan Carlos | Ortiz      | Serrano   | cortiz@jardineria.es      |
   | Carlos      | Soria      | Jimenez   | csoria@jardineria.es      |
   | Emmanuel    | Magaña     | Perez     | manu@jardineria.es        |
   | Francois    | Fignon     |           | ffignon@gardening.com     |
   | Michael     | Bolton     |           | mbolton@gardening.com     |
   | Hilary      | Washington |           | hwashington@gardening.com |
   | Nei         | Nishikori  |           | nnishikori@gardening.com  |
   | Amy         | Johnson    |           | ajohnson@gardening.com    |
   | Kevin       | Fallmer    |           | kfalmer@gardening.com     |
   +-------------+------------+-----------+---------------------------+
   ```

  

###### Subconsultas con ALL y ANY

8. Devuelve el nombre del cliente con mayor límite de crédito.

   ```sql
   SELECT c.nombre_cliente
   FROM cliente AS c
   WHERE c.limite_credito >= ALL (
   	SELECT c.limite_credito
       FROM cliente AS c
   );
   
   +----------------+
   | nombre_cliente |
   +----------------+
   | Tendo Garden   |
   +----------------+
   ```

   

9. Devuelve el nombre del producto que tenga el precio de venta más caro.

   ```sql
   SELECT p.nombre
   FROM producto AS p
   WHERE p.precio_venta >= ALL (
   	SELECT p.precio_venta
       FROM producto AS p
   );
   
   +-----------------------+
   | nombre                |
   +-----------------------+
   | Trachycarpus Fortunei |
   +-----------------------+
   ```

   

10. Devuelve el producto que menos unidades tiene en stock.

    ```sql
    SELECT p.nombre
    FROM producto AS p
    WHERE p.cantidad_en_stock <= ALL (
    	SELECT p.cantidad_en_stock
        FROM producto AS p
    );
    
    +---------------+
    | nombre        |
    +---------------+
    | Brahea Armata |
    +---------------+
    ```
    
    

###### Subconsultas con IN y NOT IN

11. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.

    ```sql
    SELECT e.nombre, e.apellido1, p.nombre_puesto
    FROM empleado AS e, puesto AS p
    WHERE e.codigo_puesto = p.codigo_puesto
    AND e.codigo_empleado NOT IN (
    	SELECT c.codigo_empleado_rep_ventas
        FROM cliente AS c
    );
    
    +-------------+------------+-----------------------+
    | nombre      | apellido1  | nombre_puesto         |
    +-------------+------------+-----------------------+
    | Marcos      | Magaña     | Director General      |
    | Ruben       | López      | Subdirector Marketing |
    | Alberto     | Soria      | Subdirector Ventas    |
    | Maria       | Solís      | Secretaria            |
    | Juan Carlos | Ortiz      | Representante Ventas  |
    | Hilario     | Rodriguez  | Representante Ventas  |
    | David       | Palma      | Representante Ventas  |
    | Oscar       | Palma      | Representante Ventas  |
    | Laurent     | Serra      | Representante Ventas  |
    | Marcus      | Paxton     | Representante Ventas  |
    | Narumi      | Riko       | Representante Ventas  |
    | Takuma      | Nomura     | Representante Ventas  |
    | Larry       | Westfalls  | Representante Ventas  |
    | John        | Walton     | Representante Ventas  |
    | Carlos      | Soria      | Director Oficina      |
    | Francois    | Fignon     | Director Oficina      |
    | Hilary      | Washington | Director Oficina      |
    | Nei         | Nishikori  | Director Oficina      |
    | Amy         | Johnson    | Director Oficina      |
    | Kevin       | Fallmer    | Director Oficina      |
    +-------------+------------+-----------------------+
    ```

    

12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

    ```sql
    SELECT c.nombre_cliente
    FROM cliente AS c
    WHERE c.codigo_cliente NOT IN (
    	SELECT p.codigo_cliente
        FROM pago AS p
    );
    
    +-----------------------------+
    | nombre_cliente              |
    +-----------------------------+
    | Lasas S.A.                  |
    | Club Golf Puerta del hierro |
    | DaraDistribuciones          |
    | Madrileña de riegos         |
    | Lasas S.A.                  |
    | Flowers, S.A                |
    | Naturajardin                |
    | Americh Golf Management SL  |
    | Aloha                       |
    | El Prat                     |
    | Vivero Humanes              |
    | Fuenla City                 |
    | Top Campo                   |
    | Campohermoso                |
    | france telecom              |
    | Musée du Louvre             |
    | Flores S.L.                 |
    | The Magic Garden            |
    +-----------------------------+
    ```

    

13. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

    ```sql
    SELECT c.nombre_cliente
    FROM cliente AS c
    WHERE c.codigo_cliente IN (
    	SELECT p.codigo_cliente
        FROM pago AS p
    );
    
    +--------------------------------+
    | nombre_cliente                 |
    +--------------------------------+
    | GoldFish Garden                |
    | Gardening Associates           |
    | Gerudo Valley                  |
    | Tendo Garden                   |
    | Beragua                        |
    | Naturagua                      |
    | Camunas Jardines S.L.          |
    | Dardena S.A.                   |
    | Jardin de Flores               |
    | Flores Marivi                  |
    | Golf S.A.                      |
    | Sotogrande                     |
    | Jardines y Mansiones Cactus SL |
    | Jardinerías Matías SL          |
    | Agrojardin                     |
    | Jardineria Sara                |
    | Tutifruti S.A                  |
    | El Jardin Viviente S.L         |
    +--------------------------------+
    ```

    

14. Devuelve un listado de los productos que nunca han aparecido en un pedido.

    ```sql
    SELECT DISTINCT(p.nombre)
    FROM producto AS p
    WHERE p.codigo_producto NOT IN (
    	SELECT dp.producto_codigo_producto
        FROM detalle_pedido AS dp
    );
    
    +-------------------------------------------------------------+
    | nombre                                                      |
    +-------------------------------------------------------------+
    | Olea-Olivos                                                 |
    | Calamondin Mini                                             |
    | Camelia Blanco, Chrysler Rojo, Soraya Naranja,              |
    | Landora Amarillo, Rose Gaujard bicolor blanco-rojo          |
    | Kordes Perfect bicolor rojo-amarillo, Roundelay rojo fuerte |
    | Albaricoquero Corbato                                       |
    | Albaricoquero Moniqui                                       |
    | Albaricoquero Kurrot                                        |
    | Cerezo Burlat                                               |
    | Cerezo Picota                                               |
    | Ciruelo R. Claudia Verde                                    |
    | Ciruelo Golden Japan                                        |
    | Ciruelo Claudia Negra                                       |
    | Higuera Verdal                                              |
    | Higuera Breva                                               |
    | Melocotonero Spring Crest                                   |
    | Melocotonero Federica                                       |
    | Parra Uva de Mesa                                           |
    | Mandarino -Plantón joven                                    |
    | Peral Castell                                               |
    | Peral Williams                                              |
    | Peral Conference                                            |
    | Olivo Cipresino                                             |
    | Albaricoquero                                               |
    | Cerezo                                                      |
    | Ciruelo                                                     |
    | Granado                                                     |
    | Higuera                                                     |
    | Manzano                                                     |
    | Melocotonero                                                |
    | Membrillero                                                 |
    | Arbustos Mix Maceta                                         |
    | Mimosa Injerto CLASICA Dealbata                             |
    | Mimosa Semilla Bayleyana                                    |
    | Mimosa Semilla Espectabilis                                 |
    | Mimosa Semilla Longifolia                                   |
    | Mimosa Semilla Floribunda 4 estaciones                      |
    | Abelia Floribunda                                           |
    | Callistemom (Mix)                                           |
    | Corylus Avellana "Contorta"                                 |
    | Escallonia (Mix)                                            |
    | Evonimus Emerald Gayeti                                     |
    | Evonimus Pulchellus                                         |
    | Hibiscus Syriacus  "Helene" -Blanco-C.rojo                  |
    | Hibiscus Syriacus "Pink Giant" Rosa                         |
    | Lonicera Nitida "Maigrum"                                   |
    | Prunus pisardii                                             |
    | Weigelia "Bristol Ruby"                                     |
    | Leptospermum formado PIRAMIDE                               |
    | Leptospermum COPA                                           |
    | Nerium oleander-CALIDAD "GARDEN"                            |
    | Nerium Oleander Arbusto GRANDE                              |
    | Nerium oleander COPA  Calibre 6/8                           |
    | ROSAL TREPADOR                                              |
    | Solanum Jazminoide                                          |
    | Wisteria Sinensis  azul, rosa, blanca                       |
    | Wisteria Sinensis INJERTADAS DECÃ?                          |
    | Bougamvillea Sanderiana Tutor                               |
    | Bougamvillea Sanderiana Espaldera                           |
    | Bougamvillea Sanderiana, 3 tut. piramide                    |
    | Expositor Árboles clima mediterráneo                        |
    | Expositor Árboles borde del mar                             |
    | Brachychiton Acerifolius                                    |
    | Cassia Corimbosa                                            |
    | Cassia Corimbosa                                            |
    | Chitalpa Summer Bells                                       |
    | Erytrina Kafra                                              |
    | Eucalyptus Citriodora                                       |
    | Eucalyptus Ficifolia                                        |
    | Hibiscus Syriacus  Var. Injertadas 1 Tallo                  |
    | Lagunaria Patersonii                                        |
    | Lagunaria Patersonii                                        |
    | Morus Alba                                                  |
    | Platanus Acerifolia                                         |
    | Salix Babylonica  Pendula                                   |
    | Tamarix  Ramosissima Pink Cascade                           |
    | Tecoma Stands                                               |
    | Tecoma Stands                                               |
    | Tipuana Tipu                                                |
    | Pleioblastus distichus-Bambú enano                          |
    | Sasa palmata                                                |
    | Phylostachys aurea                                          |
    | Phylostachys Bambusa Spectabilis                            |
    | Phylostachys biseti                                         |
    | Pseudosasa japonica (Metake)                                |
    | Pseudosasa japonica (Metake)                                |
    | Cedrus Deodara "Feeling Blue" Novedad                       |
    | Juniperus chinensis "Blue Alps"                             |
    | Juniperus Chinensis Stricta                                 |
    | Juniperus squamata "Blue Star"                              |
    | Juniperus x media Phitzeriana verde                         |
    | Bismarckia Nobilis                                          |
    | Brahea Armata                                               |
    | Brahea Edulis                                               |
    | Butia Capitata                                              |
    | Chamaerops Humilis                                          |
    | Chamaerops Humilis "Cerifera"                               |
    | Chrysalidocarpus Lutescens -ARECA                           |
    | Cordyline Australis -DRACAENA                               |
    | Cycas Revoluta                                              |
    | Dracaena Drago                                              |
    | Livistonia Decipiens                                        |
    | Rhaphis Excelsa                                             |
    | Sabal Minor                                                 |
    | Trachycarpus Fortunei                                       |
    | Washingtonia Robusta                                        |
    | Zamia Furfuracaea                                           |
    +-------------------------------------------------------------+
    ```

    

15. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.

    ```sql
    SELECT e.nombre, e.apellido1, e.apellido2, p.nombre_puesto, t.numero_telefono
    FROM empleado AS e, puesto AS p, oficina AS o, telefono AS t
    WHERE e.codigo_puesto = p.codigo_puesto
    AND e.codigo_oficina = o.codigo_oficina
    AND o.codigo_oficina = t.codigo_oficina
    AND e.codigo_empleado NOT IN (
    	SELECT c.codigo_empleado_rep_ventas
        FROM cliente AS c
    );
    
    +-------------+------------+-----------+-----------------------+-----------------+
    | nombre      | apellido1  | apellido2 | nombre_puesto         | numero_telefono |
    +-------------+------------+-----------+-----------------------+-----------------+
    | Marcos      | Magaña     | Perez     | Director General      | +34 925 867231  |
    | Ruben       | López      | Martinez  | Subdirector Marketing | +34 925 867231  |
    | Alberto     | Soria      | Carrasco  | Subdirector Ventas    | +34 925 867231  |
    | Maria       | Solís      | Jerez     | Secretaria            | +34 925 867231  |
    | Juan Carlos | Ortiz      | Serrano   | Representante Ventas  | +34 925 867231  |
    | Hilario     | Rodriguez  | Huertas   | Representante Ventas  | +34 91 7514487  |
    | David       | Palma      | Aceituno  | Representante Ventas  | +34 93 3561182  |
    | Oscar       | Palma      | Aceituno  | Representante Ventas  | +34 93 3561182  |
    | Laurent     | Serra      |           | Representante Ventas  | +33 14 723 4404 |
    | Marcus      | Paxton     |           | Representante Ventas  | +1 215 837 0825 |
    | Narumi      | Riko       |           | Representante Ventas  | +81 33 224 5000 |
    | Takuma      | Nomura     |           | Representante Ventas  | +81 33 224 5000 |
    | Larry       | Westfalls  |           | Representante Ventas  | +44 20 78772041 |
    | John        | Walton     |           | Representante Ventas  | +44 20 78772041 |
    | Carlos      | Soria      | Jimenez   | Director Oficina      | +34 91 7514487  |
    | Francois    | Fignon     |           | Director Oficina      | +33 14 723 4404 |
    | Hilary      | Washington |           | Director Oficina      | +1 215 837 0825 |
    | Nei         | Nishikori  |           | Director Oficina      | +81 33 224 5000 |
    | Amy         | Johnson    |           | Director Oficina      | +44 20 78772041 |
    | Kevin       | Fallmer    |           | Director Oficina      | +61 2 9264 2451 |
    +-------------+------------+-----------+-----------------------+-----------------+
    ```

    

16. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

    ```sql
    /* RESIGNACIÓN */
    ```

    

17. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

    ```sql
    SELECT DISTINCT(c.nombre_cliente)
    FROM cliente AS c, pedido AS p
    WHERE c.codigo_cliente = p.codigo_cliente
    AND c.codigo_cliente NOT IN (
    	SELECT pa.codigo_cliente
        FROM pago AS pa
    );
    
    +----------------+
    | nombre_cliente |
    +----------------+
    | Flores S.L.    |
    +----------------+
    ```
    
    

###### Subconsultas con EXISTS y NOT EXISTS

18. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

    ```sql
    SELECT c.nombre_cliente
    FROM cliente AS c
    WHERE NOT EXISTS (
    	SELECT p.codigo_cliente
        FROM pago AS p
        WHERE p.codigo_cliente = c.codigo_cliente
    );
    
    +-----------------------------+
    | nombre_cliente              |
    +-----------------------------+
    | Lasas S.A.                  |
    | Club Golf Puerta del hierro |
    | DaraDistribuciones          |
    | Madrileña de riegos         |
    | Lasas S.A.                  |
    | Flowers, S.A                |
    | Naturajardin                |
    | Americh Golf Management SL  |
    | Aloha                       |
    | El Prat                     |
    | Vivero Humanes              |
    | Fuenla City                 |
    | Top Campo                   |
    | Campohermoso                |
    | france telecom              |
    | Musée du Louvre             |
    | Flores S.L.                 |
    | The Magic Garden            |
    +-----------------------------+
    ```

    

19. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

    ```sql
    SELECT c.nombre_cliente
    FROM cliente AS c
    WHERE EXISTS (
    	SELECT p.codigo_cliente
        FROM pago AS p
        WHERE p.codigo_cliente = c.codigo_cliente
    );
    
    +--------------------------------+
    | nombre_cliente                 |
    +--------------------------------+
    | GoldFish Garden                |
    | Gardening Associates           |
    | Gerudo Valley                  |
    | Tendo Garden                   |
    | Beragua                        |
    | Naturagua                      |
    | Camunas Jardines S.L.          |
    | Dardena S.A.                   |
    | Jardin de Flores               |
    | Flores Marivi                  |
    | Golf S.A.                      |
    | Sotogrande                     |
    | Jardines y Mansiones Cactus SL |
    | Jardinerías Matías SL          |
    | Agrojardin                     |
    | Jardineria Sara                |
    | Tutifruti S.A                  |
    | El Jardin Viviente S.L         |
    +--------------------------------+
    ```

    

20. Devuelve un listado de los productos que nunca han aparecido en un pedido.

    ```sql
    SELECT DISTINCT(p.nombre)
    FROM producto AS p
    WHERE NOT EXISTS (
    	SELECT dp.producto_codigo_producto
        FROM detalle_pedido AS dp
        WHERE dp.producto_codigo_producto = p.codigo_producto
    );
    
    +-------------------------------------------------------------+
    | nombre                                                      |
    +-------------------------------------------------------------+
    | Olea-Olivos                                                 |
    | Calamondin Mini                                             |
    | Camelia Blanco, Chrysler Rojo, Soraya Naranja,              |
    | Landora Amarillo, Rose Gaujard bicolor blanco-rojo          |
    | Kordes Perfect bicolor rojo-amarillo, Roundelay rojo fuerte |
    | Albaricoquero Corbato                                       |
    | Albaricoquero Moniqui                                       |
    | Albaricoquero Kurrot                                        |
    | Cerezo Burlat                                               |
    | Cerezo Picota                                               |
    | Ciruelo R. Claudia Verde                                    |
    | Ciruelo Golden Japan                                        |
    | Ciruelo Claudia Negra                                       |
    | Higuera Verdal                                              |
    | Higuera Breva                                               |
    | Melocotonero Spring Crest                                   |
    | Melocotonero Federica                                       |
    | Parra Uva de Mesa                                           |
    | Mandarino -Plantón joven                                    |
    | Peral Castell                                               |
    | Peral Williams                                              |
    | Peral Conference                                            |
    | Olivo Cipresino                                             |
    | Albaricoquero                                               |
    | Cerezo                                                      |
    | Ciruelo                                                     |
    | Granado                                                     |
    | Higuera                                                     |
    | Manzano                                                     |
    | Melocotonero                                                |
    | Membrillero                                                 |
    | Arbustos Mix Maceta                                         |
    | Mimosa Injerto CLASICA Dealbata                             |
    | Mimosa Semilla Bayleyana                                    |
    | Mimosa Semilla Espectabilis                                 |
    | Mimosa Semilla Longifolia                                   |
    | Mimosa Semilla Floribunda 4 estaciones                      |
    | Abelia Floribunda                                           |
    | Callistemom (Mix)                                           |
    | Corylus Avellana "Contorta"                                 |
    | Escallonia (Mix)                                            |
    | Evonimus Emerald Gayeti                                     |
    | Evonimus Pulchellus                                         |
    | Hibiscus Syriacus  "Helene" -Blanco-C.rojo                  |
    | Hibiscus Syriacus "Pink Giant" Rosa                         |
    | Lonicera Nitida "Maigrum"                                   |
    | Prunus pisardii                                             |
    | Weigelia "Bristol Ruby"                                     |
    | Leptospermum formado PIRAMIDE                               |
    | Leptospermum COPA                                           |
    | Nerium oleander-CALIDAD "GARDEN"                            |
    | Nerium Oleander Arbusto GRANDE                              |
    | Nerium oleander COPA  Calibre 6/8                           |
    | ROSAL TREPADOR                                              |
    | Solanum Jazminoide                                          |
    | Wisteria Sinensis  azul, rosa, blanca                       |
    | Wisteria Sinensis INJERTADAS DECÃ?                          |
    | Bougamvillea Sanderiana Tutor                               |
    | Bougamvillea Sanderiana Espaldera                           |
    | Bougamvillea Sanderiana, 3 tut. piramide                    |
    | Expositor Árboles clima mediterráneo                        |
    | Expositor Árboles borde del mar                             |
    | Brachychiton Acerifolius                                    |
    | Cassia Corimbosa                                            |
    | Cassia Corimbosa                                            |
    | Chitalpa Summer Bells                                       |
    | Erytrina Kafra                                              |
    | Eucalyptus Citriodora                                       |
    | Eucalyptus Ficifolia                                        |
    | Hibiscus Syriacus  Var. Injertadas 1 Tallo                  |
    | Lagunaria Patersonii                                        |
    | Lagunaria Patersonii                                        |
    | Morus Alba                                                  |
    | Platanus Acerifolia                                         |
    | Salix Babylonica  Pendula                                   |
    | Tamarix  Ramosissima Pink Cascade                           |
    | Tecoma Stands                                               |
    | Tecoma Stands                                               |
    | Tipuana Tipu                                                |
    | Pleioblastus distichus-Bambú enano                          |
    | Sasa palmata                                                |
    | Phylostachys aurea                                          |
    | Phylostachys Bambusa Spectabilis                            |
    | Phylostachys biseti                                         |
    | Pseudosasa japonica (Metake)                                |
    | Pseudosasa japonica (Metake)                                |
    | Cedrus Deodara "Feeling Blue" Novedad                       |
    | Juniperus chinensis "Blue Alps"                             |
    | Juniperus Chinensis Stricta                                 |
    | Juniperus squamata "Blue Star"                              |
    | Juniperus x media Phitzeriana verde                         |
    | Bismarckia Nobilis                                          |
    | Brahea Armata                                               |
    | Brahea Edulis                                               |
    | Butia Capitata                                              |
    | Chamaerops Humilis                                          |
    | Chamaerops Humilis "Cerifera"                               |
    | Chrysalidocarpus Lutescens -ARECA                           |
    | Cordyline Australis -DRACAENA                               |
    | Cycas Revoluta                                              |
    | Dracaena Drago                                              |
    | Livistonia Decipiens                                        |
    | Rhaphis Excelsa                                             |
    | Sabal Minor                                                 |
    | Trachycarpus Fortunei                                       |
    | Washingtonia Robusta                                        |
    | Zamia Furfuracaea                                           |
    +-------------------------------------------------------------+
    ```

    

21. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.

    ```sql
    SELECT DISTINCT(p.nombre)
    FROM producto AS p
    WHERE EXISTS (
    	SELECT dp.producto_codigo_producto
        FROM detalle_pedido AS dp
        WHERE dp.producto_codigo_producto = p.codigo_producto
    );
    
    +-------------------------------------------------------------+
    | nombre                                                      |
    +-------------------------------------------------------------+
    | Sierra de Poda 400MM                                        |
    | Pala                                                        |
    | Rastrillo de Jardín                                         |
    | Azadón                                                      |
    | Ajedrea                                                     |
    | Lavándula Dentata                                           |
    | Mejorana                                                    |
    | Melissa                                                     |
    | Mentha Sativa                                               |
    | Petrosilium Hortense (Peregil)                              |
    | Salvia Mix                                                  |
    | Thymus Citriodra (Tomillo limón)                            |
    | Thymus Vulgaris                                             |
    | Santolina Chamaecyparys                                     |
    | Expositor Cítricos Mix                                      |
    | Limonero 2 años injerto                                     |
    | Nectarina                                                   |
    | Nogal                                                       |
    | Olea-Olivos                                                 |
    | Peral                                                       |
    | Limonero 30/40                                              |
    | Kunquat                                                     |
    | Kunquat  EXTRA con FRUTA                                    |
    | Calamondin Copa                                             |
    | Calamondin Copa EXTRA Con FRUTA                             |
    | Rosal bajo 1Âª -En maceta-inicio brotación                  |
    | ROSAL TREPADOR                                              |
    | Naranjo -Plantón joven 1 año injerto                        |
    | Pitimini rojo                                               |
    | Rosal copa                                                  |
    | Cerezo Napoleón                                             |
    | Naranjo 2 años injerto                                      |
    | Ciruelo Santa Rosa                                          |
    | Ciruelo Friar                                               |
    | Ciruelo Reina C. De Ollins                                  |
    | Granado Mollar de Elche                                     |
    | Higuera Napolitana                                          |
    | Naranjo calibre 8/10                                        |
    | Manzano Starking Delicious                                  |
    | Manzano Reineta                                             |
    | Manzano Golden Delicious                                    |
    | Membrillero Gigante de Wranja                               |
    | Melocotonero Amarillo de Agosto                             |
    | Melocotonero Paraguayo                                      |
    | Nogal Común                                                 |
    | Peral Blanq. de Aranjuez                                    |
    | Níspero Tanaca                                              |
    | Kaki Rojo Brillante                                         |
    | Albaricoquero                                               |
    | Mandarino 2 años injerto                                    |
    | Cerezo                                                      |
    | Mandarino calibre 8/10                                      |
    | Ciruelo                                                     |
    | Granado                                                     |
    | Higuera                                                     |
    | Limonero -Plantón joven                                     |
    | Kaki                                                        |
    | Manzano                                                     |
    | Limonero calibre 8/10                                       |
    | Níspero                                                     |
    | Melocotonero                                                |
    | Expositor Mimosa Semilla Mix                                |
    | Mimosa Semilla Bayleyana                                    |
    | Mimosa Semilla Cyanophylla                                  |
    | Forsytia Intermedia "Lynwood"                               |
    | Hibiscus Syriacus  "Diana" -Blanco Puro                     |
    | Laurus Nobilis Arbusto - Ramificado Bajo                    |
    | Lonicera Nitida                                             |
    | Lonicera Pileata                                            |
    | Philadelphus "Virginal"                                     |
    | Viburnum Tinus "Eve Price"                                  |
    | Camelia japonica                                            |
    | Camelia japonica ejemplar                                   |
    | Callistemom COPA                                            |
    | Nerium oleander ARBOL Calibre 8/10                          |
    | Landora Amarillo, Rose Gaujard bicolor blanco-rojo          |
    | Kordes Perfect bicolor rojo-amarillo, Roundelay rojo fuerte |
    | Bougamvillea Sanderiana Tutor                               |
    | Bougamvillea roja, naranja                                  |
    | Expositor Árboles clima continental                         |
    | Acer Negundo                                                |
    | Acer platanoides                                            |
    | Acer Pseudoplatanus                                         |
    | Brachychiton Discolor                                       |
    | Brachychiton Rupestris                                      |
    | Erytrina Kafra                                              |
    | Eucalyptus Ficifolia                                        |
    | Lagunaria patersonii  calibre 8/10                          |
    | Morus Alba  calibre 8/10                                    |
    | Prunus pisardii                                             |
    | Robinia Pseudoacacia Casque Rouge                           |
    | Sesbania Punicea                                            |
    | Tamarix  Ramosissima Pink Cascade                           |
    | Sasa palmata                                                |
    | Phylostachys biseti                                         |
    | Cedrus Deodara                                              |
    | Juniperus horizontalis Wiltonii                             |
    | Pinus Canariensis                                           |
    | Pinus Halepensis                                            |
    | Pinus Pinea -Pino Piñonero                                  |
    | Thuja Esmeralda                                             |
    | Tuja Occidentalis Woodwardii                                |
    | Tuja orientalis "Aurea nana"                                |
    | Archontophoenix Cunninghamiana                              |
    | Beucarnea Recurvata                                         |
    | Bismarckia Nobilis                                          |
    | Brahea Armata                                               |
    | Brahea Edulis                                               |
    | Butia Capitata                                              |
    | Chamaerops Humilis                                          |
    | Dracaena Drago                                              |
    | Jubaea Chilensis                                            |
    | Livistonia Australis                                        |
    | Phoenix Canariensis                                         |
    | Rhaphis Humilis                                             |
    | Trachycarpus Fortunei                                       |
    | Washingtonia Robusta                                        |
    | Yucca Jewel                                                 |
    | Mimosa DEALBATA Gaulois Astier                              |
    +-------------------------------------------------------------+
    ```
    
    

##### Consultas variadas

1. Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido.

   ```sql
   SELECT c.nombre_cliente, COUNT(p.codigo_pedido) AS pedidos_realizados
   FROM cliente AS c
   LEFT JOIN pedido AS p
   ON p.codigo_cliente = c.codigo_cliente
   GROUP BY c.nombre_cliente;
   
   +--------------------------------+--------------------+
   | nombre_cliente                 | pedidos_realizados |
   +--------------------------------+--------------------+
   | GoldFish Garden                |                 11 |
   | Gardening Associates           |                  9 |
   | Gerudo Valley                  |                  5 |
   | Tendo Garden                   |                  5 |
   | Lasas S.A.                     |                  0 |
   | Beragua                        |                  5 |
   | Club Golf Puerta del hierro    |                  0 |
   | Naturagua                      |                  5 |
   | DaraDistribuciones             |                  0 |
   | Madrileña de riegos            |                  0 |
   | Camunas Jardines S.L.          |                  5 |
   | Dardena S.A.                   |                  5 |
   | Jardin de Flores               |                  5 |
   | Flores Marivi                  |                 10 |
   | Flowers, S.A                   |                  0 |
   | Naturajardin                   |                  0 |
   | Golf S.A.                      |                  5 |
   | Americh Golf Management SL     |                  0 |
   | Aloha                          |                  0 |
   | El Prat                        |                  0 |
   | Sotogrande                     |                  5 |
   | Vivero Humanes                 |                  0 |
   | Fuenla City                    |                  0 |
   | Jardines y Mansiones Cactus SL |                  5 |
   | Jardinerías Matías SL          |                  5 |
   | Agrojardin                     |                  5 |
   | Top Campo                      |                  0 |
   | Jardineria Sara                |                 10 |
   | Campohermoso                   |                  0 |
   | france telecom                 |                  0 |
   | Musée du Louvre                |                  0 |
   | Tutifruti S.A                  |                  5 |
   | Flores S.L.                    |                  5 |
   | The Magic Garden               |                  0 |
   | El Jardin Viviente S.L         |                  5 |
   +--------------------------------+--------------------+
   ```

   

2. Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.

   ```sql
   SELECT c.nombre_cliente, SUM(p.total) AS total_pagado
   FROM cliente AS c
   LEFT JOIN pago AS p
   ON p.codigo_cliente = c.codigo_cliente
   GROUP BY c.nombre_cliente;
   
   +--------------------------------+--------------+
   | nombre_cliente                 | total_pagado |
   +--------------------------------+--------------+
   | GoldFish Garden                |      4000.00 |
   | Gardening Associates           |     10926.00 |
   | Gerudo Valley                  |     81849.00 |
   | Tendo Garden                   |     23794.00 |
   | Lasas S.A.                     |         NULL |
   | Beragua                        |      2390.00 |
   | Club Golf Puerta del hierro    |         NULL |
   | Naturagua                      |       929.00 |
   | DaraDistribuciones             |         NULL |
   | Madrileña de riegos            |         NULL |
   | Camunas Jardines S.L.          |      2246.00 |
   | Dardena S.A.                   |      4160.00 |
   | Jardin de Flores               |     12081.00 |
   | Flores Marivi                  |      4399.00 |
   | Flowers, S.A                   |         NULL |
   | Naturajardin                   |         NULL |
   | Golf S.A.                      |       232.00 |
   | Americh Golf Management SL     |         NULL |
   | Aloha                          |         NULL |
   | El Prat                        |         NULL |
   | Sotogrande                     |       272.00 |
   | Vivero Humanes                 |         NULL |
   | Fuenla City                    |         NULL |
   | Jardines y Mansiones Cactus SL |     18846.00 |
   | Jardinerías Matías SL          |     10972.00 |
   | Agrojardin                     |      8489.00 |
   | Top Campo                      |         NULL |
   | Jardineria Sara                |      7863.00 |
   | Campohermoso                   |         NULL |
   | france telecom                 |         NULL |
   | Musée du Louvre                |         NULL |
   | Tutifruti S.A                  |      3321.00 |
   | Flores S.L.                    |         NULL |
   | The Magic Garden               |         NULL |
   | El Jardin Viviente S.L         |      1171.00 |
   +--------------------------------+--------------+
   ```

   


3. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor.

   ```sql
   SELECT DISTINCT(c.nombre_cliente)
   FROM cliente AS c
   INNER JOIN pedido AS p
   ON p.codigo_cliente = c.codigo_cliente
   WHERE YEAR(p.fecha_pedido) = '2008'
   ORDER BY c.nombre_cliente ASC;
   
   +--------------------------------+
   | nombre_cliente                 |
   +--------------------------------+
   | Camunas Jardines S.L.          |
   | Dardena S.A.                   |
   | El Jardin Viviente S.L         |
   | Flores Marivi                  |
   | Flores S.L.                    |
   | Gerudo Valley                  |
   | GoldFish Garden                |
   | Jardin de Flores               |
   | Jardines y Mansiones Cactus SL |
   | Tendo Garden                   |
   | Tutifruti S.A                  |
   +--------------------------------+
   ```

   


4. Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.

   ```sql
   SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS apellido_representante, t.numero_telefono AS numero_oficina
   FROM cliente AS c, empleado AS e, oficina AS o, telefono AS t
   WHERE c.codigo_empleado_rep_ventas = e.codigo_empleado
   AND e.codigo_oficina = o.codigo_oficina
   AND o.codigo_oficina = t.codigo_oficina
   AND c.codigo_cliente NOT IN (
   	SELECT p.codigo_cliente
       FROM pago AS p
   );
   
   +-----------------------------+----------------------+------------------------+-----------------+
   | nombre_cliente              | nombre_representante | apellido_representante | numero_oficina  |
   +-----------------------------+----------------------+------------------------+-----------------+
   | Lasas S.A.                  | Mariano              | López                  | +34 91 7514487  |
   | Club Golf Puerta del hierro | Emmanuel             | Magaña                 | +34 93 3561182  |
   | DaraDistribuciones          | Emmanuel             | Magaña                 | +34 93 3561182  |
   | Madrileña de riegos         | Emmanuel             | Magaña                 | +34 93 3561182  |
   | Lasas S.A.                  | Mariano              | López                  | +34 91 7514487  |
   | Flowers, S.A                | Felipe               | Rosas                  | +34 925 867231  |
   | Naturajardin                | Julian               | Bellinelli             | +61 2 9264 2451 |
   | Americh Golf Management SL  | José Manuel          | Martinez               | +34 93 3561182  |
   | Aloha                       | José Manuel          | Martinez               | +34 93 3561182  |
   | El Prat                     | José Manuel          | Martinez               | +34 93 3561182  |
   | Vivero Humanes              | Julian               | Bellinelli             | +61 2 9264 2451 |
   | Fuenla City                 | Felipe               | Rosas                  | +34 925 867231  |
   | Top Campo                   | Felipe               | Rosas                  | +34 925 867231  |
   | Campohermoso                | Julian               | Bellinelli             | +61 2 9264 2451 |
   | france telecom              | Lionel               | Narvaez                | +33 14 723 4404 |
   | Musée du Louvre             | Lionel               | Narvaez                | +33 14 723 4404 |
   | Flores S.L.                 | Michael              | Bolton                 | +1 650 219 4782 |
   | The Magic Garden            | Michael              | Bolton                 | +1 650 219 4782 |
   +-----------------------------+----------------------+------------------------+-----------------+
   ```

   


5. Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante de ventas y la ciudad donde está su oficina.

   ```sql
   SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS apellido_representante, ci.nombre_ciudad AS ciudad_oficina
   FROM cliente AS c
   INNER JOIN empleado AS e
   ON e.codigo_empleado = c.codigo_empleado_rep_ventas
   INNER JOIN oficina AS o
   ON o.codigo_oficina = e.codigo_oficina
   INNER JOIN direccion AS d
   ON d.codigo_oficina = o.codigo_oficina
   INNER JOIN ciudad AS ci
   ON ci.codigo_ciudad = d.codigo_ciudad;
   
   +--------------------------------+----------------------+------------------------+----------------------+
   | nombre_cliente                 | nombre_representante | apellido_representante | ciudad_oficina       |
   +--------------------------------+----------------------+------------------------+----------------------+
   | GoldFish Garden                | Walter Santiago      | Sanchez                | San Francisco        |
   | Gardening Associates           | Walter Santiago      | Sanchez                | San Francisco        |
   | Gerudo Valley                  | Lorena               | Paxton                 | Boston               |
   | Tendo Garden                   | Lorena               | Paxton                 | Boston               |
   | Lasas S.A.                     | Mariano              | López                  | Madrid               |
   | Beragua                        | Emmanuel             | Magaña                 | Barcelona            |
   | Club Golf Puerta del hierro    | Emmanuel             | Magaña                 | Barcelona            |
   | Naturagua                      | Emmanuel             | Magaña                 | Barcelona            |
   | DaraDistribuciones             | Emmanuel             | Magaña                 | Barcelona            |
   | Madrileña de riegos            | Emmanuel             | Magaña                 | Barcelona            |
   | Lasas S.A.                     | Mariano              | López                  | Madrid               |
   | Camunas Jardines S.L.          | Mariano              | López                  | Madrid               |
   | Dardena S.A.                   | Mariano              | López                  | Madrid               |
   | Jardin de Flores               | Julian               | Bellinelli             | Sydney               |
   | Flores Marivi                  | Felipe               | Rosas                  | Talavera de la Reina |
   | Flowers, S.A                   | Felipe               | Rosas                  | Talavera de la Reina |
   | Naturajardin                   | Julian               | Bellinelli             | Sydney               |
   | Golf S.A.                      | José Manuel          | Martinez               | Barcelona            |
   | Americh Golf Management SL     | José Manuel          | Martinez               | Barcelona            |
   | Aloha                          | José Manuel          | Martinez               | Barcelona            |
   | El Prat                        | José Manuel          | Martinez               | Barcelona            |
   | Sotogrande                     | José Manuel          | Martinez               | Barcelona            |
   | Vivero Humanes                 | Julian               | Bellinelli             | Sydney               |
   | Fuenla City                    | Felipe               | Rosas                  | Talavera de la Reina |
   | Jardines y Mansiones Cactus SL | Lucio                | Campoamor              | Madrid               |
   | Jardinerías Matías SL          | Lucio                | Campoamor              | Madrid               |
   | Agrojardin                     | Julian               | Bellinelli             | Sydney               |
   | Top Campo                      | Felipe               | Rosas                  | Talavera de la Reina |
   | Jardineria Sara                | Felipe               | Rosas                  | Talavera de la Reina |
   | Campohermoso                   | Julian               | Bellinelli             | Sydney               |
   | france telecom                 | Lionel               | Narvaez                | Paris                |
   | Musée du Louvre                | Lionel               | Narvaez                | Paris                |
   | Tutifruti S.A                  | Mariko               | Kishi                  | Sydney               |
   | Flores S.L.                    | Michael              | Bolton                 | San Francisco        |
   | The Magic Garden               | Michael              | Bolton                 | San Francisco        |
   | El Jardin Viviente S.L         | Mariko               | Kishi                  | Sydney               |
   +--------------------------------+----------------------+------------------------+----------------------+
   ```

   


6. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.

   ```sql
   SELECT e.nombre, e.apellido1, e.apellido2, p.nombre_puesto, t.numero_telefono
   FROM empleado AS e
   INNER JOIN puesto AS p
   ON e.codigo_puesto = p.codigo_puesto
   INNER JOIN oficina AS o
   ON e.codigo_oficina = o.codigo_oficina
   INNER JOIN telefono AS t
   ON o.codigo_oficina = t.codigo_oficina
   AND e.codigo_empleado NOT IN (
   	SELECT c.codigo_empleado_rep_ventas
       FROM cliente AS c
   );
   
   +-------------+------------+-----------+-----------------------+-----------------+
   | nombre      | apellido1  | apellido2 | nombre_puesto         | numero_telefono |
   +-------------+------------+-----------+-----------------------+-----------------+
   | Marcos      | Magaña     | Perez     | Director General      | +34 925 867231  |
   | Ruben       | López      | Martinez  | Subdirector Marketing | +34 925 867231  |
   | Alberto     | Soria      | Carrasco  | Subdirector Ventas    | +34 925 867231  |
   | Maria       | Solís      | Jerez     | Secretaria            | +34 925 867231  |
   | Juan Carlos | Ortiz      | Serrano   | Representante Ventas  | +34 925 867231  |
   | Hilario     | Rodriguez  | Huertas   | Representante Ventas  | +34 91 7514487  |
   | David       | Palma      | Aceituno  | Representante Ventas  | +34 93 3561182  |
   | Oscar       | Palma      | Aceituno  | Representante Ventas  | +34 93 3561182  |
   | Laurent     | Serra      |           | Representante Ventas  | +33 14 723 4404 |
   | Marcus      | Paxton     |           | Representante Ventas  | +1 215 837 0825 |
   | Narumi      | Riko       |           | Representante Ventas  | +81 33 224 5000 |
   | Takuma      | Nomura     |           | Representante Ventas  | +81 33 224 5000 |
   | Larry       | Westfalls  |           | Representante Ventas  | +44 20 78772041 |
   | John        | Walton     |           | Representante Ventas  | +44 20 78772041 |
   | Carlos      | Soria      | Jimenez   | Director Oficina      | +34 91 7514487  |
   | Francois    | Fignon     |           | Director Oficina      | +33 14 723 4404 |
   | Hilary      | Washington |           | Director Oficina      | +1 215 837 0825 |
   | Nei         | Nishikori  |           | Director Oficina      | +81 33 224 5000 |
   | Amy         | Johnson    |           | Director Oficina      | +44 20 78772041 |
   | Kevin       | Fallmer    |           | Director Oficina      | +61 2 9264 2451 |
   +-------------+------------+-----------+-----------------------+-----------------+
   ```

     

7. Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.

   ```sql
   SELECT c.nombre_ciudad, COUNT(e.codigo_empleado) AS numero_empleados
   FROM empleado AS e
   INNER JOIN oficina AS o
   ON o.codigo_oficina = e.codigo_oficina
   INNER JOIN direccion AS d
   ON d.codigo_oficina = o.codigo_oficina
   INNER JOIN ciudad AS c
   ON c.codigo_ciudad = d.codigo_ciudad
   GROUP BY c.nombre_ciudad;
   
   +----------------------+------------------+
   | nombre_ciudad        | numero_empleados |
   +----------------------+------------------+
   | Barcelona            |                4 |
   | Boston               |                3 |
   | Londres              |                3 |
   | Madrid               |                4 |
   | Paris                |                3 |
   | San Francisco        |                2 |
   | Sydney               |                3 |
   | Talavera de la Reina |                6 |
   | Tokyo                |                3 |
   +----------------------+------------------+
   ```

   

#### Vistas

1. A

   ```sql
   
   ```

   

2. B

   ```sql
   
   ```

   

3. C

   ```sql
   
   ```

   

4. D

   ```sql
   
   ```

   

5. E

   ```sql
   
   ```

   

6. F

   ```sql
   
   ```

   

7. G

   ```sql
   
   ```

   

8. H

   ```sql
   
   ```

   

9. I

   ```sql
   
   ```

   

10. J

    ```sql
    
    ```

    

#### Procedimientos almacenados

1. A

   ```sql
   
   ```

   

2. B

   ```sql
   
   ```

   

3. C

   ```sql
   
   ```

   

4. D

   ```sql
   
   ```

   

5. E

   ```sql
   
   ```

   

6. F

   ```sql
   
   ```

   

7. G

   ```sql
   
   ```

   

8. H

   ```sql
   
   ```

   

9. I

   ```sql
   
   ```

   

10. J

    ```sql
    
    ```
