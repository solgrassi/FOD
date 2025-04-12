{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a 
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por 
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total 
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el 
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido 
por la empresa.  
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año, 
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes. 

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron 
compras. No es necesario que informe tales meses en el reporte. 
}

program Ejercicio9;
const
impo= -1;
type
    cliente = record
        cod:integer;
        nombre: string[30];
        apellido: string[30];
    end;

    maestro = record
       cli:cliente;
       anio: integer;
       mes:integer;
       dia:integer;
       monto: double;
    end;

arc = file of maestro;

procedure informarDatos (c: cliente);
begin
     writeln('Los datos del cliente son: ');
     writeln('Nombre: ', c.nombre);
     writeln('Apellido: ', c.apellido);
     writeln('Codigo de cliente: ', c.cod);
end;

procedure leer(var archivo: arc; var dato: maestro);
begin
    if not EOF(archivo) then
        read(archivo, dato)
    else
        dato.cli.cod := impo;
end;

procedure procesarMaestro(var mae: arc);
var
    regMae: maestro;
    actualC, actualA, actualM: integer;
    totMes, totAnio, totEmpresa: double;
begin
    assign(mae, 'maestroVentas');
    reset(mae);
    leer(mae, regMae);
    totEmpresa := 0;

    while (regMae.cli.cod <> impo) do begin
        actualC := regMae.cli.cod;
        informarDatos(regMae.cli);

        while (regMae.cli.cod = actualC) do begin
            actualA := regMae.anio;
            totAnio := 0;
            writeln('Año: ', actualA);

            while (regMae.cli.cod = actualC) and (regMae.anio = actualA) do begin
                actualM := regMae.mes;
                totMes := 0;
                writeln('Mes: ', actualM);

                while (regMae.cli.cod = actualC) and (regMae.anio = actualA) and (regMae.mes = actualM) do begin
                    totMes := totMes + regMae.monto;
                    leer(mae, regMae);
                end;

                writeln('Total mes: $', totMes:0:2);
                totAnio := totAnio + totMes;
            end;

            writeln('Total año ', actualA, ': $', totAnio:0:2);
            totEmpresa := totEmpresa + totAnio;
        end;
        writeln;
    end;

    writeln('---------------------------------------------');
    writeln('TOTAL RECAUDADO POR LA EMPRESA: $', totEmpresa:0:2);
    close(mae);
end;


var
mae:arc;
begin
     procesarMaestro(mae);
     readln();
end.



