CREATE TABLE INSCRITOS(
 cantidad INT, 
 fecha DATE, 
 fuente VARCHAR);

INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 44, '01/01/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 56, '01/01/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 39, '01/02/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 81, '01/02/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 12, '01/03/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 91, '01/03/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 48, '01/04/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 45, '01/04/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 55, '01/05/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 33, '01/05/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 18, '01/06/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 12, '01/06/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 34, '01/07/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 24, '01/07/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 83, '01/08/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 99, '01/08/2021', 'Página' );

select * from inscritos 

select count(*) from inscritos 

select sum(cantidad) as total_inscritos from inscritos

select * from inscritos where fecha <= (select min(fecha)from inscritos);

--4. ¿Cuántos inscritos hay por día? (Indistintamente de la fuente de inscripción) (1 Punto)

select fuente, sum(cantidad) as inscritos_por_fuente from inscritos group by fuente;

--6. ¿Qué día se inscribió la mayor cantidad de personas? 
--Y ¿Cuántas personas se inscribieron en ese día? (1 Punto)

select fecha, sum(cantidad) as total_inscritos from inscritos 
group by fecha order by total_inscritos desc limit 1;

--7. ¿Qué días se inscribieron la mayor cantidad de personas utilizando el blog? 
--¿Cuántas personas fueron? (1 Punto) 
--HINT: si hay más de un registro, tomar el primero 
select fecha, sum(cantidad) as total_inscritos_blog from inscritos 
where fuente = 'Blog'
group by fecha order by total_inscritos_blog desc limit 1;


--¿Cuál es el promedio de personas inscritas por día? 
--Toma en consideración que la base de datos tiene un registro de 8 días,
--es decir, se obtendrán 8 promedios.

select fecha, avg(cantidad) as inscritos_por_dia
from inscritos group by Fecha order by fecha asc;

--9. ¿Qué días se inscribieron más de 50 personas? 

select fecha, sum(cantidad) as Total_inscritos from inscritos 
group by fecha having sum(cantidad)> 50;


--10. ¿Cuál es el promedio por día de personas inscritas? 
--Considerando sólo calcular desde el tercer día. (1 Punto)

select fecha, avg(cantidad) as Promedio_por_dia
from inscritos where fecha >= (select fecha from inscritos group by fecha 
order by fecha limit 1 offset 2) group by fecha order by fecha;

