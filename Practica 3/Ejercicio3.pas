{Realizar un programa que genere un archivo de novelas filmadas durante el presente 
año. De cada novela se registra: código, género, nombre, duración, director  y precio. 
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se 
utiliza la técnica de lista invertida para recuperar espacio libre en el 
archivo.  Para ello, durante la creación del archivo, en el primer registro del 
mismo se debe almacenar la cabecera de la lista. Es decir un registro 
ficticio, inicializando con el valor cero (0) el campo correspondiente al 
código de novela, el cual indica que no hay espacio libre dentro del 
archivo. 
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el 
inciso a), se utiliza lista invertida para recuperación de espacio. En 
particular, para el campo de “enlace”  de la lista (utilice el código de 
novela como enlace), se debe especificar los números de registro 
referenciados con signo negativo, . Una vez abierto el archivo, brindar 
operaciones para: 
i. Dar de alta una novela leyendo la información desde teclado. Para esta operación,
en caso de ser posible, deberá recuperarse el espacio libre. Es decir, si en el campo
correspondiente al código de novela del registro cabecera hay un valor negativo,
por ejemplo -5,se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la posición 5.
Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde teclado. El
código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da
de baja un registro en la posición 8, en el campo código de novela del registro cabecera
deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que 
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”. 
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser 
proporcionado por el usuario. 

}
program ejercicio3;
const
impo=9999;
type
    novela = record
        cod:integer;
        genero:string;
        nom: string;
        duracion: double;
        director: string;
        precio: double;
   end;

arc = file of novela;
txt = text;

procedure leerDatosNovela (var miNovela: novela);
begin
    write('Genero: ');
    readln(miNovela.genero);

    write('Nombre: ');
    readln(miNovela.nom);

    write('Duracion (en horas): ');
    readln(miNovela.duracion);

    write('Director: ');
    readln(miNovela.director);

    write('Precio: ');
    readln(miNovela.precio);
end;

procedure leerNovela (var miNovela:novela);
begin
    writeln('Ingrese los datos de la novela:)');
    write('Codigo: (9999 para finalizar');
    readln(miNovela.cod);
    if (miNovela.cod <> impo) then
       leerDatosNovela(miNovela);
end;

procedure crearArchivo (var mae:arc);
var
n:novela;
begin
     rewrite(mae);
     n.cod:=0;
     write(mae, n);
     leerNovela(n);
     while (n.cod <> impo) do begin
         write(mae,n);
         leerNovela(n);
     end;
     close(mae);
end;

procedure agregarNovela (var mae:arc);
var
n, regMae:novela;
begin
     reset(mae);
     writeln('Ingrese los datos de la novela a agregar');
     leerNovela(n);
     read(mae,regMae);
     if (regMae.cod < 0) then begin
        seek(mae, regMae.cod * -1);
        read(mae,regMae);
        seek(mae, filepos(mae)-1);
        write(mae,n);
        seek(mae, 0);
        write(mae, regMae); //actualizo cabecera si hay mas pos disponibles
     end
     else begin
         seek(mae, filesize(mae));
         write(mae, n);
     end;
     close(mae);
end;

procedure modificarNovela (var mae:arc);
var
n, regMae:novela;

begin
     reset(mae);
     writeln('ingrese el codigo de la novela a modificar');
     readln(n.cod);
     read(mae,regMae);
     while (not EOF(mae)) and (regMae.cod <> n.cod) do
         read(mae,regMae);
     if (regMae.cod = n.cod) then begin
        leerDatosNovela(n);
        seek(mae, filepos(mae)-1);
        regMae := n;
        write(mae,regMae);
     end
     else
         writeln('No se encontro novela con ese codigo');
     close(mae);
end;

procedure eliminarNovela (var mae:arc);
var
cod:integer;
regMae, regCabecera: novela;
begin
     reset(mae);
     writeln('Ingrese el codigo de novela a eliminar');
     read(cod);
     read(mae, regMae);
     regCabecera:= regMae;
     while (not EOF (mae)) and (regMae.cod <> cod) do
        read(mae, regMae);
     if (regMae.cod = cod) then begin
        seek(mae, filepos(mae)-1);
        regMae.cod:= regCabecera.cod;
        regCabecera.cod:= filepos(mae) * -1;
        write(mae,regMae);
        seek(mae, 0);
        write(mae, regCabecera);
     end
     else
         writeln('No se encontro novela con ese codigo');
     close(mae);
end;

procedure listarNovelas (var mae: arc; var nove:txt);
var
reg:novela;
nom_log:string;
begin
     reset(mae);
     writeln('Ingrese el nombre del archivo txt');
     readln(nom_log);
     assign(nove, nom_log);
     rewrite(nove);
     while(not EOF(mae)) do begin
         read(mae,reg);
         writeln(nove, 'codigo: ', reg.cod, ' ', 'duracion: ', reg.duracion:0:2, ' ', 'nombre: ', reg.nom);
         writeln(nove, 'precio: ', reg.precio:0:2, ' ', 'director: ', reg.director);
         writeln(nove, 'genero: ', reg.genero);
         writeln(nove, '---------------------------------------');
     end;
     close(mae);
     close(nove);

end;


var
mae:arc;
nove: txt;
op:integer;
nom_log: string;
begin
     writeln('Ingrese el nombre del archivo');
     read(nom_log);
     assign(mae, nom_log);
     repeat
           writeln('Ingrese la opcion a realizar');
           writeln('1. Cargar archivo');
           writeln('2. Modificar el archivo');
           writeln('3. Listar novelas en txt');
           writeln('4. Salir');
           readln(op);
           case op of
                1: crearArchivo(mae);
                3: listarNovelas(mae, nove);
                4: writeln('Saliendo del programa...');
           else begin
                if (op = 2) then begin
                  writeln('1. Agregar una novela');
                  writeln('2. Modificar una novela');
                  writeln('3. Eliminar una novela');
                  readln(op);
                  case op of
                       1: agregarNovela(mae);
                       2: modificarNovela(mae);
                       3: eliminarNovela(mae)
                  else
                      writeln('Opcion invalida, intente nuevamente');
                  end;
                end
                else
                   writeln('Opcion invalida, intente nuevamente (1-4)');
          end;
       end;
     until (op = 4);
     readln();
end.
