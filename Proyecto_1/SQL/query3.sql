/*Mostrar a la persona que más ha vendido. Se debe mostrar el id del vendedor,
nombre del vendedor, monto total vendido*/
use proyecto1;

select V.id_vendedor,V.Nombre
,sum((O.cantidad*P.Precio)) as monto_total 
from vendedor V
join orden O on V.id_vendedor=O.id_vendedor
join producto P on P.id_producto=O.id_producto
group by V.id_vendedor,V.Nombre
order by monto_total desc
limit 1;






