-- Habilitar extensión dblink
CREATE EXTENSION IF NOT EXISTS dblink;

-- Crear base de datos para usuarios si no existe
--SELECT 'CREATE DATABASE universidad'
--WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'universidad')\gexec

-- Conectar a la nueva base de datos
\c universidad

-- Crear extensión en la nueva base de datos
CREATE EXTENSION IF NOT EXISTS dblink;

create schema ingenieria
-- drop schema ingenieria cascade

CREATE TABLE ingenieria.carreras (
	cod_carr int4 NOT NULL,
	nom_carr character varying(50) DEFAULT ''::character varying NOT NULL
);
ALTER TABLE ONLY ingenieria.carreras ADD CONSTRAINT pk_cod_carr PRIMARY KEY (cod_carr );



CREATE TABLE ingenieria.estudiantes (
    cod_e bigint NOT null ,
    nom_e character varying(50) DEFAULT ''::character varying NOT NULL,
    dir_e character varying(50) DEFAULT ''::character varying NOT NULL,
    tel_e int4,
    cod_carr int4,
    f_nac date    
);
ALTER TABLE ONLY ingenieria.estudiantes ADD CONSTRAINT pk_estudiantes PRIMARY KEY (cod_e );
ALTER TABLE ingenieria.estudiantes
    ADD CONSTRAINT fk_cod_carr FOREIGN KEY (cod_carr ) REFERENCES ingenieria.carreras(cod_carr ) ON UPDATE RESTRICT ON DELETE RESTRICT;




CREATE TABLE ingenieria.asignaturas (
    cod_a integer NOT NULL primary key,
    nom_a character varying(50) DEFAULT ''::character varying NOT NULL,
    ih integer NOT NULL,
    cred integer NOT NULL
);



CREATE TABLE ingenieria.autores (
    id_a integer NOT NULL primary key ,
    nom_a character varying(50) DEFAULT ''::character varying NOT NULL
);


CREATE TABLE ingenieria.libros (
    isbn bigint NOT NULL primary key ,
    titulo character varying(50) DEFAULT ''::character varying NOT NULL,
    edicion int4 NOT NULL
);




CREATE TABLE ingenieria.ejemplares (
    num_ej int4 NOT NULL,
    isbn bigint NOT NULL
);
ALTER TABLE ONLY ingenieria.ejemplares ADD CONSTRAINT pk_ejemplares PRIMARY KEY (num_ej, isbn);
ALTER TABLE ONLY ingenieria.ejemplares 
    ADD CONSTRAINT fk_isbn2 FOREIGN KEY (isbn) REFERENCES ingenieria.libros(isbn) ON UPDATE RESTRICT ON DELETE RESTRICT;





CREATE TABLE ingenieria.escribe (
    isbn bigint NOT NULL,
    id_a int4 NOT NULL
);
ALTER TABLE ONLY ingenieria.escribe ADD CONSTRAINT pk_escribe PRIMARY KEY (isbn, id_a);
ALTER TABLE ONLY ingenieria.escribe
    ADD CONSTRAINT fk_isbn FOREIGN KEY (isbn) REFERENCES ingenieria.libros(isbn) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY ingenieria.escribe
    ADD CONSTRAINT fk_id_a FOREIGN KEY (id_a) REFERENCES ingenieria.autores(id_a) ON UPDATE RESTRICT ON DELETE RESTRICT;



CREATE TABLE ingenieria.profesores (
    id_p int NOT NULL primary key,
    nom_p character varying(50) DEFAULT ''::character varying NOT NULL,
    profesion character varying(50) DEFAULT ''::character varying NOT NULL,
    tel_p int NOT NULL
);


CREATE TABLE ingenieria.imparte (
    id_p int NOT NULL,
    cod_a int NOT NULL,
    grupo int NOT NULL,
    horario character varying(50) DEFAULT ''::character varying NOT NULL
);
ALTER TABLE ONLY ingenieria.imparte ADD CONSTRAINT pk_imparte PRIMARY KEY (id_p, cod_a, grupo, horario);
ALTER TABLE ONLY ingenieria.imparte
    ADD CONSTRAINT fk_id_p FOREIGN KEY (id_p) REFERENCES ingenieria.profesores(id_p) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY ingenieria.imparte
    ADD CONSTRAINT fk_cod_a FOREIGN KEY (cod_a) REFERENCES ingenieria.asignaturas(cod_a) ON UPDATE RESTRICT ON DELETE RESTRICT;


CREATE TABLE ingenieria.inscribe (
    cod_e int NOT NULL,
    id_p int NOT NULL,
    cod_a int NOT NULL,
    grupo int NOT NULL,
    n1 NUMERIC(3, 2) NOT NULL,
    n2 NUMERIC(3, 2) NOT NULL,
    n3 NUMERIC(3, 2) NOT NULL
);
ALTER TABLE ONLY ingenieria.inscribe ADD CONSTRAINT pk_inscribe PRIMARY KEY (cod_e, id_p, cod_a, grupo);
ALTER TABLE ONLY ingenieria.inscribe
    ADD CONSTRAINT fk_cod_e FOREIGN KEY (cod_e) REFERENCES ingenieria.estudiantes(cod_e) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY ingenieria.inscribe
    ADD CONSTRAINT fk_id_p FOREIGN KEY (id_p) REFERENCES ingenieria.profesores(id_p) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY ingenieria.inscribe
    ADD CONSTRAINT fk_cod_a FOREIGN KEY (cod_a) REFERENCES ingenieria.asignaturas(cod_a) ON UPDATE RESTRICT ON DELETE RESTRICT;
--ALTER TABLE ONLY ingenieria.inscribe
    --ADD CONSTRAINT fk_grupo FOREIGN KEY (grupo) REFERENCES ingenieria.imparte(grupo) ON UPDATE RESTRICT ON DELETE RESTRICT; 


CREATE TABLE ingenieria.presta (
    cod_e int NOT NULL,
    isbn bigint NOT NULL,
    num_ej int NOT NULL,
	fecha_p date NOT NULL,
    fecha_d date
);
ALTER TABLE ONLY ingenieria.presta ADD CONSTRAINT pk_presta PRIMARY KEY (cod_e, isbn, num_ej, fecha_p);
ALTER TABLE ONLY ingenieria.presta
    ADD CONSTRAINT fk_isbn FOREIGN KEY (isbn, num_ej) REFERENCES ingenieria.ejemplares(isbn, num_ej) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY ingenieria.presta
    ADD CONSTRAINT fk_cod_e2 FOREIGN KEY (cod_e) REFERENCES ingenieria.estudiantes(cod_e) ON UPDATE RESTRICT ON DELETE RESTRICT;


CREATE TABLE ingenieria.referencia (
	cod_a int NOT NULL,
	isbn bigint NOT NULL
);
ALTER TABLE ONLY ingenieria.referencia ADD CONSTRAINT pk_referencia PRIMARY KEY (cod_a, isbn);
ALTER TABLE ONLY ingenieria.referencia
    ADD CONSTRAINT fk_cod_a_2 FOREIGN KEY (cod_a) REFERENCES ingenieria.asignaturas(cod_a) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY ingenieria.referencia
    ADD CONSTRAINT fk_isbn2 FOREIGN KEY (isbn) REFERENCES ingenieria.libros(isbn) ON UPDATE RESTRICT ON DELETE RESTRICT;
