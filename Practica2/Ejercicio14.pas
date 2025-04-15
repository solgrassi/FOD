// consultar whileee
{ Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus 
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la 
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles 
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida 
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino 
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada 
uno del maestro. Se pide realizar los módulos necesarios para: 
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje 
sin asiento disponible. 
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que 
tengan menos de una cantidad específica de asientos disponibles. La misma debe 
ser ingresada por teclado. 
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

program ejercicio14;
const
impo='zzzz';
type
    vuelos = record
        destino: string[100];
        fecha: string[10];
        horaS: double;
        asientos: integer;
   end;

   lista = ^nodo;

   nodo = record
        dato:vuelos;
        sig: lista;
   end;

arc= file of vuelos;

procedure crearMaestro(var mae: arc);
var
  v: vuelos;
begin
  rewrite(mae);
  v.destino := 'Londres'; v.fecha := '13/04/2025'; v.horaS := 09.00; v.asientos := 80; write(mae, v);
  v.destino := 'Madrid'; v.fecha := '12/04/2025'; v.horaS := 10.30; v.asientos := 120; write(mae, v);
  v.destino := 'Madrid'; v.fecha := '12/04/2025'; v.horaS := 18.45; v.asientos := 100; write(mae, v);
  v.destino := 'París'; v.fecha := '14/04/2025'; v.horaS := 15.00; v.asientos := 50; write(mae, v);
   v.destino := 'París'; v.fecha := '15/04/2025'; v.horaS := 17.00; v.asientos := 100; write(mae, v);
  close(mae);
end;

procedure crearDetalle1(var det: arc);
var
  v: vuelos;
begin
  rewrite(det);
  v.destino := 'Londres'; v.fecha := '13/04/2025'; v.horaS := 09.00; v.asientos := 20; write(det, v);
  v.destino := 'Madrid'; v.fecha := '12/04/2025'; v.horaS := 10.30; v.asientos := 10; write(det, v);
  close(det);
end;

procedure crearDetalle2(var det: arc);
var
  v: vuelos;
begin
  rewrite(det);
  v.destino := 'Madrid'; v.fecha := '12/04/2025'; v.horaS := 18.45; v.asientos := 25; write(det, v);
  v.destino := 'París'; v.fecha := '14/04/2025'; v.horaS := 15.00; v.asientos := 10; write(det, v);
  close(det);
end;

procedure asignarArchivos (var mae:arc; var det1,det2:arc);
begin
     assign(mae, 'C:\Dev-Pas\maestroVuelos');
     assign(det1, 'C:\Dev-Pas\detalleVuelos');
     assign(det2, 'C:\Dev-Pas\detallesVuelos2');
end;

procedure leer (var de:arc; var v:vuelos);
begin
     if (not EOF(de)) then
        read(de,v)
     else
         v.destino:= impo;
end;

procedure minimo (var det1:arc; var det2:arc; var r1,r2,min:vuelos);
begin
     if (r1.destino < r2.destino) or 
        ((r1.destino = r2.destino) and (r1.fecha < r2.fecha)) or
        ((r1.destino = r2.destino) and (r1.fecha = r2.fecha) and (r1.horaS < r2.horaS)) then begin
        min := r1;
        leer(det1, r1);
     end
     else begin
        min := r2;
        leer(det2, r2);
     end;
end;


procedure agregarLista (var l,ult:lista; re: vuelos);
var
nue:lista;
begin
     new(nue);
     nue^.dato:= re;
     nue^.sig:= nil;
     if (l= nil) then
        l:= nue
     else
        ult^.sig:= nue;
     ult:= nue;
end;

procedure actualizarMaestro (var mae:arc; var det1,det2:arc; var l:lista);
var
r1,r2,min,regMae: vuelos;
menosAsi: integer;
ult:lista;
begin
     writeln('Ingrese la cantidad de asientos disponibles');
     read(menosAsi);
     reset(mae);
     reset(det1);
     reset(det2);
     leer(det1,r1);
     leer(det2, r2);
     minimo(det1,det2,r1,r2,min);

     while (not EOF(mae)) do begin
         read(mae, regMae);
         if (min.destino <> impo)  then begin
             while (regMae.destino = min.destino) and (regMae.fecha = min.fecha) and (regMae.horaS = min.horaS) do begin
                 regMae.asientos := regMae.asientos - min.asientos;
                 minimo(det1, det2, r1, r2, min);
             end;
             seek(mae, filepos(mae)-1);
             write(mae, regMae);
         end;
         if (regMae.asientos < menosAsi) then
             agregarLista(l, ult, regMae);
     end;
     close(mae);
     close(det1);
     close(det2);
     writeln('Maestro actualizado con exito');
end;

procedure imprimirLista(var l: lista);
begin
    while (l <> nil) do begin
        writeln('Destino: ', l^.dato.destino, ' Fecha: ', l^.dato.fecha, 
                ' Hora: ', l^.dato.horaS:0:2, ' Asientos: ', l^.dato.asientos);
        l := l^.sig;
    end;
end;

var
mae:arc;
det1:arc;
det2:arc;
l:lista;
begin
     l:=nil;
     asignarArchivos(mae,det1,det2);
     crearMaestro(mae);
     crearDetalle1(det1);
     crearDetalle2(det2);
     actualizarMaestro(mae,det1,det2,l);
     readln();
     imprimirLista(l);
     readln();
end.
