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
create or replace procedure sp_insertar_doctor
(p_apellido DOCTOR.APELLIDO%TYPE
, p_especialidad DOCTOR.ESPECIALIDAD%TYPE
, p_salario DOCTOR.SALARIO%TYPE
, p_hospital_nombre HOSPITAL.NOMBRE%TYPE)
as
    v_max_iddoctor DOCTOR.DOCTOR_NO%TYPE;
    v_hospitalcod HOSPITAL.HOSPITAL_COD%TYPE;
begin
    select HOSPITAL_COD into v_hospitalcod
    from HOSPITAL
    where upper(NOMBRE) = upper(p_hospital_nombre);
    select max(DOCTOR_NO) + 1 into v_max_iddoctor from DOCTOR;
    insert into DOCTOR values (v_hospitalcod, v_max_iddoctor
    , p_apellido, p_especialidad, p_salario);
    dbms_output.put_line('Insertados ' || SQL%ROWCOUNT); 
    commit;
exception
    when no_data_found then
        dbms_output.put_line('No existe el hospital ' || p_hospital_nombre);
end;
begin
    SP_INSERTAR_DOCTOR('House', 'Diagnostico', 380000, 'la plaza');
end;
select * from DOCTOR order by doctor_no desc;
--PODEMOS UTILIZAR CURSORES EXPLICITOS DENTRO DE LOS PROCEDIMIENTOS
--Realizar un procedimiento para mostrar los empleados
--de un determinado número de departamento.
create or replace procedure sp_empleados_dept
(p_deptno EMP.DEPT_NO%TYPE)
as
    cursor cursor_emp is
    select * from EMP
    where DEPT_NO = p_deptno;
begin
    for v_reg_emp in cursor_emp
    loop
        dbms_output.put_line('Apellido: ' || v_reg_emp.APELLIDO
        || ', Oficio: ' || v_reg_emp.OFICIO);
    end loop;
end;
begin
    SP_EMPLEADOS_DEPT(10);
end;

create or replace procedure EjemploOpcionales
(p_uno int, p_dos int := 0, p_tres int := 0, p_cuatro int := 0)
as
begin
    dbms_output.put_line('algo');
end;
begin
    EjemploOpcionales(8); --error
    EjemploOpcionales(8, p_cuatro => 77, p_tres => 9); 
    EjemploOpcionales(8, 9, 10);
end;
--VAMOS A REALIZAR UN PROCEDIMIENTO PARA ENVIAR EL 
--NOMBRE DEL DEPARTAMENTO Y DEVOLVER EL NUMERO DE DICHO DEPARTAMENTO
create or replace procedure sp_numerodepartamento
(p_nombre DEPT.DNOMBRE%TYPE, p_iddept out DEPT.DEPT_NO%TYPE)
as
    v_iddept DEPT.DEPT_NO%TYPE;
begin
    select DEPT_NO into v_iddept 
    from DEPT
    where upper(DNOMBRE) = upper(p_nombre);
    p_iddept := v_iddept;
    dbms_output.put_line('El número de departamento es ' || v_iddept);    
end;
begin
    SP_NUMERODEPARTAMENTO('ventas');
end;
--NECESITO UN PROCEDIMIENTO PARA INCREMENTAR EN 1 
--EL SALARIO DE LOS EMPLEADOS DE UN DEPARTAMENTO.
--ENVIAREMOS AL PROCEDIMIENTO EL NOMBRE DEL DEPARTAMENTO
create or replace procedure sp_incrementar_sal_dept
(p_nombre DEPT.DNOMBRE%TYPE)
as
    v_num DEPT.DEPT_NO%TYPE;
begin
    --recuperamos el id del departamento a partir del nombre
    --llamamos al procedimiento de numero para recuperar el numero 
    --a partir del nombre
    --sp_numerodepartamento
    --(p_nombre DEPT.DNOMBRE%TYPE, p_iddept out DEPT.DEPT_NO%TYPE)
    SP_NUMERODEPARTAMENTO(p_nombre, v_num);
    update EMP set SALARIO = SALARIO + 1
    where DEPT_NO=v_num;
    dbms_output.put_line('Salarios modificados: ' || SQL%ROWCOUNT);
end;
begin
    SP_INCREMENTAR_SAL_DEPT('ventas');
end;

select * from DEPT;