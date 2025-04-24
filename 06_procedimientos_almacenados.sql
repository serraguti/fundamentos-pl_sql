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