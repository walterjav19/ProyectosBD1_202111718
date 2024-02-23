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

const CargaDatos=(req,res)=>{
    


    const ListaArchivos=["Categorias","paises","vendedores","clientes","productos","ordenes"]
    const NombreTablas=["Categoria","Pais","Vendedor","Cliente","Producto","Orden"]
    ListaArchivos.forEach((archivo,num)=>{
        // Ruta al archivo CSV
        let filePath = `Data/${archivo}.csv`;

        // Array para almacenar los datos del CSV
        const data = [];

        // Utilizando fs.createReadStream para leer el archivo CSV
        fs.createReadStream(filePath)
        .pipe(csv())
        .on('data', (row) => {
            // Cada fila se agrega al array 'data'
            data.push(row)
        })
        .on('end', () => {
            // El código aquí se ejecuta cuando se completa la lectura del archivo
    
                


            data.forEach((rowData) => {
                
               let dato_insertar={} 
               for(var clave in rowData){
                //console.log(`clave: ${clave}, valor: ${rowData[clave]}`)
                let header=clave.split(';').map(item => item.trim());
                let valor=rowData[clave].split(';').map(item => item.trim());
                
                header.forEach((element,index) => {
                    //comprobar si el dato es numerico
                    if(!isNaN(valor[index])){
                        valor[index]=parseFloat(valor[index])
                    }
                    
                    if(element=="fecha_orden"){
                        valor[index]=ModificarFormatoFecha(valor[index])
                    }
                    
                    dato_insertar[element]=valor[index]
                    
                    
                    
                    
                });
                
                
                
                connection.query(`INSERT INTO ${NombreTablas[num]} SET ?`,dato_insertar, (error, result) => {
                    if (error) {
                        console.error('Error al insertar datos:', error.message);
                        console.log(`INSERT INTO ${NombreTablas[num]} SET ?`,dato_insertar)
                    } 
                }); 

               }            
                
                    
            });


            
            
            
            
        })
        .on('error', (error) => {
            // Manejar errores durante la lectura
            console.error('Error al leer el archivo CSV:', error.message);
            res.status(500).json({ message: 'Error al leer el archivo CSV', error });
        });
    })

    res.status(200).json({message:'Carga de Datos Hecha Correctamente'})
    
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