--1 CREAREMOS LA BASE DE DATOS
CREATE DATABASE PROY_SIS_ALQ_AUT
ON PRIMARY
(
	NAME = 'PROY_SIS_ALQ_AUT_data',
	FILENAME = 'D:\SQLSERVER_BDs\PROY_SIS_ALQ_AUT.mdf',
	SIZE = 50MB,
	MAXSIZE = 500MB,
	FILEGROWTH = 10MB
)
LOG ON 
	(
		NAME='PROY_SIS_ALQ_AUT_Log',
		FILENAME = 'D:\SQLSERVER_BDs\PROY_SIS_ALQ_AUT.ldf',
		SIZE = 20MB,
		MAXSIZE = 100MB,
		FILEGROWTH = 10MB
	);
GO

--2 elegimos la BD creada
use PROY_SIS_ALQ_AUT
Go

--CREAREMOS LAS TABLAS
Create table Cliente (
	Id_Cliente int identity (1,1),
	Nombre nvarchar(80) not null,
	Dni nchar(8) not null,
	CONSTRAINT CHK_DNI_FormatoCorrecto CHECK (Dni LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT PK_ID_CLIENTE Primary Key (Id_Cliente),
	CONSTRAINT UK_DNI_ClIENTE Unique (Dni)
)
--En telefono no usaremos UNIQUE porque puede haber personas que dejen el numero de otra como referencia
--ejemplo un Hijo que deje el numero del padre como referencia
Create table Contacto (
	Id_Contacto int identity (1,1),
	Telefono varchar(9) not null,
	Id_Cliente int not null,
	CONSTRAINT CHK_Telefono_7_o_9_Digitos
	CHECK (
    -- Opción de 7 dígitos estrictamente numéricos
    (Telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND LEN(Telefono) = 7)
    OR 
    -- Opción de 9 dígitos estrictamente numéricos
    (Telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND LEN(Telefono) = 9)),
	
	Constraint PK_ID_Contacto Primary Key (Id_Contacto)
)

--CREANDO PRIMERA RELACION CLIENTE - CONTACTO
alter table CONTACTO
add constraint FK_Contacto_Cliente Foreign key (id_cliente)
references Cliente(id_cliente) ON DELETE CASCADE; -- Si se elimina el cliente no veo necesario tener el reg. de telf

Create Table Alquiler (
	Id_Alquiler int identity (1,1),
	Id_Cliente int not null,
	Fecha_Inicio date default getdate() not null,
	Fecha_Fin date default getdate() not null,
	Constraint PK_ID_ALQUILER Primary Key (Id_Alquiler), 
	Constraint CK_Validar_FechaFin_FechaInicio Check (Fecha_Fin > = Fecha_Inicio)
)

--Relacionando tabla ALQUILER con CLIENTE
Alter table Alquiler 
add constraint FK_ALQUILER_CLIENTE Foreign key (Id_Cliente)
references Cliente(Id_Cliente) ON DELETE NO ACTION --No agreamos on delete porque SQL server le pone por defecto restric y no pueden haber alquieres sin clientes

Create Table Detalle_Alquiler (
	Id_Alquiler int not null,
	Id_Vehiculo int not null,
	Precio_dia  decimal (10,2) not null,
	Constraint PK_ID_ALQUILER_ID_VEHICULO Primary Key (Id_Alquiler, Id_Vehiculo),
	constraint CHECK_PRECIO_DIA Check (Precio_dia > 0)
)


--Relacionando con tabla DETALLE con ALQUILER
Alter table Detalle_Alquiler
Add Constraint FK_DETALLE_ALQUILER_Y_ALQUILER foreign Key (Id_Alquiler)
References Alquiler (Id_Alquiler) ON DELETE CASCADE --SI NO HAY ALQUILER NO ES NECESARIO GUARDAR DETALLES


Create table Vehiculos (
	Id_Vehiculo int identity (1,1),
	Placa nchar(6) not null,
	Marca nvarchar(20) not null,
	Modelo nvarchar(20) not null,
	Id_Categoria int not null,
	Id_Estado int not null,

	Constraint PK_ID_VEHICULO Primary Key (Id_Vehiculo),
	Constraint UK_PLACA Unique (Placa)
)

--Relacionando Tabla VEHICULOS con DETALLE
Alter table Detalle_Alquiler
Add constraint FK_DETALLE_ALQUILER_VEHICULOS Foreign key (Id_Vehiculo)
References Vehiculos (Id_Vehiculo) ON DELETE NO ACTION --No puede haber un detalle si no hay vehiculos

Create table Estado (
	Id_Estado int identity(1,1),
	Descripcion_Estado nvarchar(20) not null,
	Constraint PK_ID_ESTADO Primary Key (Id_Estado),
	Constraint UK_DESCRIPCION UNIQUE (Descripcion_Estado)
)

--Relacionando tabla VEHICULO con ESTADO
Alter table Vehiculos 
Add Constraint FK_VEHICULO_ESTADO Foreign Key (Id_Estado)
References Estado(Id_Estado) On delete no action --No puede haber vehiculos sin estado


Create Table Categoria (
	Id_Categoria int identity (1,1),
	Descripcion_Categoria nvarchar(20) not null,
	Constraint PK_ID_CATEGORIA Primary Key (Id_Categoria),
	Constraint UK_DESCRIPCION_CAT UNIQUE (Descripcion_Categoria)
)


--Relacionando tabla VEHICULO con CATEGORIA
Alter table Vehiculos 
Add Constraint FK_VEHICULO_CATEGORIA Foreign Key (Id_Categoria)
References Categoria(Id_Categoria) on delete no action -- No puede haber vehiculos sin categoria

--CREAREMOS NUESTROS 3 INDICES

CREATE NONCLUSTERED INDEX IX_DETALLE_VEHICULO
ON Detalle_Alquiler(Id_vehiculo);
-- porque se van a efectuar operaciones diarias para reportes de vehiculos dentro de un detalle

CREATE NONCLUSTERED INDEX IX_ALQUILER_CLIENTE
ON Alquiler (id_cliente);
--Vamos a consultar para reporte diarios la cantidad de alquiler que tiene un cliente.

CREATE NONCLUSTERED INDEX IX_ALQUILER_FECHA
on Alquiler (fecha_inicio, Fecha_Fin)
--vamos a consultar a diario las fechas en las que se efectuaron los alquileres

SELECT name AS ForeignKey, delete_referential_action_desc AS AlBorrar
FROM sys.foreign_keys;