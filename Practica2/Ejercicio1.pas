{
 Una empresa posee un archivo con información de los ingresos percibidos por diferentes
 empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
 nombre y monto de la comisión. La información del archivo se encuentra ordenada por
 código de empleado y cada empleado puede aparecer más de una vez en el archivo de
 comisiones.
 Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
 consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
 única vez con el valor total de sus comisiones.
 NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
 recorrido una única vez.
}

program Ejercicio1;
uses crt;

const
    impo = -1;

type
    emple = record
        nombre: string[30];
        cod: integer;
        monto: integer;
    end;

arc= file of emple;

procedure leer(var reg: emple; var detalle: arc);
begin
    if (not eof(detalle)) then
        read(detalle, reg)
    else
        reg.cod := impo;
end;

procedure compactar( var detalle:arc; var maestro:arc);
var
    aux: integer;
    tot: integer;
    reg,actual:emple;

begin
    assign(detalle, 'detalleEmpleados');
    assign(maestro, 'compactoEmple');
    reset(detalle);
    rewrite(maestro);
    leer(reg,detalle);
    while (reg.cod <> impo) do begin
        aux := reg.cod;
        actual.nombre:= reg.nombre;
        tot:= 0;
        while (reg.cod<>impo) and (reg.cod = aux) do begin
            tot := tot + reg.monto;
            leer(reg,detalle);
        end;
        actual.monto:= tot;
        actual.cod:= aux;
        write(maestro, actual);
 end;

    close(detalle);
    close(maestro);
end;

procedure informarEmpleado(e: emple);
begin
    writeln('Codigo: ', e.cod);
    writeln('Nombre: ', e.nombre);
    writeln('Monto total: ', e.monto);
    writeln('-------------------------');
end;

procedure imprimir(var maestro:arc);
var
reg: emple;
begin
    reset(maestro);
    writeln('Los empleados son:');
    while (not eof(maestro)) do begin
        read(maestro, reg);
        informarEmpleado(reg);
    end;
    close(maestro);
end;

var
detalle:arc;
maestro:arc;
begin
    compactar(detalle,maestro);
    imprimir(maestro);
    readln();
end.
