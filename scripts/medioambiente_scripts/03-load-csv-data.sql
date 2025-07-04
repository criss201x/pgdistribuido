

COPY asignaturas(cod_a, nom_a, int_h, creditos)
from '/csv-data/Asignaturas_Med.csv' CSV DELIMITER ';' header;
select * from asignaturas;

COPY carreras(id_carr,nom_carr, reg_calif)
from '/csv-data/Carreras_Med.csv' CSV DELIMITER ';' header;
select * from carreras;

COPY profesores(id_p,nom_p, dir_p, Profesion, tel_p)
from '/csv-data/Profesores_Med.csv' CSV DELIMITER ';' header;
select * from profesores;

COPY estudiantes(cod_e,nom_e,dir_e,tel_e,id_carr,fech_nac)
from '/csv-data/Estudiantes_Med.csv' CSV DELIMITER ';' header;
select * from estudiantes;

COPY libros(isbn,titulo,edicion, editorial)
from '/csv-data/libros_Med.csv' CSV DELIMITER ';' header;
select * from libros;

COPY autores(id_a,nom_a, nacionalidad)
from '/csv-data/autores_Med.csv' CSV DELIMITER ';' header;

COPY ejemplares(num_ej,isbn)
from '/csv-data/ejemplares_Med.csv' CSV DELIMITER ';' header;
select * from ejemplares;

COPY escribe(isbn,id_a)
from '/csv-data/escribe_Med.csv' CSV DELIMITER ';' header;
select * from escribe;

COPY imparte(id_p,cod_a,grupo,horario)
from '/csv-data/Imparte_Med.csv' CSV DELIMITER ';' header;
select * from imparte;

COPY inscribe(cod_e,id_p,cod_a,grupo,n1,n2,n3)
from '/csv-data/Inscribe_Med.csv' CSV DELIMITER ';' header;
select * from inscribe;

COPY presta(cod_e,isbn,num_ej,fecha_p,fecha_d)
from '/csv-data/presta_Med.csv' CSV DELIMITER ';' header;
select * from presta;

COPY referencia(cod_a,isbn)
from '/csv-data/referencia_Med.csv' CSV DELIMITER ';' header;
select * from referencia;

-- Asegura que la tabla carreras tenga la columna id_coordinador y la FK a profesores
alter table carreras add column if not exists id_coordinador int;
alter table carreras
    add constraint fk_carreras_coordinador
    foreign key (id_coordinador) references profesores(id_p);


-- Verificar carga de usuarios
DO $$
DECLARE
    carreras INTEGER;
    estudiantes INTEGER;
    asignaturas INTEGER;
    autores INTEGER;
    libros INTEGER;
    ejemplares INTEGER;
    escribe INTEGER;
    profesores INTEGER;
    imparte INTEGER;
    inscribe INTEGER;
    presta INTEGER;
    referencia INTEGER;
BEGIN
    SELECT COUNT(*) INTO carreras FROM carreras;
    RAISE NOTICE 'carreras cargadas: %', carreras;
    SELECT COUNT(*) INTO estudiantes FROM estudiantes;
    RAISE NOTICE 'estudiantes cargados: %', estudiantes;
    SELECT COUNT(*) INTO asignaturas FROM asignaturas;
    RAISE NOTICE 'asignaturas cargadas: %', asignaturas;
    SELECT COUNT(*) INTO autores FROM autores;
    RAISE NOTICE 'autores cargados: %', autores;
    SELECT COUNT(*) INTO libros FROM libros;
    RAISE NOTICE 'libros cargados: %', libros;
    SELECT COUNT(*) INTO ejemplares FROM ejemplares;
    RAISE NOTICE 'ejemplares cargados: %', ejemplares;
    SELECT COUNT(*) INTO escribe FROM escribe;
    RAISE NOTICE 'escribe cargados: %', escribe;
    SELECT COUNT(*) INTO profesores FROM profesores;
    RAISE NOTICE 'profesores cargados: %', profesores;
    SELECT COUNT(*) INTO imparte FROM imparte;
    RAISE NOTICE 'imparte cargados: %', imparte;
    SELECT COUNT(*) INTO inscribe FROM inscribe;
    RAISE NOTICE 'inscribe cargados: %', inscribe;
    SELECT COUNT(*) INTO presta FROM presta;
    RAISE NOTICE 'presta cargados: %', presta;
    SELECT COUNT(*) INTO referencia FROM referencia;
    RAISE NOTICE 'referencia cargados: %', referencia;
END $$;