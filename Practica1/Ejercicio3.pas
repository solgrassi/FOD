{Realizar un programa que presente un menú con opciones para: 
a. Crear un archivo de registros no ordenados de empleados y completarlo con 
datos ingresados desde teclado. De cada empleado se registra: número de 
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con 
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido. 
b. Abrir el archivo anteriormente generado y 
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado. 
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el
usuario.}

program Ejercicio3;
uses crt;
type
emple = record
      num:integer;
      ape:string[20];
      nom:string [20];
      edad:integer;
      dni:integer;
end;

var
empleados:file of emple;

procedure leerEmple (var emple:emple);
begin
     writeln('Ingrese el apellido del empleado');
     read(emple.ape);
     if (emple.ape<> 'fin') then begin
        writeln('Ingrese el numero de empleado');
        readln(emple.num);
        writeln('Ingrese el nombre del empleado');
        readln(emple.nom);
        writeln('Ingrese la edad del empleado');
        readln(emple.edad);
        writeln('Ingrese el dni del empleado');
        readln(emple.dni);
     end;
end;

procedure crearArchivo;
var
nom_fisico:string; emple:emple;
begin
writeln('Ingrese el nombre del archivo');
readln(nom_fisico);
assign(empleados, nom_fisico);
rewrite(empleados);
leerEmple(emple);
while (emple.ape <> 'fin') do begin
      write(empleados,emple);
      leerEmple(emple);
end;
close(empleados);
end;

procedure informarEmpleado (e:emple);
begin
      writeln('Numero: ', e.num);
      writeln('Nombre: ', e.nom);
      writeln('Apellido: ', e.ape);
      writeln('Edad: ', e.edad);
      writeln('DNI: ', e.dni);
      writeln('-------------------------');
end;

procedure listarNombre;
var
nombre:string;
registro:emple;
begin
writeln('ingrese el nombre o apellido a buscar');
readln(nombre);
reset(empleados);
while not(EOF(empleados)) do begin
      read(empleados,registro);
      if (registro.nom = nombre) or (registro.ape=nombre) then
         informarEmpleado(registro);
end;
close(empleados);
end;


procedure listarTodos;
var
emple:emple;
begin
reset(empleados);
while not(EOF(empleados)) do begin
     read(empleados,emple);
     informarEmpleado(emple);
end;
close(empleados);
end;

procedure listarJubilados;
var
empleado:emple;
begin
reset(empleados);
while not(EOF(empleados)) do begin
      read(empleados, empleado);
      if (empleado.edad >70) then
         informarEmpleado(empleado);
end;
close (empleados);
end;


var
opcion: integer;
begin
  repeat
  writeln('Menu de opciones');
  writeln('1. Crear archivo de empleados');
  writeln('2. Listar empleados por nombre o apellido');
  writeln('3. Listar todos los empleados por linea');
  writeln('4. listar proximos a jubilarse');
  writeln('5. Salir');
  writeln('Ingrese el numero de opcion a realizar (1-5)');
  readln(opcion);
  case opcion of
       1: crearArchivo;
       2: listarNombre;
       3: listarTodos;
       4: listarJubilados;
       5: writeln('Saliendo del programa...')
  else
      writeln('Opcion invalida. Por favor, ingrese un numero entre 1 y 5.');
  end;
  until (opcion =5);
end.
