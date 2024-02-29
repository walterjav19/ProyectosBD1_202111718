/*Mostrar la categoría más comprada por cada país. Se debe de mostrar el nombre del
país, nombre de la categoría y cantidad de unidades*/

WITH CategoriasRank AS (
    SELECT
        Pa.nombre AS NombrePais,
        Cat.nombre AS NombreCategoria,
        SUM(O.cantidad) AS CantidadUnidades,
        ROW_NUMBER() OVER (PARTITION BY Pa.id_pais ORDER BY SUM(O.cantidad) DESC) AS RankCategoria
    FROM
        Orden O
    JOIN
        Producto P ON O.id_producto = P.id_producto
    JOIN
        Categoria Cat ON P.id_categoria = Cat.id_categoria
    JOIN
        Cliente Cli ON O.id_cliente = Cli.id_cliente
    JOIN
        Pais Pa ON Cli.id_pais = Pa.id_pais
    GROUP BY
        Cat.id_categoria, Pa.id_pais
)
SELECT
    NombrePais,
    NombreCategoria,
    CantidadUnidades
FROM
    CategoriasRank
WHERE
    RankCategoria = 1
ORDER BY
    CantidadUnidades DESC;


select 
Pa.nombre as Nombre_Pais,
Cat.nombre as Nombre_Categoria,
Sum(O.cantidad) as Cantidad_Unidades
from orden O
join producto P on O.id_producto=P.id_producto
join categoria Cat on P.id_categoria=Cat.id_categoria
join Cliente Cli on O.id_cliente=Cli.id_cliente
join Pais Pa on Cli.id_pais=Pa.id_pais
group by Cat.id_categoria,Pa.id_pais
ORDER BY Nombre_Pais,Cantidad_Unidades desc