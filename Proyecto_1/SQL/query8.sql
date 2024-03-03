
/*Mostrar las ventas por mes de Inglaterra. Debe de mostrar el número del mes y el
monto.*/
use proyecto1; 

select 
month(O.fecha_orden) as Num_Mes,
monthname(O.fecha_orden) as Nombre_Mes, 
sum(O.cantidad*P.precio) as Monto_Total 
from orden O
join producto P on O.id_producto=P.id_producto
join Vendedor V on O.id_vendedor=V.id_vendedor
join Pais Pa on V.id_pais=Pa.id_pais
where Pa.id_pais=10
group by Num_Mes,Nombre_Mes;

#si la consulta fuese de compras por mes 
SELECT
    EXTRACT(MONTH FROM O.fecha_orden) AS NumeroMes,
    monthname(O.fecha_orden) as Nombre_Mes, 
    SUM(O.cantidad * P.Precio) AS Monto
FROM
    Orden O
JOIN
    Producto P ON O.id_producto = P.id_producto
JOIN
    Cliente C ON O.id_cliente = C.id_cliente
JOIN
    Pais Pa ON C.id_pais = Pa.id_pais
WHERE
    Pa.nombre = 'Inglaterra'
GROUP BY
    NumeroMes,Nombre_Mes
ORDER BY
    NumeroMes;


