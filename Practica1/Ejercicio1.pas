{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita 
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza 
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del 
archivo debe ser proporcionado por el usuario desde teclado. }
program Ejercicio1;
uses crt;
var
archivo: file of integer;
num: integer;
nom_fisico: string;
begin
  writeln('ingrese el nombre del archivo');
  readln(nom_fisico);
  //conceccion entre archivo logico y fisico
  assign(archivo,nom_fisico);
  //creacion
  rewrite(archivo);
  //ingreso y guardado de numeros
  writeln('ingrese un numero');
  readln(num);
  while (num<>30000) do begin
        write(archivo,num);
        writeln('ingrese un numero');
        readln(num);
  end;
  close(archivo);
  writeln('archivo creado');
  //imprimo el archivo
  reset(archivo);
  while not(EOF(archivo)) do begin
        read(archivo,num);
        writeln(num);
  end;
  close(archivo);
  writeln('presione enter para salir');
  readln;
end.
