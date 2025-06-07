-- Crear rol para estudiantes y dar permisos
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT cod_e FROM estudiantes LOOP
        -- Crea el usuario si no existe
        EXECUTE format('DO $do$ BEGIN IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = %L) THEN CREATE USER %I WITH PASSWORD %L; END IF; END $do$', rec.cod_e, rec.cod_e, rec.cod_e);
        -- Da permisos de consulta sobre la vista
        EXECUTE format('GRANT SELECT ON estudiante_FacIng TO %I;', rec.cod_e);
    END LOOP;
END $$;

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT id_p FROM profesores LOOP
        -- Crea el usuario si no existe
        EXECUTE format('DO $do$ BEGIN IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = %L) THEN CREATE USER %I WITH PASSWORD %L; END IF; END $do$', rec.id_p, rec.id_p, rec.id_p);
        -- Da permisos de consulta sobre la vista
        EXECUTE format('GRANT SELECT ON profacIng TO %I;', rec.cod_e);
    END LOOP;
END $$;

