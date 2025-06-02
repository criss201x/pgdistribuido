-- Sincroniza la tabla carreras
CREATE OR REPLACE FUNCTION sync_carreras_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT cod_carr, nom_carr FROM ingenieria.carreras'
        ) AS t(cod_carr int, nom_carr varchar)
    LOOP
        INSERT INTO ingenieria.carreras (cod_carr, nom_carr)
        VALUES (rec.cod_carr, rec.nom_carr)
        ON CONFLICT (cod_carr) DO UPDATE SET nom_carr = EXCLUDED.nom_carr;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla estudiantes
CREATE OR REPLACE FUNCTION sync_estudiantes_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT cod_e, nom_e, dir_e, tel_e, cod_carr, f_nac FROM ingenieria.estudiantes'
        ) AS t(cod_e bigint, nom_e varchar, dir_e varchar, tel_e int, cod_carr int, f_nac date)
    LOOP
        INSERT INTO ingenieria.estudiantes (cod_e, nom_e, dir_e, tel_e, cod_carr, f_nac)
        VALUES (rec.cod_e, rec.nom_e, rec.dir_e, rec.tel_e, rec.cod_carr, rec.f_nac)
        ON CONFLICT (cod_e) DO UPDATE SET
            nom_e = EXCLUDED.nom_e,
            dir_e = EXCLUDED.dir_e,
            tel_e = EXCLUDED.tel_e,
            cod_carr = EXCLUDED.cod_carr,
            f_nac = EXCLUDED.f_nac;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla asignaturas
CREATE OR REPLACE FUNCTION sync_asignaturas_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT cod_a, nom_a, ih, cred FROM ingenieria.asignaturas'
        ) AS t(cod_a int, nom_a varchar, ih int, cred int)
    LOOP
        INSERT INTO ingenieria.asignaturas (cod_a, nom_a, ih, cred)
        VALUES (rec.cod_a, rec.nom_a, rec.ih, rec.cred)
        ON CONFLICT (cod_a) DO UPDATE SET
            nom_a = EXCLUDED.nom_a,
            ih = EXCLUDED.ih,
            cred = EXCLUDED.cred;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla autores
CREATE OR REPLACE FUNCTION sync_autores_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT id_a, nom_a FROM ingenieria.autores'
        ) AS t(id_a int, nom_a varchar)
    LOOP
        INSERT INTO ingenieria.autores (id_a, nom_a)
        VALUES (rec.id_a, rec.nom_a)
        ON CONFLICT (id_a) DO UPDATE SET nom_a = EXCLUDED.nom_a;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla libros
CREATE OR REPLACE FUNCTION sync_libros_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT isbn, titulo, edicion FROM ingenieria.libros'
        ) AS t(isbn bigint, titulo varchar, edicion int)
    LOOP
        INSERT INTO ingenieria.libros (isbn, titulo, edicion)
        VALUES (rec.isbn, rec.titulo, rec.edicion)
        ON CONFLICT (isbn) DO UPDATE SET titulo = EXCLUDED.titulo, edicion = EXCLUDED.edicion;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla ejemplares
CREATE OR REPLACE FUNCTION sync_ejemplares_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT num_ej, isbn FROM ingenieria.ejemplares'
        ) AS t(num_ej int, isbn bigint)
    LOOP
        INSERT INTO ingenieria.ejemplares (num_ej, isbn)
        VALUES (rec.num_ej, rec.isbn)
        ON CONFLICT (num_ej, isbn) DO NOTHING;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla escribe
CREATE OR REPLACE FUNCTION sync_escribe_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT isbn, id_a FROM ingenieria.escribe'
        ) AS t(isbn bigint, id_a int)
    LOOP
        INSERT INTO ingenieria.escribe (isbn, id_a)
        VALUES (rec.isbn, rec.id_a)
        ON CONFLICT (isbn, id_a) DO NOTHING;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla profesores
CREATE OR REPLACE FUNCTION sync_profesores_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT id_p, nom_p, profesion, tel_p FROM ingenieria.profesores'
        ) AS t(id_p int, nom_p varchar, profesion varchar, tel_p int)
    LOOP
        INSERT INTO ingenieria.profesores (id_p, nom_p, profesion, tel_p)
        VALUES (rec.id_p, rec.nom_p, rec.profesion, rec.tel_p)
        ON CONFLICT (id_p) DO UPDATE SET nom_p = EXCLUDED.nom_p, profesion = EXCLUDED.profesion, tel_p = EXCLUDED.tel_p;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla imparte
CREATE OR REPLACE FUNCTION sync_imparte_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT id_p, cod_a, grupo, horario FROM ingenieria.imparte'
        ) AS t(id_p int, cod_a int, grupo int, horario varchar)
    LOOP
        INSERT INTO ingenieria.imparte (id_p, cod_a, grupo, horario)
        VALUES (rec.id_p, rec.cod_a, rec.grupo, rec.horario)
        ON CONFLICT (id_p, cod_a, grupo, horario) DO NOTHING;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla inscribe
CREATE OR REPLACE FUNCTION sync_inscribe_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT cod_e, id_p, cod_a, grupo, n1, n2, n3 FROM ingenieria.inscribe'
        ) AS t(cod_e int, id_p int, cod_a int, grupo int, n1 numeric, n2 numeric, n3 numeric)
    LOOP
        INSERT INTO ingenieria.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3)
        VALUES (rec.cod_e, rec.id_p, rec.cod_a, rec.grupo, rec.n1, rec.n2, rec.n3)
        ON CONFLICT (cod_e, id_p, cod_a, grupo) DO UPDATE SET n1 = EXCLUDED.n1, n2 = EXCLUDED.n2, n3 = EXCLUDED.n3;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla presta
CREATE OR REPLACE FUNCTION sync_presta_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT cod_e, isbn, num_ej, fecha_p, fecha_d FROM ingenieria.presta'
        ) AS t(cod_e int, isbn bigint, num_ej int, fecha_p date, fecha_d date)
    LOOP
        INSERT INTO ingenieria.presta (cod_e, isbn, num_ej, fecha_p, fecha_d)
        VALUES (rec.cod_e, rec.isbn, rec.num_ej, rec.fecha_p, rec.fecha_d)
        ON CONFLICT (cod_e, isbn, num_ej, fecha_p) DO UPDATE SET fecha_d = EXCLUDED.fecha_d;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Sincroniza la tabla referencia
CREATE OR REPLACE FUNCTION sync_referencia_from_node(remote_host TEXT)
RETURNS VOID AS
$$
DECLARE
    rec RECORD;
BEGIN
    PERFORM dblink_connect('sync_conn',
        format('host=%s port=5432 user=postgres password=postgres dbname=universidad', remote_host));

    FOR rec IN
        SELECT * FROM dblink('sync_conn',
            'SELECT cod_a, isbn FROM ingenieria.referencia'
        ) AS t(cod_a int, isbn bigint)
    LOOP
        INSERT INTO ingenieria.referencia (cod_a, isbn)
        VALUES (rec.cod_a, rec.isbn)
        ON CONFLICT (cod_a, isbn) DO NOTHING;
    END LOOP;

    PERFORM dblink_disconnect('sync_conn');
END;
$$ LANGUAGE plpgsql;

-- Función general para sincronizar todas las tablas principales
CREATE OR REPLACE FUNCTION sync_all_from_node(remote_host TEXT)
RETURNS TEXT AS
$$
BEGIN
    PERFORM sync_carreras_from_node(remote_host);
    PERFORM sync_estudiantes_from_node(remote_host);
    PERFORM sync_asignaturas_from_node(remote_host);
    PERFORM sync_autores_from_node(remote_host);
    PERFORM sync_libros_from_node(remote_host);
    PERFORM sync_ejemplares_from_node(remote_host);
    PERFORM sync_escribe_from_node(remote_host);
    PERFORM sync_profesores_from_node(remote_host);
    PERFORM sync_imparte_from_node(remote_host);
    PERFORM sync_inscribe_from_node(remote_host);
    PERFORM sync_presta_from_node(remote_host);
    PERFORM sync_referencia_from_node(remote_host);
    RETURN 'Sincronización completa desde ' || remote_host;
END;
$$ LANGUAGE plpgsql;