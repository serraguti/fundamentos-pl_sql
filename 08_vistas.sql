--Vamos a crear una vista para tener todos 
--los datos de los empleados sin el salario ni comisión, ni dir.
create or replace view V_EMPLEADOS
as
    select EMP_NO, APELLIDO, OFICIO, FECHA_ALT, DEPT_NO from EMP;
select * from V_EMPLEADOS;
--una vista simplifica las consultas
--Mostrar el Apellido, oficio, salario
--, nombre departamento y localidad de todos los empleados
create or replace view V_EMP_DEPT 
as
    select EMP.APELLIDO, EMP.OFICIO, EMP.SALARIO
    , DEPT.DNOMBRE as DEPARTAMENTO, DEPT.LOC as LOCALIDAD
    from EMP
    inner join DEPT
    on EMP.DEPT_NO = DEPT.DEPT_NO;
select * from V_EMP_DEPT where LOCALIDAD='MADRID';

SELECT * FROM user_views where VIEW_NAME='V_EMP_DEPT';
--podemos tener campos virtuales
create or replace view V_EMPLEADOS_VIRTUAL
as
    select EMP_NO, APELLIDO, OFICIO
    , salario + comision as TOTAL
    , DEPT_NO from EMP;
select * from V_EMPLEADOS_VIRTUAL;
create or replace view V_EMPLEADOS
as
    select EMP_NO, APELLIDO, OFICIO, SALARIO
    , FECHA_ALT, DEPT_NO from EMP;
select * from V_EMPLEADOS where OFICIO='ANALISTA';
--modificar el salario de los empleados ANALISTA
--tabla
update EMP set SALARIO = SALARIO + 1 where OFICIO='ANALISTA';
--VISTA
update V_EMPLEADOS set SALARIO = SALARIO + 1 where OFICIO='ANALISTA';
select * from EMP where OFICIO='ANALISTA';
--eliminamos al empleado con id 7917
delete from V_EMPLEADOS where EMP_NO=7917;
--INSERTAMOS EN LA VISTA
insert into V_EMPLEADOS values 
(1111, 'lunes', 'LUNES', 0, sysdate, 40);
--¿que sucede si las columnas no admiten null?
alter table EMP 
modify SALARIO NUMBER  NULL;
create or replace view V_EMPLEADOS3
as
    select EMP_NO, APELLIDO, OFICIO
    , FECHA_ALT, DEPT_NO from EMP;
insert into V_EMPLEADOS3 values 
(2222, 'lunes 2', 'LUNES 2', sysdate, 40);  
--vista join
create or replace view V_EMP_DEPT 
as
    select EMP.EMP_NO, EMP.APELLIDO, EMP.OFICIO, EMP.SALARIO
    , DEPT.DNOMBRE as DEPARTAMENTO, DEPT.LOC as LOCALIDAD
    from EMP
    inner join DEPT
    on EMP.DEPT_NO = DEPT.DEPT_NO;
select * from V_EMP_DEPT where LOCALIDAD='MADRID';  
--modificar el salario de los empleados de MADRID
update V_EMP_DEPT set SALARIO = SALARIO + 1 where LOCALIDAD='MADRID';
--ELIMINAR A LOS EMPLEADOS DE BARCELONA
delete from V_EMP_DEPT where LOCALIDAD='BARCELONA';
insert into V_EMP_DEPT values (3333, 'lunes 3', 'LUNES 3'
, 250000, 'CONTABILIDAD', 'SEVILLA');
update V_EMP_DEPT set SALARIO = SALARIO + 1
, DEPARTAMENTO='CONTABLES' where LOCALIDAD='MADRID';
select * from V_EMP_DEPT;
rollback;
--vistas que pueden llegar a ser inutiles
create or replace view V_VENDEDORES
as
    select EMP_NO, APELLIDO, OFICIO
    , SALARIO, DEPT_NO from EMP
    where OFICIO='VENDEDOR'
    with check option;
--modificamos el salario de los vendedores
update V_VENDEDORES set SALARIO = SALARIO + 1;
update V_VENDEDORES set OFICIO = 'VENDIDOS';
select * from V_VENDEDORES;
rollback;












