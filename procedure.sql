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