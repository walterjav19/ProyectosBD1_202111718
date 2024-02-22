Drop database Proyecto1;
Create Database Proyecto1;
Use Proyecto1;

drop table Categoria;

Drop Table Categoria;
Create Table Categoria(
id_categoria integer primary key,
nombre varchar(100) not null
);

Drop table Pais;
Create Table Pais(
id_pais integer primary key,
nombre varchar(100) not null
);

Drop Table Producto;
Create Table Producto(
id_producto integer primary key,
Nombre varchar(100) not null,
Precio decimal(10,2) not null,
id_categoria integer not null,
FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

Drop Table Vendedor;
Create Table Vendedor(
id_vendedor integer primary key,
Nombre  varchar(100) not null,
id_pais integer not null,
FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);
drop table Cliente;
Create Table Cliente(
id_cliente integer primary key,
Nombre  varchar(100) not null,
Apellido  varchar(100) not null,
Direccion  varchar(100) not null,
Telefono  integer not null,
Tarjeta  integer not null,
Edad  integer not null,
Genero char(1) not null,
Salario Integer NOT NULL,
id_pais integer not null,
FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);

drop table Orden;
Create Table Orden(
id_orden Integer,
linea_orden Integer,
fecha_orden Date Not null,
cantidad Integer Not null,
id_cliente Integer Not Null,
id_vendedor Integer Not Null,
id_producto Integer Not null,
FOREIGN KEY (id_cliente ) REFERENCES  Cliente(id_cliente),
FOREIGN KEY (id_vendedor) REFERENCES  Vendedor(id_vendedor),
FOREIGN KEY (id_producto) REFERENCES  Producto(id_producto),
primary key (id_orden,linea_orden)
);








