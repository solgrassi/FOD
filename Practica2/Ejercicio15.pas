{Se desea modelar la información de una ONG dedicada a la asistencia de personas con 
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información 
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre 
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin 
agua, # viviendas sin sanitarios.  
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras 
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información 
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas 
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios. 
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles 
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de 
provincia y código de localidad.  
Para la actualización del archivo maestro, se debe proceder de la siguiente manera:  
- Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
- Idem para viviendas sin agua, sin gas y sin sanitarios.
- A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de  provincia y localidad aparecen a lo sumo una única vez. 
Realice las declaraciones necesarias, el programa principal y los procedimientos que 
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de 
chapa (las localidades pueden o no haber sido actualizadas).
}
program ejercicio15;
const
df = 10;
impo= 9999;

type
     maestro = record
        codPro: integer;
        nomPro:string[20];
        codLoca: integer;
        nomLoca: string[20];
        sinLuz: integer;
        sinAgua: integer;
        sinGas: integer;
        sinSani: integer;
        deChapa: integer;
     end;
     detalle = record
        codPro: integer;
        codLoca: integer;
        conLuz: integer;
        conAgua: integer;
        conGas: integer;
        conSani: integer;
        construidas: integer;
     end;

det = file of detalle;
detalles = array [1..df] of  det;
arc = file of maestro;
registros = array [1..df] of detalle;

procedure asignarArchivos (var mae:arc; var det: detalles);
var
i:integer;
num: string;
begin
     assign(mae, 'maestroONG');
     for i:= 1 to df do begin
         Str(i,num);
         assign(det[i], 'detalle' + num);
     end;
end;

procedure leer (var d: det; reg: detalle);
begin
     if (not EOF(d)) then
        read(d,reg)
     else
         reg.codPro:= impo;
end;

procedure minimo (var det:detalles; var r:registros; var min:detalle);
var
i,indice: integer;
begin
     min.codPro:= impo;
     min.codLoca:= impo;
     for i:= 1 to df do begin
         if (r[i].codPro < min.codPro) or ((r[i].codPro = min.codPro) and (r[i].codLoca < min.codLoca)) then begin
            indice:= i;
            min:= r[i];
         end;
     end;
     leer(det[indice], r[indice]);
end;


procedure actualizarMaestro (var mae:arc; var det:detalles; var r:registros);
var
min: detalle;
regMae: maestro;
i,locaSinChapa:integer;
begin
     locaSinChapa:=0;
     reset(mae);
     for i:= 1 to df do begin
         reset(det[i]);
         leer(det[i],r[i]);
     end;
     minimo(det,r, min);
     while (min.codPro <> impo) do begin
           read(mae,regMae);
           if (regMae.codPro = min.codPro)and (regMae.codLoca = min.codLoca) then begin
                     regMae.sinLuz:= regMae.sinLuz - min.conLuz;
                     regMae.sinAgua:= regMae.sinAgua - min.conAgua;
                     regMae.sinSani:= regMae.sinSani - min.conSani;
                     regMae.sinGas:= regMae.sinGas - min.conGas;
                     regMae.deChapa:= regMae.deChapa - min.construidas;
                     minimo(det,r,min);
           end;
           seek(mae, filepos(mae)-1);
           write(mae,regMae);
           if (regMae.deChapa = 0) then
              locaSinChapa := locaSinChapa + 1;
    end;
    while (not EOF(mae)) do begin
         read(mae, regMae);
         if (regMae.deChapa = 0) then
              locaSinChapa := locaSinChapa + 1;
    end;
    close(mae);
    for i:= 1 to df do
        close(det[i]);
    writeln('La cantidad de localidades sin viviendas de chapa es de: ', locaSinChapa);
end;


var
mae:arc;
deta:detalles;
r:registros;
begin
     asignarArchivos(mae,deta);
     actualizarMaestro(mae,deta,r);
end.

