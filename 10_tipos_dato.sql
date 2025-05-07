--bloque anonimo para recuperar el apellido, oficio y salario de empleados
declare
    --primero declaramos el tipo.
    type type_empleado is record(
        v_apellido varchar2(50),
        v_oficio varchar2(50),
        v_salario number
    );
    --uso del tipo en una variable
    v_tipo_empleado type_empleado;
begin
    select APELLIDO, OFICIO, SALARIO into v_tipo_empleado
    from EMP where EMP_NO=7839;
    dbms_output.put_line('Apellido: ' || v_tipo_empleado.v_apellido
    || ', Oficio: ' || v_tipo_empleado.v_oficio
    || ', Salario: ' || v_tipo_empleado.v_salario);
end;


create or replace package pk_variables
as
    type type_empleado is record(
        v_apellido varchar2(50),
        v_oficio varchar2(50),
        v_salario number
    );
end pk_variables;
    create or replace function function_programa
    return apellido, oficio
    as
        v_emp ????;
    begin 
        --DEVOLVEMOS UN EMPLEADO
        select apellido, oficio, salario + comision into v_emp from EMP;
        return v_emp;
    end;
create or replace procedure ejemplo
as
    v_dato ???;
begin
    v_dato := function_programa;
end;

--Por un lado tenemos la declaración del tipo
--por otro lado, tenemos la variable de dicho tipo
declare
    --un tipo array para numeros
    type table_numeros IS TABLE OF NUMBER
    index by BINARY_INTEGER;
    --OBJETO PARA ALMACENAR VARIOS NUMEROS
    lista_numeros table_numeros;
begin
    --almacenamos datos en su interior
    lista_numeros(1) := 88;
    lista_numeros(2) := 99;
    lista_numeros(3) := 222;
    dbms_output.put_line('Numero elementos: ' || lista_numeros.count);
    --podemos recorrer todos los registros (numeros) que tengamos
    for i in 1..lista_numeros.count loop
        dbms_output.put_line('Numero: ' || lista_numeros(i));
    end loop; 
end;
  
--almacenamos a la vez
--guardamos un tipo fila de departamento
declare
    type table_dept is table of DEPT%ROWTYPE INDEX BY 
    BINARY_INTEGER;
    --declaramos el objeto para almacenar filas
    lista_dept table_dept;
begin
    select * into lista_dept(1) from DEPT where DEPT_NO=10;
    select * into lista_dept(2) from DEPT where DEPT_NO=30;
    for i in 1..lista_dept.count
    loop
        dbms_output.put_line(lista_dept(i).DNOMBRE || ', ' || lista_dept(i).LOC);
    end loop;
end;
DECLARE
   CURSOR cursorEmpleados is
   SELECT  apellido FROM EMP;
   type c_lista is varray (20) of EMP.apellido%type;
   --crear un objeto
   lista_empleados c_lista := c_lista();
   contador integer :=0;
BEGIN
   FOR n IN cursorEmpleados LOOP
      contador := contador + 1;
      lista_empleados.extend;
      lista_empleados(contador)  := n.apellido;
      dbms_output.put_line('Empleado('||contador ||'):'||lista_empleados(contador));
   END LOOP;
END;

--mostrar los numeros pares de 2 a 30
DECLARE
   v_contador number := 0;
BEGIN
   FOR i IN 1..30 LOOP
      v_contador := v_contador + 2;
      dbms_output.put_line(v_contador);
   END LOOP;
END;
