 {Realizar un programa para una tienda de celulares, que presente un menú con
opciones para: 
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos 
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros 
correspondientes a los celulares deben contener: código de celular, nombre, 
descripción, marca, precio, stock mínimo y stock disponible. 
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al 
stock mínimo. 
c. Listar en pantalla los celulares del archivo cuya descripción contenga una 
cadena de caracteres proporcionada por el usuario. 
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado 
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2. 
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el 
usuario. 
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique 
en tres  líneas consecutivas. En la primera se especifica: código de celular,  el precio y 
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera 
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo 
“celulares.txt”.
}
program Ejercio5;
uses crt;
const
impo = -1;
type
    celular = record
        codigo:integer;
        desc:string[100];
        nom:string[50];
        marca:string[30];
        precio:real;
        stockMin:integer;
        stockDis:integer;
   end;

var
   arcCelulares: file of celular;
   celuTXT: text;

procedure asignarArchivo(var asigno:boolean);
var
nom_fisico: string;
begin
     writeln('Ingrese el nombre del archivo');
     readln(nom_fisico);
     assign(arcCelulares, nom_fisico);
     asigno:= false;
end;


procedure crearArchivo;
var
reg: celular;
begin
     rewrite(arcCelulares);
     assign(celuTXT,'C:\Dev-Pas\celulares.txt.txt');
     Reset(celuTXT);
     while not EOF(celuTXT) do begin
        readln(celuTXT, reg.codigo, reg.precio,reg.marca);
        readln(celuTXT, reg.stockDis, reg.stockMin,reg.desc);
        readln(celuTXT, reg.nom);
        write(arcCelulares, reg);
    end;
    writeln('archivo creado con exito');
    close(celuTXT);
    close(arcCelulares);
end;

procedure leerHastaFin(var reg:celular);
begin
     if (not EOF(arcCelulares)) then
           read(arcCelulares, reg)
     else
         reg.stockDis:= impo;
end;

procedure informarCelular (c:celular);
begin
      write('Codigo: ', c.codigo);
      write('. Nombre: ', c.nom);
      write('. Marca: ', c.marca);
      write('. Descripcion: ', c.desc);
      write('. Precio: ', c.precio:10:2);
      write('. Stock minimo: ', c.stockMin);
      writeln('. Stock disponible ', c.stockDis);
      writeln('-------------------------');
end;

procedure listarTodos;
var
celu: celular;
begin
     writeln('Listado de celulares');
     reset(arcCelulares);
     leerHastaFin(celu);
     while (celu.stockDis<> impo) do begin
           informarCelular(celu);
           leerHastaFin(celu);
     end;
     close(arcCelulares);
end;

procedure listarStockMin;
var
celu: celular;
begin
    writeln('Celulares con stock menor al minimo: ');
    reset(arcCelulares);
    leerHastaFin(celu);
    while (celu.stockDis<> impo) do begin
          if (celu.stockDis < celu.stockMin) then
             informarCelular(celu);
          leerHastaFin(celu);
    end;
    close(arcCelulares);
end;

procedure listarDescripcion;
var
des : string;
reg: celular;
posi:integer;
begin
     reset(arcCelulares);
     writeln('Ingrese la descripcion, o parte de ella, por la que quiere buscar los celulares');
     readln(des);
     while (Not EOF(arcCelulares)) do begin
           read(arcCelulares,reg);
           posi := Pos(des, reg.desc);
           if (posi > 0) then
               informarCelular(reg);
     end;
     close(arcCelulares);
end;

procedure exportarATexto;
var
reg:celular;
begin
     reset(arcCelulares);
     assign(celuTXT,'C:\Dev-Pas\celulares.txt.txt');
     rewrite(celuTXT);
     while (not EOF(arcCelulares)) do begin
        read(arcCelulares, reg);
        writeln(celuTXT,reg.codigo,' ',reg.precio:10:2,' ',reg.marca);
        writeln(celuTXT,reg.stockDis,' ', reg.stockMin,' ',reg.desc);
        writeln(celuTXT, reg.nom);
    end;
    writeln('archivo de texto creado con exito');
    close(celuTXT);
    close(arcCelulares);
end;

var
opcion: integer;  asigno: boolean;
begin
  asigno:=True;
  repeat
  writeln('Menu de opciones');
  writeln('1. Crear archivo de celulares');
  writeln('2. Listar todos los celulares');
  writeln('3. Listar celulares con stock menor al minimo');
  writeln('4. Listar celulares por descripcion');
  writeln('5. exportar todos los celulares a un archivo de texto');
  writeln('6. Salir');
  writeln('Ingrese el numero de opcion a realizar (1-6)');
  readln(opcion);
  if (asigno) then
     asignarArchivo(asigno);
  case opcion of
       1: crearArchivo;
       2: listarTodos;
       3: listarStockMin;
       4: listarDescripcion;
       5: exportarATexto;
       6: writeln('Saliendo del programa...')
  else
      writeln('Opcion invalida. Por favor, ingrese un numero entre 1 y 6.');
  end;
  until (opcion =6);
end.
