{7. Realizar un programa que permita: 
a) Crear un archivo binario a partir de la información almacenada en un archivo de 
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el 
archivo de texto consiste en: código  de novela, nombre, género y precio de 
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos 
líneas en el archivo de texto. La primera línea contendrá la siguiente información: 
código novela, precio y género, y la segunda línea almacenará el nombre de la 
novela. 
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder 
agregar una novela y modificar una existente. Las búsquedas se realizan por 
código de novela. 
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado. 
}

program ejercicio7;
uses crt;
type

novela = record
    codigo: integer;
    precio: real;
    genero: string;
    nombre: string;
end;

archivo = file of novela; 
texto = text;

procedure asignarArchivo (var arc: archivo; var asignar:boolean);
var
nom_fisico:string;
begin
     writeln('ingrese el nombre fisico del archivo');
     readln(nom_fisico);
     assign(arc,nom_fisico);
     asignar:= false;
end;

procedure crearArchivo (var arc: archivo; var novelas:txt);
var
reg:novela;
begin
    rewrite(arc);
    assign(novelas, 'C:\Dev-Pas\novelas.txt.txt');
    reset(novelas);
    while not(EOF(novelas)) do begin
          readln(novelas, reg.codigo, reg.precio, reg.genero);
          readln(novelas,reg.nombre);
          write(arc,reg);
    end;
    close(arc); close(novelas);
end;

procedure leerNovela (var n:novela);
begin
      writeln('Ingrese el codigo de la novela');
      readln(n.codigo);
      writeln('Ingrese el nombre de la novela');
      readln(n.nombre);
      writeln('Ingrese el precio de la novela');
      readln(n.precio);
      writeln('Ingrese el genero de la novela');
      readln(n.genero);
end;


procedure agregarNovela (var arc:archivo);
var
reg,aux:novela;
sigue:boolean;
begin
     writeln('ingrese la novela a agregar');
     leerNovela(reg);
     reset(arc);
     sigue:= true;
     while (not (EOF(arc))) and (sigue) do begin
          read(arc,aux);
          if (reg.codigo =  aux.codigo) then
             sigue:=false;
     end;
     if (sigue) then  //llego al final del archivo
         write(arc,reg)
     else
         writeln('La novela ingresada ya existe');
     close(arc);
 end;

procedure informarNovela (n:novela);
begin
      write('Codigo de la novela: ');
      writeln(n.codigo);
      write('Nombre de la novela: ');
      writeln(n.nombre);
      write('Precio de la novela: ');
      writeln(n.precio:0:2);
      write('Genero de la novela: ');
      writeln(n.genero);
end;

procedure modificarNovela (var arc: archivo);
var
cod:integer;
sigue: boolean;
aux:novela;
begin
    sigue:=true;
    reset(arc);
    writeln('ingrese el codigo de pelicula a actualizar');
    readln(cod);
    while (not (EOF(arc))) and sigue do begin
          read(arc,aux);
          if (aux.codigo = cod) then
             sigue:=false;
    end;
    if not(sigue) then begin
        seek(arc, filepos(arc)-1);
        writeln(' Los datos actuales de la novela son: ');
        informarNovela(aux);
        writeln('Ingrese los datos de la novela actualizados');
        leerNovela(aux);
        write(arc,aux);
    end
    else
        writeln('No se encontro una novela con ese codigo');
    close(arc);
 end;


var
arc: archivo;
txt: texto;
opcion:integer;
asigno:boolean;
begin
     asigno:= true;
     repeat
     writeln('ingrese el numero de opcion a realizar');
     writeln('1. Crear un archivo a partir de txt');
     writeln('2. Agregar una novela al archivo');
     writeln('3. Modificar una novela existente');
     writeln('4. Salir');
     readln(opcion);
     if (asigno) then
        asignarArchivo(arc,asigno);
     case opcion of
          1: crearArchivo(arc,txt);
          2: agregarNovela(arc);
          3: modificarNovela(arc);
          4: writeln('Saliendo del programa...');
     else
         writeln('ingrese una opcion válida (1-4)');
     end;
     until (opcion=4);
 end.
