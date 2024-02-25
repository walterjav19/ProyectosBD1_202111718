const { generarSeparacion, generarEncabezados, generarRegistros} = require('../Formatter/TableFormatter');
require('dotenv').config(); // Cargar variables de entorno desde .env
const mysql = require('mysql');
const csv = require('csv-parser');
const fs = require('fs');
const { parse, format } = require('date-fns');


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
                res.status(500).json({ message: 'Modelo ya existe' });
            }else{
                    
                    
                    connection.query(categoria, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Categoria', error });
                    } else {
                        console.log('**********************Creando modelo**********************')
                        console.log('- Tabla Categoria creada correctamente');
                    }
                });
            
                connection.query(pais, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Pais', error });
                    } else {
                        console.log('- Tabla Pais creada correctamente');
                    }
                });
            
                connection.query(producto, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Producto', error });
                    } else {
                        console.log('- Tabla Producto creada correctamente');
                    }
                });
            
                connection.query(vendedor, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Vendedor', error });
                    } else {
                        console.log('- Tabla Vendedor creada correctamente');
                    }
                });
            
                connection.query(cliente, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Cliente', error });
                    } else {
                        console.log('- Tabla Cliente creada correctamente');
                    }
                });
            
                connection.query(orden, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al crear Tabla Orden', error });
                    } else {
                        console.log('- Tabla Orden creada correctamente');
                        console.log('**********************************************************')
                    }
                });
               
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
                res.status(500).json({ message: 'Modelo a Borrar No existe' });
            }else{
                connection.query(orden, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Orden', error });
                    } else {
                        console.log('**********************Borrando modelo**********************')
                        console.log('- Tabla Orden borrada correctamente');
                    }
                });

                connection.query(cliente, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Cliente', error });
                    } else {
                        console.log('- Tabla Cliente borrada correctamente');
                    }
                });

                connection.query(vendedor, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Vendedor', error });
                    } else {
                        console.log('- Tabla Vendedor borrada correctamente');
                    }
                }); 

                connection.query(producto, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Producto', error });
                    } else {
                        console.log('- Tabla Producto borrada correctamente');
                    }
                });


                connection.query(pais, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Pais', error });
                    } else {
                        console.log('- Tabla Pais borrada correctamente');
                    }
                });


                connection.query(categoria, (error, result) => {
                    if (error) {
                        res.status(500).json({ message: 'Error al borrar Tabla Categoria', error });
                    } else {
                        console.log('- Tabla Categoria borrada correctamente');
                        console.log('**********************************************************')
                    }
                });
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

    try {
        await Promise.all([
            InsertarPaises(),
            InsertarCategorias(),
            InsertarProductos(),
            insertarClientes(), 
            InsertarVendedores(),
        ]);
        // esperar a que se inserten todo lo anterior con un delay de 500 milisegundo
        await new Promise((resolve) => setTimeout(resolve, 500));
        await insertarOrdenes();
        res.status(200).json({ message: 'Carga de Datos Hecha Correctamente' });
    } catch (error) {
        res.status(500).json({ message: 'Error al cargar datos', error: error.message });
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



module.exports={
    index,
    CreateModel,
    DeleteModel,
    CargaDatos
}