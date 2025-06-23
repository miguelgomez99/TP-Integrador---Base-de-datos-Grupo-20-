INSERT INTO Usuario (NombreUser, Contraseña, Email, TipoUsuario, Activo) VALUES 
('admin', 'admin123', 'admin@logistica.com', 'Admin', 1),
('cliente1', 'clave123', 'cliente1@mail.com', 'Cliente', 1),
('transportista1', 'clave456', 'trans1@mail.com', 'Trans1', 1),
('cliente2', 'clave789', 'cliente2@mail.com', 'Cliente', 1),
('transportista2', 'clave012', 'trans2@mail.com', 'Trans2', 1),
('cliente3', 'clave345', 'cliente3@mail.com', 'Cliente', 1),
('transportista3', 'clave678', 'trans3@mail.com', 'Trans3', 1);

INSERT INTO EstadoVehiculo (Descripcion) VALUES 
('Disponible'),
('En mantenimiento'),
('En sede'),
('En ruta');

INSERT INTO Vehiculo (Patente, CapacidadDeCarga, Disponible, IDEstadoVehiculo) VALUES 
('ABC123', 1500.50, 1, 1),
('XYZ789', 1000.00, 1, 1),
('DEF456', 2000.00, 1, 1),
('GHI321', 1800.00, 1, 1);

INSERT INTO Transportista (IDUsuario, Nombre, Apellido, Telefono, Licencia, Cuil, Activo, Legajo, EstadoDisponible) VALUES 
(3, 'Juan', 'Pérez', '1123456789', 'LIC1234567', 20345678901, 1, 1001,1),
(5, 'Luis', 'Gómez', '1198765432', 'LIC7654321', 20345678902, 1, 1002,1),
(7, 'Ana', 'Martínez', '1187654321', 'LIC2345678', 20345678903, 1, 1003,1);

INSERT INTO TransportistaVehiculo (IDTransportista, IDVehiculo, FechaAsignacion) VALUES 
(1, 1, GETDATE()),
(2, 2, GETDATE()),
(3, 3, GETDATE());

INSERT INTO Categoria (Nombre, Descripcion) VALUES 
('Chico', 'Caja chica'),
('Mediano', 'Caja mediana'),
('Grande', 'Caja grande');

INSERT INTO Paquete (IDCategoria, Descripcion, valorDeclarado, Cantidad, Peso, Alto, Ancho, Largo) VALUES 
(1, 'Notebook', 150000, 1, 2.5, 5, 35, 25),
(2, 'Camperas de abrigo', 80000, 4, 3.2, 30, 50, 40),
(1, 'Tablet', 60000, 2, 1.0, 3, 20, 15),
(3, 'Jeans', 30000, 5, 4.0, 25, 40, 35);

INSERT INTO Clientes (IDUsuario, Calle, NumeroDeCalle, Localidad, CodigoPostal, Provincia, Cuil, Nombre, Apellido, Telefono) VALUES 
(2, 'Av. Siempre Viva', 123, 'Springfield', '1000', 'Buenos Aires', 20300123456, 'Homero', 'Simpson', '1134567890'),
(4, 'Calle Luna', 456, 'Rosario', '2000', 'Santa Fe', 20300123457, 'Marge', 'Bouvier', '1133334444'),
(6, 'Calle Sol', 789, 'Mendoza', '5500', 'Mendoza', 20300123458, 'Lisa', 'Simpson', '1144445555');


INSERT INTO Destinatarios (Cuil, Nombre, Apellido, Telefono, Email, Calle, NumeroDeCalle, Localidad, CodigoPostal, Provincia) VALUES 
(30123456, 'Bart', 'Simpson', 1145678901, 'bart@springfield.com', 'Calle Falsa', 456, 'Springfield', '1001', 'Buenos Aires'),
(30123457, 'Milhouse', 'Van Houten', 1145671234, 'milhouse@springfield.com', 'Calle Falsa', 789, 'Springfield', '1002', 'Buenos Aires'),
(30123458, 'Maggie', 'Simpson', 1145675678, 'maggie@springfield.com', 'Calle Inventada', 101, 'Springfield', '1003', 'Buenos Aires');

INSERT INTO Rutas (PuntoPartida, PuntoDestino, TiempoEnMinutos, DistanciaKilometros) VALUES 
('Buenos Aires', 'Córdoba', 420, 700.5),
('Rosario', 'Mendoza', 600, 1000.0),
('Córdoba', 'Santa Fe', 240, 400.0);

INSERT INTO EstadoOrdenesEnvio (Descripcion) VALUES 
('Pendiente'),
('En transito'),
('Entregado'),
('Reprogramado'),
('Demorado'),
('Cancelado');

INSERT INTO OrdenesEnvio (IDUsuario, IDCliente, IDTransportista, IDRuta, IDEstadoOrdenEnvio, IDDestinatario, FechaEnvio, FechaEstimadaDeEntrega, FechaLlegada) VALUES 
(2, 1, 2, 1, 2, 1, GETDATE(), DATEADD(day, 2, GETDATE()), DATEADD(day, 3, GETDATE())),
(4, 2, 2, 2, 3, 2, GETDATE(), DATEADD(day, 2, GETDATE()), DATEADD(day, 3, GETDATE())),
(6, 3, 3, 3, 3, 3, GETDATE(), DATEADD(day, 2, GETDATE()), DATEADD(day, 3, GETDATE()));

INSERT INTO DetalleOrdenesEnvio (IDOrden, IDPaquete, Total) VALUES 
(1, 1, 150000.00),
(1, 2, 80000.00),
(2, 3, 60000.00),
(2, 4, 30000.00),
(3, 4, 30000.00);