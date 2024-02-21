Drop database Proyecto1;
Create Database Proyecto1;
Use Proyecto1;

drop table Categoria;

Create Table Categoria(
id_categoria integer primary key auto_increment,
nombre varchar(100) not null
);

Create Table Pais(
id_pais integer primary key auto_increment,
nombre varchar(100) not null
);


Create Table Producto(
id_producto integer primary key auto_increment,
Nombre varchar(100) not null,
Precio decimal(10,2) not null,
id_categoria integer not null,
FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

Create Table Vendedor(
id_vendedor integer primary key auto_increment,
Nombre  varchar(100) not null,
id_pais integer not null,
FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);




