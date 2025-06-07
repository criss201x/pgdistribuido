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
        EXECUTE format('GRANT SELECT ON profacIng TO %I;', rec.id_p);
    END LOOP;
END $$;



-- Crear rol para profesores y dar permisos
create role rol_profacIng;
grant select on profacIng  to rol_profacIng;
grant update on profesores to rol_profacIng;
-- Crear usuario profesor y asignar rol
--create user "11002" with password '123456';

grant execute on function actualizar_datos_profesor(varchar, varchar, varchar, bigint) to rol_profacIng;

-- Crear rol para coordinador
create role rol_coordinador;



-- Asegura que la tabla carreras tenga la columna id_coordinador y la FK a profesores
alter table carreras add column if not exists id_coordinador int;
alter table carreras
    add constraint fk_carreras_coordinador
    foreign key (id_coordinador) references profesores(id_p);

-- Asigna el profesor 11001 como coordinador en todas las carreras (ajusta el WHERE si es necesario)
update carreras set id_coordinador = 11001;

-- Crear usuario coordinador y asignar rol (si no existe)
do $$
begin
    if not exists (select 1 from pg_roles where rolname = '11001') then
        execute 'create user "11001" with password ''123456''';
    end if;
end
$$;
grant rol_coordinador to "11001";

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

-- Función para actualizar notas y registrar log
create or replace function actualizar_nota_coordinador(
    p_cod_e bigint,
    p_cod_a bigint,
    p_grupo int,
    p_n1 numeric,
    p_n2 numeric,
    p_n3 numeric
) returns void as $$
declare
    v_n1_old numeric(2,1);
    v_n2_old numeric(2,1);
    v_n3_old numeric(2,1);
    v_id_carr int;
    v_id_coordinador int;
begin
    select id_carr into v_id_carr from estudiantes where cod_e = p_cod_e;
    select id_coordinador into v_id_coordinador from carreras where id_carr = v_id_carr;
    if v_id_coordinador = current_user::int then
        select n1, n2, n3 into v_n1_old, v_n2_old, v_n3_old
        from inscribe
        where cod_e = p_cod_e and cod_a = p_cod_a and grupo = p_grupo;

        update inscribe
        set n1 = p_n1, n2 = p_n2, n3 = p_n3
        where cod_e = p_cod_e and cod_a = p_cod_a and grupo = p_grupo;

        insert into log_actualizacion_notas(
            id_coordinador, cod_e, cod_a, grupo,
            nota_anterior1, nota_anterior2, nota_anterior3,
            nota_nueva1, nota_nueva2, nota_nueva3
        ) values (
            current_user::int, p_cod_e, p_cod_a, p_grupo,
            v_n1_old, v_n2_old, v_n3_old,
            p_n1, p_n2, p_n3
        );
    else
        raise exception 'No tiene permiso para modificar notas de estudiantes fuera de su carrera';
    end if;
end;
$$ language plpgsql;


-- Permisos para el rol coordinador
grant select, insert, update, delete on estudiantes to rol_coordinador;
grant select, insert, update, delete on imparte to rol_coordinador;
grant select, insert, update, delete on referencia to rol_coordinador;
grant select, insert, update, delete on libros to rol_coordinador;
grant select, insert, update, delete on autores to rol_coordinador;
grant select, insert, update, delete on escribe to rol_coordinador;
grant select on carreras to rol_coordinador;
grant select on inscribe to rol_coordinador;
--grant select on vista_coordinador_estudiantes to rol_coordinador;
--grant select on vista_coordinador_notas to rol_coordinador;
--grant select on vista_coordinador_grupos to rol_coordinador;
--grant select on vista_coordinador_referencias to rol_coordinador;
--grant select on vista_coordinador_libros_autores to rol_coordinador;
--grant execute on function actualizar_nota_coordinador(bigint, bigint, int, numeric, numeric, numeric) to rol_coordinador;
--grant insert on log_actualizacion_notas to rol_coordinador;

----------------------------
-- Crear rol para bibliotecario (transversal a todas las facultades)
create role rol_bibliotecario;

-- Permisos para administración de préstamos de libros
grant select, insert, update, delete on presta to rol_bibliotecario;

-- Permisos para administración de ejemplares de libros
grant select, insert, update, delete on ejemplares to rol_bibliotecario;

-- Permisos para gestión de libros y autores
grant select, insert, update, delete on libros to rol_bibliotecario;
grant select, insert, update, delete on autores to rol_bibliotecario;
grant select, insert, update, delete on escribe to rol_bibliotecario;
create user "bibliotecario1" with password '123456';
grant rol_bibliotecario to "bibliotecario1";
