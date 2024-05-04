--tabla de películas
CREATE TABLE peliculas (
    ID SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    anno INTEGER
);
--tabla de etiquetas (tags)
CREATE TABLE tags (
    ID SERIAL PRIMARY KEY,
    tag VARCHAR(32)
);

--tabla para relacionar películas y etiquetas

CREATE TABLE pelicula_tag (
    id INTEGER PRIMARY KEY,
    id_pelicula INTEGER REFERENCES peliculas(ID),
    id_tag INTEGER REFERENCES tags(ID)
);
SELECT * FROM peliculas;

/*2- Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la
segunda película debe tener 2 tags asociados.*/

INSERT INTO peliculas (id, nombre, anno) VALUES
    (1, 'Rambo', 2001),
    (2, 'una pareja explosiva1', 2010),
    (3,'rapidos y furiosos', 2018),
    (4, 'avengers', 2021),
    (5, 'cunfu panda', 2024);
SELECT * from peliculas;

INSERT INTO tags (id, tag) VALUES
    (1, 'Tag1'),
    (2, 'Tag2'),
    (3, 'Tag3'),
    (4, 'Tag4'),
    (5, 'Tag5');
SELECT * FROM tags;

INSERT INTO pelicula_tag (id, id_pelicula, id_tag) VALUES
    (1, 1, 1),
    (2, 1, 2), 
    (3, 1, 3), 
    (4, 2, 4), 
    (5, 2, 5);
SELECT * FROM pelicula_tag;

/*3.Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0.*/
SELECT peliculas.nombre AS pelicula, COALESCE(COUNT(tags.tag), 0) AS cantidad_tags
FROM peliculas
LEFT JOIN pelicula_tag ON peliculas.id = pelicula_tag.id_pelicula
LEFT JOIN tags ON pelicula_tag.id_tag = tags.id
GROUP BY peliculas.id, peliculas.id
ORDER by peliculas.id

/*4.Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y
foráneas y tipos de datos.*/

CREATE TABLE preguntas (
    ID SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta varchar
);

CREATE TABLE usuarios (
    ID SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER
);

CREATE TABLE respuestas (
    ID SERIAL PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER REFERENCES usuarios(id),
    pregunta_id INTEGER REFERENCES preguntas(id)
);


-5. Agrega 5 usuarios y 5 preguntas.
-- Insertar usuarios
INSERT INTO usuarios (nombre, edad) VALUES
    ('Gerson', 33),
    ('Lisbeth', 30),
    ('Grecia', 07),
    ('Asdrubal', 51),
    ('lesther', 32);

-- Insertar preguntas
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES
    ('¿Cuál es la capital de Francia?', 'París'),
    ('¿Quién escribió "Don Quijote de la Mancha"?', 'Miguel de Cervantes'),
    ('¿En qué año se firmó la Declaración de Independencia de Estados Unidos?', '1776'),
    ('¿Cuál es el símbolo químico del agua?', 'H2O'),
    ('¿Cuál es el planeta más grande del sistema solar?', 'Júpiter');
   
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id)
VALUES
    ('París', 1, 1),  
    ('París', 2, 1),  
    ('Miguel de Cervantes', 3, 2), 
    ('Madrid', 4, 3), 
    ('H2O', 5, 4),    
    ('Saturno', 1, 5);
    
SELECT * FROM preguntas;
SELECT * FROM usuarios;
SELECT * FROM respuestas;

/*6.Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta)*/
SELECT usuarios.id, usuarios.nombre,
       COUNT(respuestas.id) AS respuestas_correctas_totales
FROM usuarios
LEFT JOIN respuestas ON usuarios.id = respuestas.usuario_id
INNER JOIN preguntas ON respuestas.pregunta_id = preguntas.id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY usuarios.id, usuarios.nombre
ORDER by usuarios.id;

/*7.Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
correctamente.*/
SELECT preguntas.id, preguntas.pregunta,
       COUNT(respuestas.usuario_id) AS usuarios_correctos
FROM preguntas
LEFT JOIN respuestas ON preguntas.id = respuestas.pregunta_id
INNER JOIN usuarios ON respuestas.usuario_id = usuarios.id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY preguntas.id, preguntas.pregunta;

/*8.Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la
implementación borrando el primer usuario.*/
ALTER TABLE respuestas
ADD CONSTRAINT fk_usuario_respuesta
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id)
ON DELETE CASCADE;

DELETE FROM respuestas
WHERE usuario_id = 1;

DELETE FROM usuarios WHERE id = 1;

SELECT * FROM usuarios;
SELECT * FROM respuestas;

/*9.Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos.*/
ALTER TABLE usuarios
ADD CONSTRAINT check_edad_minima
CHECK (edad >= 18);

INSERT INTO usuarios (nombre, edad)
VALUES ('Juan', 18);

/*10.Altera la tabla existente de usuarios agregando el campo email. Debe tener la
restricción de ser único.*/
ALTER TABLE usuarios add COLUMN email varchar;

ALTER TABLE usuarios
ADD CONSTRAINT email_unique UNIQUE(email);

UPDATE usuarios
SET email = 'anthonella@gmail.com.com' -- se puede establecer un valor por defecto para el campo "email"
WHERE id = 2;
SELECT * FROM usuarios;




