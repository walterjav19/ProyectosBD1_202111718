DROP DATABASE IF EXISTS Banco;
CREATE DATABASE Banco;
USE Banco;

/*TABLAS DE LA BASE DE DATOS*/
DROP TABLE IF EXISTS TipoCliente ;
CREATE TABLE TipoCliente(
    idTipo INTEGER PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(40) NOT NULL,
    Descripcion VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS Cliente;
CREATE TABLE Cliente(
IdCliente INTEGER PRIMARY KEY,
Nombre VARCHAR(40) NOT NULL,
Apellido VARCHAR(40) NOT NULL,
Usuario VARCHAR(40) NOT NULL,
Contrasena VARCHAR(200) NOT NULL,
Fecha_Creacion DATETIME,
TipoCliente INTEGER(10) NOT NULL,
FOREIGN KEY (TipoCliente) REFERENCES TipoCliente(idTipo)
);

DROP TABLE IF EXISTS Telefono;
CREATE TABLE Telefono(
IdCliente INTEGER,
Telefono VARCHAR(12) NOT NULL,
FOREIGN KEY (IdCliente)  REFERENCES Cliente(IdCliente)
);

DROP TABLE IF EXISTS Correo;
CREATE TABLE Correo(
IdCliente INTEGER,
Correo VARCHAR(40) NOT NULL,
FOREIGN KEY (IdCliente)  REFERENCES Cliente(IdCliente)
);


DROP TABLE IF EXISTS TipoCuenta;
CREATE TABLE TipoCuenta(
    Codigo INTEGER PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(40) NOT NULL,
    Descripcion VARCHAR(120) NOT NULL
);

DROP TABLE IF EXISTS Cuenta;
CREATE TABLE Cuenta(
    IdCuenta BIGINT PRIMARY KEY,
    Monto_Apertura DECIMAL(12,2) NOT NULL,
    Saldo_Cuenta DECIMAL(12,2) NOT NULL,
    Descripcion VARCHAR(50) NOT NULL,
    Fecha_Apertura DATETIME NOT NULL,
    Detalle VARCHAR(100),
    TipoCuenta INTEGER NOT NULL,
    IdCliente INTEGER NOT NULL,
    FOREIGN KEY (TipoCuenta) REFERENCES TipoCuenta(Codigo),
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

DROP TABLE IF EXISTS ProductoServicio;
CREATE TABLE ProductoServicio(
    IdProductoServicio INTEGER PRIMARY KEY,
    Tipo INTEGER NOT NULL,
    Costo DECIMAL(12,2),
    Descripcion VARCHAR(100) NOT NULL
);


DROP TABLE IF EXISTS Compra;
CREATE TABLE Compra(
    IdCompra INTEGER PRIMARY KEY,
    Fecha DATE NOT NULL,
    Importe DECIMAL(12,2),
    Detalle VARCHAR(40),
    IdProductoServicio INTEGER NOT NULL,
    IdCliente INTEGER NOT NULL,
    FOREIGN KEY (IdProductoServicio) REFERENCES ProductoServicio(IdProductoServicio),
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

DROP TABLE IF EXISTS Deposito;
CREATE TABLE Deposito(
    IdDeposito INTEGER PRIMARY KEY,
    Fecha DATE NOT NULL,
    Monto DECIMAL(12,2) NOT NULL,
    Detalle VARCHAR(40),
    IdCliente INTEGER NOT NULL,
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

DROP TABLE IF EXISTS Debito;
CREATE TABLE Debito(
    IdDebito INTEGER PRIMARY KEY,
    Fecha DATE NOT NULL,
    Monto DECIMAL(12,2) NOT NULL,
    Detalle VARCHAR(40),
    IdCliente INTEGER NOT NULL,
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

DROP TABLE IF EXISTS TipoTransaccion;
CREATE TABLE TipoTransaccion(
    CodigoTransaccion INTEGER PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(20) NOT NULL,
    Descripcion VARCHAR(40) NOT NULL
);

DROP TABLE IF EXISTS Transaccion;

CREATE TABLE Transaccion(
    IdTransaccion INTEGER PRIMARY KEY AUTO_INCREMENT,
    Fecha DATE NOT NULL,
    Detalle VARCHAR(40),
    TipoTransaccion INTEGER NOT NULL,
    IdCompra INTEGER,
    IdDeposito INTEGER,
    IdDebito INTEGER,
    IdCuenta BIGINT NOT NULL,
    FOREIGN KEY (TipoTransaccion) REFERENCES TipoTransaccion(CodigoTransaccion),
    FOREIGN KEY (IdCompra) REFERENCES Compra(IdCompra),
    FOREIGN KEY (IdDeposito) REFERENCES Deposito(IdDeposito),
    FOREIGN KEY (IdDebito) REFERENCES Debito(IdDebito),
    FOREIGN KEY (IdCuenta) REFERENCES Cuenta(IdCuenta)
);

/*FIN TABLAS*/