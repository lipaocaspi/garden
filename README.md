# gardenDB

#### Normalización

#### Creación BD

```sql
-- -----------------------------------------------------
-- gama_producto
-- -----------------------------------------------------
CREATE TABLE gama_producto (
  gama VARCHAR(50) NOT NULL,
  descripcion_texto TEXT NULL,
  descripcion_html TEXT NULL,
  imagen VARCHAR(256) NULL,
  CONSTRAINT PK_gama_producto PRIMARY KEY (gama)
);

-- -----------------------------------------------------
-- dimension
-- -----------------------------------------------------
/* 1FN */
CREATE TABLE dimension (
  codigo_dimension INT(10) NOT NULL,
  alto DECIMAL(15,2) NULL,
  ancho DECIMAL(15,2) NULL,
  largo DECIMAL(15,2) NULL,
  CONSTRAINT PK_dimension PRIMARY KEY (codigo_dimension)
);

-- -----------------------------------------------------
-- proveedor
-- -----------------------------------------------------
/* 1FN, 2FN */
CREATE TABLE proveedor (
  codigo_proveedor INT(11) NOT NULL,
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
  descripcion TEXT NULL,
  cantidad_en_stock SMALLINT(6) NOT NULL,
  precio_venta DECIMAL(15,2) NOT NULL,
  precio_proveedor DECIMAL(15,2) NULL,
  codigo_dimension INT(10) NULL,
  codigo_proveedor INT(11) NULL,
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
  codigo_pais INT(10) NOT NULL,
  nombre_pais VARCHAR(50) NOT NULL,
  CONSTRAINT PK_pais PRIMARY KEY (codigo_pais)
);

-- -----------------------------------------------------
-- region
-- -----------------------------------------------------
/* 1FN */
CREATE TABLE region (
  codigo_region INT(10) NOT NULL,
  nombre_region VARCHAR(50) NOT NULL,
  codigo_pais INT(10) NOT NULL,
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
  codigo_ciudad INT(10) NOT NULL,
  nombre_ciudad VARCHAR(50) NOT NULL,
  codigo_region INT(10) NOT NULL,
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
  codigo_tipo INT(10) NOT NULL,
  nombre_tipo VARCHAR(30) NOT NULL,
  CONSTRAINT PK_tipo_direccion PRIMARY KEY (codigo_tipo)
);

-- -----------------------------------------------------
-- direccion
-- -----------------------------------------------------
/* 1FN, 2FN, 3FN y 4FN */
CREATE TABLE direccion (
  codigo_direccion INT(10) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50) NULL,
  codigo_postal VARCHAR(10) NULL,
  codigo_ciudad INT(10) NOT NULL,
  codigo_tipo INT(10) NOT NULL,
  codigo_cliente INT(11) NULL,
  codigo_oficina VARCHAR(10) NULL,
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
  codigo_puesto INT(10) NOT NULL,
  nombre_puesto VARCHAR(50) NOT NULL,
  CONSTRAINT PK_puesto PRIMARY KEY (codigo_puesto)
);

-- -----------------------------------------------------
-- extension
-- -----------------------------------------------------
/* 1FN */
CREATE TABLE extension (
  codigo_extension INT(10) NOT NULL,
  numero_extension VARCHAR(10) NOT NULL,
  CONSTRAINT PK_extension PRIMARY KEY (codigo_extension)
);

-- -----------------------------------------------------
-- empleado
-- -----------------------------------------------------
/* 1FN, 2FN, 3FN y 4FN */
CREATE TABLE empleado (
  codigo_empleado INT(11) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50) NULL,
  email VARCHAR(100) NOT NULL,
  codigo_oficina VARCHAR(10) NULL,
  codigo_jefe INT(11) NULL,
  codigo_puesto INT(10) NOT NULL,
  codigo_extension INT(10) NOT NULL,
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
  codigo_cliente INT(11) NOT NULL,
  nombre_cliente VARCHAR(50) NOT NULL,
  codigo_empleado_rep_ventas INT(11) NULL,
  limite_credito DECIMAL(15,2) NULL,
  CONSTRAINT PK_cliente PRIMARY KEY (codigo_cliente),
  CONSTRAINT FK_cliente_empleado
    FOREIGN KEY (codigo_empleado_rep_ventas)
    REFERENCES empleado(codigo_empleado)
);

-- -----------------------------------------------------
-- estado
-- -----------------------------------------------------
/* 1FN */
CREATE TABLE estado (
  codigo_estado INT(10) NOT NULL,
  nombre_estado VARCHAR(15) NOT NULL,
  CONSTRAINT PK_estado PRIMARY KEY (codigo_estado)
);

-- -----------------------------------------------------
-- pedido
-- -----------------------------------------------------
/* 1FN */
CREATE TABLE pedido (
  codigo_pedido INT(11) NOT NULL,
  fecha_pedido DATE NOT NULL,
  fecha_esperada DATE NOT NULL,
  fecha_entrega DATE NULL,
  comentarios TEXT NULL,
  codigo_cliente INT(11) NOT NULL,
  codigo_estado INT(10) NOT NULL,
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
  pedido_codigo_pedido INT(11) NOT NULL,
  producto_codigo_producto VARCHAR(15) NOT NULL,
  cantidad INT(11) NOT NULL,
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
  codigo_forma INT(10) NOT NULL,
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
  codigo_cliente INT(11) NOT NULL,
  codigo_forma INT(10) NOT NULL,
  CONSTRAINT PK_ pago PRIMARY KEY (id_transaccion),
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
  codigo_tipo INT(10) NOT NULL,
  nombre_tipo VARCHAR(20) NOT NULL,
  CONSTRAINT PK_tipo_telefono PRIMARY KEY (codigo_tipo)
);

-- -----------------------------------------------------
-- telefono
-- -----------------------------------------------------
/* 1FN */
CREATE TABLE telefono (
  codigo_telefono INT(10) NOT NULL,
  numero_telefono VARCHAR(15) NOT NULL,
  codigo_tipo INT(10) NOT NULL,
  codigo_oficina VARCHAR(10) NOT NULL,
  CONSTRAINT PK_telefono PRIMARY KEY (codigo_telefono),
  CONSTRAINT FK_telefono_tipo_telefono
    FOREIGN KEY (codigo_tipo)
    REFERENCES tipo_telefono(codigo_tipo),
  CONSTRAINT FK_telefono_oficina
    FOREIGN KEY (codigo_oficina)
    REFERENCES oficina(codigo_oficina)
);

-- -----------------------------------------------------
-- contacto
-- -----------------------------------------------------
/* 1FN, 2FN, 3FN */
CREATE TABLE contacto (
  codigo_contacto INT(11) NOT NULL,
  nombre_contacto VARCHAR(30) NULL,
  apellido_contacto VARCHAR(30) NULL,
  telefono VARCHAR(15) NOT NULL,
  fax VARCHAR(15) NOT NULL,
  codigo_cliente INT(11) NOT NULL,
  CONSTRAINT PK_contacto PRIMARY KEY (codigo_contacto),
  CONSTRAINT FK_contacto_cliente
    FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo_cliente)
);
```



#### Inserción de datos

```sql

```



#### Consultas SQL

##### Consultas sobre una tabla

1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

   ```sql
   
   ```

   

2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

   ```sql
   
   ```

   

3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.

   ```sql
   
   ```

   

4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.

   ```sql
   
   ```

   

5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.

   ```sql
   
   ```

   

6. Devuelve un listado con el nombre de los todos los clientes españoles.

   ```sql
   
   ```

   

7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.

   ```sql
   
   ```

   

8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
   • Utilizando la función YEAR de MySQL.

   ```sql
   
   ```

   • Utilizando la función DATE_FORMAT de MySQL.

   ```sql
   
   ```

   • Sin utilizar ninguna de las funciones anteriores.

   ```sql
   
   ```

   

9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.

   ```sql
   
   ```

   

10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
    • Utilizando la función ADDDATE de MySQL.

    ```sql
    
    ```

    • Utilizando la función DATEDIFF de MySQL.

    ```sql
    
    ```

    • ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?

    ```sql
    
    ```

    

11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.

    ```sql
    
    ```

    

12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.

    ```sql
    
    ```

    

13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.

    ```sql
    
    ```

    

14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.

    ```sql
    
    ```

    

15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.

    ```sql
    
    ```

    

16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.

    ```sql
    
    ```

    

##### Consultas multitabla (Composición interna)

1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

   ```sql
   
   ```

   

2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.

  ```sql
  
  ```

  

3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.

  ```sql
  
  ```

  

4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

  ```sql
  
  ```

  

5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

  ```sql
  
  ```

  

6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.

  ```sql
  
  ```

  

7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

  ```sql
  
  ```

  

8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.

  ```sql
  
  ```

  

9. Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe.

  ```sql
  
  ```

  

10. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.

  ```sql
  
  ```

  

11. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.

   ```sql
   
   ```

   

##### Consultas multitabla (Composición externa)

1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

   ```sql
   
   ```

   

2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.

  ```sql
  
  ```


3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.

  ```sql
  
  ```


4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.

  ```sql
  
  ```


5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.

  ```sql
  
  ```


6. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.

  ```sql
  
  ```


7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.

  ```sql
  
  ```


8. Devuelve un listado de los productos que nunca han aparecido en un pedido.

  ```sql
  
  ```

  

9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.

  ```sql
  
  ```


10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

    ```sql
    
    ```

11. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

    ```sql
    
    ```

12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.

    ```sql
    
    ```

    

##### Consultas resumen

1. ¿Cuántos empleados hay en la compañía?

   ```sql
   
   ```

   

2. ¿Cuántos clientes tiene cada país?

   ```sql
   
   ```

3. ¿Cuál fue el pago medio en 2009?

   ```sql
   
   ```

4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.

  ```sql
  
  ```


5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.

  ```sql
  
  ```


6. Calcula el número de clientes que tiene la empresa.

   ```sql
   
   ```

7. ¿Cuántos clientes existen con domicilio en la ciudad de Madrid?

   ```sql
   
   ```

8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?

  ```sql
  
  ```


9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.

  ```sql
  
  ```


10. Calcula el número de clientes que no tiene asignado representante de ventas.

    ```sql
    
    ```

11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.

    ```sql
    
    ```

    

12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.

    ```sql
    
    ```

13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.

    ```sql
    
    ```

14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.

    ```sql
    
    ```

15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.

    ```sql
    
    ```

16. La misma información que en la pregunta anterior, pero agrupada por código de producto.

    ```sql
    
    ```

17. La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.

    ```sql
    
    ```

18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA).

    ```sql
    
    ```

19. Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos.

    ```sql
    
    ```

    

##### Subconsultas

###### Con operadores básicos de comparación

1. Devuelve el nombre del cliente con mayor límite de crédito.

   ```sql
   
   ```

   

2. Devuelve el nombre del producto que tenga el precio de venta más caro.

   ```sql
   
   ```

3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido).

  ```sql
  
  ```

  

4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).

  ```sql
  
  ```


5. Devuelve el producto que más unidades tiene en stock.

   ```sql
   
   ```

6. Devuelve el producto que menos unidades tiene en stock.

   ```sql
   
   ```

7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.

  ```sql
  
  ```

  

###### Subconsultas con ALL y ANY

8. Devuelve el nombre del cliente con mayor límite de crédito.

   ```sql
   
   ```

   

9. Devuelve el nombre del producto que tenga el precio de venta más caro.

   ```sql
   
   ```

   

10. Devuelve el producto que menos unidades tiene en stock.

    ```sql
    
    ```

    

###### Subconsultas con IN y NOT IN

11. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.

    ```sql
    
    ```

    

12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

    ```sql
    
    ```

13. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

    ```sql
    
    ```

14. Devuelve un listado de los productos que nunca han aparecido en un pedido.

    ```sql
    
    ```

15. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.

    ```sql
    
    ```

16. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

    ```sql
    
    ```

17. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

    ```sql
    
    ```

    

###### Subconsultas con EXISTS y NOT EXISTS

18. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

    ```sql
    
    ```

    

19. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

    ```sql
    
    ```

20. Devuelve un listado de los productos que nunca han aparecido en un pedido.

    ```sql
    
    ```

21. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.

    ```sql
    
    ```

    

##### Consultas variadas

1. Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido.

   ```sql
   
   ```

   

2. Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.

  ```sql
  
  ```


3. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor.

  ```sql
  
  ```


4. Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.

  ```sql
  
  ```


5. Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante de ventas y la ciudad donde está su oficina.

  ```sql
  
  ```


6. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.

  ```sql
  
  ```

  

7. Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.

  ```sql
  
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
