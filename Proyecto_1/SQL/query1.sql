/*Mostrar el cliente que más ha comprado. Se debe de mostrar el id del cliente,
nombre, apellido, país y monto total*/
use proyecto1;

SELECT cliente.id_cliente, cliente.Nombre,cliente.apellido,pais.nombre as Pais,sum((orden.cantidad*producto.precio)) as monto_total
FROM cliente
JOIN orden ON cliente.id_cliente = orden.id_cliente
join pais ON cliente.id_pais=pais.id_pais
join producto on orden.id_producto=producto.id_producto
group by cliente.id_cliente
order by monto_total desc
limit 1
;


