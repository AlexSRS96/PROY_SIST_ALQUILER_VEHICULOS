Use PROY_SIS_ALQ_AUT
Go

--Insertando valor en tabla ESTADO
Select * from Estado
--Nos pide 3 estados (Disponible, Alquilado, Mantenimiento)
Insert into Estado Values ('Disponible');
Insert into Estado Values ('Alquilado');
Insert into Estado Values ('Mantenimiento');

--Insertando valor en tabla CATEGORIA
Select * From Categoria
--Nos pide 3 Categorias (Economico, SUV, Lujo)
Insert into Categoria values ('Economico');
Insert into Categoria values ('SUV');
Insert into Categoria values ('Lujo');

--Insertando valores de 5 vehiculos 
Select * from Vehiculos
Insert into Vehiculos Values ('AJS123', 'Hyundai', 'Accent', 1, 1);
Insert into Vehiculos Values ('ADJ852', 'Toyota', 'Yaris', 1, 1);
Insert into Vehiculos Values ('SEH951', 'Kia', 'Sportage', 2, 1);
Insert into Vehiculos Values ('HJK785', 'BMW', 'Serie 3', 3, 1);
Insert into Vehiculos Values ('QHU875', 'Audi', 'Q5', 3, 1);
--Nota: Como recien estamos implementando deben estar en disponibles

--Insertando valores de 4 CLIENTES
Select * From Cliente
Insert into Cliente Values ('Julio Valdes Quiroz','79845632');
Insert into Cliente Values ('Ramon Razuri Milei','01025698');
Insert into Cliente Values ('Javier Melendez Ramos','89412456');
Insert into Cliente Values ('Marcelo Gimenez Bellido','26985421');

--Insertando 6 CONTACTOS
Select * from Contacto
Insert into Contacto Values ('974258632', 3);
Insert into Contacto Values ('3891024', 3);
Insert into Contacto Values ('989645258', 2);
Insert into Contacto Values ('978642583', 1);
Insert into Contacto Values ('929102358', 2);
Insert into Contacto Values ('984521365', 4);

--Insertando 8 ALQUILER
Select * from Alquiler
Insert into Alquiler Values (1, '2026-10-10', '2026-10-12')
Insert into Alquiler Values (2, '2026-08-10', '2026-08-14')
Insert into Alquiler Values (3, '2026-01-15', '2026-01-20')
Insert into Alquiler Values (4, '2026-04-20', '2026-04-22')
Insert into Alquiler Values (2, '2026-03-22', '2026-03-27')
Insert into Alquiler Values (3, '2026-02-18', '2026-02-22')
Insert into Alquiler Values (1, '2026-10-20', '2026-10-25')
Insert into Alquiler Values (4, '2026-10-20', '2026-10-28')


--Agregando Columna Fecha devolucion
Alter table Detalle_Alquiler
Add Fecha_devolucion date;

--Agregando 8 DETALLE_ALQUILER y 2 detalle llevara 2 vehiculos alquilados
Insert Into Detalle_Alquiler Values (1, 1, 80, '2026-10-12')
Insert Into Detalle_Alquiler Values (1, 2, 85, '2026-10-12')
Insert Into Detalle_Alquiler Values (2, 4, 180, '2026-08-14')
Insert Into Detalle_Alquiler Values (3, 5, 150, '2026-01-20')
Insert Into Detalle_Alquiler Values (4, 3, 110, '2026-04-22')
Insert Into Detalle_Alquiler Values (5, 2, 85, '2026-03-27')
Insert Into Detalle_Alquiler Values (6, 3, 110, '2026-02-22')
Insert Into Detalle_Alquiler Values (7, 4, 180, null)
Insert Into Detalle_Alquiler Values (8, 1, 80, null)
Insert Into Detalle_Alquiler Values (8, 5, 150, null)

--Realizando consulta para verificar
Select C.Id_Cliente, C.Nombre, A.Fecha_Inicio, a.Fecha_Fin, DT.Id_Alquiler,dt.Id_Vehiculo ,CONCAT(V.Marca,' ',v.Modelo) as Vehiculo_Alquilado, dt.Precio_dia, Dt.Fecha_devolucion 
from Alquiler A inner join Detalle_Alquiler DT on A.Id_Alquiler = DT.Id_Alquiler
				inner join Cliente C on C.Id_Cliente = A.Id_Cliente
				inner join Vehiculos V on V.Id_Vehiculo = DT.Id_Vehiculo

--Upadates a Vehiculos Alquilados con vigencia
Update Vehiculos
set Id_Estado = '2'
where Id_Vehiculo in(1, 4, 5)
--Verificando update
Select V.Id_Vehiculo, CONCAT (V.Marca, ' ', v.Modelo) as Vehiculo, E.Descripcion_Estado
From Vehiculos v inner join Estado E on V.Id_Estado = E.Id_Estado

--Update a vehiculo con estado mantenimiento
Update Vehiculos
set Id_Estado = 3 
Where Id_Vehiculo = 2

/*
	Para cada vehículo, muestra su estado y si tiene alguna línea 
	sin devolver (Fecha_devolucion en NULL). Todo vehículo Alquilado debe mostrar Sí, y los demás, No.

	SELECT v.Id_Vehiculo, e.Descripcion_Estado,
       CASE WHEN EXISTS (SELECT 1 FROM Detalle_Alquiler d
                         WHERE d.Id_Vehiculo = v.Id_Vehiculo
                           AND d.Fecha_devolucion IS NULL)
            THEN 'Sí' ELSE 'No' END AS SinDevolver
FROM Vehiculos v
INNER JOIN Estado e ON e.Id_Estado = v.Id_Estado;

*/

/* SIRVE PARA PODER LIMPIAR LA TABLA 
DELETE FROM Alquiler;
DBCC CHECKIDENT ('Alquiler', RESEED, 0);
*/
