--EJEMPLO PROCEDIMIENTO PARA MOSTRAR UN MENSAJE
--STORED PROCEDURE
create or replace procedure sp_mensaje
as
begin
    --MOSTRAMOS UN MENSAJE
    dbms_output.put_line('Hoy es juernes con música!!!');
end;
--LLAMADA AL PROCEDIMIENTO
begin
    sp_mensaje;
end;
exec sp_mensaje;
--CREAMOS EL PROCEDIMIENTO
create or replace procedure sp_ejemplo_plsql
as
begin
    --procedimiento con bloque pl/sql
    declare
        v_numero number;
    begin 
        v_numero := 14;
        if v_numero > 0 then
            dbms_output.put_line('Positivo');
        else 
            dbms_output.put_line('Negativo');
        end if;
    end;
end;
--LLAMADA
begin
    sp_ejemplo_plsql;
end;
--TENEMOS OTRA SINTAXIS PARA TENER VARIABLES
--DENTRO DE UN PROCEDIMIENTO.
--NO SE UTILIZA LA PALABRA declare
create or replace procedure sp_ejemplo_plsql2
AS
    v_numero number := 14;
begin
    if v_numero > 0 then
        dbms_output.put_line('Positivo');
    else 
        dbms_output.put_line('Negativo');
    end if;    
end;
begin
    sp_ejemplo_plsql2;
end;
--PROCEDIMIENTO PARA SUMAR DOS NUMEROS
create or replace procedure sp_sumar_numeros
(p_numero1 number, p_numero2 number)
as
    v_suma number;
begin
    v_suma := p_numero1 + p_numero2;
    dbms_output.put_line('La suma de ' || p_numero1 
    || ' + ' || p_numero2 || ' es igual a ' || v_suma);
end;
---llamada al procedimiento
begin
    sp_sumar_numeros(5, 6);
end;
--NECESITO UN PROCEDIMIENTO PARA DIVIDIR DOS NUMEROS
--SE LLAMARA sp_dividir_numeros
create or replace procedure sp_dividir_numeros
(p_numero1 number, p_numero2 number)
as
begin
    declare
        v_division number;
    begin
        v_division := p_numero1 / p_numero2;
        dbms_output.put_line('La división entre ' || p_numero1 
        || ' y ' || p_numero2 || ' es igual a ' || v_division);        
    EXCEPTION
        when ZERO_DIVIDE then
            dbms_output.PUT_LINE('División entre cero. PL/SQL inner');
    end;
exception
    when ZERO_DIVIDE then
        dbms_output.put_line('División entre cero PROCEDURE');
end;

declare 
    v_dato number;
begin
    v_dato := 7/0;
    sp_dividir_numeros(7, 0);
EXCEPTION
    when ZERO_DIVIDE then
        dbms_output.put_line('División entre cero, PL/SQL outer');
end;

--REALIZAR UN PROCEDIMIENTO PARA INSERTAR UN NUEVO DEPARTAMENTO
create or replace procedure sp_insertardepartamento
(p_id DEPT.DEPT_NO%TYPE
, p_nombre DEPT.DNOMBRE%TYPE
, p_localidad DEPT.LOC%TYPE)
as
begin
    insert into DEPT values (p_id, p_nombre, p_localidad);
    --normalmente, dentro de los procedimientos de acción se incluye
    --commit o rollback si diera una excepción
    commit;
end;
--llamada al procedimiento
begin
    sp_insertardepartamento(11, '11', '11');
end;
select * from DEPT;
rollback;
--VERSION 2
--REALIZAR UN PROCEDIMIENTO PARA INSERTAR UN NUEVO DEPARTAMENTO
--GENERAMOS EL ID CON EL MAX AUTOMATICO DENTRO DEL PROCEDURE
create or replace procedure sp_insertardepartamento
(p_nombre DEPT.DNOMBRE%TYPE
, p_localidad DEPT.LOC%TYPE)
as
    v_max_id DEPT.DEPT_NO%TYPE;
begin
    --REALIZAMOS EL CURSOR IMPLICITO PARA BUSCAR EL MAX ID
    select max(DEPT_NO) + 1 into v_max_id from DEPT;
    insert into DEPT values (v_max_id, p_nombre, p_localidad);
    --normalmente, dentro de los procedimientos de acción se incluye
    --commit o rollback si diera una excepción
    commit;
exception 
    when no_data_found THEN
        dbms_output.put_line('No existen datos');
        rollback;
end;
--llamada al procedimiento
begin
    sp_insertardepartamento('miercoles', 'miercoles');
end;
select * from DEPT;
--REALIZAR UN PROCEDIMIENTO PARA INCREMENTAR EL SALARIO DE 
--LOS EMPLEADOS POR UN OFICIO.
--DEBEMOS ENVIAR EL OFICIO Y EL INCREMENTO.
/
create or replace procedure sp_incremento_emp_oficio
(p_oficio EMP.OFICIO%TYPE, p_incremento number)
as
begin
   update EMP set SALARIO = SALARIO + p_incremento
   where upper(OFICIO) = upper(p_oficio);
   commit; 
end;
/
begin
    SP_INCREMENTO_EMP_OFICIO('analista', 1);
end;
select * from EMP where oficio = 'ANALISTA';
--NECESITO UN PROCEDIMIENTO PARA INSERTAR UN DOCTOR.
--ENVIAREMOS TODOS LOS DATOS DEL DOCTOR, EXCEPTO EL ID
--DEBEMOS RECUPERAR EL MAXIMO ID DE DOCTOR DENTRO DEL PROCEDIMIENTO
create or replace procedure sp_insertar_doctor
(p_apellido DOCTOR.APELLIDO%TYPE
, p_especialidad DOCTOR.ESPECIALIDAD%TYPE
, p_salario DOCTOR.SALARIO%TYPE
, p_hospital DOCTOR.HOSPITAL_COD%TYPE)
as
    v_max_iddoctor DOCTOR.DOCTOR_NO%TYPE;
begin
    select max(DOCTOR_NO) + 1 into v_max_iddoctor from DOCTOR;
    insert into DOCTOR values (p_hospital, v_max_iddoctor
    , p_apellido, p_especialidad, p_salario);
    commit;
    dbms_output.put_line('Insertados ' || SQL%ROWCOUNT); 
end;
begin
    SP_INSERTAR_DOCTOR('Willson2', 'Doctor', 280000, 19);
end;
select * from DOCTOR order by doctor_no desc;
--VERSION 2
--NECESITO UN PROCEDIMIENTO PARA INSERTAR UN DOCTOR.
--ENVIAREMOS TODOS LOS DATOS DEL DOCTOR, EXCEPTO EL ID
--DEBEMOS RECUPERAR EL MAXIMO ID DE DOCTOR DENTRO DEL PROCEDIMIENTO
--ENVIAMOS EL NOMBRE DEL HOSPITAL EN LUGAR DEL ID DEL HOSPITAL
--CONTROLAR SI NO EXISTE EL HOSPITAL ENVIADO
