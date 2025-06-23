create database sistemaLogistico_BDD;
go

use sistemaLogistico_BDD;
go

create table Usuario
(IDUsuario int not null primary key identity (1,1),
NombreUser varchar(50) not null,
Contraseña varchar(50) not null,
Email varchar (50) not null,
TipoUsuario varchar(10) not null,
Activo bit not null)

go

create table EstadoVehiculo (
IDEstadoVehiculo int not null primary key identity (1,1),
Descripcion varchar (50) not null
)

go

create table Vehiculo 
(IDVehiculo int not null primary key identity (1,1),
Patente varchar (20) not null, 
CapacidadDeCarga decimal (10,2) not null,
Disponible bit not null,
IDEstadoVehiculo int not null foreign key references EstadoVehiculo (IDEstadoVehiculo)
)

go

create table Transportista 
(IDTransportista int not null primary key identity (1,1),
IDUsuario int not null foreign key references Usuario (IDUsuario),
Nombre varchar(50) not null,
Apellido varchar (50) not null,
Telefono varchar (11) not null,
Licencia varchar (10) not null,
Cuil bigint not null,
Activo bit not null,
Legajo int not null
)

go

create table TransportistaVehiculo (
IDTransportista int not null,
IDVehiculo int not null,
FechaAsignacion datetime not null default getdate(),
FechaFinAsignacion datetime null,
primary key (IDTransportista, IDVehiculo, FechaAsignacion),
foreign key (IDTransportista) references Transportista(IDTransportista),
foreign key (IDVehiculo) references Vehiculo(IDVehiculo)
)

go

create table Categoria (
IDCategoria int not null primary key identity (1,1),
Nombre varchar (50) not null,
Descripcion varchar (50) null
)

create table Paquete (
IDPaquete int not null primary key identity (1,1),
IDCategoria int not null foreign key references Categoria (IDCategoria),
Descripcion varchar (100) null,
valorDeclarado decimal (10,2) not null,
Cantidad int not null,
Peso decimal (10,2) not null,
Alto decimal (10,2) not null, 
Ancho decimal (10,2) not null,
Largo decimal (10,2) not null)



go 

create table Clientes (
IDCliente int not null primary key identity (1,1),
IDUsuario int not null foreign key references Usuario (IDUsuario),
Calle varchar (50) not null,
NumeroDeCalle int not null,
Localidad varchar (50) not null,
CodigoPostal varchar (10) not null,
Provincia varchar (50) not null,
Cuil bigint not null unique,
Nombre varchar (50) not null,
Apellido varchar (50) not null,
Telefono varchar (50) not null
)

go 

create table Destinatarios(
	IDDestinatario int not null primary key identity(1,1),
	Cuil int not null,
	Nombre varchar(100) not null,
	Apellido varchar(100) not null,
	Telefono int not null, 
	Email varchar (50) not null,
	Calle varchar (50) not null,
	NumeroDeCalle int not null,
	Localidad varchar (50) not null,
	CodigoPostal varchar (10) not null,
	Provincia varchar (50) not null)

go

create table Rutas (
IDRuta int not null primary key identity (1,1),
PuntoPartida varchar (50) not null,
PuntoDestino varchar (50) not null,
TiempoEnMinutos int not null,
DistanciaKilometros decimal (10,2) not null
)

go

create table EstadoOrdenesEnvio (
IDEstadoOrdenEnvio int not null primary key identity (1,1),
Descripcion varchar (50) not null
)

go

create table OrdenesEnvio (
IDOrden int not null primary key identity (1,1),
IDUsuario int not null foreign key references Usuario (IDUsuario),
IDCliente int not null foreign key references Clientes (IDCliente),
IDTransportista int not null foreign key references Transportista (IDTransportista),
IDRuta int not null foreign key references Rutas (IDRuta),
IDEstadoOrdenEnvio int not null foreign key references EstadoOrdenesEnvio (IDEstadoOrdenEnvio),
IDDestinatario int not null foreign key references Destinatarios(IDDestinatario),
FechaCreacion datetime not null default getdate(),
FechaEnvio datetime not null,
FechaEstimadaDeEntrega datetime not null,
FechaLlegada datetime not null
)

go

create table DetalleOrdenesEnvio (
IDDetalleOrden int not null primary key identity (1,1),
IDOrden int not null foreign key references OrdenesEnvio (IDOrden),
IDPaquete int not null foreign key references Paquete (IDPaquete),
Total decimal (10,2) not null
)

