

COPY ingenieria.carreras FROM '/csv-data/carreras.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.estudiantes FROM '/csv-data/estudiantes.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.asignaturas FROM '/csv-data/asignaturas.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.autores FROM '/csv-data/autores_Med.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.libros FROM '/csv-data/libros_Med.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.ejemplares FROM '/csv-data/ejemplares_Med.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.escribe FROM '/csv-data/escribe_Med.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.profesores FROM '/csv-data/profesores.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.imparte FROM '/csv-data/imparte.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.inscribe FROM '/csv-data/inscribe.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.presta FROM '/csv-data/presta_Med.csv' WITH (FORMAT csv, HEADER true, delimiter ';');

COPY ingenieria.referencia FROM '/csv-data/referencia_Med.csv' WITH (FORMAT csv, HEADER true, delimiter ';');


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
    SELECT COUNT(*) INTO carreras FROM ingenieria.carreras;
    RAISE NOTICE 'carreras cargadas: %', carreras;
    SELECT COUNT(*) INTO estudiantes FROM ingenieria.estudiantes;
    RAISE NOTICE 'estudiantes cargados: %', estudiantes;
    SELECT COUNT(*) INTO asignaturas FROM ingenieria.asignaturas;
    RAISE NOTICE 'asignaturas cargadas: %', asignaturas;
    SELECT COUNT(*) INTO autores FROM ingenieria.autores;
    RAISE NOTICE 'autores cargados: %', autores;
    SELECT COUNT(*) INTO libros FROM ingenieria.libros;
    RAISE NOTICE 'libros cargados: %', libros;
    SELECT COUNT(*) INTO ejemplares FROM ingenieria.ejemplares;
    RAISE NOTICE 'ejemplares cargados: %', ejemplares;
    SELECT COUNT(*) INTO escribe FROM ingenieria.escribe;
    RAISE NOTICE 'escribe cargados: %', escribe;
    SELECT COUNT(*) INTO profesores FROM ingenieria.profesores;
    RAISE NOTICE 'profesores cargados: %', profesores;
    SELECT COUNT(*) INTO imparte FROM ingenieria.imparte;
    RAISE NOTICE 'imparte cargados: %', imparte;
    SELECT COUNT(*) INTO inscribe FROM ingenieria.inscribe;
    RAISE NOTICE 'inscribe cargados: %', inscribe;
    SELECT COUNT(*) INTO presta FROM ingenieria.presta;
    RAISE NOTICE 'presta cargados: %', presta;
    SELECT COUNT(*) INTO referencia FROM ingenieria.referencia;
    RAISE NOTICE 'referencia cargados: %', referencia;
END $$;