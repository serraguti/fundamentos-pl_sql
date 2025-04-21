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