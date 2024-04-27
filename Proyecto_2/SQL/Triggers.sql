USE Banco;

DROP TRIGGER IF EXISTS registrarHistorial1;
DROP TRIGGER IF EXISTS registrarHistorial2;
DROP TRIGGER IF EXISTS registrarHistorial3;
DROP TRIGGER IF EXISTS registrarHistorial4;
DROP TRIGGER IF EXISTS registrarHistorial5;
DROP TRIGGER IF EXISTS registrarHistorial6;
DROP TRIGGER IF EXISTS registrarHistorial7;
DROP TRIGGER IF EXISTS registrarHistorial8;
DROP TRIGGER IF EXISTS registrarHistorial9;
DROP TRIGGER IF EXISTS registrarHistorial10;
DROP TRIGGER IF EXISTS registrarHistorial11;
DROP TRIGGER IF EXISTS registrarHistorial12;
DROP TRIGGER IF EXISTS registrarHistorial13;
DROP TRIGGER IF EXISTS registrarHistorial14;
DROP TRIGGER IF EXISTS registrarHistorial15;
DROP TRIGGER IF EXISTS registrarHistorial16;
DROP TRIGGER IF EXISTS registrarHistorial17;
DROP TRIGGER IF EXISTS registrarHistorial18;
DROP TRIGGER IF EXISTS registrarHistorial19;
DROP TRIGGER IF EXISTS registrarHistorial20;
DROP TRIGGER IF EXISTS registrarHistorial21;
DROP TRIGGER IF EXISTS registrarHistorial22;
DROP TRIGGER IF EXISTS registrarHistorial23;
DROP TRIGGER IF EXISTS registrarHistorial24;
DROP TRIGGER IF EXISTS registrarHistorial25;
DROP TRIGGER IF EXISTS registrarHistorial26;
DROP TRIGGER IF EXISTS registrarHistorial27;
DROP TRIGGER IF EXISTS registrarHistorial28;
DROP TRIGGER IF EXISTS registrarHistorial29;
DROP TRIGGER IF EXISTS registrarHistorial30;
DROP TRIGGER IF EXISTS registrarHistorial31;
DROP TRIGGER IF EXISTS registrarHistorial32;
DROP TRIGGER IF EXISTS registrarHistorial33;
DROP TRIGGER IF EXISTS registrarHistorial34;
DROP TRIGGER IF EXISTS registrarHistorial35;
DROP TRIGGER IF EXISTS registrarHistorial36;



DELIMITER //

-- TABLA TIPOCLIENTE
CREATE TRIGGER registrarHistorial1 AFTER INSERT ON TipoCliente
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Cliente', 'Cliente', 'Inserción');
END//


CREATE TRIGGER registrarHistorial2 AFTER UPDATE ON TipoCliente
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Tipo Cliente', 'Tipo Cliente', 'Actualización');
END//

CREATE TRIGGER registrarHistorial3 AFTER DELETE ON  TipoCliente
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Tipo Cliente', 'Tipo Cliente', 'Eliminación');
END//

-- TABLA CLIENTE
CREATE TRIGGER registrarHistorial4 AFTER INSERT ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Cliente', 'Cliente', 'Inserción');
END//

CREATE TRIGGER registrarHistorial5 AFTER UPDATE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Cliente', 'Cliente', 'Actualización');
END//

CREATE TRIGGER registrarHistorial6 AFTER DELETE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Cliente', 'Cliente', 'Eliminación');
END//

-- TABLA TELEFONO

CREATE TRIGGER registrarHistorial7 AFTER INSERT ON Telefono
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Telefono', 'Telefono', 'Inserción');
END//

CREATE TRIGGER registrarHistorial8 AFTER UPDATE ON Telefono
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Telefono', 'Telefono', 'Actualización');
END//

CREATE TRIGGER registrarHistorial9 AFTER DELETE ON Telefono
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Telefono', 'Telefono', 'Eliminación');
END//

-- TABLA CORREO

CREATE TRIGGER registrarHistorial10 AFTER INSERT ON Correo
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Correo', 'Correo', 'Inserción');
END//


CREATE TRIGGER registrarHistorial11 AFTER UPDATE ON Correo
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Correo', 'Correo', 'Actualización');
END//

CREATE TRIGGER registrarHistorial12 AFTER DELETE ON Correo
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Correo', 'Correo', 'Eliminación');
END//

-- TABLA TIPOCUENTA

CREATE TRIGGER registrarHistorial13 AFTER INSERT ON TipoCuenta
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Tipo Cuenta', 'Tipo Cuenta', 'Inserción');
END//

CREATE TRIGGER registrarHistorial14 AFTER UPDATE ON TipoCuenta
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Tipo Cuenta', 'Tipo Cuenta', 'Actualización');
END//

CREATE TRIGGER registrarHistorial15 AFTER DELETE ON TipoCuenta
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Tipo Cuenta', 'Tipo Cuenta', 'Eliminación');
END//



-- TABLA CUENTA

CREATE TRIGGER registrarHistorial16 AFTER INSERT ON Cuenta
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Cuenta', 'Cuenta', 'Inserción');
END//


CREATE TRIGGER registrarHistorial17 AFTER UPDATE ON Cuenta
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Cuenta', 'Cuenta', 'Actualización');
END//

CREATE TRIGGER registrarHistorial18 AFTER DELETE ON Cuenta
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Cuenta', 'Cuenta', 'Eliminación');
END//



-- TABLA PRODUCTOSERVICIO

CREATE TRIGGER registrarHistorial19 AFTER INSERT ON ProductoServicio
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Producto Servicio', 'Producto Servicio', 'Inserción');
END//


CREATE TRIGGER registrarHistorial20 AFTER UPDATE ON ProductoServicio
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Producto Servicio', 'Producto Servicio', 'Actualización');
END//


CREATE TRIGGER registrarHistorial21 AFTER DELETE ON ProductoServicio
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Producto Servicio', 'Producto Servicio', 'Eliminación');
END//

-- TABLA COMPRA

CREATE TRIGGER registrarHistorial22 AFTER INSERT ON Compra
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Compra', 'Compra', 'Inserción');
END//

CREATE TRIGGER registrarHistorial23 AFTER UPDATE ON Compra
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Compra', 'Compra', 'Actualización');
END//

CREATE TRIGGER registrarHistorial24 AFTER DELETE ON Compra
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Compra', 'Compra', 'Eliminación');
END//


-- TABLA DEPOSITO

CREATE TRIGGER registrarHistorial25 AFTER INSERT ON Deposito
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Deposito', 'Deposito', 'Inserción');
END//

CREATE TRIGGER registrarHistorial26 AFTER UPDATE ON Deposito
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Deposito', 'Deposito', 'Actualización');
END//

CREATE TRIGGER registrarHistorial27 AFTER DELETE ON Deposito
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Deposito', 'Deposito', 'Eliminación');
END//


-- TABLA DEBITO

CREATE TRIGGER registrarHistorial28 AFTER INSERT ON Debito
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Debito', 'Debito', 'Inserción');
END//

CREATE TRIGGER registrarHistorial29 AFTER UPDATE ON Debito
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Debito', 'Debito', 'Actualización');
END//

CREATE TRIGGER registrarHistorial30 AFTER DELETE ON Debito
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Debito', 'Debito', 'Eliminación');
END//



-- TABLA TIPOTRANSACCION

CREATE TRIGGER registrarHistorial31 AFTER INSERT ON TipoTransaccion
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Tipo Transaccion', 'Tipo Transaccion', 'Inserción');
END//

CREATE TRIGGER registrarHistorial32 AFTER UPDATE ON TipoTransaccion
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Tipo Transaccion', 'Tipo Transaccion', 'Actualización');
END//

CREATE TRIGGER registrarHistorial33 AFTER DELETE ON TipoTransaccion
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Tipo Transaccion', 'Tipo Transaccion', 'Eliminación');
END//




-- TABLA TRANSACCION

CREATE TRIGGER registrarHistorial34 AFTER INSERT ON Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una inserción en la tabla Transaccion', 'Transaccion', 'Inserción');
END//

CREATE TRIGGER registrarHistorial35 AFTER UPDATE ON Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una actualización en la tabla Transaccion', 'Transaccion', 'Actualización');
END//

CREATE TRIGGER registrarHistorial36 AFTER DELETE ON Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO Historial (Fecha, Descripcion, Tabla, Tipo) VALUES (NOW(), 'Se ha realizado una eliminación en la tabla Transaccion', 'Transaccion', 'Eliminación');
END//



DELIMITER ;