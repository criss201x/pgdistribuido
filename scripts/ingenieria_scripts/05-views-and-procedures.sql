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
create or replace view profacIng as
    select p.id_p, p.nom_p, e.cod_e, e.nom_e, a.cod_a, a.nom_a, i.n1, i.n2, i.n3, 
    (i.n1*0.35 + i.n2*0.35 + i.n3*0.30) as nota,
    case when (i.n1*0.35 + i.n2*0.35 + i.n3*0.30) >= 3.5 then 'Aprobo' else 'Reprobo' end as definitiva
    from profesores p
        inner join imparte imp on p.id_p = imp.id_p
        inner join inscribe i on imp.id_p = i.id_p and imp.cod_a = i.cod_a and imp.grupo = i.grupo
        inner join estudiantes e on i.cod_e = e.cod_e
        inner join asignaturas a on i.cod_a = a.cod_a
    where p.id_p::text = current_user -- Cambia a p.nom_p = current_user si usas nombres
    order by a.cod_a, e.cod_e;

