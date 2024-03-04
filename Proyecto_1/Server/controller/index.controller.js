const { generarSeparacion, generarEncabezados, generarRegistros} = require('../Formatter/TableFormatter');
require('dotenv').config(); // Cargar variables de entorno desde .env
const mysql = require('mysql');
const csv = require('csv-parser');
const fs = require('fs');
const { parse, format } = require('date-fns');
const { query } = require('express');

let Aux_Table=false;
let Aux_Insercion=false;
const connection=mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE
});

connection.connect(error=>{
    if(error) throw error;
    console.log('Conexion exitosa a la base de datos');
});



const index = (req, res) =>{
   
    res.status(200).json({message: 'Api Funcionando'});
}


//peticion 12
const CreateModel = (req, res) => {
    // Scripts SQL
    const categoria = `
    CREATE TABLE Categoria (
    id_categoria INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
    );
    `;

    const pais=`
    Create Table Pais(
        id_pais integer primary key,
        nombre varchar(100) not null
        );`
    
    const producto=`Create Table Producto(
        id_producto integer primary key,
        Nombre varchar(100) not null,
        Precio decimal(10,2) not null,
        id_categoria integer not null,
        FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
        );`

    const vendedor=`Create Table Vendedor(
        id_vendedor integer primary key,
        Nombre  varchar(100) not null,
        id_pais integer not null,
        FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
        );`
    
    const cliente=`Create Table Cliente(
        id_cliente integer primary key,
        Nombre  varchar(100) not null,
        Apellido  varchar(100) not null,
        Direccion  varchar(100) not null,
        Telefono  BIGINT not null,
        Tarjeta  BIGINT not null,
        Edad  integer not null,
        Salario Integer NOT NULL,
        Genero char(1) not null,
        id_pais integer not null,
        FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
        );`
    
    const orden=`Create Table Orden(
        id_orden Integer,
        linea_orden Integer,
        fecha_orden Date Not null,
        id_cliente Integer Not Null,
        id_vendedor Integer Not Null,
        id_producto Integer Not null,
        cantidad Integer Not null,
        FOREIGN KEY (id_cliente ) REFERENCES  Cliente(id_cliente),
        FOREIGN KEY (id_vendedor) REFERENCES  Vendedor(id_vendedor),
        FOREIGN KEY (id_producto) REFERENCES  Producto(id_producto),
        primary key (id_orden,linea_orden)
        );`
    
    
    // comprobar si hay tablas
    connection.query('SHOW TABLES', (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al comprobar si hay tablas', error });
        } else {
            if(result.length>0){
                console.log('**************************************')
                console.log('*                                    *')
                console.log('*         Modelo ya existe           *');
                console.log('*                                    *')
                console.log('**************************************')
                res.status(500).json({ message: 'Modelo ya existe' });
            }else{
                    
                    
                    connection.query(categoria, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Categoria', error });
                    } else {
                        console.log('****************Creando modelo****************')
                        console.log('*                                            *')
                        console.log('*   - Tabla Categoria creada correctamente   *');
                    }
                });
            
                connection.query(pais, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Pais', error });
                    } else {
                        console.log('*   - Tabla Pais creada correctamente        *');
                    }
                });
            
                connection.query(producto, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Producto', error });
                    } else {
                        console.log('*   - Tabla Producto creada correctamente    *');
                    }
                });
            
                connection.query(vendedor, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Vendedor', error });
                    } else {
                        console.log('*   - Tabla Vendedor creada correctamente    *');
                    }
                });
            
                connection.query(cliente, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Cliente', error });
                    } else {
                        console.log('*   - Tabla Cliente creada correctamente     *');
                    }
                });
            
                connection.query(orden, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Orden', error });
                    } else {
                        console.log('*   - Tabla Orden creada correctamente       *');
                        console.log('*                                            *');
                        console.log('**********************************************')
                    }
                });
                Aux_Table=true;
                res.status(200).json({ message: 'Modelo creado correctamente' });
            }
        }
    });

    
};

//peticion 11
const DeleteModel = (req, res) => {
    // Scripts SQL
    const categoria = `DROP TABLE Categoria;`;
    const pais = `DROP TABLE Pais;`;
    const producto = `DROP TABLE Producto;`;
    const vendedor = `DROP TABLE Vendedor;`;
    const cliente = `DROP TABLE Cliente;`;
    const orden = `DROP TABLE Orden;`;

    connection.query('SHOW TABLES', (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al comprobar si hay tablas', error });
        } else {
            if(result.length==0){
                console.log('**************************************')
                console.log('*                                    *')
                console.log('*         Modelo no existe           *');
                console.log('*                                    *')
                console.log('**************************************')
                res.status(500).json({ message: 'Modelo a Borrar No existe' });
            }else{
                connection.query(orden, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Orden', error });
                    } else {
                        console.log('**************Borrando modelo*****************')
                        console.log('*                                            *')
                        console.log('*   - Tabla Orden borrada correctamente      *');
                    }
                });

                connection.query(cliente, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Cliente', error });
                    } else {
                        console.log('*   - Tabla Cliente borrada correctamente    *');
                    }
                });

                connection.query(vendedor, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Vendedor', error });
                    } else {
                        console.log('*   - Tabla Vendedor borrada correctamente   *');
                    }
                }); 

                connection.query(producto, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Producto', error });
                    } else {
                        console.log('*   - Tabla Producto borrada correctamente   *');
                    }
                });


                connection.query(pais, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Pais', error });
                    } else {
                        console.log('*   - Tabla Pais borrada correctamente       *');
                    }
                });


                connection.query(categoria, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Categoria', error });
                    } else {
                        console.log('*   - Tabla Categoria borrada correctamente  *');
                        console.log('*                                            *');
                        console.log('**********************************************')
                    }
                });
                Aux_Table=false;
                Aux_Insercion=false;
                res.status(200).json({ message: 'Modelo borrado correctamente' });
            }
        }
    });

    
};


async function  insertarEnLotesOrden(rows) {
    connection.beginTransaction((err) => {
        if (err) throw err;
        connection.query('INSERT INTO Orden (id_orden, linea_orden, fecha_orden, id_cliente, id_vendedor, id_producto, cantidad) VALUES ?', [rows], (error, results, fields) => {
            if (error) {
                return connection.rollback(() => {
                    throw error;
                });
            }
            connection.commit((err) => {
                if (err) {
                    return connection.rollback(() => {
                        throw err;
                    });
                }
            });
        });
    });
}


async function  insertarEnLotesCliente(rows) {
    connection.beginTransaction((err) => {
        if (err) throw err;
        connection.query('INSERT INTO Cliente (id_cliente,Nombre,Apellido,Direccion,Telefono,Tarjeta,Edad,Salario,Genero,id_pais) VALUES ?', [rows], (error, results, fields) => {
            if (error) {
                return connection.rollback(() => {
                    throw error;
                });
            }
            connection.commit((err) => {
                if (err) {
                    return connection.rollback(() => {
                        throw err;
                    });
                }
            });
        });
    });
}

async function  insertarEnLotesProductos(rows) {
    connection.beginTransaction((err) => {
        if (err) throw err;
        connection.query('INSERT INTO Producto (id_producto,Nombre,Precio,id_categoria) VALUES ?', [rows], (error, results, fields) => {
            if (error) {
                return connection.rollback(() => {
                    throw error;
                });
            }
            connection.commit((err) => {
                if (err) {
                    return connection.rollback(() => {
                        throw err;
                    });
                }
            });
        });
    });
}

const insertarClientes = async () => {
    return new Promise((resolve, reject) => {
        let rows = [];
        fs.createReadStream('Data/clientes.csv')
            .pipe(csv({ separator: ';', mapHeaders: ({ header, index }) => header.trim() }))
            .on('data', (row) => {
                rows.push([Number(row.id_cliente), row.Nombre, row.Apellido, row.Direccion, Number(row.Telefono),Number(row.Tarjeta), Number(row.Edad), Number(row.Salario), row.Genero, Number(row.id_pais)]);
                if (rows.length >= 1000) { // Insertar en lotes de 1000 filas
                    insertarEnLotesCliente(rows).then(resolve).catch(reject);
                    rows = [];
                }
            })
            .on('end', () => {
                if (rows.length > 0) {
                    insertarEnLotesCliente(rows).then(resolve).catch(reject);
                } else {
                    resolve();
                }
            });
    });
};



const insertarOrdenes = async () => {
    return new Promise((resolve, reject) => {
        let rows = [];
        fs.createReadStream('Data/ordenes.csv')
            .pipe(csv({ separator: ';', mapHeaders: ({ header, index }) => header.trim() }))
            .on('data', (row) => {
                rows.push([Number(row.id_orden), Number(row.linea_orden), ModificarFormatoFecha(row.fecha_orden), Number(row.id_cliente), Number(row.id_vendedor), Number(row.id_producto), Number(row.cantidad)]);
                if (rows.length >= 1000) { // Insertar en lotes de 1000 filas
                    insertarEnLotesOrden(rows).then(resolve).catch(reject);
                    rows = [];
                }
            })
            .on('end', () => {
                if (rows.length > 0) {
                    insertarEnLotesOrden(rows).then(resolve).catch(reject);
                } else {
                    resolve();
                }
            });
    });
};

const InsertarProductos=async()=>{
    return new Promise((resolve, reject) => {
        let rows = [];
        fs.createReadStream('Data/productos.csv')
            .pipe(csv({ separator: ';', mapHeaders: ({ header, index }) => header.trim() }))
            .on('data', (row) => {
                rows.push([Number(row.id_producto), row.Nombre, Number(row.Precio), Number(row.id_categoria)]);
                if (rows.length >= 1000) { // Insertar en lotes de 1000 filas
                    insertarEnLotesProductos(rows).then(resolve).catch(reject);
                    rows = [];
                }
            })
            .on('end', () => {
                if (rows.length > 0) {
                    insertarEnLotesProductos(rows).then(resolve).catch(reject);
                } else {
                    resolve();
                }
            });
    });
}

const InsertarCategorias=async()=>{
    return new Promise((resolve, reject) => {
        fs.createReadStream('Data/categorias.csv')
            .pipe(csv({ separator: ';', mapHeaders: ({ header, index }) => header.trim() }))
            .on('data', (row) => {
                connection.query('INSERT INTO Categoria (id_categoria, nombre) VALUES (?, ?)', [Number(row.id_categoria), row.nombre], (error, results, fields) => {
                    if (error) {
                        reject(error);
                    }else{
                        resolve();
                    }
                });
            })
            .on('end', () => {
                resolve();
            });
    });

}

const InsertarPaises=async()=>{
    return new Promise((resolve, reject) => {
        fs.createReadStream('Data/paises.csv')
        .pipe(csv({ separator: ';', mapHeaders: ({ header, index }) => header.trim() }))
        .on('data', (row) => {
            connection.query('INSERT INTO Pais (id_pais, nombre) VALUES (?, ?)', [Number(row.id_pais), row.nombre], (error, results, fields) => {
                if (error) {
                    reject(error);
                }else{
                    resolve();
                }
            });
        }).on('end', () => {   
            resolve();
        });
    });
}

const InsertarVendedores=async()=>{
    return new Promise((resolve, reject) => {
        fs.createReadStream('Data/vendedores.csv')
        .pipe(csv({ separator: ';', mapHeaders: ({ header, index }) => header.trim() }))
        .on('data', (row) => {
            connection.query('INSERT INTO Vendedor (id_vendedor, nombre, id_pais) VALUES (?, ?, ?)', [Number(row.id_vendedor), row.nombre, Number(row.id_pais)], (error, results, fields) => {
                if (error) {
                    reject(error);
                }else{
                    resolve();
                }
            });
        }).on('end', () => {   
            resolve();
        });
    });
}

const CargaDatos=async(req,res)=>{
    
    if(Aux_Table && !Aux_Insercion){
        try {
            await Promise.all([
                InsertarPaises(),
                InsertarCategorias(),
                InsertarProductos(),
                insertarClientes(), 
                InsertarVendedores(),
            ]);
            // esperar a que se inserten todo lo anterior con un delay de 800 milisegundo
            await new Promise((resolve) => setTimeout(resolve, 800));
            await insertarOrdenes();
            Aux_Insercion=true;
            console.log('**************************************')
            console.log('*                                    *')
            console.log('* Carga de Datos Hecha Correctamente *');
            console.log('*                                    *')
            console.log('**************************************')
            res.status(200).json({ message: 'Carga de Datos Hecha Correctamente' });
        } catch (error) {
            res.status(500).json({ message: 'Error al cargar datos', error: error.message });
        }
    }else if(Aux_Table && Aux_Insercion){
        console.log('**************************************')
        console.log('*                                    *')
        console.log('*         Datos ya cargados          *');
        console.log('*                                    *')
        console.log('**************************************')
        res.status(500).json({ message: 'Datos ya cargados' });
    }else if(!Aux_Table){
        console.log('**************************************')
        console.log('*                                    *')
        console.log('*         Modelo no existe           *');
        console.log('*                                    *')
        console.log('**************************************')
        res.status(500).json({ message: 'Modelo donde Insertar Inexistente' });
    }
    

    
}

const ModificarFormatoFecha=(fecha)=>{
    //DD/MM/YYYY 27/01/2004 a YYYY-MM-DD 2004-01-27
    // Parsear la fecha del formato 'DD/MM/YYYY'
    const fechaParseada = parse(fecha, 'dd/MM/yyyy', new Date());

    // Formatear la fecha al formato 'YYYY-MM-DD'
    const fechaFormateada = format(fechaParseada, 'yyyy-MM-dd');

    return fechaFormateada;

}

const BorrarInfo = (req, res) => {
    const queries = [
        'TRUNCATE TABLE Orden;',
        'SET FOREIGN_KEY_CHECKS = 0;',
        'TRUNCATE TABLE Cliente;',
        'TRUNCATE TABLE Producto;',
        'TRUNCATE TABLE Vendedor;',
        'TRUNCATE TABLE Pais;',
        'TRUNCATE TABLE Categoria;',
        'SET FOREIGN_KEY_CHECKS = 1;'
    ];
    let existserror = false;
    let error_info = false;
    for(query of queries){
        connection.query(query, (error, result) => {
            if (error) {
                existserror = true;
                error_info = error;
                
            }
        });
    }
    Aux_Insercion=false;
    if(existserror){
        res.status(500).json({ message: 'Error al borrar datos' ,error_info:error_info});
    }
    else if(Aux_Table==false){
        console.log('**************************************')
        console.log('*                                    *')
        console.log('*         Modelo no existe           *');
        console.log('*                                    *')
        console.log('**************************************')
        res.status(500).json({ message: 'Modelo donde Borrar Inexistente' });
    }else{
        console.log('**************************************')
        console.log('*                                    *')
        console.log('*            Datos Borrados          *');
        console.log('*                                    *')
        console.log('**************************************')
        res.status(200).json({ message: 'Datos Borrados Correctamente' });
    }
};

/*Mostrar el cliente que más ha comprado. Se debe de mostrar el id del cliente,
nombre, apellido, país y monto total*/
const Consulta1 = (req, res) => {
    query=`SELECT cliente.id_cliente, cliente.Nombre,cliente.apellido,pais.nombre as Pais,sum((orden.cantidad*producto.precio)) as monto_total
    FROM cliente
    JOIN orden ON cliente.id_cliente = orden.id_cliente
    join pais ON cliente.id_pais=pais.id_pais
    join producto on orden.id_producto=producto.id_producto
    group by cliente.id_cliente
    order by monto_total desc
    limit 1
    ;
    `

    connection.query(query, (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 1', result });
        }
    });

    
}

/*Mostrar el producto más y menos comprado. Se debe mostrar el id del producto,
nombre del producto, categoría, cantidad de unidades y monto vendido.*/
const Consulta2 = (req, res) => {
    const query=`(select producto.id_producto,producto.nombre,categoria.nombre as categoria,sum(orden.cantidad) as cantidad_unidades 
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
    ;`

    connection.query(query, (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 2', result });
        }
    });


}
/*Mostrar a la persona que más ha vendido. Se debe mostrar el id del vendedor,
nombre del vendedor, monto total vendido*/
const Consulta3 = (req, res) => {
    const query=`
    select V.id_vendedor,V.Nombre
    ,sum((O.cantidad*P.Precio)) as monto_total 
    from vendedor V
    join orden O on V.id_vendedor=O.id_vendedor
    join producto P on P.id_producto=O.id_producto
    group by V.id_vendedor
    order by monto_total desc
    limit 1;
    `
    connection.query(query, (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 3', result });
        }
    });
};

/*Mostrar el país que más y menos ha vendido. Debe mostrar el nombre del país y el
monto. (Una sola consulta).*/

const Consulta4=(req,res)=>{
    const query=`(select 
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
        limit 1);`
    connection.query(query, (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 4', result });
        }
    });
}

/*Top 5 de países que más han comprado en orden ascendente. Se le solicita mostrar
el id del país, nombre y monto total.
*/
const Consulta5=(req,res)=>{
    const query=`select C.id_pais,Pa.nombre as Nombre_Pais,sum((O.cantidad*P.Precio)) as Monto_Total from orden O
    join producto P ON O.id_producto=P.id_producto
    join Cliente C ON O.id_cliente=C.id_cliente
    join pais Pa on C.id_pais=Pa.id_pais
    group by Pa.id_pais
    order by Monto_Total ASC
    LIMIT 5;
    `

    connection.query(query, (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 5', result });
        }
    });
}


/*Mostrar la categoría que más y menos se ha comprado. Debe de mostrar el nombre
de la categoría y cantidad de unidades. (Una sola consulta)*/
const Consulta6=(req,res)=>{
    const query=`(select
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
        limit 1);`
        connection.query(query, (error, result) => {
            if (error) {
                res.status(500).json({ message: 'Error al realizar la consulta', error });
            } else {
                res.status(200).json({ message: 'Consulta 6', result });
            }
        });
}


/*Mostrar la categoría más comprada por cada país. Se debe de mostrar el nombre del
país, nombre de la categoría y cantidad de unidades*/
const Consulta7=(req,res)=>{
    const query=`WITH CategoriasRank AS (
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
        CantidadUnidades DESC;`
    connection.query(query, (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 7', result });
        }
    });
}

/*Mostrar las ventas por mes de Inglaterra. Debe de mostrar el número del mes y el
monto.*/
const Consulta8=(req,res)=>{
    const query=`select 
    month(O.fecha_orden) as Num_Mes,
    monthname(O.fecha_orden) as Nombre_Mes, 
    sum(O.cantidad*P.precio) as Monto_Total 
    from orden O
    join producto P on O.id_producto=P.id_producto
    join Vendedor V on O.id_vendedor=V.id_vendedor
    join Pais Pa on V.id_pais=Pa.id_pais
    where Pa.id_pais=10
    group by Num_Mes,Nombre_Mes;`


    connection.query(query, (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 8', result });
        }
    });
}

/*Mostrar el mes con más y menos ventas. Se debe de mostrar el número de mes y
monto. (Una sola consulta).*/

const Consulta9=(req,res)=>{  
    const query=`(select month(O.fecha_orden) as Num_Mes,
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
    limit 1);`

    connection.query(query, (error, result) => {   
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 9', result });
        }
     });
 }

/*Mostrar las ventas de cada producto de la categoría deportes. Se debe de mostrar el
id del producto, nombre y monto*/
 const Consulta10=(req,res)=>{
    const query=`select P.id_producto,P.nombre,coalesce(SUM(O.cantidad*P.Precio),0) as monto_total from producto P
    left join orden O  ON P.id_producto=O.id_producto
    join categoria C ON P.id_categoria=C.id_categoria
    where P.id_categoria=15
    group by P.id_producto
    order by monto_total asc;`
    connection.query(query, (error, result) => {
        if (error) {
            res.status(500).json({ message: 'Error al realizar la consulta', error });
        } else {
            res.status(200).json({ message: 'Consulta 10', result });
        }
    });
}


module.exports={
    index,
    CreateModel,
    DeleteModel,
    CargaDatos,
    BorrarInfo,
    Consulta1,
    Consulta2,
    Consulta3,
    Consulta4,
    Consulta5,
    Consulta6,
    Consulta7,
    Consulta8,
    Consulta9,
    Consulta10
}