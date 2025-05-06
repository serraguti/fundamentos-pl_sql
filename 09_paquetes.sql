--creamos nuestro primer package de prueba
--header
create or replace package pk_ejemplo
as
    --en el header solamente se incluyen las declaraciones
    procedure mostrarmensaje;
end pk_ejemplo;
--body
create or replace package body pk_ejemplo
as
    --en el header solamente se incluyen las declaraciones
    procedure mostrarmensaje
    as
    begin 
        dbms_output.put_line('Soy un paquete');
    end;
end pk_ejemplo;
--llamada
begin
    PK_EJEMPLO.MOSTRARMENSAJE;
end;
--vamos a realizar un paquete que contenga acciones de eliminar
--sobre EMP, DEPT, DOCTOR, ENFERMO
create or replace package pk_delete
AS
    procedure eliminarempleado(p_empno EMP.EMP_NO%TYPE);
    procedure eliminardepartamento(p_deptno DEPT.DEPT_NO%TYPE);
    procedure eliminardoctor(p_doctorno DOCTOR.DOCTOR_NO%TYPE);
    procedure eliminarenfermo(p_inscripcion ENFERMO.INSCRIPCION%TYPE);
end pk_delete;
--body
create or replace package body pk_delete
AS
    procedure eliminarempleado(p_empno EMP.EMP_NO%TYPE)
    as
    begin
        delete from EMP where EMP_NO=p_empno;
        commit;
    end;
    procedure eliminardepartamento(p_deptno DEPT.DEPT_NO%TYPE)
    as 
    begin
        delete from DEPT where DEPT_NO=p_deptno;
        commit;
    end;
    procedure eliminardoctor(p_doctorno DOCTOR.DOCTOR_NO%TYPE)
    as
    begin
        delete from DOCTOR where DOCTOR_NO=p_doctorno;
        commit;
    end;
    procedure eliminarenfermo(p_inscripcion ENFERMO.INSCRIPCION%TYPE)
    as
    begin
        delete from ENFERMO where INSCRIPCION=p_inscripcion;
        commit;
    end;
end pk_delete;
select * from DEPT;
BEGIN
    PK_DELETE.ELIMINARENFERMO(43);
END;
--creamos un paquete para devolver maximo, minimo y diferencia de 
--todos los empleados (salario)
create or replace package pk_empleados_salarios
AS
    function minimo return number;
    function maximo return number;
    function diferencia return number;
end pk_empleados_salarios;
--body
create or replace package body pk_empleados_salarios
AS
    function minimo return number
    as
        v_minimo EMP.SALARIO%TYPE;
    begin 
        select min(SALARIO) into v_minimo from EMP;
        return v_minimo;
    end;
    function maximo return number
    as
        v_maximo number;
    begin
        select max(SALARIO) into v_maximo from EMP;
        return v_maximo;
    end;
    function diferencia return number
    as
        v_diferencia number;
    begin
        v_diferencia := maximo - minimo;
        return v_diferencia;
    end;
end pk_empleados_salarios;

select PK_EMPLEADOS_SALARIOS.MAXIMO as MAXIMO,
PK_EMPLEADOS_SALARIOS.MINIMO as MINIMO,
PK_EMPLEADOS_SALARIOS.DIFERENCIA as DIFERENCIA from DUAL;

--Necesito un paquete para realizar 
--Update, Insert y Delete sobre Departamentos.
--Llamamos al paquete pk_departamentos
create or replace package pk_departamentos
as
    procedure updatedept(p_id DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE
    , p_localidad DEPT.LOC%TYPE);
    procedure insertdept(p_id DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE
    , p_localidad DEPT.LOC%TYPE);
    procedure deletedept(p_id DEPT.DEPT_NO%TYPE);
end pk_departamentos;
--body
create or replace package body pk_departamentos
as
    procedure updatedept(p_id DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE
    , p_localidad DEPT.LOC%TYPE)
    as
    begin
        update DEPT set DNOMBRE=p_nombre, LOC=p_localidad
        where DEPT_NO=p_id;
        commit;
    end;
    procedure insertdept(p_id DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE
    , p_localidad DEPT.LOC%TYPE)
    as
    begin
        insert into DEPT values (p_id, p_nombre, p_localidad);
        commit;
    end;
    procedure deletedept(p_id DEPT.DEPT_NO%TYPE)
    as
    begin 
        delete from DEPT where DEPT_NO = p_id;
        commit;
    end;
end pk_departamentos;
--probando
begin
    --PK_DEPARTAMENTOS.INSERTDEPT(88, 'martes', 'Madrid');
    --PK_DEPARTAMENTOS.UPDATEDEPT(88, 'martesssss', 'MadriZZ');
    PK_DEPARTAMENTOS.DELETEDEPT(88);
end;
select * from DEPT;
--Necesito una funcionalidad que nos devuelva 
--el Apellido, el trabajo, salario y lugar de trabajo (departamento/hospital)
--de todas las personas de nuestra bbdd.
--Necesito otra funcionalidad que nos devuelva 
--el Apellido, el trabajo, salario y lugar de trabajo (departamento/hospital)
--dependiendo del salario.

--1) CONSULTA GORDA
--2) CONSULTA DENTRO DE VISTA
--3) PAQUETE CON DOS PROCEDIMIENTOS
--3A) PROCEDIMIENTO PARA DEVOLVER TODOS LOS DATOS EN UN CURSOR
--3B) PROCEDIMIENTO PARA DEVOLVER TODOS LOS DATOS EN UN CURSOR POR SALARIO































grant XDBADMIN to SYSTEM;
grant ut_http to SYSTEM;
select * from dba_network_acls;
declare
    v_req       utl_http.req;
    v_res       utl_http.resp;
    v_buffer    varchar2(4000); 
    v_body      varchar2(4000) := '{"field":"value"}'; -- Your JSON
begin
    -- Set connection.
    v_req := utl_http.begin_request('https://apiejemplos.azurewebsites.net/api/Coches', 'GET');
    -- utl_http.set_authentication(v_req, 'your_username','your_password');
    utl_http.set_header(v_req, 'content-type', 'application/json'); 
    -- utl_http.set_header(v_req, 'Content-Length', length(v_body));
    
    -- Invoke REST API.
    utl_http.write_text(v_req, v_body);
  
    -- Get response.
    v_res := utl_http.get_response(v_req);
    begin
        loop
            utl_http.read_line(v_res, v_buffer);
            -- Do something with buffer.
            dbms_output.put_line(v_buffer);
        end loop;
        utl_http.end_response(v_res);
    exception
        when utl_http.end_of_body then
            utl_http.end_response(v_res);
    end;
end;
