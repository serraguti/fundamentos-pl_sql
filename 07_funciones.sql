--Realizar una función para sumar dos números
create or replace function f_sumar_numeros
(p_numero1 number, p_numero2 number)
return number
as
    v_suma number;
begin
    v_suma := nvl(p_numero1, 0) + nvl(p_numero2, 0);
    --SIEMPRE UN RETURN
    return v_suma;
end;

--llamada con codigo pl/sql
declare
    v_resultado number;
begin
    v_resultado := F_SUMAR_NUMEROS(22, 55);
    dbms_output.put_line('La suma es ' || v_resultado);
end;
--llamada con select
select F_SUMAR_NUMEROS(22, 99) as SUMA from dual;
select apellido, F_SUMAR_NUMEROS(salario, comision) as TOTAL from EMP;
select F_SUMAR_NUMEROS(null, null) as SUMA from dual;
--FUNCION PARA SABER EL NUMERO DE PERSONAS DE UN OFICIO
create or replace function num_personas_oficio
(p_oficio EMP.OFICIO%TYPE)
return NUMBER
as
    v_personas int;
begin
    select count(EMP_NO) into v_personas from EMP
    where lower(OFICIO) = lower(p_oficio);
    return v_personas;
end;
select NUM_PERSONAS_OFICIO('analista') as PERSONAS from DUAL;
--Realizar una función para devolver el mayor de dos números
create or replace function mayor_dos_numeros
(p_numero1 number, p_numero2 number)
return number
as
    v_mayor number;
begin
    if (p_numero1 > p_numero2) then
        v_mayor := p_numero1;
    else
        v_mayor := p_numero2;
    end if;
    return v_mayor;
end;
select MAYOR_DOS_NUMEROS(8 , 99) as mayor from DUAL;
--Realizar una función para devolver el mayor de tres números
--No quiero utilizar IF.
--Buscar (Google) una función de Oracle que nos devuelva el mayor...
create or replace function mayor_tres_numeros
(p_numero1 number, p_numero2 number, p_numero3 number)
return number
as
    v_mayor number;
begin
    v_mayor := greatest(p_numero1, p_numero2, p_numero3);
    return v_mayor;
end;
select MAYOR_TRES_NUMEROS(8,3,55) as mayor from DUAL;
--Tenemos los parámetros por defecto dentro de las funciones
select 100 * 1.21 as iva from DUAL;
select 100 * 1.18 as iva from DUAL;
select importe, iva(importe) as iva from productos;
select importe, iva(importe, 21) as iva from productos;
create or replace function calcular_iva
(p_precio number, p_iva number := 1.18)
return number
as 
begin
    return p_precio * p_iva;
end;
select CALCULAR_IVA(100, 1.21) as iva from DUAL;
select CALCULAR_IVA(100) as iva from DUAL;

