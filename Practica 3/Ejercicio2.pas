{ Definir un programa que genere un archivo con registros de longitud fija conteniendo 
información de asistentes a un congreso a partir de la información obtenida por 
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y 
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del 
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de 
asistente inferior a 1000.  
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo 
String a su elección.  Ejemplo:  ‘@Saldaño’. }


program ejercicio2;
const
valorAlto= 9999;

type
    asistente = record
        num: integer;
        ape: string[25];
        nom: string[25];
        email: string[100];
        cel: integer;
        dni: integer;
    end;

arc= file of asistente;


procedure leerAsistente (var s: asistente);
begin
     writeln('Ingrese el numero de asistente (9999 para terminar)');
     readln(s.num);
     if (s.num<> valorAlto) then begin
        writeln('Ingrese el apellido');
        readln(s.ape);
        writeln('Ingrese el nombre');
        readln(s.nom);
        writeln('Ingrese el email');
        readln(s.email);
        writeln('Ingrese el numero de celular');
        readln(s.cel);
        writeln('Ingrese el dni');
        readln(s.dni);
     end;
end;

procedure cargarArchivo (var mae:arc);
var
asi:asistente;
begin
    assign(mae, 'archivoAsistentes');
    rewrite(mae);
    leerAsistente(asi);
    while (asi.num <> valorAlto) do begin
          write(mae,asi);
          leerAsistente(asi);
    end;

    close(mae);
end;


procedure eliminarInferiores (var mae:arc);
var
regMae:asistente;
begin
     reset(mae);
     while (not EOF (mae)) do begin
           read(mae,regMae);
           if (regMae.num < 1000) then begin
              regMae.ape := '#' + regMae.ape;
              seek(mae, filepos(mae) -1);
              write(mae, regMae);
           end;
     end;
     close(mae);
end;
procedure informarAsi (reg:asistente);
begin
     write(reg.num, ' ' );
     write(reg.ape, ' ');
     writeln(reg.nom);
end;

procedure imprimirArchivo (var mae:arc) ;
var
reg:asistente;
begin
     assign(mae, 'archivoAsistentes');
     reset(mae);
     while (not EOF(mae)) do begin
           read(mae,reg);
           informarAsi (reg);
     end;
     close(mae);
end;

var
mae:arc;
begin
     cargarArchivo(mae);
     eliminarInferiores(mae);
     imprimirArchivo(mae);
     readln();
end.

