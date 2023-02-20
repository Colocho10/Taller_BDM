CREATE DATABASE MUSEODEARTE;

USE MUSEODEARTE;

CREATE TABLE Piezas (
cod_pieza CHAR(5) PRIMARY KEY NOT NULL,
nombre_pieza VARCHAR(50)
)

CREATE TABLE Exposicion (
id_exposicion CHAR(5) PRIMARY KEY NOT NULL,
cod_pieza CHAR(5),
id_pintor CHAR(5),
precio DECIMAL(15,2)
)

CREATE TABLE Pintores (
id_pintor CHAR(5) PRIMARY KEY NOT NULL,
nombre VARCHAR(40)
)

ALTER TABLE Exposicion add constraint fk_ex_pintor 
FOREIGN KEY (id_pintor) references Pintores(id_pintor)

ALTER TABLE Exposicion add constraint fk_ex_pieza 
FOREIGN KEY (cod_pieza) references Piezas(cod_pieza)

--------- AGREGANDO CAMPOS A TABLAS -----------

-----------Tabla Piezas-----------
INSERT Piezas VALUES ('PA001', 'La última cena')
INSERT Piezas VALUES ('PA002', 'La Gioconda')
INSERT Piezas VALUES ('PA003', 'La Noche Estrellada')
INSERT Piezas VALUES ('PA004', 'Las Tres Gracias')
INSERT Piezas VALUES ('PA005', 'El grito')
INSERT Piezas VALUES ('PA006', 'La Guernica')
INSERT Piezas VALUES ('PA007', 'La Creación de Adán')
INSERT Piezas VALUES ('PA008', 'Los Girasoles')
INSERT Piezas VALUES ('PA009', 'La Tentación de San Antonio')
INSERT Piezas VALUES ('PA010', 'Los fusilamiento del 3 de mayo')
INSERT Piezas VALUES ('PA011', 'El Taller de BD')


----------Tabla Pintores-----------
INSERT Pintores VALUES ('NA001', 'Goya')
INSERT Pintores VALUES ('NA002', 'Dalí')
INSERT Pintores VALUES ('NA003', 'Van Gogh')
INSERT Pintores VALUES ('NA004', 'Miguel Angel')
INSERT Pintores VALUES ('NA005', 'Pablo Picasso')
INSERT Pintores VALUES ('NA006', 'Rubens')
INSERT Pintores VALUES ('NA007', 'Da Vinci')
INSERT Pintores VALUES ('NA008', 'Kevin')


------------------Tabla Exposicion-----------
INSERT Exposicion VALUES ('EX001', 'PA001', 'NA007', 12000.80)
INSERT Exposicion VALUES ('EX002', 'PA002', 'NA007', 13500.70)
INSERT Exposicion VALUES ('EX003', 'PA003', 'NA003', 18000.13)
INSERT Exposicion VALUES ('EX004', 'PA004', 'NA006', 25000.80)
INSERT Exposicion VALUES ('EX005', 'PA005', 'NA003', 30879.00)
INSERT Exposicion VALUES ('EX006', 'PA006', 'NA005', 25000.75)
INSERT Exposicion VALUES ('EX007', 'PA007', 'NA004', 50000.75)
INSERT Exposicion VALUES ('EX008', 'PA008', 'NA003', 10000.80)
INSERT Exposicion VALUES ('EX009', 'PA009', 'NA002', 13000.10)
INSERT Exposicion VALUES ('EX010', 'PA010', 'NA001', 09000.05)
INSERT Exposicion VALUES ('EX011', 'PA011', 'NA008', NULL)

---------- --------------QUERYS----------------------------------
--1--
SELECT nombre_pieza FROM Piezas

--2--
SELECT * FROM Pintores

--3--
SELECT ROUND(AVG(precio), 2) AS [precio_med] FROM Exposicion

--4--
SELECT nombre AS ["El Grito"] FROM Pintores WHERE 
id_pintor=(SELECT id_pintor FROM Exposicion 
WHERE cod_pieza=(SELECT cod_pieza FROM Piezas WHERE nombre_pieza='El grito'))


--5--
SELECT nombre_pieza AS [Autor Van Gogh: Piezas Expuestas] FROM Piezas WHERE cod_pieza IN 
(SELECT cod_pieza FROM Exposicion 
WHERE id_pintor=(SELECT id_pintor FROM Pintores WHERE nombre='Van Gogh'))

--6--
SELECT MAX(precio) AS [Pieza más cara] FROM Exposicion

--7--
SELECT TOP 3 Pintores.nombre, Piezas.nombre_pieza, Exposicion.precio FROM ((Pintores INNER JOIN Exposicion 
ON Pintores.id_pintor = Exposicion.id_pintor) INNER JOIN Piezas ON Piezas.cod_pieza = Exposicion.cod_pieza) 
ORDER BY Exposicion.precio DESC

--8-- Pe: Piezas en exposixion--- Cp: Cantidad de Cuadros-----------------
SELECT Pe.nombre, Cp.[Cantidad_piezas] FROM (Pintores AS Pe INNER JOIN 
(SELECT id_pintor, COUNT(cod_pieza) AS [Cantidad_piezas] FROM Exposicion GROUP BY id_pintor) 
AS Cp ON Pe.id_pintor = Cp.id_pintor)

--9--
SELECT nombre_pieza FROM Piezas WHERE cod_pieza IN 
(SELECT cod_pieza FROM Exposicion WHERE id_pintor IN (SELECT id_pintor FROM Pintores 
WHERE nombre IN ('Van Gogh', 'Da Vinci')))

--10--
SELECT cod_pieza AS [Código], id_pintor AS [Id_pintor], precio + 1 AS [Precio Aumentado] 
FROM Exposicion

--11--
UPDATE Pintores SET nombre = 'Vincent Van Gogh' WHERE nombre = 'Van Gogh'
SELECT * FROM Pintores

--12--
UPDATE Pintores SET nombre = 'Leonardo Da Vinci' WHERE nombre = 'Da Vinci'
SELECT * FROM Pintores

--13--
DELETE FROM Exposicion WHERE precio IS NULL
SELECT * FROM Exposicion

--14--------------------- Coe:cantidad de obras expuestas-----------------------------------------------
DELETE FROM Exposicion WHERE id_exposicion = (SELECT id_exposicion FROM Exposicion INNER JOIN 
(SELECT TOP 1 id_pintor, COUNT(cod_pieza) AS piezas FROM Exposicion GROUP BY id_pintor ORDER BY Piezas ASC) 
AS Coe ON Exposicion.id_pintor = Coe.id_pintor)

SELECT * FROM Exposicion