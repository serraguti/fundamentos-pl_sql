--CURSORES IMPLICITOS SOLAMENTE PUEDEN
--DEVOLVER UNA FILA Y siempre una fila
--recuperar el oficio del empleado REY
declare 
    v_oficio EMP.OFICIO%TYPE;
begin
    select OFICIO into v_oficio from EMP 
    where upper(APELLIDO)='REY';
    dbms_output.put_line('El oficio de REY es...' || v_oficio);
end;
--cursor explicito
--pueden devolver mas de una fila y es necesario declararlos
--mostrar el apellido y salario de todos los empleados
declare
    v_ape EMP.APELLIDO%TYPE;
    v_sal EMP.SALARIO%TYPE;
    --declaramos nuestro cursor con una consulta
    --la consulta debe tener los mismos datos para luego
    --hacer el fetch
    cursor CURSOREMP is 
    select APELLIDO, SALARIO from EMP;
begin
    --1) abrir el cursor
    open CURSOREMP;
    --BUCLE INFINITO
    loop
        --2) EXTRAEMOS LOS DATOS DEL CURSOR
        fetch CURSOREMP into v_ape, v_sal;
        --3) preguntamos si hemos terminado
        exit when CURSOREMP%notfound;
        --DIBUJAMOS LOS DATOS
        dbms_output.put_line('Apellido: ' || v_ape 
        || ', Salario: ' || v_sal);
    end loop;
    --4) Cerramos cursor
    close CURSOREMP;
end;
select * from EMP where APELLIDO='gutierrez';
--ATRIBUTO ROWCOUNT PARA LAS CONSULTAS DE ACCION
--INCREMENTAR EN 1 EL SALARIO DE LOS EMPLEADOS DEL DEPARTAMENTO
--10.
--MOSTRAR EL NUMERO DE EMPLEADOS MODIFICADOS.
begin
    update EMP set SALARIO = SALARIO + 1
    where DEPT_NO=10;
    dbms_output.put_line('Empleados modificados: ' 
    || SQL%ROWCOUNT);
end;
--INCREMENTAR EN 10.000 AL EMPLEADO QUE 
--MENOS COBRE EN LA EMPRESA.
--1) ¿que necesito para esto?
--minimo salario IMPLICITO
--2) ¿qué más? update a ese salario
declare
    v_minimo_salario EMP.SALARIO%TYPE;
    v_apellido EMP.APELLIDO%TYPE;
begin
    --realizamos una consulta para recuperar el mínimo salario
    select min(SALARIO) into v_minimo_salario from EMP;
    --ALMACENAMOS LA PERSONA QUE COBRA DICHO SALARIO
    select APELLIDO into v_apellido from EMP
    where SALARIO=v_minimo_salario;
    update EMP set SALARIO = SALARIO + 10000
    where SALARIO=v_minimo_salario;
    dbms_output.put_line('Salario incrementado a '
    || SQL%ROWCOUNT || ' empleados. Sr/Sra ' || v_apellido);
end;

--Realizar un código PL/SQL dónde pediremos 
--el número, nombre y localidad de un departamento.
--Si el departamento existe, modificamos su nombre y localidad
--si el departamento no existe, lo insertamos.
--BLOQUE CON CURSOR EXPLICITO
declare
    v_id DEPT.DEPT_NO%TYPE;
    v_nombre DEPT.DNOMBRE%TYPE;
    v_localidad DEPT.LOC%TYPE;
    v_existe DEPT.DEPT_NO%TYPE;
    cursor CURSORDEPT is
    select DEPT_NO from DEPT
    where DEPT_NO=v_id;
begin
    v_id := &iddepartamento;
    v_nombre := '&nombre';
    v_localidad := '&localidad';
    open CURSORDEPT;
    fetch CURSORDEPT into v_existe;
    if (CURSORDEPT%found) then
        dbms_output.put_line('UPDATE');
        update DEPT set DNOMBRE=v_nombre, LOC=v_localidad
        where DEPT_NO=v_id;
    else 
        dbms_output.put_line('INSERT');
        insert into DEPT values (v_id, v_nombre, v_localidad);
    end if;
    close CURSORDEPT;
end;

declare 
    v_id DEPT.DEPT_NO%TYPE;
    v_nombre DEPT.DNOMBRE%TYPE;
    v_localidad DEPT.LOC%TYPE;
    v_existe DEPT.DEPT_NO%TYPE;
begin
    v_id := &iddepartamento;
    v_nombre := '&nombre';
    v_localidad := '&localidad';
    select COUNT(DEPT_NO) into v_existe from DEPT
    where DEPT_NO=v_id;
    if (v_existe = 0) then
        dbms_output.put_line('Insert');
    else
        dbms_output.put_line('Update');
    end if;
end;
undefine iddepartamento;
undefine nombre;
undefine localidad;

--Realizar un código pl/sql para modificar el salario del 
--empleado ARROYO
--Si el empleado cobra más de 250.000, le bajamos el sueldo en 10.000
--Si no, le subimos el sueldo en 10.000
declare
    v_salario EMP.SALARIO%TYPE;
    v_idemp EMP.EMP_NO%TYPE;
begin
    select EMP_NO, SALARIO into v_idemp, v_salario from EMP
    where UPPER(APELLIDO)='ARROYO';
    if v_salario > 250000 then
        v_salario := v_salario - 10000;
    else
        v_salario := v_salario + 10000;
    end if;
    update EMP set SALARIO=v_salario 
    where EMP_NO=v_idemp;
    dbms_output.put_line('Salario modificado: ' || v_salario);
end;

--Necesito mostrar la suma salarial de los doctores de la paz.
--Realizar el siguiente código pl/sql.
--Necesitamos modificar el salario de los doctores de LA PAZ.
--Si la suma salarial supera 1.000.000 bajamos salarios en 10.000 a todos
--Si la suma salarial no supera el millón, subimos salarios en 10.000
--Mostrar el número de filas que hemos modificado (subir o bajar)
--Doctores con suerte: 6, Doctores más pobres: 6
describe doctor;
declare
   v_suma_salarial NUMBER; 
begin
    select sum(DOCTOR.SALARIO) into v_suma_salarial
    from DOCTOR
    inner join HOSPITAL
    on DOCTOR.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
    where lower(HOSPITAL.NOMBRE)='la paz';
    dbms_output.put_line('Suma salarial La paz: ' || v_suma_salarial);    
    if v_suma_salarial > 1000000 then
        update DOCTOR set SALARIO = SALARIO - 10000
        where hospital_cod=
        (select HOSPITAL_COD from HOSPITAL where UPPER(NOMBRE)='LA PAZ');
        dbms_output.put_line('Bajando salarios: ' || SQL%ROWCOUNT);
    else 
        update DOCTOR set SALARIO = SALARIO + 10000
        where hospital_cod=
        (select HOSPITAL_COD from HOSPITAL where UPPER(NOMBRE)='LA PAZ');
        dbms_output.put_line('Doctores ricos ' || SQL%ROWCOUNT);
    end if;
end;
--SOLUCION 2
declare
   v_suma_salarial NUMBER; 
   v_codigo HOSPITAL.HOSPITAL_COD%TYPE;
begin
    select HOSPITAL_COD into v_codigo from HOSPITAL
    where lower(NOMBRE)='la paz';
    select sum(SALARIO) into v_suma_salarial
    from DOCTOR 
    where HOSPITAL_COD=v_codigo;
    dbms_output.put_line('Suma salarial La paz: ' || v_suma_salarial);    
    if v_suma_salarial > 1000000 then
        update DOCTOR set SALARIO = SALARIO - 10000
        where hospital_cod=v_codigo;
        dbms_output.put_line('Bajando salarios: ' || SQL%ROWCOUNT);
    else 
        update DOCTOR set SALARIO = SALARIO + 10000
        where hospital_cod=v_codigo;
        dbms_output.put_line('Doctores ricos ' || SQL%ROWCOUNT);
    end if;
end;

--REALIZAMOS LA DECLARACION CON DEPARTAMENTOS
--PODEMOS ALMACENAR TODOS LOS DEPARTAMENTOS (UNO A UNO) EN UN ROWTYPE
describe DEPT;
declare
    v_fila DEPT%ROWTYPE; 
    cursor cursor_dept IS
    select * from DEPT;
begin
    open cursor_dept;
    loop
        fetch cursor_dept into v_fila;
        exit when cursor_dept%notfound;
        dbms_output.put_line('Id: ' || v_fila.DEPT_NO
        || ', Nombre: ' || v_fila.DNOMBRE
        || ', Localidad: ' || v_fila.LOC);
    end loop;
    close cursor_dept;
end;

--REALIZAR UN CURSOR PARA MOSTRAR EL APELLIDO, SALARIO Y OFICIO 
--DE EMPLEADOS
/
declare 
    cursor cursor_emp is
    select apellido, salario, oficio, 
    salario + comision as total
    from EMP;
begin
    for v_registro in cursor_emp
    loop
        dbms_output.put_line('Apellido ' || v_registro.apellido
        || ', Salario: ' || v_registro.salario 
        || ', Oficio: ' || v_registro.oficio
        || ', Total: ' || v_registro.total);
    end loop;
end;
/


