USE Banco;

DROP PROCEDURE IF EXISTS registrarTipoCliente;
DROP PROCEDURE IF EXISTS registrarTipoCuenta;
DROP PROCEDURE IF EXISTS registrarCliente;
DROP PROCEDURE IF EXISTS registrarCuenta;
DROP PROCEDURE IF EXISTS crearProductoServicio;
DROP PROCEDURE IF EXISTS realizarCompra;
DROP PROCEDURE IF EXISTS realizarDeposito;
DROP PROCEDURE IF EXISTS realizarDebito;
DROP PROCEDURE IF EXISTS registrarTipoTransaccion;
DROP PROCEDURE IF EXISTS asignarTransaccion;
DROP PROCEDURE IF EXISTS consultarSaldoCliente;
DROP PROCEDURE IF EXISTS consultarCliente;
DROP PROCEDURE IF EXISTS consultarMovsCliente;
DROP PROCEDURE IF EXISTS consultarTipoCuentas;
DROP PROCEDURE IF EXISTS consultarMovsGenFech;
DROP PROCEDURE IF EXISTS consultarMovsFechClien;
DROP PROCEDURE IF EXISTS consultarProductoServicio;

DELIMITER //

CREATE PROCEDURE registrarTipoCliente(
    IN p_Id INTEGER,
    IN p_Nombre VARCHAR(40),
    IN p_Descripcion VARCHAR(100)
)
BEGIN
    -- Validar que la descripción solo contenga letras
    IF NOT p_Descripcion REGEXP '^[a-zA-ZñÑ., ]+$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La descripción debe contener solo letras.';
    ELSE
        -- Verificar si el nombre ya está en uso
        IF EXISTS (SELECT * FROM TipoCliente WHERE Nombre = p_Nombre) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El nombre ya está en uso. Por favor, elija otro.';
        ELSE
            -- Insertar el nuevo tipo de cliente, ignorando el valor del ID proporcionado y dejando que se autoincremente
            INSERT INTO TipoCliente (Nombre, Descripcion) VALUES (p_Nombre, p_Descripcion);
        END IF;
    END IF;
END//


CREATE PROCEDURE registrarTipoCuenta(
    IN c_Id INTEGER,
    IN c_Nombre VARCHAR(40),
    IN c_Descripcion VARCHAR(120)
)
BEGIN
    IF EXISTS (SELECT * FROM TipoCuenta WHERE Nombre = c_Nombre) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre ya está en uso. Por favor, elija otro.';
    ELSE
        INSERT INTO TipoCuenta (Nombre, Descripcion) VALUES (c_Nombre, c_Descripcion);
    END IF;
END//

CREATE PROCEDURE registrarCliente(
    IN c_Id INTEGER,
    IN c_Nombre VARCHAR(40),
    IN c_Apellido VARCHAR(40),
    IN c_Telefono VARCHAR(100),
    IN c_correo VARCHAR(200),
    IN c_usuario VARCHAR(40),
    IN c_contrasena VARCHAR(200),
    IN c_TipoCliente INTEGER
)
BEGIN
	

	DECLARE telefono_actual VARCHAR(20);
    DECLARE telefono_insertar VARCHAR(20);
    DECLARE posicion_guion INT;
	DECLARE correo_actual VARCHAR(40);
    DECLARE posicion_or INT;
    
    SET autocommit = 0;
    
    COMMIT; -- guardamos el punto de restauracion
    
	IF EXISTS (SELECT * FROM Cliente WHERE IdCliente =c_Id) THEN
        SET autocommit = 1;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ID de cliente ya está en uso. Por favor, elija otro.';
    END IF;


    IF NOT c_Nombre REGEXP '^[a-zA-ZñÑ., ]+$' THEN
		SET autocommit = 1;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre debe contener solo letras.';
    END IF;

    IF NOT c_Apellido REGEXP '^[a-zA-ZñÑ., ]+$' THEN
		SET autocommit = 1;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El apellido debe contener solo letras.';
    END IF;

    IF EXISTS (SELECT * FROM Cliente WHERE Usuario = c_usuario) THEN
    	SET autocommit = 1;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre de usuario ya está en uso. Por favor, elija otro.';
    END IF;
	
	IF NOT c_Telefono REGEXP '^[0-9]+(-[0-9]+)*$' THEN
		SET autocommit = 1;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato del numero Incorrecto.';
    END IF;
	
    IF EXISTS (SELECT * FROM TipoCliente WHERE idTipo =c_TipoCliente)THEN
        INSERT INTO Cliente (IdCliente, Nombre, Apellido, Usuario, Contrasena,Fecha_Creacion, TipoCliente) VALUES (c_Id, c_Nombre, c_Apellido, c_usuario, SHA2(c_contrasena,256),NOW(), c_TipoCliente);
    ELSE
		SET autocommit = 1;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de cliente no existe.';
    END IF;
    
	
	-- Telefonos
    WHILE CHAR_LENGTH(c_Telefono) > 0 DO
		SET posicion_guion = LOCATE('-', c_Telefono); -- verificar si hay guiones
		IF posicion_guion > 0 THEN
            SET telefono_actual = TRIM(SUBSTRING(c_Telefono, 1, posicion_guion - 1)); -- guardamos el telefono actual
            SET c_Telefono = TRIM(SUBSTRING(c_Telefono, posicion_guion + 1)); -- actualizamos el string borrando el telefono que sacamos de la cadena
        ELSE -- en el caso que no venga con separadores eliminamos caracteres especiales y actualizamos variable
            SET telefono_actual = TRIM(c_Telefono);
            SET c_Telefono = '';
        END IF;
        
		IF CHAR_LENGTH(telefono_actual)>8 THEN
            SET telefono_insertar = TRIM(SUBSTRING(telefono_actual, 4));
        ELSE
            SET telefono_insertar = telefono_actual;
        END IF;
        
        IF NOT EXISTS (SELECT * FROM Telefono WHERE IdCliente =c_Id and Telefono=telefono_insertar) THEN
			INSERT INTO Telefono (IdCliente,Telefono) VALUES (c_Id,telefono_insertar);
		END IF;
    END WHILE;

    -- Correos
    WHILE CHAR_LENGTH(c_correo) > 0 DO
		SET posicion_or = LOCATE('|', c_correo); -- verificar si hay guiones
		IF posicion_or > 0 THEN
            SET correo_actual = TRIM(SUBSTRING(c_correo, 1, posicion_or - 1)); -- guardamos el telefono actual
            SET c_correo = TRIM(SUBSTRING(c_correo, posicion_or + 1)); -- actualizamos el string borrando el telefono que sacamos de la cadena
        ELSE -- en el caso que no venga con separadores eliminamos caracteres especiales y actualizamos variable
            SET correo_actual = TRIM(c_correo);
            SET c_correo = '';
        END IF;
        
		IF NOT correo_actual REGEXP '^[a-zA-ZñÑ0-9._%+-]+@[a-zA-ZñÑ0-9.-]+\.[a-zA-ZñÑ]{2,}$' THEN
			ROLLBACK;
            SET autocommit = 1;
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Formato de correo Incorrecto';
		END IF;
        
        IF NOT EXISTS (SELECT * FROM Correo WHERE IdCliente =c_Id and Correo=correo_actual) THEN
			INSERT INTO Correo (IdCliente,Correo) VALUES (c_Id,correo_actual);
		END IF;
    END WHILE;
    
END//

CREATE PROCEDURE registrarCuenta(
    IN c_Id BIGINT,
    IN c_MontoApertura DECIMAL(12,2),
    IN c_Saldo DECIMAL(12,2),
    IN c_Descripcion VARCHAR(50),
    IN c_FechaApertura VARCHAR(100),
    IN c_OtrosDetalles VARCHAR(100),
    IN c_TipoCuenta INTEGER,
    IN c_IdCliente INTEGER
)
BEGIN
    IF EXISTS (SELECT * FROM Cuenta WHERE IdCuenta =c_Id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El numero de cuenta ya existe.';
    END IF;

    IF c_MontoApertura<0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto de apertura no puede ser negativo.';
    END IF;

    IF c_Saldo<0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El saldo no puede ser negativo.';
    END IF;

    -- Insertar la fecha del sistema si la fecha proporcionada es nula o vacía
    IF c_FechaApertura IS NULL OR c_FechaApertura = '' THEN
        SET c_FechaApertura = NOW(); -- NOW() devuelve la fecha y hora actuales
    ELSE
		SET c_FechaApertura=STR_TO_DATE(c_FechaApertura, '%d/%m/%Y %H:%i:%s');
	END IF;


    IF NOT EXISTS (SELECT * FROM TipoCuenta WHERE Codigo =c_TipoCuenta) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de cuenta asociado no existe.';
    END IF;

    IF NOT EXISTS (SELECT * FROM Cliente WHERE IdCliente =c_IdCliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente asociado no existe.';
    END IF;
    
    IF c_MontoApertura<>c_Saldo THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saldo No coincide con el monto de apertura.';
    END IF;
    
    IF  c_OtrosDetalles='' THEN
		set c_OtrosDetalles=NULL;
    END IF;

    INSERT INTO Cuenta (IdCuenta, Monto_Apertura, Saldo_Cuenta, Descripcion, Fecha_Apertura, Detalle, TipoCuenta, IdCliente) VALUES (c_Id, c_MontoApertura, c_Saldo, c_Descripcion, c_FechaApertura, c_OtrosDetalles, c_TipoCuenta, c_IdCliente);
  



END//

CREATE PROCEDURE crearProductoServicio(
    IN ps_Cod INTEGER,
    IN Tipo INTEGER,
    IN Costo DECIMAL(12,2),
    IN Descripcion VARCHAR(100)
)
BEGIN
    IF EXISTS(SELECT * FROM ProductoServicio WHERE IdProductoServicio=ps_Cod )THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'id ya esta Ocupado por Un producto o Servicio';
    END IF;



    IF TIPO<1 OR TIPO>2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de producto o servicio no valido unicamente 1-2';
    END IF;

    IF TIPO=1 THEN
        IF COSTO<0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Costo de un servicio no puede ser negativo';
        END IF;

        IF COSTO IS NULL OR COSTO=0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Costo de un servicio no puede ser nulo ni cero';
        END IF;

        INSERT INTO ProductoServicio (IdProductoServicio, Tipo, Costo, Descripcion) VALUES (ps_Cod, Tipo, Costo, Descripcion);
    ELSE
        IF COSTO<0 OR COSTO>0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Costo de un producto debe ser variable';
        END IF;

        IF COSTO=NULL OR COSTO=0 OR COSTO='' THEN
            SET COSTO=NULL;
        END IF;


        INSERT INTO ProductoServicio (IdProductoServicio, Tipo, Costo, Descripcion) VALUES (ps_Cod, Tipo, Costo, Descripcion);
    END IF;


END//


CREATE PROCEDURE realizarCompra(
    IN c_IdCompra INTEGER,
    IN c_Fecha VARCHAR(30),
    IN c_Importe DECIMAL(12,2),
    IN c_Detalle VARCHAR(40),
    IN c_IdProductoServicio INTEGER,
    IN c_IdCliente INTEGER
)
BEGIN
    DECLARE tipo_producto INT;
    DECLARE costops DECIMAL(12,2);
	DECLARE saldo_actual DECIMAL(12,2);

    

    IF c_Fecha IS NULL OR c_Fecha='' THEN
        SET c_Fecha=DATE_FORMAT(CURDATE(), '%Y-%m-%d');
    ELSE
        SET c_Fecha=STR_TO_DATE(c_Fecha, '%d/%m/%Y');
    END IF;

    IF EXISTS(SELECT * FROM Compra WHERE IdCompra=c_IdCompra) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ID de compra ya está en uso. Por favor, elija otro.';
    END IF;

    IF NOT EXISTS(SELECT * FROM ProductoServicio WHERE IdProductoServicio=c_IdProductoServicio) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El servicio o producto asociado no existe.';
    END IF;



    IF NOT EXISTS(SELECT * FROM Cliente WHERE IdCliente=c_IdCliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente asociado no existe.';
    END IF;

    IF c_Detalle='' THEN
        SET c_Detalle=NULL;
    END IF;

    SELECT Tipo INTO tipo_producto FROM ProductoServicio WHERE IdProductoServicio = c_IdProductoServicio;

    IF tipo_producto=1 THEN -- servicio

        IF c_Importe<0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El importe de un servicio no puede ser negativo';
        END IF;

        IF NOT c_Importe=0 OR c_Importe is NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El precio de un servicio ya esta predefinido no puede ser variable';
        END IF;

        SELECT Costo INTO costops FROM ProductoServicio WHERE IdProductoServicio = c_IdProductoServicio;

        INSERT INTO Compra (IdCompra, Fecha, Importe, Detalle, IdProductoServicio, IdCliente) VALUES (c_IdCompra, c_Fecha, costops, c_Detalle, c_IdProductoServicio, c_IdCliente);

    END IF;

    IF tipo_producto=2 THEN -- producto
            
            IF c_Importe<0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'El importe de un producto no puede ser negativo';
            END IF;
    
            IF c_Importe=0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'El precio de un producto debe ser variable';
            END IF;
			
            SET costops=c_Importe;
            INSERT INTO Compra (IdCompra, Fecha, Importe, Detalle, IdProductoServicio, IdCliente) VALUES (c_IdCompra, c_Fecha, costops, c_Detalle, c_IdProductoServicio, c_IdCliente);
    END IF;
	
    
	/* -- Actualizar el saldo de la cuenta
    SELECT Saldo_Cuenta INTO saldo_actual FROM Cuenta WHERE IdCliente = c_IdCliente;
    IF (saldo_actual - costops) < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fondos insuficientes en la cuenta para realizar la compra.';
    ELSE
        UPDATE Cuenta SET Saldo_Cuenta = saldo_actual - costops WHERE IdCliente = c_IdCliente;
    END IF;*/

END//

CREATE PROCEDURE realizarDeposito(
    IN d_IdDeposito INTEGER,
    IN d_Fecha VARCHAR(30),
    IN d_Importe DECIMAL(12,2),
    IN d_Detalle VARCHAR(40),
    IN d_IdCliente INTEGER
)
BEGIN
    
    IF d_Fecha IS NULL OR d_Fecha='' THEN
        SET d_Fecha=DATE_FORMAT(CURDATE(), '%Y-%m-%d');
    ELSE
        SET d_Fecha=STR_TO_DATE(d_Fecha, '%d/%m/%Y');
    END IF;

    IF EXISTS (SELECT * FROM Deposito WHERE IdDeposito = d_IdDeposito) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ID de depósito ya está en uso. Por favor, elija otro.';
    END IF;

    IF d_Importe<=0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El importe del depósito debe ser mayor a cero.';
    END IF;

    IF NOT EXISTS(SELECT * FROM Cliente WHERE IdCliente=d_IdCliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente asociado no existe.';
    END IF;


    IF d_Detalle='' THEN
        SET d_Detalle=NULL;
    END IF;

    INSERT INTO Deposito (IdDeposito, Fecha,Monto, Detalle, IdCliente) VALUES (d_IdDeposito, d_Fecha, d_Importe, d_Detalle, d_IdCliente);

    /*-- ACTUALIZAMOS LA CUENTA
    UPDATE Cuenta SET Saldo_Cuenta = Saldo_Cuenta + d_Importe WHERE IdCliente = d_IdCliente;*/



END//


CREATE PROCEDURE realizarDebito(
    IN d_IdDebito INTEGER,
    IN d_Fecha VARCHAR(30),
    IN d_Importe DECIMAL(12,2),
    IN d_Detalle VARCHAR(40),
    IN d_IdCliente INTEGER
)
BEGIN
    


    IF d_Fecha IS NULL OR d_Fecha='' THEN
        SET d_Fecha=DATE_FORMAT(CURDATE(), '%Y-%m-%d');
    ELSE
        SET d_Fecha=STR_TO_DATE(d_Fecha, '%d/%m/%Y');
    END IF;

    IF EXISTS (SELECT * FROM Debito WHERE IdDebito = d_IdDebito) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ID de débito ya está en uso. Por favor, elija otro.';
    END IF;

    IF d_Importe<=0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El importe del débito debe ser mayor a cero.';
    END IF;

    IF NOT EXISTS(SELECT * FROM Cliente WHERE IdCliente=d_IdCliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente asociado no existe.';
    END IF;

    IF d_Detalle='' THEN
        SET d_Detalle=NULL;
    END IF;

    INSERT INTO Debito (IdDebito, Fecha, Monto, Detalle, IdCliente) VALUES (d_IdDebito, d_Fecha, d_Importe, d_Detalle, d_IdCliente);


END//

CREATE PROCEDURE registrarTipoTransaccion(
    IN t_Id INTEGER,
    IN t_Nombre VARCHAR(40),
    IN t_Descripcion VARCHAR(120)
)
BEGIN
    IF EXISTS (SELECT * FROM TipoTransaccion WHERE Nombre = t_Nombre) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre ya está en uso. Por favor, elija otro.';
    END IF;

    INSERT INTO TipoTransaccion (Nombre, Descripcion) VALUES (t_Nombre, t_Descripcion);

END//

CREATE PROCEDURE asignarTransaccion(
    IN t_IdTransaccion INTEGER,
    IN t_Fecha VARCHAR(30),
    IN t_Detalle VARCHAR(40),
    IN t_TipoTransaccion INTEGER,
    IN t_cmpdepdeb INTEGER,
    IN t_NoCuenta BIGINT
)
BEGIN
    DECLARE saldo_actual DECIMAL(12,2);
    DECLARE importe_compra DECIMAL(12,2);
    DECLARE No_Cliente INTEGER;
    DECLARE No_cuenta BIGINT;

    IF t_Fecha IS NULL OR t_Fecha='' THEN
        SET t_Fecha=DATE_FORMAT(CURDATE(), '%Y-%m-%d');
    ELSE
        SET t_Fecha=STR_TO_DATE(t_Fecha, '%d/%m/%Y');
    END IF;
    
    IF NOT EXISTS(SELECT * FROM TipoTransaccion WHERE CodigoTransaccion=t_TipoTransaccion) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de transaccion no existe.';
    END IF;

    IF NOT EXISTS(SELECT * FROM Cuenta WHERE IdCuenta=t_NoCuenta) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El numero de cuenta no existe.';
    END IF;

    IF t_Detalle='' or t_Detalle IS NULL THEN
        SET t_Detalle=NULL;
    END IF;



    IF t_TipoTransaccion=1 THEN
        -- Compra
        IF NOT EXISTS(SELECT * FROM Compra WHERE IdCompra=t_cmpdepdeb) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La compra no existe.';
        END IF;

        -- encontramos el numero cliente
        SELECT IdCliente INTO No_Cliente from Compra WHERE IdCompra=t_cmpdepdeb;

        -- encontramos el numero de cuenta
        SELECT IdCuenta INTO No_cuenta from Cuenta WHERE IdCliente=No_Cliente and IdCuenta=t_NoCuenta;


        -- comparamos si la cuenta ingresada es la misma que la de la compra
        IF No_cuenta<>t_NoCuenta THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El numero de cuenta no coincide con el asociado a la compra.';
        END IF;

        -- extraemos el saldo actual de la cuenta
        SELECT Saldo_Cuenta INTO saldo_actual FROM Cuenta WHERE IdCuenta = t_NoCuenta;
        -- extraemos el importe de la compra
        SELECT Importe INTO importe_compra FROM Compra WHERE IdCompra = t_cmpdepdeb;

        -- verificamos si el saldo es suficiente
        IF (saldo_actual - importe_compra) < 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Fondos insuficientes en la cuenta para realizar la compra.';
        ELSE
        
            INSERT INTO Transaccion (Fecha, Detalle, TipoTransaccion,IdCompra, IdCuenta) VALUES (t_Fecha, t_Detalle, t_TipoTransaccion,t_cmpdepdeb, t_NoCuenta);
            -- actualizamos el saldo de la cuenta
            UPDATE Cuenta SET Saldo_Cuenta = saldo_actual - importe_compra WHERE IdCuenta = t_NoCuenta;
        END IF;

        

    END IF;

    IF t_TipoTransaccion=2 THEN
        -- Deposito
        IF NOT EXISTS(SELECT * FROM Deposito WHERE IdDeposito=t_cmpdepdeb) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El deposito no existe.';
        END IF;

        -- encontramos el numero cliente
        SELECT IdCliente INTO No_Cliente from Deposito WHERE IdDeposito=t_cmpdepdeb;

        -- encontramos el numero de cuenta
        SELECT IdCuenta INTO No_cuenta from Cuenta WHERE IdCliente=No_Cliente and IdCuenta=t_NoCuenta;

        -- comparamos si la cuenta ingresada es la misma que la del deposito
        IF No_cuenta<>t_NoCuenta THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El numero de cuenta no coincide con el asociado al deposito.';
        END IF;

        -- extraemos el saldo actual de la cuenta
        SELECT Saldo_Cuenta INTO saldo_actual FROM Cuenta WHERE IdCuenta = t_NoCuenta;
        -- extraemos el importe del deposito
        SELECT Monto INTO importe_compra FROM Deposito WHERE IdDeposito = t_cmpdepdeb;

        -- actualizamos el saldo de la cuenta
        UPDATE Cuenta SET Saldo_Cuenta = saldo_actual + importe_compra WHERE IdCuenta = t_NoCuenta;

        INSERT INTO Transaccion (Fecha, Detalle, TipoTransaccion,IdDeposito, IdCuenta) VALUES (t_Fecha, t_Detalle, t_TipoTransaccion,t_cmpdepdeb, t_NoCuenta);
    END IF;


    IF t_TipoTransaccion=3 THEN
    
        -- Debito
        IF NOT EXISTS(SELECT * FROM Debito WHERE IdDebito=t_cmpdepdeb) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El debito no existe.';
        END IF;

        -- encontramos el numero cliente
        SELECT IdCliente INTO No_Cliente from Debito WHERE IdDebito=t_cmpdepdeb;

        -- encontramos el numero de cuenta
        SELECT IdCuenta INTO No_cuenta from Cuenta WHERE IdCliente=No_Cliente and IdCuenta=t_NoCuenta;

        -- comparamos si la cuenta ingresada es la misma que la del debito
        IF No_cuenta<>t_NoCuenta THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El numero de cuenta no coincide con el asociado al debito.';
        END IF;

        -- extraemos el saldo actual de la cuenta
        SELECT Saldo_Cuenta INTO saldo_actual FROM Cuenta WHERE IdCuenta = t_NoCuenta;
        -- extraemos el importe del debito
        SELECT Monto INTO importe_compra FROM Debito WHERE IdDebito = t_cmpdepdeb;

        -- verificamos si el saldo es suficiente
        IF (saldo_actual - importe_compra) < 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Fondos insuficientes en la cuenta para realizar el debito.';
        ELSE
            -- actualizamos el saldo de la cuenta
            UPDATE Cuenta SET Saldo_Cuenta = saldo_actual - importe_compra WHERE IdCuenta = t_NoCuenta;
            INSERT INTO Transaccion (Fecha, Detalle, TipoTransaccion,IdDebito, IdCuenta) VALUES (t_Fecha, t_Detalle, t_TipoTransaccion,t_cmpdepdeb, t_NoCuenta);
        END IF;
    END IF;


    

END//

-- AQUI VAN LOS ULTIMOS 7 PROCEDURES

CREATE PROCEDURE consultarSaldoCliente(
    IN NoCuenta BIGINT
)
BEGIN
    IF NOT EXISTS(SELECT * FROM Cuenta WHERE IdCuenta=NoCuenta) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cuenta no existe';
    END IF;


    SELECT 
    Cliente.Nombre,
    TipoCliente.Nombre as Tipo_Cliente,
    TipoCuenta.Nombre as Tipo_Cuenta,
    Cuenta.Saldo_Cuenta,
    Cuenta.Monto_Apertura 
    from Cuenta 
    JOIN Cliente ON Cuenta.IdCliente=Cliente.IdCliente
    JOIN TipoCliente ON Cliente.TipoCliente=TipoCliente.idTipo
    JOIN TipoCuenta ON Cuenta.TipoCuenta=TipoCuenta.Codigo
    WHERE Cuenta.IdCuenta=NoCuenta;


END//

CREATE PROCEDURE consultarCliente(
    IN c_Id INTEGER
)
BEGIN
    DECLARE No_Cuentas INTEGER;
    DECLARE telefonos VARCHAR(100);
    DECLARE correos VARCHAR(200);
    DECLARE tipos VARCHAR(100);

    SET No_Cuentas=(SELECT COUNT(*) FROM Cuenta WHERE IdCliente=c_Id);

    IF NOT EXISTS(SELECT * FROM Cliente WHERE IdCliente=c_Id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    SELECT GROUP_CONCAT(Telefono SEPARATOR '-') INTO telefonos FROM Telefono WHERE IdCliente=c_Id;
    SELECT GROUP_CONCAT(Correo SEPARATOR '-') INTO correos FROM Correo WHERE IdCliente=c_Id;
    

   
    -- Obtener los nombres de los tipos de cuenta asociados al cliente
    SELECT GROUP_CONCAT(TipoCuenta.Nombre SEPARATOR '-') INTO tipos
    FROM Cuenta
    INNER JOIN TipoCuenta ON Cuenta.TipoCuenta = TipoCuenta.Codigo
    WHERE Cuenta.IdCliente = c_Id;


    SELECT 
    Cliente.IdCliente,
    CONCAT(Cliente.Nombre,' ',Cliente.Apellido) as Nombre_Completo,
    Cliente.Fecha_Creacion,
    Cliente.Usuario,
    No_Cuentas as Cuentas_Activas,
    telefonos as Telefonos,
    correos as Correos,
    tipos as Tipos_Cuenta
    FROM Cliente 
    WHERE Cliente.IdCliente=c_Id;


END//

CREATE PROCEDURE consultarMovsCliente(
    IN c_IdCliente INTEGER
)
BEGIN





    IF NOT EXISTS(SELECT * FROM Cliente WHERE IdCliente=c_IdCliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;


    SELECT
        Transaccion.idTransaccion,
        CASE
            WHEN Transaccion.idDebito IS NOT NULL THEN 'Débito'
            WHEN Transaccion.idDeposito IS NOT NULL THEN 'Depósito'
            WHEN Transaccion.idCompra IS NOT NULL THEN 'Compra'
        END AS TipoTransaccion,
        CASE 
            WHEN Debito.Monto IS NOT NULL THEN Debito.Monto
            WHEN Deposito.Monto IS NOT NULL THEN Deposito.Monto
            WHEN Compra.Importe IS NOT NULL THEN Compra.Importe
        END AS Monto,
        Transaccion.IdCuenta AS No_Cuenta,
        TipoCuenta.Nombre AS Tipo_Cuenta
    FROM Transaccion
    LEFT JOIN Compra ON Transaccion.IdCompra = Compra.IdCompra
    LEFT JOIN Deposito ON Transaccion.IdDeposito = Deposito.IdDeposito
    LEFT JOIN Debito ON Transaccion.IdDebito = Debito.IdDebito
    LEFT JOIN Cuenta ON Transaccion.IdCuenta = Cuenta.IdCuenta
    JOIN Cliente ON Cuenta.IdCliente = Cliente.IdCliente
    JOIN TipoCuenta ON Cuenta.TipoCuenta = TipoCuenta.Codigo
    WHERE Cliente.IdCliente = c_IdCliente; -- Aquí debes reemplazar tu_IdCliente con el ID del cliente deseado

END//


CREATE PROCEDURE consultarTipoCuentas(
    IN c_tipocuenta INTEGER
)
BEGIN
    IF NOT EXISTS(SELECT * FROM TipoCuenta WHERE Codigo=c_tipocuenta) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de cuenta no existe';
    END IF;

   SELECT 
        TC.Codigo,
        TC.Nombre,
        COUNT(C.IdCuenta) AS Cuentas_Activas
    FROM 
        TipoCuenta TC
    LEFT JOIN 
        Cuenta C ON TC.Codigo = C.TipoCuenta
    WHERE 
        TC.Codigo = c_tipocuenta
    GROUP BY 
        TC.Codigo, TC.Nombre;
    
END//

CREATE PROCEDURE consultarMovsGenFech(
    IN c_FechaInicio VARCHAR(30),
    IN c_FechaFin VARCHAR(30)
)
BEGIN
    -- validar que las fechas sean válidas  dd/mm/yy
    IF NOT c_FechaInicio REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{2}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio no tiene el formato correcto.';
    END IF;

    IF NOT c_FechaFin REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{2}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de fin no tiene el formato correcto.';
    END IF;

    -- convertir las fechas al formato correcto
    SET c_FechaInicio = STR_TO_DATE(c_FechaInicio, '%d/%m/%y');
    SET c_FechaFin = STR_TO_DATE(c_FechaFin, '%d/%m/%y');

    SELECT 
    transaccion.idTransaccion,
    CASE
        WHEN transaccion.idDebito IS NOT NULL THEN 'Débito'
        WHEN transaccion.idDeposito IS NOT NULL THEN 'Depósito'
        WHEN transaccion.idCompra IS NOT NULL THEN 'Compra'
    END AS TipoTransaccion,
    Cliente.Nombre,
    Cuenta.IdCuenta,
    TipoCuenta.Nombre AS TipoCuenta,
    transaccion.Fecha,
    CASE
        WHEN Compra.IdCompra IS NOT NULL THEN Compra.importe
        WHEN Deposito.IdDeposito IS NOT NULL THEN Deposito.monto
        WHEN Debito.IdDebito IS NOT NULL THEN Debito.monto
    END AS monto,
    transaccion.Detalle
    FROM Transaccion
    JOIN Cuenta ON Transaccion.IdCuenta = Cuenta.IdCuenta
    JOIN Cliente ON Cuenta.IdCliente = Cliente.IdCliente
    JOIN TipoCuenta ON Cuenta.TipoCuenta = TipoCuenta.Codigo
    LEFT JOIN Compra ON Transaccion.IdCompra = Compra.IdCompra
    LEFT JOIN Deposito ON Transaccion.IdDeposito = Deposito.IdDeposito
    LEFT JOIN Debito ON Transaccion.IdDebito = Debito.IdDebito
    WHERE Transaccion.Fecha BETWEEN c_FechaInicio AND c_FechaFin;




END// 

CREATE PROCEDURE consultarMovsFechClien(
    IN c_IdCliente INTEGER,
    IN c_FechaInicio VARCHAR(30),
    IN c_FechaFin VARCHAR(30)
)
BEGIN
    IF NOT EXISTS(SELECT * FROM Cliente WHERE IdCliente=c_IdCliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    -- validar que las fechas sean válidas  dd/mm/yy
    IF NOT c_FechaInicio REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{2}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio no tiene el formato correcto.';
    END IF;

    IF NOT c_FechaFin REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{2}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de fin no tiene el formato correcto.';
    END IF;

    -- convertir las fechas al formato correcto
    SET c_FechaInicio = STR_TO_DATE(c_FechaInicio, '%d/%m/%y');
    SET c_FechaFin = STR_TO_DATE(c_FechaFin, '%d/%m/%y');

    SELECT 
    transaccion.idTransaccion,
    CASE
        WHEN transaccion.idDebito IS NOT NULL THEN 'Débito'
        WHEN transaccion.idDeposito IS NOT NULL THEN 'Depósito'
        WHEN transaccion.idCompra IS NOT NULL THEN 'Compra'
    END AS TipoTransaccion,
    Cliente.Nombre,
    Cuenta.IdCuenta,
    TipoCuenta.Nombre AS TipoCuenta,
    transaccion.Fecha,
    CASE
        WHEN Compra.IdCompra IS NOT NULL THEN Compra.importe
        WHEN Deposito.IdDeposito IS NOT NULL THEN Deposito.monto
        WHEN Debito.IdDebito IS NOT NULL THEN Debito.monto
    END AS monto,
    transaccion.Detalle
    FROM Transaccion
    JOIN Cuenta ON Transaccion.IdCuenta = Cuenta.IdCuenta
    JOIN Cliente ON Cuenta.IdCliente = Cliente.IdCliente
    JOIN TipoCuenta ON Cuenta.TipoCuenta = TipoCuenta.Codigo
    LEFT JOIN Compra ON Transaccion.IdCompra = Compra.IdCompra
    LEFT JOIN Deposito ON Transaccion.IdDeposito = Deposito.IdDeposito
    LEFT JOIN Debito ON Transaccion.IdDebito = Debito.IdDebito
    WHERE Cliente.IdCliente = c_IdCliente
    AND Transaccion.Fecha BETWEEN c_FechaInicio AND c_FechaFin;

END//

CREATE PROCEDURE consultarProductoServicio()
BEGIN
    SELECT 
    IdProductoServicio AS CODIGO,
    Descripcion AS Nombre, 
    TIPO,
    CASE TIPO
        WHEN 1 THEN 'SERVICIO'
        WHEN 2 THEN 'PRODUCTO'
    END AS Descripcion
    FROM ProductoServicio;
END//

DELIMITER ;



-- TIPOS DE CLIENTES
CALL registrarTipoCliente(1,'Individual Nacional','Este tipo de cliente es una persona individual de nacionalidad guatemalteca.');
CALL registrarTipoCliente(null,'Individual Extranjero','Este tipo de cliente es una persona individual de nacionalidad extranjera.');
CALL registrarTipoCliente(0,'Empresa PyMe ','Este tipo de cliente es una empresa de tipo pequeña o mediana.');
CALL registrarTipoCliente(4,'Empresa S.C','Este tipo de cliente corresponde a las empresa grandes que tienen una sociedad colectiva.');

-- TIPOS DE CUENTA
CALL registrarTipoCuenta(1,'Cuenta de Cheques','Este tipo de cuenta ofrece la facilidad de emitir cheques para realizar transacciones monetarias.');
CALL registrarTipoCuenta(2,'Cuenta de Ahorros','Esta cuenta genera un interés anual del 2%, lo que la hace ideal para guardar fondos a largo plazo.');
CALL registrarTipoCuenta(3,'Cuenta de Ahorro Plus','Con una tasa de interés anual del 10%, esta cuenta de ahorros ofrece mayores rendimientos.');
CALL registrarTipoCuenta(4,'Pequeña Cuenta','Una cuenta de ahorros con un interés semestral del 0.5%, ideal para pequeños ahorros y movimientos.');
CALL registrarTipoCuenta(null,'Cuenta de Nómina','Diseñada para recibir depósitos de sueldo y realizar pagos, con acceso a servicios bancarios básicos.');
CALL registrarTipoCuenta(0,'Cuenta de Inversión','Orientada a inversionistas, ofrece opciones de inversión y rendimientos más altos que una cuenta de ahorros estándar. ');

CALL registrarCliente(1001, 'Juan Isaac','Perez Lopez','50322888080-65436756','micorreo@gmail.com','jisaacp20243','12345678','2' );
call registrarCliente(1002, 'Maria Isabel','Gonzalez Perez','22805050-22808080','micorreo1@gmail.com|micorreo2@gmail.com','mariauser','12345679','2' );
CALL registrarCliente(1003, 'Walter Javier','Santizo Mazriegos','50259663187-45575187-502876543','walterjav19@gmail.com|w.javiersantizo@hotmail.com|hola@yopmail.com','walterjav19','cientificojoven','3' );

-- registro de cuenta
--               idcuenta, montoapertura,*saldo, descripcion,     fechaapertura,otrosdetalles,idtipocuenta,idcliente
CALL registrarCuenta(3030206080, 800.00, 800.00, 'Apertura de cuenta con Q500','','',5,1002);
CALL registrarCuenta(3030206081, 600.00, 600.00, 'Apertura de cuenta con Q500','01/04/2024 07:00:00','esta apertura tiene fecha',5,1001);
CALL registrarCuenta(3030206082, 900.00, 900.00, 'Apertura de cuenta con Q900','01/04/2024 07:00:00','esta apertura tiene fecha',5,1001);


-- registro de productoservicio
--                         id, tipo, costo, descripcion
CALL crearProductoServicio(1,1,10,'Servicio de tarjeta de debito');
CALL crearProductoServicio(2,1,10,'Servicio de chequera');
CALL crearProductoServicio(3,1,400,'Servicio de asesoramiento financiero');
CALL crearProductoServicio(4,1,5,'Servicio de banca personal');
CALL crearProductoServicio(5,1,30,'Seguro de Vida');
CALL crearProductoServicio(6,1,100,'Seguro de vida plus');
CALL crearProductoServicio(7,1,300,'Seguro de automovil');
CALL crearProductoServicio(8,1,500,'Seguro de automovil plus');
CALL crearProductoServicio(9,1,0.05,'Servicio de Deposito');
CALL crearProductoServicio(10,1,0.10,'Servicio de Debito');
-- productos
CALL crearProductoServicio(11,2,0,'Pago de energía Eléctrica (EEGSA)');
CALL crearProductoServicio(12,2,0,'Pago de agua potable (EMPAGUA)');
CALL crearProductoServicio(13,2,0,'Pago de Matricula USAC');
CALL crearProductoServicio(14,2,0,'Pago de Curso Vacaciones Usac');
CALL crearProductoServicio(15,2,0,'Pago de servicio de internet');
CALL crearProductoServicio(16,2,0,'Servicio de suscripción plataformas streaming');
CALL crearProductoServicio(17,2,0,'Servicios Cloud');
CALL crearProductoServicio(18, 1, 53.80,'Servicio Extra');
CALL crearProductoServicio(19, 2, 0,'Producto Extra'); -- producto, tiene un precio de "cero" el cual indica que es variable

-- realizar compra
--                  id,      fecha,   monto,  otrosdetalles, codProducto/Servicio, idcliente
CALL realizarCompra(1111, '10/04/2024', 0, 'compra de servicio', 18, 1001); -- aqui hay error ya que el monto deberia de ser cero por que ya tiene un precio preestablecido por ser un servicio
call realizarCompra(1113, '10/04/2024', 34, 'compra de producto', 19, 1001); -- aqui esta correcto ya que el monto es mayor a cero y es un producto
call realizarCompra(1114, '10/04/2024', 0, 'compra de producto', 8, 1001);
call realizarCompra(1115, '10/04/2024', 0, 'compra de producto', 8, 1002);
call realizarCompra(1116, '10/04/2024', 0, 'compra de producto', 8, 1001);
-- call realizarCompra(1115, '10/04/2024', 0, 'compra de producto', 8, 1001); -- cuenta sin saldo


-- realizar deposito
--              id,      fecha,     monto,  otrosdetalles, idcliente
CALL realizarDeposito(1114, '', 100, 'deposito de dinero', 1001);
CALL realizarDeposito(1115, '10/04/2024', 21, 'deposito de dinero', 1001); -- aqui hay error ya que el monto deberia de ser mayor a cero

-- realizar retiro
--              id,      fecha,     monto,  otrosdetalles, idcliente
CALL realizarDebito(1116, '10/04/2024', 100, 'retiro de dinero', 1001);
CALL realizarDebito(1117, '10/04/2024', 2, 'retiro de dinero con error', 1001); -- aqui hay error ya que el monto deberia de ser mayor a cero

CALL registrarTipoTransaccion(1, 'Compra', 'Transacción de compra');
CALL registrarTipoTransaccion(2, 'Deposito', 'Transacción de deposito');
CALL registrarTipoTransaccion(3, 'Debito', 'Transacción de debito');

CALL asignarTransaccion(1118, '10/04/2024','',1, 1115, 3030206080);
CALL asignarTransaccion(1115, '10/04/2024','',2, 1114, 3030206081); -- se realia deposito *aqui se puede depositar a una cuenta que no es del cliente
CALL asignarTransaccion(1120, '10/04/2024','este si tiene detalle',3, 1116, 3030206081); -- se realiza un debito
CALL asignarTransaccion(1121, '10/06/2024','este si tiene detalle',1, 1116, 3030206082);-- compra 

CALL consultarSaldoCliente(3030206082);

CALL consultarCliente(1001);

CALL consultarMovsCliente(1001);	

CALL consultarTipoCuentas(1);

CALL consultarMovsGenFech('10/04/24','10/06/24');
CALL consultarMovsFechClien(1001,'10/04/24','10/06/24');
CALL consultarProductoServicio();


SELECT * from tipocliente;
SELECT * FROM Cliente;
SELECT * FROM Telefono;
SELECT * FROM Correo;
SELECT * FROM Cuenta;
SELECT * from TipoCuenta;
SELECT * FROM productoservicio;
SELECT * FROM compra;
SELECT * FROM Deposito;
SELECT * FROM Debito;
SELECT * FROM TipoTransaccion;
SELECT * FROM Transaccion;
SELECT * FROM Historial;