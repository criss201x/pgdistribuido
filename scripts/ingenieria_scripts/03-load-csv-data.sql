--COPY carreras FROM '/csv-data/carreras.csv' WITH (FORMAT csv, HEADER true, delimiter ',');
COPY carreras FROM '/csv-data/carreras.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY estudiantes FROM '/csv-data/estudiantes.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY asignaturas FROM '/csv-data/asignaturas.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY autores FROM '/csv-data/autores.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY libros FROM '/csv-data/libros.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY ejemplares FROM '/csv-data/ejemplares.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY escribe FROM '/csv-data/escribe.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY profesores FROM '/csv-data/profesores.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY imparte FROM '/csv-data/imparte.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY inscribe FROM '/csv-data/inscribe.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY presta FROM '/csv-data/presta.csv' WITH (FORMAT csv, HEADER true, delimiter ',');

COPY referencia FROM '/csv-data/referencia.csv' WITH (FORMAT csv, HEADER true, delimiter ',');






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