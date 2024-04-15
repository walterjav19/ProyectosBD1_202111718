USE Banco;

DROP PROCEDURE IF EXISTS registrarTipoCliente;
DROP PROCEDURE IF EXISTS registrarTipoCuenta;
DROP PROCEDURE IF EXISTS registrarCliente;
DROP PROCEDURE IF EXISTS registrarCuenta;
DROP PROCEDURE IF EXISTS crearProductoServicio;

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
    IF EXISTS(SELECT * FROM Producto WHERE IdProducto=ps_Cod )THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'id ya esta Ocupado por Un producto';
    END IF;

    IF EXISTS(SELECT * FROM Servicio WHERE IdServicio=ps_Cod )THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'id ya esta Ocupado por Un Servicio';
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

        IF COSTO=NULL OR COSTO=0 OR COSTO='' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Costo de un servicio no puede ser nulo ni cero';
        END IF;

        INSERT INTO Servicio (IdServicio, Tipo, Costo, Descripcion) VALUES (ps_Cod, Tipo, Costo, Descripcion);
    ELSE
        IF COSTO<0 OR COSTO>0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Costo de un producto debe ser variable';
        END IF;

        IF COSTO=NULL OR COSTO=0 OR COSTO='' THEN
            SET COSTO=NULL;
        END IF;


        INSERT INTO Producto (IdProducto, Tipo, Costo, Descripcion) VALUES (ps_Cod, Tipo, Costo, Descripcion);
    END IF;


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

-- registro de productoservicio
--                    id, tipo, costo, descripcion
CALL crearProductoServicio(18, 1, 50.80, 'Este es un servicio el cual tiene un precio predefinido'); -- servicio
CALL crearProductoServicio(19, 2, 0, 'Este es un producto el cual tiene un precio variable'); -- producto, tiene un precio de "cero" el cual indica que es variable
CALL crearProductoServicio(9, 2,0, 'Este es un producto el cual tiene un precio variable'); -- producto, tiene un precio de "cero" el cual indica que es variable




SELECT * from tipocliente;
SELECT * FROM Cliente;
SELECT * FROM Telefono;
SELECT * FROM Correo;
SELECT * FROM Cuenta;
SELECT * from TipoCuenta;
SELECT * FROM servicio;
SELECT * FROM  producto;

