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







-- Vista 1 --
CREATE VIEW vw_OrdenesEnvioPendientes as
SELECT ordenes.IDOrden, ordenes.IDCliente, ordenes.IDTransportista, ordenes.IDDestinatario, ordenes.FechaCreacion, 
ordenes.FechaEnvio, ordenes.FechaEstimadaDeEntrega, rutas.PuntoPartida, rutas.PuntoDestino, estado.Descripcion as EstadoOrden
FROM OrdenesEnvio ordenes
INNER JOIN EstadoOrdenesEnvio estado ON estado.IDEstadoOrdenEnvio = ordenes.IDEstadoOrdenEnvio
INNER JOIN Rutas rutas ON rutas.IDRuta= ordenes.IDRuta
WHERE estado.Descripcion = 'Pendiente';


-- Vista 2 --
CREATE VIEW vw_TransportistasDisponibles AS
SELECT t.IDTransportista, t.Nombre, t.Apellido, t.Cuil, u.Email, t.EstadoDisponible, v.Patente, v.CapacidadDeCarga
FROM Transportista t
INNER JOIN Usuario u ON t.IDUsuario = u.IDUsuario
INNER JOIN TransportistaVehiculo tv ON t.IDTransportista = tv.IDTransportista
INNER JOIN Vehiculo v ON tv.IDVehiculo = v.IDVehiculo
WHERE t.EstadoDisponible = 1;


-- Vista 3 --
CREATE VIEW vw_RendimientoTransportistas AS 
SELECT
T.IDTransportista, T.Nombre+' ' + T.Apellido AS NombreTransportista, COUNT (*) AS CantidadEntregasCompletadas  
FROM OrdenesEnvio OE 
INNER JOIN Transportista T on T.IDTransportista=OE.IDTransportista 
INNER JOIN EstadoOrdenesEnvio EOE on EOE.IDEstadoOrdenEnvio = OE.IDEstadoOrdenEnvio 
WHERE EOE.Descripcion= 'Entregado' GROUP BY T.IDTransportista, T.Nombre, T.Apellido;


-- Vista 4 --
CREATE VIEW vw_VehiculosDisponibles AS
SELECT V.Patente, V.CapacidadDeCarga, T.Nombre +' '+ T.Apellido AS NombreTransportista, V.Disponible
FROM Vehiculo V
INNER JOIN TransportistaVehiculo TV ON TV.IDVehiculo=V.IDVehiculo
INNER JOIN Transportista T ON T.IDTransportista=TV.IDTransportista
WHERE V.Disponible=1 AND T.EstadoDisponible=1;



-- Procedimiento Almacenado 1 --
CREATE PROCEDURE SP_Agregar_Transportista(
    @NombreUser VARCHAR(50),
	@Contraseña VARCHAR(50),
	@Email VARCHAR(70),
	@TipoUsuario VARCHAR(20),
	@ActivoUser BIT,
	@Nombre VARCHAR(100),
	@Apellido VARCHAR(100),
	@Telefono VARCHAR (20),
	@Licencia VARCHAR (10),
	@Cuil BIGINT,
	@Activo BIT,
	@Legajo INT,
	@EstadoDisponible BIT
)
AS
BEGIN
	BEGIN TRY
	IF EXISTS (SELECT 1 FROM Usuario WHERE NombreUser = @NombreUser)
		BEGIN
			PRINT 'YA EXISTE UN TRANSPORTISTA CON ESE NOMBRE DE USUARIO.'
			RETURN
		END
		
		IF EXISTS (SELECT 1 FROM Transportista WHERE Cuil = @Cuil)
		BEGIN
			PRINT 'YA EXISTE UN TRANSPORTISTA CON ESE CUIL.'
			RETURN
		END

		IF (@Cuil <= 0)
		BEGIN
			PRINT 'EL CUIL NO PUEDE TENER VALORES NEGATIVOS.'
			RETURN
		END

		IF @Email NOT LIKE '_%@_%._%'
		BEGIN
		    PRINT 'EL FORMATO DEL EMAIL ES INVÁLIDO.'
		    RETURN
		END

		INSERT INTO Usuario(NombreUser, Contraseña, Email,  TipoUsuario, Activo)
		VALUES (@NombreUser, @Contraseña, @Email, @TipoUsuario, @ActivoUser)

		DECLARE @IdUsuario INT;
		SET @IdUsuario = SCOPE_IDENTITY(); 

		INSERT INTO Transportista (IDUsuario, Nombre, Apellido, Telefono, Licencia, Cuil, Activo, Legajo, EstadoDisponible)
		VALUES (@IdUsuario, @Nombre, @Apellido, @Telefono, @Licencia, @Cuil, @Activo, @Legajo, @EstadoDisponible)

	 PRINT 'USUARIO Y TRANSPORTISTA CREADOS EXITOSAMENTE'
    END TRY
    BEGIN CATCH
        PRINT 'ERROR AL AGREGAR UN REGISTRO NUEVO'
		PRINT ERROR_MESSAGE()
    END CATCH
END;



-- Procedimiento Almacenado 2 --
CREATE PROCEDURE SP_ReporteHistorialEntregas (
@IDTransportista int,
@FechaInicio date,
@FechaFin date
)
AS
BEGIN TRY
 IF @FechaInicio > @FechaFin BEGIN
   RAISERROR ('La primera fecha elegida no puede ser mayor a la segunda',16,1)
 RETURN
 END

 IF NOT EXISTS (SELECT 1 FROM Transportista WHERE IDTransportista=@IDTransportista) BEGIN
	RAISERROR ('El transportista buscado no existe',16,1)
	RETURN
 END 
 
SELECT T.Nombre +' '+T.Apellido AS NombreTransportista,OE.IDOrden,C.Nombre+' '+C.Apellido AS NombreCliente, D.Nombre+' '+D.Apellido AS NombreDestinatario ,  OE.FechaEnvio, OE.FechaLlegada FROM OrdenesEnvio OE 
INNER JOIN Clientes C ON C.IDCliente= OE.IDCliente
INNER JOIN Destinatarios D ON D.IDDestinatario= OE.IDDestinatario
INNER JOIN Transportista T ON OE.IDTransportista=T.IDTransportista
WHERE T.IDTransportista=@IDTransportista AND OE.IDEstadoOrdenEnvio=3 AND OE.FechaEnvio BETWEEN @FechaInicio AND @FechaFin;

END TRY
BEGIN CATCH
  RAISERROR ('No se puede visualizar el reporte debido a un error inesperado',16,1);
END CATCH



-- Procedimiento Almacenado 3 --
create procedure sp_CambiarEstadoOrdenEnvio
    @IDOrdenEnvio int,
    @NuevoIDEstado int
as
begin

    if not exists(select 1 from OrdenesEnvio where IDOrden = @IDOrdenEnvio)
    begin
        raiserror('La orden de envío no existe.', 16, 1);
        return;
    end
    if not exists (select 1 from EstadoOrdenesEnvio where IDEstadoOrdenEnvio = @NuevoIDEstado)
    begin
        raiserror('El estado indicado no existe.', 16, 1);
        return;
    end

    update OrdenesEnvio
    set IDEstadoOrdenEnvio = @NuevoIDEstado,
    FechaLlegada = case when @NuevoIDEstado = 3 then GETDATE() else FechaLlegada       end
    where IDOrden = @IDOrdenEnvio;

    print 'Estado actualizado correctamente.';
end



-- Trigger 1 --
CREATE TRIGGER tr_DesactivarUsuario_AlEliminarTransportista 
ON Transportista
AFTER UPDATE
AS
BEGIN
BEGIN TRY
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN deleted d ON i.IDTransportista = d.IDTransportista
            WHERE d.Activo = 1 AND i.Activo = 0
        )
        BEGIN
            DECLARE @IDUsuario INT;

            SELECT @IDUsuario = i.IDUsuario
            FROM inserted i
            JOIN deleted d ON i.IDTransportista = d.IDTransportista
            WHERE d.Activo = 1 AND i.Activo = 0;

            UPDATE Usuario
            SET Activo = 0
            WHERE IDUsuario = @IDUsuario;

            PRINT 'Usuario desactivado por baja del transportista.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Ocurrio un error al intentar desactivar un usuario por la baja de un transportista';
        PRINT ERROR_MESSAGE();
    END CATCH
END




-- Trigger 2 --
create trigger tr_AgregarOrdenEnvio
on OrdenesEnvio
after insert
as
begin

    begin try
        begin transaction;

        if exists (
            select 1
            from inserted i
            left join Usuario u on u.IDUsuario = i.IDUsuario
            where u.Activo <> 1 or u.IDUsuario is null
        )
        begin
            raiserror('El Usuario no se encuentra activo', 16, 1);
            rollback transaction;
            return;
        end

        if exists (
            select 1
            from inserted i
            left join Clientes c on c.IDCliente = i.IDCliente
            where c.IDCliente is null
        )
        begin
            raiserror('El Cliente no existe', 16, 1);
            rollback transaction;
            return;
        end

        if exists (
            select 1
            from inserted i
            left join Transportista t on t.IDTransportista = i.IDTransportista
            where t.Activo <> 1 or t.IDTransportista is null or or t.EstadoDisponible<>1
        )
        begin
            raiserror('El Transportista especificado no existe o no se encuentra activo', 16, 1);
            rollback transaction;
            return;
        end

        if exists (
            select 1
            from inserted i
            left join Rutas r on r.IDRuta = i.IDRuta
            where r.IDRuta is null
        )
        begin
            raiserror('La Ruta indicada no existe en nuestra base de datos', 16, 1);
            rollback transaction;
            return;
        end

        if exists (
            select 1
            from inserted i
            left join Destinatarios d on d.IDDestinatario = i.IDDestinatario
            where d.IDDestinatario is null
        )
        begin
            raiserror('El Destinatario indicado no existe', 16, 1);
            rollback transaction;
            return;
        end

        if exists (
            select 1
            from inserted
            where FechaLlegada < FechaCreacion
        )
        begin
            raiserror('La fecha de llegada no puede ser menor a la fecha de creación', 16, 1);
            rollback transaction;
            return;
        end

        if not exists (
            select 1 from EstadoOrdenesEnvio where IDEstadoOrdenEnvio = 1
        )
        begin
            raiserror('El estado inicial con id = 1 (Pendiente) no existe en la tabla EstadoOrdenesEnvio', 16, 1);
            rollback transaction;
            return;
        end

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        declare @msg nvarchar(4000) = error_message();
        raiserror(@msg, 16, 1);
    end catch
end




-- Trigger 3 --
CREATE TRIGGER tr_CancelarOrden_AlEliminarUltimoDetalle ON DetalleOrdenesEnvio
AFTER DELETE
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @IDOrden INT;

	IF NOT EXISTS (SELECT 1 FROM deleted)
	BEGIN
	PRINT 'No se encontro ningun detalle para eliminar'
	ROLLBACK TRANSACTION
	RETURN
	END
SELECT TOP 1 @IDOrden = IDOrden FROM deleted;

IF EXISTS (SELECT 1 FROM OrdenesEnvio WHERE IDOrden = @IDOrden AND IDEstadoOrdenEnvio = 1)

BEGIN
   DELETE FROM Paquete WHERE IDPaquete IN (SELECT IDPaquete FROM deleted);

   IF NOT EXISTS (SELECT 1 FROM DetalleOrdenesEnvio WHERE IDOrden = @IDOrden)
 BEGIN
    UPDATE OrdenesEnvio SET IDEstadoOrdenEnvio = 6 WHERE IDOrden = @IDOrden;
    PRINT 'Orden cancelada, detalle de paquete y paquete eliminado'
  END
COMMIT TRANSACTION
END
ELSE 
   BEGIN
      PRINT 'La orden no esta en estado pendiente, por lo cual no se realiza la eliminacion';
      ROLLBACK TRANSACTION
      RETURN
    END
END TRY
    BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Error en trigger de cancelacion de orden';
   PRINT ERROR_MESSAGE()
END CATCH
END

