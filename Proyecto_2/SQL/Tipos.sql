USE Banco;

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


CALL registrarTipoTransaccion(1, 'Compra', 'Transacción de compra');
CALL registrarTipoTransaccion(2, 'Deposito', 'Transacción de deposito');
CALL registrarTipoTransaccion(3, 'Debito', 'Transacción de debito');


/* SELECT * from tipocliente;
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
SELECT * FROM Transaccion;*/
