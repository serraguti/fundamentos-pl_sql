---ejemplo de trigger capturando informacion
drop trigger tr_dept_before_insert;
create or replace trigger tr_dept_before_insert
before insert 
on DEPT
for each row
declare
begin
    dbms_output.put_line('Trigger DEPT before insert row');
    dbms_output.put_line(:new.DEPT_NO || ', ' || :new.DNOMBRE
    || ', ' || :new.LOC);
end;
insert into DEPT values (111, 'NUEVO', 'TOLEDO');
--delete
drop trigger tr_dept_before_delete;
create or replace trigger tr_dept_before_delete
before delete 
on DEPT
for each row
declare
begin
    dbms_output.put_line('Trigger DEPT before delete row');
    dbms_output.put_line(:old.DEPT_NO || ', ' || :old.DNOMBRE
    || ', ' || :old.LOC);
end;
delete from DEPT where DEPT_NO=478;
--update
drop trigger tr_dept_before_update;
create or replace trigger tr_dept_before_update
before update 
on DEPT
for each row
declare
begin
    dbms_output.put_line('Trigger DEPT before updte row');
    dbms_output.put_line(:old.DEPT_NO || ', Antigua LOC: ' || :old.LOC
    || ', Nueva LOC: ' || :new.LOC);
end;
update DEPT set LOC='VITORIA' where DEPT_NO=111;
select * from DEPT;
--TRIGGER CONTROL DOCTOR
drop trigger tr_doctor_control_salario_update;
create or replace trigger tr_doctor_control_salario_update
before update 
on DOCTOR
for each row
    when (new.SALARIO > 250000)
declare
begin
    dbms_output.put_line('Trigger DOCTOR before update row');
    dbms_output.put_line('Dr/Dra ' || :old.APELLIDO 
    || ' cobra mucho dinero: ' ||  :new.SALARIO
    || '. Antes: ' || :old.SALARIO);
end;
update DOCTOR set SALARIO = 252000 where DOCTOR_NO=386;
--386, 435
select * from DOCTOR;
--NO PODEMOS TENER DOS TRIGGERS DEL MISMO TIPO EN UNA TABLA
drop trigger tr_dept_before_insert;
create or replace trigger tr_dept_control_barcelona
before insert 
on DEPT
for each row
declare
begin
    dbms_output.put_line('Trigger Control Barcelona');
    if (upper(:new.LOC) = 'BARCELONA') then
        dbms_output.put_line('No se admiten departamentos en Barcelona');
        RAISE_APPLICATION_ERROR(-20001, 'En Munich solo ganadores');
    end if;
end;
insert into DEPT values (5, 'MILAN', 'BARCELONA');
drop trigger tr_dept_control_barcelona;
create or replace trigger tr_dept_control_barcelona
before insert 
on DEPT
for each row
    when (upper(new.LOC) = 'BARCELONA')
declare
begin
    dbms_output.put_line('Trigger Control Barcelona');
    dbms_output.put_line('No se admiten departamentos en Barcelona');
    RAISE_APPLICATION_ERROR(-20001, 'En Munich solo ganadores');
end;
insert into DEPT values (5, 'MILAN', 'BARCELONA');
select * from DEPT;
DROP trigger tr_dept_control_localidades;
create or replace trigger tr_dept_control_localidades
AFTER insert --VAMOS A COMPROBAR DESPUES DE INSERTAR
on DEPT
for each row
declare
    v_num number;
begin
    dbms_output.put_line('Trigger Control Localidades');
    select count(DEPT_NO) into v_num from DEPT 
    where UPPER(LOC)=UPPER(:new.loc);
    if (v_num > 0) then
        RAISE_APPLICATION_ERROR(-20001
        , 'Solo un departamento por ciudad ' || :new.LOC);
    end if;
end;
insert into DEPT values (6, 'MILAN', 'parla');
select * from DEPT where LOC='TERUEL';
---ejemplo integridad relacional con update
--si cambiamos un id de departamento que se modifiquen tambien
--los empleados asociados.
drop trigger tr_update_dept_cascade;
create or replace trigger tr_update_dept_cascade
before update
on DEPT
for each row 
    when (new.DEPT_NO <> old.DEPT_NO)
declare
begin
    dbms_output.put_line('DEPT_NO cambiando');
    --modificamos los datos asociados (EMP)
    update EMP set DEPT_NO=:new.DEPT_NO where 
    DEPT_NO=:old.DEPT_NO;
end;
select * from DEPT;
update DEPT set DEPT_NO=31 where dept_no=30;
update DEPT set LOC='ZARAGOZA' where dept_no=30;
select * from EMP where DEPT_NO=31;
--Impedir insertar un nuevo PRESIDENTE si ya existe uno en la tabla EMP.
drop trigger tr_emp_control_presi_insert;
create or replace trigger tr_emp_control_presi_insert
before insert
on EMP
for each row
    when (upper(new.OFICIO) = 'PRESIDENTE')
declare
    v_presis NUMBER;
begin
    dbms_output.put_line('Derrocando presidente!!!');
    select count(EMP_NO) into v_presis from EMP
    where upper(OFICIO)='PRESIDENTE';
    if v_presis <> 0 then
        RAISE_APPLICATION_ERROR(-20001, 'Solo un Presidente activo');
    end if;
end;
select * from EMP;
insert into EMP values (2222, 'USURPADOR', 'PRESIDENTE'
, 7566, sysdate, 120000, 2000, 20);
insert into EMP values (2224, 'USURPADOR', 'PRESIDENTA'
, 7566, sysdate, 120000, 2000, 20);
--PACKAGE PARA ALMACENAR LAS VARIABLES ENTRE TRIGGERS
create or replace package PK_TRIGGERS
as
    v_nueva_localidad DEPT.LOC%TYPE;
end PK_TRIGGERS;
create or replace trigger tr_dept_control_localidades_row
before update --VAMOS A COMPROBAR ANTES DE UPDATE
on DEPT
for each row
declare
begin
    dbms_output.PUT_LINE('For each ROW ');
    --almacenamos el valor de la nueva localidad
    PK_TRIGGERS.v_nueva_localidad := :new.LOC;
end;
drop trigger tr_dept_control_localidades_after;
--creamos el trigger de update para after
create or replace trigger tr_dept_control_localidades_after
after update
on DEPT
declare
    v_numero NUMBER;
begin
    select count(DEPT_NO) into v_numero from DEPT
    where upper(LOC)=upper(PK_TRIGGERS.v_nueva_localidad);
    if (v_numero > 0) then
        RAISE_APPLICATION_ERROR(-20001, 'Solo un departamento por localidad');
    end if;
    dbms_output.PUT_LINE('Localidad nueva: ' || PK_TRIGGERS.v_nueva_localidad);
end;

update DEPT set LOC='CADIZ' where DEPT_NO=20;
select * from DEPT;
rollback;

--creamos una vista con todos los datos de los departamentos
create or replace view vista_departamentos
AS
    select * from DEPT;
--SOLO TRABAJAMOS CON LA VISTA
--creamos un trigger sobre la vista
create or replace trigger tr_vista_dept
instead of insert
on vista_departamentos
declare
begin
    dbms_output.PUT_LINE('Insertando en Vista DEPT');
end;
insert into VISTA_DEPARTAMENTOS values 
(12, 'VISTA', 'CON TRIGGER');
select * from vista_departamentos;
--VAMOS A CREAR UNA VISTA CON LOS DATOS DE LOS EMPLEADOS
--PERO SIN SUS DATOS SENSIBLES (salario, comision, fecha_alt)
create or replace view vista_empleados
as
    select EMP_NO, APELLIDO, OFICIO, DIR, DEPT_NO from EMP;
select * from VISTA_EMPLEADOS;
insert into VISTA_EMPLEADOS values (555, 'el nuevo', 'BECARIO', 7566, 31);
--si miramos en la tabla...
select * from EMP ORDER BY EMP_NO;
--creamos un trigger rellenando los huecos que quedan de EMP
create or replace trigger tr_vista_empleados
instead of INSERT
on vista_empleados
declare
begin
    --con new capturamos los datos que vienen en la vista 
    --y rellenamos el resto
    insert into EMP values (:new.EMP_NO, :new.APELLIDO, :new.OFICIO
    , :new.DIR, sysdate, 0, 0, :new.DEPT_NO);
end;
rollback;
select * from DOCTOR;
--vamos a crear una vista para mostrar doctores
create or replace view vista_doctores
as
    select DOCTOR.DOCTOR_NO, DOCTOR.APELLIDO, DOCTOR.ESPECIALIDAD
    , DOCTOR.SALARIO, HOSPITAL.NOMBRE
    from DOCTOR
    inner join HOSPITAL
    on DOCTOR.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD;
select * from VISTA_DOCTORES;

create or replace trigger tr_vista_doctor
instead of INSERT
on vista_doctores
declare
    v_codigo HOSPITAL.HOSPITAL_COD%TYPE;
begin
    select HOSPITAL_COD into v_codigo from HOSPITAL
    where upper(NOMBRE)=upper(:new.NOMBRE);
    insert into DOCTOR values
    (v_codigo, :new.DOCTOR_NO, :new.APELLIDO, :new.ESPECIALIDAD
    , :new.SALARIO);
end;
insert into VISTA_DOCTORES values 
(117, 'House 3', 'Especialista', 450000, 'provincianos');





