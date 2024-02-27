use proyecto1;
/*Mostrar el producto más y menos comprado. Se debe mostrar el id del producto,
nombre del producto, categoría, cantidad de unidades y monto vendido.*/


(select producto.id_producto,producto.nombre,categoria.nombre as categoria,sum(orden.cantidad) as cantidad_unidades 
,sum(orden.cantidad*producto.precio) as monto_vendido from
orden 
join producto on orden.id_producto=producto.id_producto
join categoria on producto.id_categoria=categoria.id_categoria
group by producto.id_producto
order by cantidad_unidades desc
limit 1)
UNION
(select producto.id_producto,producto.nombre,categoria.nombre as categoria,COALESCE(sum(orden.cantidad),0) as cantidad_unidades 
,COALESCE(sum(orden.cantidad*producto.precio),0) as monto_vendido from
producto 
left join orden  on producto.id_producto=orden.id_producto
join categoria on producto.id_categoria=categoria.id_categoria
group by producto.id_producto,producto.nombre,categoria.nombre
order by cantidad_unidades asc, producto.nombre asc
limit 1)
;
#con una venta
(select producto.id_producto,producto.nombre,categoria.nombre as categoria,sum(orden.cantidad) as cantidad_unidades 
,sum(orden.cantidad*producto.precio) as monto_vendido from
orden 
join producto on orden.id_producto=producto.id_producto
join categoria on producto.id_categoria=categoria.id_categoria
group by producto.id_producto
order by cantidad_unidades desc
limit 1)
UNION
(select producto.id_producto,producto.nombre,categoria.nombre as categoria,COALESCE(sum(orden.cantidad),0) as cantidad_unidades 
,COALESCE(sum(orden.cantidad*producto.precio),0) as monto_vendido from
producto 
join orden  on producto.id_producto=orden.id_producto
join categoria on producto.id_categoria=categoria.id_categoria
group by producto.id_producto,producto.nombre,categoria.nombre
order by cantidad_unidades asc, producto.nombre asc,monto_vendido
limit 1);

