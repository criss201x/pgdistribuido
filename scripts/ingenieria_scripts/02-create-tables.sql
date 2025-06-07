-- Habilitar extensión dblink
CREATE EXTENSION IF NOT EXISTS dblink;

-- Crear base de datos para usuarios si no existe
--SELECT 'CREATE DATABASE universidad'
--WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'universidad')\gexec

-- Conectar a la nueva base de datos
\c universidad

-- Crear extensión en la nueva base de datos
CREATE EXTENSION IF NOT EXISTS dblink;


drop table if exists asignaturas;
create table asignaturas(
cod_a bigint constraint pk_cod_a primary key check (cod_a>0),
nom_a varchar(256) not null,
int_h int not null check (int_h between 1 and 3),
creditos int not null check (creditos between 1 and 3),
constraint uq_nom_a UNIQUE (nom_a));

drop table if exists profesores;
create table profesores(
id_p int constraint pk_id_p primary key check (id_p>11000),
nom_p varchar(75) not null,
dir_p varchar (75) not null,
Profesion varchar(75) not null,
tel_p bigint not null check (tel_p>1000000000),
constraint uq_profesores UNIQUE (nom_p, profesion));
 
  drop table if exists libros;
create table libros(
isbn bigint constraint pk_isbn primary key check (isbn>100000000),
titulo varchar(76) not null,
edicion int not null check (edicion>0),
editorial varchar (76) not null,
constraint uq_libro UNIQUE (titulo, edicion, editorial));
 
drop table if exists autores;
create table autores(
id_a bigint constraint pk_id_au primary key check (id_a>1000),
nom_a varchar(256) not null,
nacionalidad varchar (20) not null,
constraint uq_autor UNIQUE (nom_a, nacionalidad));
 
drop table if exists carreras;
create table carreras(
id_carr bigint constraint pk_cod_carr primary key check (id_carr>900),
nom_carr varchar(256) not null,
reg_calif varchar (256) not null,
constraint uq_nom_carr UNIQUE (nom_carr));

drop table if exists estudiantes;
create table estudiantes(
cod_e bigint constraint pk_cod_e primary key check (cod_e>20249500000),
nom_e varchar(75) not null,
dir_e varchar(60) not null,
tel_e bigint null check (tel_e>1000000000),
id_carr int not null check (id_carr>900),
fech_nac date not null check (fech_nac between '1970-01-01' and '2009-12-31'),
constraint fk_estudiantes_carreras FOREIGN KEY (id_carr) REFERENCES carreras(id_carr),
constraint uq_estudiante UNIQUE (nom_e, fech_nac));

drop table if exists ejemplares;
create table ejemplares(
num_ej int not null check (num_ej>0),
isbn bigint not null check (isbn>100000000), 
constraint pk_ejemplares primary key (num_ej, isbn),
constraint fk_ejemplares_libros FOREIGN KEY (isbn) REFERENCES libros(isbn));

drop table if exists escribe;
create table escribe(
isbn bigint constraint rf_libros references libros (isbn),
id_a int  constraint rf_autores references autores (id_a),
constraint pk_escribe primary key (isbn, id_a));
 
create table imparte(
id_p int constraint rf_profesores references profesores (id_p) check (id_p>10000),
cod_a bigint constraint rf_asignaturas references asignaturas (cod_a) check (cod_a>0),
grupo int not null check (grupo between 1 and 5),
horario varchar(76) not null,
constraint pk_imparte primary key (id_p, cod_a, grupo));

drop table if exists inscribe;
create table inscribe(
cod_e bigint constraint rf_estudiantes references estudiantes (cod_e) check (cod_e>20249500000),
id_p int not null check (id_p>11000),
cod_a bigint not null check (cod_a>0),
grupo int not null check (grupo between 1 and 5),
n1 numeric(2,1) null check (n1 between 0 and 5),
n2 numeric(2,1) null check (n2 between 0 and 5),
n3 numeric(2,1) null check (n3 between 0 and 5),
constraint pk_inscribe primary key (cod_e, id_p, cod_a, grupo),
constraint fk_inscribe_imparte FOREIGN KEY (id_p, cod_a, grupo) REFERENCES imparte (id_p, cod_a, grupo));

drop table if exists presta;
create table presta(
cod_e bigint constraint rf_estudiantes references estudiantes (cod_e) check (cod_e>20249500000),
isbn bigint not null check (isbn>100000000),
num_ej int not null check (num_ej>0),
fecha_p date not null,
fecha_d date null,
constraint pk_presta primary key (isbn, cod_e, num_ej, fecha_p ));

create table referencia(
cod_a bigint constraint rf_asignaturas references asignaturas (cod_a) check (cod_a>0),
isbn bigint constraint rf_libros references libros (isbn) check (isbn>100000000),
constraint pk_referencia primary key (isbn, cod_a));



-- Asegura que la tabla carreras tenga la columna id_coordinador y la FK a profesores
alter table carreras add column if not exists id_coordinador int;
alter table carreras
    add constraint fk_carreras_coordinador
    foreign key (id_coordinador) references profesores(id_p);

-- Asigna el profesor 11001 como coordinador en todas las carreras (ajusta el WHERE si es necesario)
update carreras set id_coordinador = 11001;



-- Tabla de log para actualizaciones de notas por coordinador
create table if not exists log_actualizacion_notas (
    id_log serial primary key,
    id_coordinador int not null,
    cod_e bigint not null,
    cod_a bigint not null,
    grupo int not null,
    nota_anterior1 numeric(2,1),
    nota_anterior2 numeric(2,1),
    nota_anterior3 numeric(2,1),
    nota_nueva1 numeric(2,1),
    nota_nueva2 numeric(2,1),
    nota_nueva3 numeric(2,1),
    fecha_hora timestamp default current_timestamp
);

 
