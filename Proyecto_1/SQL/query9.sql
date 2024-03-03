/*Mostrar el mes con más y menos ventas. Se debe de mostrar el número de mes y
monto. (Una sola consulta).*/
use proyecto1;
(select month(O.fecha_orden) as Num_Mes,
monthname(O.fecha_orden) as Nombre_Mes, 
sum(O.cantidad*P.precio) as Monto_Total 
from orden O
join producto P on O.id_producto=P.id_producto
join Vendedor V on O.id_vendedor=V.id_vendedor
join Pais Pa on V.id_pais=Pa.id_pais
group by Num_Mes,Nombre_Mes
order by Monto_Total desc
limit 1)
union
(select month(O.fecha_orden) as Num_Mes,
monthname(O.fecha_orden) as Nombre_Mes, 
sum(O.cantidad*P.precio) as Monto_Total 
from orden O
join producto P on O.id_producto=P.id_producto
join Vendedor V on O.id_vendedor=V.id_vendedor
join Pais Pa on V.id_pais=Pa.id_pais
group by Num_Mes,Nombre_Mes
order by Monto_Total asc
limit 1);


