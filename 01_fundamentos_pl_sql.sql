declare 
    --MI COMENTARIO
    --DECLARAMOS UNA VARIABLE
    numero int;
    texto varchar2(50);
begin
    texto := 'mi primer PL/SQL';
    dbms_output.put_line('Mensaje: ' || texto);
    dbms_output.put_line('Mi primer bloque anónimo ' );
    numero := 44;
    dbms_output.put_line('Valor número: ' || numero);
    numero := 22;
    dbms_output.put_line('Valor número nuevo: ' || numero);    
end;



declare 
    nombre varchar2(30);
begin
    nombre := '&dato';
    dbms_output.put_line('Su nombre es ' || nombre);
end;


declare 
    fecha date;
    texto varchar2(50);
    longitud int;
begin
    fecha := SYSDATE;
    texto := '&data';
    --ALMACENAMOS LA LONGITUD DEL TEXTO
    longitud := LENGTH(texto);
    --LA LONGITUD DE SU TEXTO ES 41
    DBMS_OUTPUT.PUT_LINE('La longitud del texto es ' || longitud);
    --HOY ES ...Miércoles
    dbms_output.put_line('Hoy es ' || to_char(fecha, 'day'));
    dbms_output.put_line(texto);
end;

DECLARE
    numero1 int;
    numero2 int;
    suma int;
BEGIN
    numero1 := &num1;
    numero2 := &num2;
    suma := numero1 + numero2;
    dbms_output.put_line('La suma de ' || numero1 
    || ' + ' || numero2 || '=' || suma);
end;
--QUITAR LA DEFINICION DE LAS VARIABLES
undefine num1;
undefine num2;

declare
    --declaramos una variable para almacenar el numero de departamento
    v_departamento int;
begin
    --pedimos un número al usuario
    v_departamento := &dept;
    update EMP set SALARIO = SALARIO + 1 where DEPT_NO = v_departamento;
end;
undefine dept;

--BLOQUE PARA INSERTAR UN DEPARTAMENTO
declare
    v_numero dept.dept_no%type;
    v_nombre dept.dnombre%type;
    v_localidad dept.loc%type;
begin
    v_numero := &numero;
    v_nombre := '&nombre';
    v_localidad := '&localidad';
    insert into DEPT values (v_numero, v_nombre, v_localidad);
end;
undefine numero;
undefine nombre;
undefine localidad;
select * from DEPT;









