/*Mostrar las ventas de cada producto de la categoría deportes. Se debe de mostrar el
id del producto, nombre y monto*/

use proyecto1;

select P.id_producto,P.nombre,coalesce(SUM(O.cantidad*P.Precio),0) as monto_total from producto P
left join orden O  ON P.id_producto=O.id_producto
join categoria C ON P.id_categoria=C.id_categoria
where P.id_categoria=15
group by P.id_producto
order by monto_total asc;

