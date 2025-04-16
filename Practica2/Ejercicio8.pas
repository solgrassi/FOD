{ Se quiere optimizar la gestión del consumo de yerba mate en distintas provincias de 
Argentina. Para ello, se cuenta con un archivo maestro que contiene la siguiente 
información: código de provincia, nombre de la provincia, cantidad de habitantes y cantidad 
total de kilos de yerba consumidos históricamente. 
Cada mes, se reciben 16 archivos de relevamiento con información sobre el consumo de 
yerba en los distintos puntos del país. Cada archivo contiene: código de provincia y cantidad 
de kilos de yerba consumidos en ese relevamiento. Un archivo de relevamiento puede 
contener información de una o varias provincias, y una misma provincia puede aparecer 
cero, una o más veces en distintos archivos de relevamiento. 
Tanto el archivo maestro como los archivos de relevamiento están ordenados por código de 
provincia. 
Se desea realizar un programa que actualice el archivo maestro en base a la nueva 
información de consumo de yerba. Además, se debe informar en pantalla aquellas 
provincias (código y nombre) donde la cantidad total de yerba consumida supere los 10.000 
kilos históricamente, junto con el promedio consumido de yerba por habitante. Es importante 
tener en cuenta tanto las provincias actualizadas como las que no fueron actualizadas. 
Nota: cada archivo debe recorrerse una única vez.
}

program ejercicio8;
const
impo = 9999;
df= 2;
type
    yerba = record
        codPro: integer;
        nomPro:string[50];
        cantHa: integer;
        kilosCo:integer;
    end;

    provincia = record
       codPro:integer;
       kilosC: integer;
    end;

arc = file of yerba;
det = file of provincia;
detalles = array [1..df] of det;
registros= array [1..df] of provincia;

// crear archivos ----------------------------------------------

procedure crearMaestro (var mae:arc);
var
y:yerba;
begin
    rewrite(mae);

    y.codPro := 1;
    y.nomPro := 'Buenos Aires';
    y.cantHa := 15000000;
    y.kilosCo := 9800;
    write(mae, y);

    y.codPro := 2;
    y.nomPro := 'Cordoba';
    y.cantHa := 3500000;
    y.kilosCo := 12000;
    write(mae, y);

    y.codPro := 3;
    y.nomPro := 'Misiones';
    y.cantHa := 1100000;
    y.kilosCo := 8900;
    write(mae, y);

    close(mae);
    writeln('Archivo maestro creado correctamente.');
end;

procedure crearDetalles (var de:detalles);
var
    p: provincia;
begin
    { Crear detalle1 con dos registros: Buenos Aires y Misiones }
    rewrite(de[1]);

    p.codPro := 1; // Buenos Aires
    p.kilosC := 500;
    write(de[1], p);

    p.codPro := 3; // Misiones
    p.kilosC := 200;
    write(de[1], p);

    close(de[1]);

    { Crear detalle2 con dos registros: Buenos Aires y Córdoba }
    rewrite(de[2]);

    p.codPro := 1; // Buenos Aires
    p.kilosC := 300;
    write(de[2], p);

    p.codPro := 2; // Córdoba
    p.kilosC := 1000;
    write(de[2], p);

    close(de[2]);

    writeln('Archivos detalle1 y detalle2 creados correctamente.');
end;

//----------------------------------------------------------------

procedure asignarArchivos (var mae:Arc; var det:detalles);
var
i:integer;
num:string;
begin
    assign(mae, 'maestroYerba');
    for i:= 1 to df do begin
        Str(i,num);
        assign(det[i], 'detalle' + num);
    end;
end;

procedure leer (var d:det; var reg:provincia);
begin
     if (not EOF(d)) then
        read(d,reg)
     else
         reg.codPro := impo;
end;

procedure minimo(var de:detalles; var r:registros; var min:provincia);
var
    i, posMin: integer;
begin
    min.codPro := impo;
    posMin := -1;

    for i := 1 to df do begin
        if (r[i].codPro < min.codPro) then begin
            min := r[i];
            posMin := i;
        end;
    end;

    if (posMin <> -1) then
        leer(de[posMin], r[posMin]);
end;


procedure actualizarMaestro (var mae:arc; var de:detalles; var r:registros);
var
i,cantYerba:integer;
regMae:yerba;
min:provincia;
begin
     reset(mae);
     for i:= 1 to df do begin
         reset(de[i]);
         leer(de[i],r[i]);
     end;
     minimo(de,r,min);

     while (not EOF(mae)) do begin
         read(mae, regMae);
         cantYerba := 0; 
         while (regMae.codPro = min.codPro) do begin
            cantYerba := cantYerba + min.kilosC;
            minimo(de, r, min);
         end;
         if (cantYerba > 0) then begin
            regMae.kilosCo := regMae.kilosCo + cantYerba;
            seek(mae, filepos(mae) - 1);
            write(mae, regMae);
         end;
         if (regMae.kilosCo > 7000) then begin
            writeln('Codigo de prov: ', regMae.codPro, ', nombre: ', regMae.nomPro);
            writeln('Promedio consumido por habitante: ', (regMae.kilosCo / regMae.cantHa) :0:5, ' kg');
        end;
     end;

     close(mae);
     for i:= 1 to df do
         close(de[i]);
end;

var
mae:arc;
de:detalles;
r:registros;
begin
     asignarArchivos(mae,de);
     crearMaestro(mae);
     crearDetalles(de);
     actualizarMaestro(mae,de,r);
     readln();
end.
