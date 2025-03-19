{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados 
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el 
promedio de los números ingresados. El nombre del archivo a procesar debe ser 
proporcionado por el usuario una única vez.  Además, el algoritmo deberá listar el 
contenido del archivo en pantalla.}

program Ejercicio2;
var
menores,num,cant_t,suma:integer;  nombre:string;
enteros: file of integer;
begin
menores:=0;
cant_t:= 0;
suma:=0;
//Abro el archivo
writeln('ingrese el nombre del archivo');
readln(nombre);
assign (enteros,  nombre);
reset(enteros);
//proceso la informacion del archivo
while not(EOF(enteros)) do begin
      read(enteros,num);
      if (num<1500) then
         menores:=menores +1;
      cant_t:= cant_t +1;
      suma:= suma + num;
end;
close(enteros);
//informo
writeln('la cantidad de numeros menores a 1500 es de: ',menores);
if (cant_t>0) then
   writeln('el promedio de los numeros es de: ', (suma DIV cant_t))
else
    writeln('No se pudo calcular el promedio porque no hay números en el archivo.');

//imprimo el contenido del archivo
reset(enteros);
  while not(EOF(enteros)) do begin
        read(enteros,num);
        writeln(num);
  end;
  close(enteros);
  writeln('presione enter para salir');
  readln;
end.
