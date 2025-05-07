---ejemplo de trigger capturando informacion
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
create or replace trigger tr_dept_control_localidades
before insert 
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
insert into DEPT values (6, 'MILANA', 'TERUEL');

