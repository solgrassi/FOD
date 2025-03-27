{ Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por 
teclado. 
b. Modificar el stock de un celular dado. 
c. Exportar el contenido del archivo binario a un archivo de texto denominado: 
”SinStock.txt”, con aquellos celulares que tengan stock 0. 
NOTA: Las búsquedas deben realizarse por nombre de celular.
}

program ejercicio6;
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
    while (not EOF(arcCelulares)) do begin
          read(arcCelulares, celu);
          if (celu.stockDis < celu.stockMin) then
             informarCelular(celu);
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

procedure leerCelular (var c:celular);
begin
      writeln('Codigo: (-1 para finalizar)');
      readln(c.codigo);
      if (c.codigo <> impo) then begin
         writeln('Nombre: ');
         readln(c.nom);
         writeln('Marca: ');
         readln(c.marca);
         writeln('Descripcion: ');
         readln(c.desc);
         writeln('Precio: ');
         readln(c.precio);
         writeln('Stock minimo: ');
         readln(c.stockMin);
         writeln('Stock disponible ');
         readln(c.stockDis);
      end;
end;

procedure agregarCelulares;
var
cel:celular;
begin
     reset(arcCelulares);
     leerCelular(cel);
     while (cel.codigo <> impo) do begin
           seek(arcCelulares, filesize(arcCelulares));
           write(arcCelulares,cel);
           leerCelular(cel);
     end;
     close (arcCelulares);
end;

procedure modificarStock;
var
nombre:string;
reg: celular;
seguir: boolean;
stock: integer;
begin
    reset(arcCelulares);
    writeln('ingrese el nombre del celular a actualizar');
    read(nombre);
    seguir:= true;
    while (not EOF(arcCelulares)) and (seguir) do begin
             read(arcCelulares, reg);
              if (nombre = reg.nom) then
                 seguir:=false;
    end;
    if not(seguir) then begin
         seek(arcCelulares, filesize(arcCelulares)-1);
         read(arcCelulares,reg);
         writeln('Ingrese el nuevo stock');
         readln(stock);
         reg.stockDis:= stock;
         write(arcCelulares,reg);
     end
     else
         writeln('el celular ingresado no se encuentra en el archivo');
     close(arcCelulares);
end;

procedure ceroStock;
var
reg:celular;
begin
     assign(celuTXT, 'C:\Dev-Pas\SinStock.txt');
     rewrite(celuTXT);
     reset(arcCelulares);
     while (not EOF(arcCelulares)) do begin
        read(arcCelulares, reg);
        if (reg.stockDis = 0) then begin
           writeln(celuTXT,reg.codigo,' ',reg.precio:10:2,' ',reg.marca);
           writeln(celuTXT,reg.stockDis,' ', reg.stockMin,' ',reg.desc);
           writeln(celuTXT, reg.nom);
        end;
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
  writeln('6. agregar celulares al final del archivo');
  writeln('7. modificar el stock de un celular');
  writeln('8. exportar a archivo de texto los celulares con cero stock');
  writeln('9. Salir');
  writeln('Ingrese el numero de opcion a realizar (1-9)');
  readln(opcion);
  if (asigno) then
     asignarArchivo(asigno);
  case opcion of
       1: crearArchivo;
       2: listarTodos;
       3: listarStockMin;
       4: listarDescripcion;
       5: exportarATexto;
       6: agregarCelulares;
       7: modificarStock;
       8: ceroStock;
       9: writeln('Saliendo del programa...')
  else
      writeln('Opcion invalida. Por favor, ingrese un numero entre 1 y 9.');
  end;
  until (opcion =9);
end.
