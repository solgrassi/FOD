{ Se desea modelar la información necesaria para un sistema de recuentos de casos de covid 
para el ministerio de salud de la provincia de buenos aires. 
Diariamente se reciben archivos provenientes de los distintos municipios, la información 
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de 
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos 
fallecidos. 
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad, 
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos 
nuevos, cantidad de recuperados y cantidad de fallecidos.
 
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles 
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de 
localidad y código de cepa.  
Para la actualización se debe proceder de la siguiente manera:  
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle. 
2. Idem anterior para los recuperados. 
3. Los casos activos se actualizan con el valor recibido en el detalle. 
4. Idem anterior para los casos nuevos hallados. 
Realice las declaraciones necesarias, el programa principal y los procedimientos que 
requiera para la actualización solicitada e informe cantidad de localidades con más de 50 
casos activos (las localidades pueden o no haber sido actualizadas).
}

program Ejercicio6;
const
df = 10;
impo = -1;
type
    municipio = record
       codLoca: integer;
       codCepa: integer;
       activos: integer;
       nuevos:  integer;
       recu:    integer;
       falle:   integer;
   end;

   ministerio = record
      codLoca:  integer;
      loca:     string[20];
      codCepa:  integer;
      cepa:     string[20];
      activos:  integer;
      nuevos:   integer;
      recu:     integer;
      falle:    integer;
  end;

arc = file of ministerio;
det= file of municipio;
detalles = array [1..df] of det;
registros = array [1..df] of municipio;

procedure asignarArchivos (var mae:arc; var det:detalles);
var
i:integer;
num:string;
begin
     assign(mae, 'maestro');
     for i:= 1 to df do begin
         Str(i ,num);
         assign(det[i], 'detalle' + num);
     end;
end;

procedure leer (var d:det; var r:municipio);
begin
     if (not EOF(d)) then
        read(d,r)
     else
         r.codLoca:= impo;
end;

procedure minimo (var det:detalles; var r:registros; var min: municipio);
var
i,aux,indice,aux2:integer;
begin
     aux:= 9999;
     aux2:=9999;
     indice:= -1;
     for i:= 1 to df do begin
        if (r[i].codLoca < aux) or ((r[i].codLoca = aux) and (r[i].codCepa < aux2)) then begin
          aux:= r[i].codLoca;
          aux2:= r[i].codCepa;
          indice:= i;
          min:= r[i];
        end;
     end;
     if(indice<> -1) then
        leer(det[indice],r[indice]);
end;


procedure actualizarMaestro (var mae:arc;var det:detalles;var r:registros);
var
i:integer;
min:municipio;
regMae: ministerio;
begin
     reset(mae);
     for i:= 1 to df do begin
         reset(det[i]);
         leer(det[i],r[i]);
     end;
     minimo(det,r,min);
     while (min.codLoca <> impo) do begin
           read(mae,regMae);

           while (regMae.codLoca <> min.codLoca) do
                 read(mae,regMae);
           while (min.codLoca = regMae.codLoca) and (min.codCepa = regMae.codCepa)  do begin
                  regMae.falle :=  regMae.falle + min.falle;
                  regMae.recu :=   regMae.recu + min.recu;
                  regMae.activos:= min.activos;
                  regMae.nuevos:=  min.nuevos;
                  minimo(det,r,min);
           end;
               seek(mae, FilePos(mae) - 1);
               write(mae,regMae);
     end;
     close(mae);
     for i:= 1 to df do
         close(det[i]);
end;

procedure informarMasCasos (var mae:arc);
var
reg: ministerio;
cant:integer;
begin
     reset(mae);
     cant:=0;
     while (not EOF(mae)) do begin
           read(mae,reg);
           if (reg.activos > 50) then
                  cant:= cant +1;
     end;
     writeln('La cantidad de localidades con mas de 50 casos activos es de: ', cant);
end;

var
mae:arc;
deta: detalles;
r:registros;
begin
    asignarArchivos(mae,deta);
    actualizarMaestro(mae,deta,r);
    informarMasCasos(mae);
end.
