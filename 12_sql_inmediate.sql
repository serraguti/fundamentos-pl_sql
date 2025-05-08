create table registros
(idcliente number
, compras varchar2(50)
, ventas varchar2(50)
, estado number);

insert into registros (idcliente, compras, estado)
values (1, 'telefono', 1);

insert into registros (idcliente, ventas, estado)
values (1, 'telefono averiado', 0);
--querría tener un procedimiento que insertar compras o ventas
create or replace procedure sp_insert_registro
(p_idcliente number, p_valor varchar2, p_estado number, p_tipo boolean)
as
begin
    if p_tipo = true then
        insert into registros (idcliente, compras, estado)
        values (p_idcliente, p_valor, p_estado);
    else
        insert into registros (idcliente, ventas, estado)
        values (p_idcliente, p_valor, p_estado);
    end if;
end;
--sql dinamico
create or replace procedure sp_insert_registro
(p_idcliente number, p_valor varchar2, p_estado number, p_columna varchar)
as
    v_sql varchar2(500);
begin
    v_sql := 'insert into registros (idcliente, ' || p_columna || ', estado) '
    || ' values (:pam1, :pam2, :pam3)';
    execute IMMEDIATE v_sql using p_idcliente, p_valor, p_estado;
end;