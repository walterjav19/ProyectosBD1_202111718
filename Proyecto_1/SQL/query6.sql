use proyecto1;
/*Mostrar la categoría que más y menos se ha comprado. Debe de mostrar el nombre
de la categoría y cantidad de unidades. (Una sola consulta)*/

(select
C.Nombre as Nombre_Categoria, 
sum(O.Cantidad) as Unidades_Vendidas
from orden O
join producto P on O.id_producto=P.id_producto
join Categoria C on C.id_categoria=P.id_categoria
group by C.id_categoria
order by Unidades_Vendidas DESC
limit 1)
Union
(select
C.Nombre as Nombre_Categoria, 
sum(O.Cantidad) as Unidades_Vendidas
from orden O
join producto P on O.id_producto=P.id_producto
join Categoria C on C.id_categoria=P.id_categoria
group by C.id_categoria
order by Unidades_Vendidas asc
limit 1);

