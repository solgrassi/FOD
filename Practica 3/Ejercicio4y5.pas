{ Dada la siguiente estructura:  
type 
    reg_flor = record
    nombre: String[45];
    codigo: integer;
end; 
tArchFlores = file of reg_flor; 

Las bajas se realizan apilando registros borrados y las altas reutilizando registros 
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el 
número 0 en el campo código implica que no hay registros borrados y -N indica que el 
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
  
a. Implemente el siguiente módulo:
(Abre el archivo y agrega una flor, recibida como parámetro manteniendo la política
descrita anteriormente)
procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);

b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que 
considere necesario para obtener el listado. 
}
{
5. (Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente)
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
}

program ejercicio4y5;
type 

    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;

tArchFlores = file of reg_flor;

procedure agregarFlor (var mae: tArchFlores; nom: string; cod: integer);
var
reg, cabecera, f: reg_flor;
begin
     f.nombre:= nom;
     f.codigo:=cod;
     reset(mae);
     read(mae,cabecera);
     if (cabecera.codigo <0 ) then begin
        seek(mae, (cabecera.codigo*-1)); // voy a la pos libre
        read(mae, reg);
        seek(mae, filepos(mae)-1);
        write(mae, f);
        seek(mae,0);
        write(mae, reg);
     end
     else begin
         seek(mae, filesize(mae));
         write(mae, f);
    end;
    close(mae);
end;

procedure informarFlor (reg:reg_flor);
begin
     writeln('Nombre de la flor: ', reg.nombre);
     writeln('Codigo de la flor: ', reg.codigo);
     writeln('-----------------------------');

end;

procedure listarSinEliminar (var mae:tArchFlores);
var
reg: reg_flor;
begin
     reset(mae);
     if not EOF(mae) then read(mae, reg); // salteo cabecera
     while (not EOF(mae)) do begin
           read(mae, reg);
           if (reg.codigo > 0) then
              informarFlor(reg);
     end;
     close(mae);
end;

procedure eliminarFlor (var mae:tArchFlores; var flor:reg_flor);
var
reg,cabecera: reg_flor;
begin
     reset(mae);
     read(mae,reg);
     cabecera:= reg;
     while (not EOF(mae)) and (reg.codigo <> flor.codigo) do
           read(mae,reg);
     if (reg.codigo = flor.codigo) then begin
        seek(mae, filepos(mae)-1);
        reg.codigo:= cabecera.codigo;
        cabecera.codigo:= filepos(mae) * -1;
        write(mae, reg);
        seek(mae, 0);
        write(mae, cabecera);
     end
     else
         writeln('no se encontro la flor ingresada');
     close(mae);
end;

var
mae:tArchFlores;
nom:String;
cod, op:integer;
flor: reg_flor;
begin
     assign(mae, 'flores.dat');
     repeat
           writeln('1. agregar flor');
           writeln('2. Listar');
           writeln('3. eliminar');
           writeln('4. salir');
           readln(op);
           case op of
               1: begin
                  writeln('Codigo: ');
                  read(cod);
                  writeln('Nombre: ');
                  readln(nom);
                  agregarFlor(mae, nom, cod);
               end;
               2: listarSinEliminar(mae);
               3: begin
                  writeln('Ingrese los datos de la flor a eliminar');
                  writeln('Codigo :');
                  readln(flor.codigo);
                  writeln('Nombre: ');
                  readln(flor.nombre);
                  eliminarFlor(mae, flor);
                  end;
               4: writeln ('Saliendo del programa');
          end;
     until op=4;
    readln();
end.
