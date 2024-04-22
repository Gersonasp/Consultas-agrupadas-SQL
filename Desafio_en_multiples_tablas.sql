--Requerimientos:
--1.-Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.
--Creacion de tabla Usuarios
/*CREATE TABLE Usuarios (
    id SERIAL,
    email VARCHAR,
    nombre VARCHAR,
    apellido VARCHAR,
    rol VARCHAR
);
INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES
('jeorgeg@example.com', 'Jeorge', 'Guerrero', 'usuario'),
('rdiaz@example.com', 'Roxana', 'Diaz', 'usuario'),
('Carlosmar3@example.com', 'Carlos', 'Martínez', 'usuario'),
('Contrerasl@example.com', 'Lisbeth', 'Contreras', 'administrador'),
('vzambrano4@example.com', 'Victoria', 'Zambrano', 'usuario');

SELECT * FROM Usuarios;

--Creacion de tabla posts
CREATE TABLE Posts (
    id SERIAL,
    título VARCHAR,
    contenido TEXT,
    fecha_creacion DATE,
    fecha_actualizacion DATE,
    destacado BOOLEAN,
    usuario_id BIGINT
);

-- Insertar 5 posts
INSERT INTO Posts (id, título, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
(DEFAULT, 'Prueba', 'Contenido prueba',09-08-2005, 09-08-2006, true, 1),
(DEFAULT, 'desafio', 'Contenido desafio', 09-08-2010, 09-12-2010, true, 1),
(DEFAULT, 'ejercicios', 'Contenido ejercicios', 09-09-2010, 09-01-2011, false, 2),
(DEFAULT, 'autoaprendisaje', 'Contenido Autoaprendisaje', 06-09-2010, 10-01-2011, false, 2),
(DEFAULT,'carrera', 'Contenido Carrera', 09-02-2011, 09-06-2011, true, NULL);
SELECT * from posts;

--creacion tabla comentarios
CREATE TABLE Comentarios (
    id SERIAL,
    contenido TEXT,
    fecha_creacion DATE,
    usuario_id BIGINT,
    post_id BIGINT
);

-- Insertar 5 comentarios
INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Contenido del Comentario 1', CURRENT_TIMESTAMP, 1, 1),
('Contenido del Comentario 2', CURRENT_TIMESTAMP, 2, 1),
('Contenido del Comentario 3', CURRENT_TIMESTAMP, 3, 1),
('Contenido del Comentario 4', CURRENT_TIMESTAMP, 1, 2),
('Contenido del Comentario 5', CURRENT_TIMESTAMP, 2, 2);
SELECT * FROM comentarios;*/

--2.- Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
--nombre y email del usuario junto al título y contenido del post.
SELECT Usuarios.nombre, Usuarios.email, Posts.título, Posts.contenido
FROM Usuarios
INNER JOIN Posts ON Usuarios.id = Posts.usuario_id;

-- 3.- Muestra el id, título y contenido de los posts de los administradores.
--a. El administrador puede ser cualquier id.
SELECT Posts.id, Posts.título, Posts.contenido
FROM Posts
JOIN Usuarios ON Posts.usuario_id = Usuarios.id
WHERE Usuarios.rol = 'administrador';

--4.- Cuenta la cantidad de posts de cada usuario.
--a. La tabla resultante debe mostrar el id e email del usuario junto con la
--cantidad de posts de cada usuario.
SELECT Usuarios.id, Usuarios.email, COUNT(Posts.id) AS cantidad_posts
FROM Usuarios
LEFT JOIN Posts ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id, Usuarios.email;
-- de esta manera cuanta la cantidad de Posts de cada Usuario, utilizando Left join
-- para asegurar todos los usuarios que no tengan Posts, Luego, agrupa los resultados por el id
--y email del usuario y cuenta la cantidad de posts para cada grupo
--La función COUNT() cuenta el número de registros no nulos en la columna especificada.
-- probando con inner join
SELECT Usuarios.id, Usuarios.email, COUNT(Posts.id) AS cantidad_posts
FROM Usuarios
INNER JOIN Posts ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id, Usuarios.email;
--Probando con Right join
SELECT Usuarios.id, Usuarios.email, COUNT(Posts.id) AS cantidad_posts
FROM Usuarios
RIGHT JOIN Posts ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id, Usuarios.email;
--la consulta con LEFT JOIN a mi criterio, es adecuada para contar la cantidad de posts de cada usuario en este escenario.

--5.- Muestra el email del usuario que ha creado más posts.
--  a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT Usuarios.email
FROM Usuarios
LEFT JOIN Posts ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id, Usuarios.email
ORDER BY COUNT(Posts.id) DESC
LIMIT 1;

--6.-Muestra la fecha del último post de cada usuario.
SELECT Usuarios.id, Usuarios.email, MAX(Posts.fecha_creacion) AS ultima_fecha_post
FROM Usuarios
LEFT JOIN Posts ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id, Usuarios.email;

--7.- Muestra el título y contenido del post (artículo) con más comentarios
SELECT Posts.título, Posts.contenido
FROM Posts
JOIN (
    SELECT post_id, COUNT(*) AS cantidad_comentarios
    FROM Comentarios
    GROUP BY post_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
) AS comentarios_count ON Posts.id = comentarios_count.post_id;

--8.-Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
--de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.
SELECT 
    Posts.título AS titulo_post, 
    Posts.contenido AS contenido_post, 
    Comentarios.contenido AS contenido_comentario, 
    Usuarios.email AS email_usuario
FROM 
    Posts
JOIN 
    Comentarios ON Posts.id = Comentarios.post_id
JOIN 
    Usuarios ON Comentarios.usuario_id = Usuarios.id;
    
--9.- Muestra el contenido del último comentario de cada usuario.
SELECT 
    Usuarios.id AS usuario_id,
    Usuarios.email AS email_usuario,
    Comentarios.contenido AS ultimo_comentario
FROM 
    Usuarios
JOIN 
    Comentarios ON Usuarios.id = Comentarios.usuario_id
JOIN (
    SELECT 
        usuario_id, 
        MAX(fecha_creacion) AS ultima_fecha
    FROM 
        Comentarios
    GROUP BY 
        usuario_id
) AS ultimos_comentarios ON Comentarios.usuario_id = ultimos_comentarios.usuario_id 
                           AND Comentarios.fecha_creacion = ultimos_comentarios.ultima_fecha;
                           
--10.- Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT Usuarios.email
FROM Usuarios
LEFT JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
WHERE Comentarios.id IS NULL;
