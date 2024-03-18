/*Mostrar las ventas de cada producto de la categoría deportes. Se debe de mostrar el
id del producto, nombre y monto*/

use proyecto1;

    SELECT 
        P.id_producto,
        P.nombre,
        COALESCE(SUM(O.cantidad * P.Precio), 0) AS monto_total 
    FROM 
        Orden O 
    JOIN 
        producto P ON O.id_producto = P.id_producto 
    JOIN 
        categoria C ON C.id_categoria = P.id_categoria 
    WHERE 
        P.id_categoria = 15 
    GROUP BY 
        P.id_producto
	order by monto_total 
