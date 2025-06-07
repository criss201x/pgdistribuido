-- Creación de la vista para estudiantes
create or replace view estudiante_FacIng as
    select e.cod_e, e.nom_e, a.cod_a, a.nom_a, i.n1, i.n2, i.n3, 
    (i.n1*0.35 + i.n2*0.35 + i.n3*0.30) as nota,
    case when (i.n1*0.35 + i.n2*0.35 + i.n3*0.30) >= 3.5 then 'Aprobo' else 'Reprobo' end as definitiva
    from estudiantes e
        inner join inscribe i on e.cod_e = i.cod_e
        inner join asignaturas a on a.cod_a = i.cod_a 
    where e.cod_e::text = current_user;

-- Creación de la vista para profesores
create or replace view profacMd as
select 
    p.id_p, p.nom_p, 
    e.cod_e, e.nom_e, 
    a.cod_a, a.nom_a, 
    i.n1, i.n2, i.n3, 
    (i.n1*0.35 + i.n2*0.35 + i.n3*0.30) as nota,
    case when (i.n1*0.35 + i.n2*0.35 + i.n3*0.30) >= 3.5 then 'Aprobo' else 'Reprobo' end as definitiva
from profesores p
inner join imparte imp on p.id_p = imp.id_p
inner join inscribe i on imp.id_p = i.id_p and imp.cod_a = i.cod_a and imp.grupo = i.grupo
inner join estudiantes e on i.cod_e = e.cod_e
inner join asignaturas a on i.cod_a = a.cod_a
where p.id_p::text = current_user
order by a.cod_a, e.cod_e;


-- Función para que el profesor modifique su propia información personal
create or replace function actualizar_datos_profesor(
    p_nom_p varchar,
    p_dir_p varchar,
    p_profesion varchar,
    p_tel_p bigint
) returns void as $$
begin
    update profesores
    set nom_p = p_nom_p,
        dir_p = p_dir_p,
        profesion = p_profesion,
        tel_p = p_tel_p
    where id_p = current_user::int;
end;
$$ language plpgsql;

create or replace function actualizar_datos_profesor(
    p_nom_p varchar,
    p_dir_p varchar,
    p_profesion varchar,
    p_tel_p bigint
) returns void as $$
begin
    update profesores
    set nom_p = p_nom_p,
        dir_p = p_dir_p,
        profesion = p_profesion,
        tel_p = p_tel_p
    where id_p = current_user::int;
end;
$$ language plpgsql;


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

-- Vista: estudiantes de las carreras que coordina
create or replace view vista_coordinador_estudiantes as
select e.*, c.nom_carr
from estudiantes e
join carreras c on e.id_carr = c.id_carr
where c.id_coordinador = current_user::int;

-- Vista: notas de estudiantes en asignaturas de las carreras que coordina
create or replace view vista_coordinador_notas as
select i.*, e.nom_e, a.nom_a, c.nom_carr
from inscribe i
join estudiantes e on i.cod_e = e.cod_e
join asignaturas a on i.cod_a = a.cod_a
join carreras c on e.id_carr = c.id_carr
where c.id_coordinador = current_user::int;

-- Vista: grupos de asignaturas de las carreras que coordina
create or replace view vista_coordinador_grupos as
select imp.*, a.nom_a, c.nom_carr
from imparte imp
join asignaturas a on imp.cod_a = a.cod_a
join carreras c on a.cod_a = c.id_carr
where c.id_coordinador = current_user::int;

-- Vista: referencias bibliográficas
create or replace view vista_coordinador_referencias as
select r.*, a.nom_a, l.titulo
from referencia r
join asignaturas a on r.cod_a = a.cod_a
join libros l on r.isbn = l.isbn;

-- Vista: libros y autores
create or replace view vista_coordinador_libros_autores as
select l.*, au.id_a, au.nom_a, au.nacionalidad
from libros l
left join escribe e on l.isbn = e.isbn
left join autores au on e.id_a = au.id_a;