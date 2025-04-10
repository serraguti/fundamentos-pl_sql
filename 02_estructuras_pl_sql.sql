--DEBEMOS COMPROBAR SI UN NUMERO ES POSITIVO O NEGATIVO
declare
    v_numero int;
begin
    --pedimos el numero al usuario
    v_numero := &numero;
    --preguntamos por el propio numero
    if (v_numero >= 0) then
        dbms_output.put_line('Positivo: ' || v_numero);
    else
        dbms_output.put_line('Negativo: ' || v_numero);
    end if;
    dbms_output.put_line('Fin de programa');
end;
undefine numero;
--DEBEMOS COMPROBAR SI UN NUMERO ES POSITIVO, NEGATIVO o CERO
declare
    v_numero int;
begin
    v_numero := &numero;
    if (v_numero > 0) then 
        dbms_output.put_line('Es positivo...' || v_numero);
    elsif (v_numero = 0) then
        dbms_output.put_line('Es cero!!! ' || v_numero);
    elsif (v_numero < 0) then
        dbms_output.put_line('Negativo ' || v_numero);
    end if;
    dbms_output.put_line('Fin de programa 2');
end;

--EJEMPLO DE ESTACIONES ANUALES
declare
    v_estacion int;
begin
    v_estacion := &estacion;
    if (v_estacion = 1) then
        dbms_output.put_line('Primavera');
    elsif (v_estacion = 2) then
        dbms_output.PUT_LINE('Verano');
    elsif (v_estacion = 3) then
        DBMS_OUTPUT.PUT_LINE('Otoño');
    elsif (v_estacion = 4) then 
        dbms_output.put_line('Invierno');
    else
        dbms_output.put_line('Valor incorrecto: ' || v_estacion);
    end if;
    dbms_output.put_line('Fin de programa');
end;
undefine estacion;

--EJEMPLO NUMERO MAYOR
declare
    v_num1 int;
    v_num2 int;
begin
    v_num1 := &num1;
    v_num2 := &num2;
    if (v_num1 > v_num2) then 
        --MAYOR ES EL NUMERO 1
        dbms_output.put_line('Número mayor ' || v_num1);
    else
        dbms_output.put_line('Número mayor ' || v_num2);
    end if;
    dbms_output.put_line('Fin de programa');
end;

--PEDIR UN NUMERO AL USUARIO E INDICAR SI ES PAR O IMPAR
declare 
    v_numero int;
begin
    v_numero := &numero;
    if (mod(v_numero, 2) = 0) then
        dbms_output.put_line('El número es par');
    else
        dbms_output.put_line('El número es impar');  
    end if;
end;
undefine numero;

--Por supuesto, podemos perfectamente utilizar cualquier 
--operador, tanto de comparación, como relacional en nuestros 
--códigos.
--Pedir una letra al usuario.  Si la letra es vocal (a,e,i,o,u)
--pintamos vocal, sino, consonante
/
declare 
    v_letra varchar2(1);
begin 
    v_letra := lower('&letra');
    if (v_letra = 'a' or v_letra = 'e' or v_letra = 'i' 
    or v_letra = 'o' or v_letra= 'u') then 
        dbms_output.put_line('Vocal ' || v_letra);
    else 
        dbms_output.put_line('Consonante ' || v_letra);
    end if;
    dbms_output.put_line('Fin de programa');
end;
/

--Pedir tres números al usuario
--Debemos mostrar el mayor de ellos, el menor de ellos y el intermedio.
/
declare 
    v_num1 int;
    v_num2 int;
    v_num3 int;
    v_mayor int;
    v_menor int;
    v_intermedio int;
    v_suma int;
begin
    v_num1 := &num1;
    v_num2 := &num2;
    v_num3 := &num3;
    if (v_num1 >= v_num2 and v_num1 >= v_num3) then 
        v_mayor := v_num1;
    elsif (v_num2 >= v_num1 and v_num2 >= v_num3) then 
        v_mayor := v_num2;
    else 
        v_mayor := v_num3;
    end if;
    if (v_num1 <= v_num2 and v_num1 <= v_num3) then
        v_menor := v_num1;
    elsif (v_num2 <= v_num1 and v_num2 <= v_num3) then 
        v_menor := v_num2;
    else
        v_menor := v_num3;
    end if;
    v_suma := v_num1 + v_num2 + v_num3;
    v_intermedio := v_suma - v_mayor - v_menor;
    dbms_output.put_line('Mayor: ' || v_mayor);
    dbms_output.put_line('Menor: ' || v_menor);
    dbms_output.put_line('Intermedio: ' || v_intermedio);
end;
/
undefine num1;
undefine num2;
undefine num3;











