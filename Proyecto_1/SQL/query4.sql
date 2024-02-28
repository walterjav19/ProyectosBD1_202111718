use proyecto1;
/*Mostrar el país que más y menos ha vendido. Debe mostrar el nombre del país y el
monto. (Una sola consulta).*/

(select 
Pa.nombre as Nombre_Pais,
sum((O.cantidad*P.precio)) as Monto_Total
from Orden O
join Producto  P on O.id_producto=P.id_producto
join vendedor V on  O.id_vendedor=V.id_vendedor
join pais Pa on V.id_pais=Pa.id_pais
group by V.id_pais
order by Monto_Total desc
limit 1)
UNION
(select 
Pa.nombre,
sum((O.cantidad*P.precio)) as Monto_Total
from Orden O
join Producto  P on O.id_producto=P.id_producto
join vendedor V on  O.id_vendedor=V.id_vendedor
join pais Pa on V.id_pais=Pa.id_pais
group by V.id_pais
order by Monto_Total asc
limit 1);
