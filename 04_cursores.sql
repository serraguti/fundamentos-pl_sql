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

