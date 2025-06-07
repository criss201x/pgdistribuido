

--COPY carreras FROM '/csv-data/carreras.csv' WITH (FORMAT csv, HEADER true, delimiter ',');
COPY asignaturas from '/csv-data/Asignaturas_Ciencias.csv' CSV DELIMITER ';' header;

COPY profesores from '/csv-data/Profesores_Ciencias.csv' CSV DELIMITER ';' header;

COPY libros  from '/csv-data/libros_Ciencias.csv' CSV DELIMITER ';' header;

COPY autores from '/csv-data/autores_ciencias.csv' CSV DELIMITER ';' header;

COPY carreras from '/csv-data/Carreras_Ciencias.csv' CSV DELIMITER ';' header;

COPY estudiantes from '/csv-data/Estudiantes_Ciencias.csv' CSV DELIMITER ';' header;

COPY ejemplares from '/csv-data/ejemplares_Ciencias.csv' CSV DELIMITER ';' header;

COPY escribe from '/csv-data/escribe_ciencias.csv' CSV DELIMITER ';' header;

COPY imparte from '/csv-data/Imparte_Ciencias.csv' CSV DELIMITER ';' header;

COPY inscribe from '/csv-data/Inscribe_Ciencias.csv' CSV DELIMITER ';' header;

COPY presta from '/csv-data/presta_ciencias.csv' CSV DELIMITER ';' header;

COPY referencia from '/csv-data/referencia_ciencias.csv' CSV DELIMITER ';' header;









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