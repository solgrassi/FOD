{Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con 
un número de empleado ya registrado (control de unicidad). 
b. Modificar la edad de un empleado dado. 
c. Exportar el contenido del archivo a un archivo de texto llamado 
“todos_empleados.txt”. 
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados 
que no tengan cargado el DNI (DNI en 00). 
NOTA: Las búsquedas deben realizarse por número de empleado. 
}

program Ejercicio4;
uses crt;
const
     impo = -1;

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
arcTe: text;
arcDNI: text;

procedure leerEmple (var emple:emple);
begin
     writeln('Ingrese el apellido del empleado ("fin" para terminar');
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

procedure asignarArchivo(var asigno: boolean);
var
nom_fisico: string;
begin
     writeln('Ingrese el nombre del archivo');
     readln(nom_fisico);
     assign(empleados, nom_fisico);
     asigno:= false;
end;

procedure leerHastaFin(var reg:emple);
begin
     if (not EOF(empleados)) then
           read(empleados, reg)
     else
         reg.num := impo;
end;

procedure crearArchivo;
var
emple:emple;
begin
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
      write('Numero: ', e.num);
      write('. Nombre: ', e.nom);
      write('. Apellido: ', e.ape);
      write('. Edad: ', e.edad);
      writeln('. DNI: ', e.dni);
      writeln('-------------------------');
end;

procedure listarNombre;
var
nombre:string;
aux:emple;
begin
writeln('ingrese el nombre o apellido a buscar');
readln(nombre);
reset(empleados);
leerHastaFin(aux);
while (aux.num <> impo) do begin
      if (aux.nom = nombre) or (aux.ape=nombre) then
         informarEmpleado(aux);
      leerHastaFin(aux);
end;
close(empleados);
end;


procedure listarTodos;
var
emple:emple;
begin
reset(empleados);
leerHastaFin(emple);
while (emple.num<> impo) do begin
     informarEmpleado(emple);
     leerHastaFin(emple);
end;
close(empleados);
end;

procedure listarJubilados;
var
emp:emple;
begin
reset(empleados);
leerHastaFin(emp);
while (emp.num<> impo) do begin
      if (emp.edad >70) then
         informarEmpleado(emp);
      leerHastaFin(emp);
end;
close (empleados);
end;


procedure agregarEmpleado;
var
e,reg: emple;  sigue: boolean;
begin
     leerEmple(e);
     while (e.ape <> 'fin') do begin
         reset(empleados);
         leerHastaFin(reg);
         sigue:= true;
         while (reg.num <> impo) and (sigue) do begin
             if (reg.num = e.num ) then
                sigue :=false
             else
                 leerHastaFin(reg);
         end;
         if (sigue) then begin
            write(empleados, e);
            writeln('empleado agregado');
         end
         else
             writeln('el numero de empleado ya existe');
         leerEmple(e);

     end;
  close(empleados);
end;

procedure modificarEdad;
var
num: integer;
reg: emple;
seguir: boolean;
edad:integer;
begin
    writeln('Ingrese el numero de empleado a cambiar la edad');
    read(num);
    reset(empleados);
    leerHastaFin(reg);
    seguir := true;
    while (reg.num <> impo) and (seguir) do begin
          if (reg.num = num) then
             seguir:= false
          else
              leerHastaFin(reg);
    end;
    if not(seguir) then begin
       writeln('Ingrese la edad a asignar al empelado');
       read(edad);
       seek (empleados, filepos(empleados)-1);
       reg.edad:= edad;
       write(empleados, reg);
       writeln('edad actualizada');
    end
    else
        writeln('No existe empleado con ese numero');
    close (empleados);
end;

procedure crearArchivoTexto;
var
   nomfisico:string;
begin
   writeln('ingrese nombre del archivo de texto');
   read(nomfisico);
   assign(arcTe, nomfisico);
   rewrite(arcTe);
end;

procedure exportarTodos;
var
reg: emple;
begin
     crearArchivoTexto;
     reset(empleados);
     leerHastaFin(reg);
     while (reg.num <> impo) do begin
           write(arcTe,reg.num,' ' ,reg.edad,' ' ,reg.dni,'  ',reg.nom, ' ');
           writeln(arcTe, reg.ape);
           leerHastaFin(reg);
     end;
     close(empleados);
     close(arcTe);
     writeln('Exportado correctamente');
end;

procedure exportarSinDNI;
var
nomfisico:string;
reg: emple;
begin
   writeln('ingrese nombre del archivo de texto');
   read(nomfisico);
   assign(arcDNI, nomfisico);
   rewrite(arcDNI);
   reset(empleados);
   leerHastaFin(reg);
   while (reg.num <> impo) do begin
         if (reg.dni = 00) then begin
             write(arcDNI,reg.num,' ' ,reg.edad,' ' ,reg.dni,'  ',reg.nom);
             writeln(arcDNI, reg.ape);
         end;
         leerHastaFin(reg);
  end;
  close(empleados);
  close(arcDNI);
  writeln('Exportado correctamente');
end;


var
opcion: integer;  asigno: boolean;
begin
  asigno:=True;
  repeat
  writeln('Menu de opciones');
  writeln('1. Crear archivo de empleados');
  writeln('2. Listar empleados por nombre o apellido');
  writeln('3. Listar todos los empleados por linea');
  writeln('4. listar proximos a jubilarse');
  writeln('5. agregar empelado/s');
  writeln('6. modificar la edad de un empelado');
  writeln('7. exportar todos los empelados a un archivo de texto');
  writeln('8. exportar los empleados sin dni a un archivo de texto');
  writeln('9. Salir');
  writeln('Ingrese el numero de opcion a realizar (1-9)');
  readln(opcion);
  if (asigno) then
     asignarArchivo(asigno);
  case opcion of
       1: crearArchivo;
       2: listarNombre;
       3: listarTodos;
       4: listarJubilados;
       5: agregarEmpleado;
       6: modificarEdad;
       7: exportarTodos;
       8: exportarSinDNI;
       9: writeln('Saliendo del programa...')
  else
      writeln('Opcion invalida. Por favor, ingrese un numero entre 1 y 9.');
  end;
  until (opcion =9);
end.
