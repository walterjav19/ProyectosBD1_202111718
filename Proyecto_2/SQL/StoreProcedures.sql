USE Banco;

DROP PROCEDURE IF EXISTS registrarTipoCliente;
DROP PROCEDURE IF EXISTS registrarTipoCuenta;
DROP PROCEDURE IF EXISTS registrarCliente;

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
	DECLARE correo_actual VARCHAR(20);
    DECLARE posicion_or INT;
    
    SET autocommit = 0;
    
    COMMIT; -- guardamos el punto de restauracion
    
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
CALL registrarCliente(1003, 'Juan Manuel','Perez Lopez','50322888080-65432121-50287654321-22888080','micorreo@gmail.net|sapo@gmail.net|micorreo@gmail.com','jisaacp260243','12345678','1' );

SELECT * from tipocliente;
SELECT * FROM Cliente;
SELECT * FROM Telefono;
SELECT * FROM Correo;
SELECT * from TipoCuenta;
