--CAPTURAR UNA EXCEPCION DEL SISTEMA
/
declare
    v_numero1 number := &numero1;
    v_numero2 number := &numero2;
    v_division number;
begin
    v_division := v_numero1 / v_numero2;
    dbms_output.put_line('La división es ' || v_division);
exception
    when ZERO_DIVIDE then
        dbms_output.put_line('Error al dividir entre 0');    
end;
/
undefine numero1;
undefine numero2;

select * from EMP;
--CUANDO LOS EMPLEADOS TENGAN UNA COMISION CON VALOR 0, 
--LANZAREMOS UNA EXCEPCION
--TENDREMOS UNA TABLA DONDE ALMACENAREMOS LOS EMPLEADOS
--CON COMISION MAYOR A CERO
create table emp_comision (apellido varchar2(50), comision number(9));
/
declare 
    cursor cursor_emp is
    select APELLIDO, COMISION from EMP order by COMISION DESC;
    exception_comision EXCEPTION;
begin
    for v_record in cursor_emp
    loop
        insert into emp_comision values (v_record.apellido, v_record.comision);
        if (v_record.COMISION = 0) then
            raise exception_comision;
        end if;
    end loop;
exception
    when exception_comision then
        dbms_output.put_line('Comisiones a ZERO');
    --quiero detener esto cuando la comision sea 0
end;
/
--PRAGMA EXCEPTIONS
describe dept;
-- declare 
--     exception_nulos EXCEPTION;
--     PRAGMA EXCEPTION_INIT(exception_nulos, -1400);
-- begin
--     insert into DEPT values (null, 'DEPARTAMENTO, 'PRAGMA');
-- exception
--     when exception_nulos then
--         dbms_output.put_line('No me sirven los nulos...');
-- end;

declare
    v_id number;
begin
    RAISE_APPLICATION_ERROR(-20400, 'Puedo hacer esto con Exception???');
    select DEPT_NO into v_id
    from DEPT
    where DNOMBRE='BENTAS';
    dbms_output.put_line('Ventas es el número ' || v_id);
end;