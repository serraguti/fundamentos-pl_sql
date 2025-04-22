
--VAMOS A MOSTRAR LA SUMA DE LOS PRIMEROS 100 NUMEROS
--1) LOOP..END LOOP
declare
    --variables contador suelen denominarse
    --con una sola letra: i, z k
    i int;
    suma int;
begin
    --debemos iniciar i, sino será null
    i := 1;
    --inicializamos suma
    suma := 0;
    loop
        --instrucciones
        suma := suma + i;
        --incrementamos la variable i
        i := i + 1;
        --debemos indicar cuándo queremos que el bucle finalice
        exit when i > 100;
    end loop;
    dbms_output.put_line('La suma de los 100 primeros números es: '
    || suma);
end;
--2) WHILE .. LOOP
--LA CONDICION SE EVALUA ANTES DE ENTRAR
declare
    i int;
    suma int;
begin
    --debemos iniciar las variables
    i := 1;
    suma := 0;
    while i <= 100 loop
        --instrucciones
        suma := suma + i;
        i := i + 1;
    end loop;
    dbms_output.put_line('La suma de los 100 primeros números es '
    || suma);
end;
--3) BUCLE FOR..LOOP (CONTADOR)
--CUANDO SABEMOS EL INICIO Y EL FINAL
declare
    suma int;
begin
    suma := 0;
    dbms_output.put_line('Inicio');
    dbms_output.put_line('Antes del bucle');    
    for contador in 1..100 loop
        suma := suma + contador;
    end loop;
    dbms_output.put_line('Después del bucle');    
    dbms_output.put_line('La suma de los primeros 100 números es ' || suma);
end;
--4) ETIQUETAS GOTO
declare
    suma int;
begin
    suma := 0;
    dbms_output.put_line('Inicio');
    goto codigo;
    dbms_output.put_line('Antes del bucle');    
    for contador in 1..100 loop
        suma := suma + contador;
    end loop;
    <<codigo>>
    dbms_output.put_line('Después del bucle');    
    dbms_output.put_line('La suma de los primeros 100 números es ' || suma);
end;
--5) ORDEN NULL
declare
    i int;
begin
    --debemos iniciar las variables
    i := 1;
    if (i >= 1) then
        dbms_output.put_line('i es mayor a 1');
    else
        null;
    end if;
end;
--EJEMPLOS
--BUCLE PARA MOSTRAR LOS NUMEROS ENTRE 1 Y 10 
--1) BUCLE WHILE
declare 
    i int;
begin
    i := 1;
    while i <= 10 loop
        dbms_output.put_line(i);
        i := i + 1;
    end loop;
    dbms_output.put_line('Fin de bucle while');
end;
--2) BUCLE FOR
declare 
    
begin
    for i in 1..10 loop
        dbms_output.put_line(i);
    end loop;
    dbms_output.put_line('Fin de bucle For');
end;
--PEDIR AL USUARIO UN NUMERO INICIO &inicio
--Y UN NUMERO FINAL
--MOSTRAR LOS NUMEROS COMPRENDIDOS ENTRE DICHO RANGO
--SI EL NUMERO INICIAL ES MAYOR, LO INDICAMOS Y NO HACEMOS EL BUCLE.
declare
    inicio int;
    fin int;
begin
    inicio := &inicial;
    fin := &final;
    --preguntamos por los valores de los numeros
    if (inicio >= fin) then
        dbms_output.put_line('El número de inicio (' || inicio || 
        ') debe ser menor al número de fin (' || fin || ')');
    else 
        for i in inicio..fin loop
            dbms_output.put_line(i);
        end loop;        
    end if;
    dbms_output.put_line('fin de programa');
end;
undefine inicial;
undefine final;
--QUEREMOS UN BUCLE PIDIENDO UN INICIO Y UN FIN
--MOSTRAR LOS NUMEROS PARES COMPRENDIDOS ENTRE DICHO INICIO Y FIN
declare
    ini int;
    fin int;
begin
    ini := &inicial;
    fin := &final;
    for i in ini..fin loop
        if (mod(i, 2) = 0) then 
            dbms_output.put_line(i);
        end if;
    end loop;
    dbms_output.put_line('Fin de programa');
end;
undefine inicial;
undefine final;
--CONJETURA DE COLLATZ
--La teoría indica que cualquier número siempre llegará a ser 1
--siguiendo una serie de instrucciones:
--Si el número es Par, se divide entre 2
--Si el número es Impar, se multiplica por 3 y sumamos 1
--6,3,10,5,16,8,4,2,1
declare
    numero int;
begin
    numero := &valor;
    while numero <> 1 loop
        --AVERIGUAMOS SI ES PAR/IMPAR
        if (mod(numero, 2) = 0) then
            numero := numero / 2;
        else 
            numero := numero * 3 + 1;
        end if;
        dbms_output.put_line(numero);
    end loop;
    dbms_output.put_line('Fin de programa');
end;
undefine valor;

--TABLA DE MULTIPLICAR DE UN NUMERO
declare
    numero int;
    operacion int;
begin
    numero := &valor;
    for i in 1..10 loop
        operacion := numero * i;
        dbms_output.put_line(numero || '*' || i || '=' || operacion);
    end loop;
    dbms_output.put_line('Fin de programa');
end;
undefine valor;

declare 
    v_texto varchar2(50);
    v_longitud int;
    v_letra varchar2(1);
begin
    v_texto := '&texto';
    --UN ELEMENTO EN ORACLE EMPIEZA EN 1
    --LUNESITO
    v_longitud := length(v_texto);
    for i in 1..v_longitud loop
        v_letra := substr(v_texto, i, 1);
        dbms_output.put_line(v_letra);
    end loop;
    dbms_output.put_line('Fin de programa');
end;
undefine texto;

declare
    v_texto_numero varchar2(50);
    v_longitud int;
    v_letra char(1);
    v_numero int;
    v_suma int;
begin
    v_suma := 0;
    v_texto_numero := &texto;
    v_longitud := length(v_texto_numero);
    for i in 1..v_longitud loop
        v_letra := substr(v_texto_numero, i, 1);
        v_numero := to_number(v_letra);
        v_suma := v_suma + v_numero;
    end loop;
    dbms_output.put_line('La suma de ' || v_texto_numero || ' es ' || v_suma);
end;
undefine texto;
--bloque para consultas de acción
--insertar 5 departamentos en un bloque pl/sql dinámico
declare
    v_nombre dept.dnombre%type;
    v_loc dept.loc%type;
begin
    --vamos a realizar un bucle para insertar 5 departamentos
    for i in 1..5 loop
        v_nombre := 'Departamento ' || i;
        v_loc := 'Localidad ' || i;
        insert into DEPT values 
        ((select max(DEPT_NO) + 1 from DEPT)
            , v_nombre, v_loc);
    end loop;
    dbms_output.put_line('Fin de programa');
end;
select * from DEPT;
rollback;
--realizar un bloque pl/sql que pedirá un número al 
--usuario y mostrará el departamento con dicho número
declare
    v_id int;
begin
    v_id := &numero;
    select * from DEPT where DEPT_NO=v_id;
end;
undefine numero;