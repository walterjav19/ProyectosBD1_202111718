USE Banco;

DROP PROCEDURE IF EXISTS registrarTipoCliente;
DROP PROCEDURE IF EXISTS registrarTipoCuenta;
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
    IN c_correo VARCHAR(100),
    IN c_usuario VARCHAR(40),
    IN c_contrasena VARCHAR(200),
    IN c_TipoCliente INTEGER
)
BEGIN
    SELECT 'JAVIER' AS NOMBRE;
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

CALL registrarCliente(1001, 'Juan Isaac','Perez Lopez','22888080','micorreo@gmail.com','jisaacp2024','12345678','1' );


SELECT * from tipocliente;

SELECT * from TipoCuenta;