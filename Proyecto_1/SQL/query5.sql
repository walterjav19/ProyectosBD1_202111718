use proyecto1;
/*Top 5 de países que más han comprado en orden ascendente. Se le solicita mostrar
el id del país, nombre y monto total.
*/
select C.id_pais,Pa.nombre as Nombre_Pais,sum((O.cantidad*P.Precio)) as Monto_Total from orden O
join producto P ON O.id_producto=P.id_producto
join Cliente C ON O.id_cliente=C.id_cliente
join pais Pa on C.id_pais=Pa.id_pais
group by Pa.id_pais
order by Monto_Total ASC
LIMIT 5;

