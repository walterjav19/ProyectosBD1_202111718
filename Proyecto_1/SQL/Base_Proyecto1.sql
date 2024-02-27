Drop database Proyecto1;
Create Database Proyecto1;
Use Proyecto1;



Drop Table Categoria;
truncate table categoria;
Create Table Categoria(
id_categoria integer primary key,
nombre varchar(100) not null
);

Drop table Pais;
truncate table pais;
Create Table Pais(
id_pais integer primary key,
nombre varchar(100) not null
);

Drop Table Producto;
truncate table Producto;
Create Table Producto(
id_producto integer primary key,
Nombre varchar(100) not null,
Precio decimal(10,2) not null,
id_categoria integer not null,
FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

Drop Table Vendedor;
truncate table vendedor;
Create Table Vendedor(
id_vendedor integer primary key,
Nombre  varchar(100) not null,
id_pais integer not null,
FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
);

drop table Cliente;
truncate table cliente;
Create Table Cliente(
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
);

/*INSERT INTO Cliente VALUES
(1, 'Vivian', 'Schultz', '1511 Pooh Bear Lane', 4608499546, 1979280000000000, 55, 100000, 'F', 11),
(2, 'Natisha', 'Flores', '3663 McDowell Street', 5119315633, 3144520000000000, 80, 40000, 'F', 11);*/

drop table Orden;
truncate table orden;
Create Table Orden(
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
);





#INSERT INTO Orden VALUES (1.0, 1, '2004-01-27', 7888, 96, 9117, 1);
#INSERT INTO Orden VALUES (1.0, 2, '2004-01-27', 7888, 79, 3353, 3);
#truncate table orden;



-- Select * de la tabla Categoria
SELECT count(*) FROM Categoria;
SELECT * FROM Categoria;
-- Select * de la tabla Pais
SELECT count(*) FROM Pais;
SELECT * FROM Pais;

-- Select * de la tabla Producto
SELECT count(*) FROM Producto;
select * from producto;
-- Select * de la tabla Vendedor
SELECT count(*) FROM Vendedor;
select * from vendedor;
-- Select * de la tabla Cliente
SELECT count(*) FROM Cliente;
select * from cliente;

-- Select * de la tabla Orden
SELECT count(*) FROM Orden;
select * from orden;

/*Mostrar el cliente que más ha comprado. Se debe de mostrar el id del cliente,
nombre, apellido, país y monto total*/
select * from orden;


