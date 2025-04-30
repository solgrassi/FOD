{Se cuenta con un archivo que almacena información sobre especies de aves en vía 
de extinción, para ello se almacena: código, nombre de la especie, familia de ave, 
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice 
un programa que permita borrar especies de aves extintas. Este programa debe 
disponer de dos procedimientos:  
a. Un procedimiento que dada una especie de ave (su código) marque la misma 
como borrada (en caso de querer borrar múltiples especies de aves, se podría 
invocar este procedimiento repetidamente). 
b. Un procedimiento que compacte el archivo, quitando definitivamente las 
especies de aves marcadas como borradas.  Para quitar los registros se deberá 
copiar el último registro del archivo en la posición del registro a borrar y luego 
eliminar del archivo el último registro de forma tal de evitar registros duplicados.  
i. 
Implemente una variante de este procedimiento de compactación del 
archivo (baja física) donde el archivo se trunque una sola vez.
}

program ejercicio7;

type
    ave = record
        codigo: integer;
        especie: string;
        familia: string;
        desc: string;
        zona_geo: string;
    end;

arc = file of ave;

procedure asignarArchivos (var mae:Arc);
begin
     assign(mae, 'maestro_Aves');
end;

procedure eliminarAve (var mae:arc; cod: integer);
var
regMae: ave;
  encontrado: boolean;
begin
    reset(mae);
    encontrado := false;
    while (not EOF(mae)) and (not encontrado) do begin
      read(mae, regMae);
      if (regMae.codigo = cod) then begin
        seek(mae, filepos(mae) - 1);
        regMae.codigo := -1;
        write(mae, regMae);
        encontrado := true;
      end;
    end;

    if (not encontrado) then
      writeln('No existe ave con ese codigo');

    close(mae);
end;


procedure compactarArchivo(var mae: arc);
var
regMae, regUltimo: ave;
posActual, posUltimo: integer;
begin
    reset(mae);

    while (filepos(mae) < filesize(mae)) do begin
          posActual := filepos(mae);
          read(mae, regMae);
          if (regMae.codigo = -1) then begin
               posUltimo := filesize(mae) - 1;

               if (posActual < posUltimo) then begin // si no es el ultimo
                   repeat
                       seek(mae, posUltimo);
                       read(mae, regUltimo);
                       posUltimo:= posUltimo -1 ;
                    until (regUltimo.codigo <> -1) or (posUltimo < posActual); //busca registro valido

                    if(posActual < posUltimo +1) then begin //si es valido
                        seek(mae, posActual);
                        write(mae, regUltimo);
                    end;
                    // sea valido o no
                    seek(mae, posUltimo + 1);
                    truncate(mae);
                    seek(mae, posActual +1 ); // proximo registro
               end
               else begin // si es el ultimo y es -1
                    seek(mae, posActual);
                    truncate(mae);
               end;
          end;
    end;
  close(mae);
end;


procedure truncarArchivo (var mae:arc);
var
regMae: ave;
pos:integer;
puntero: integer;
begin
     reset(mae);
     puntero := filesize(mae);

     while  (filepos(mae) < puntero) do begin
            read(mae, regMae);
            if ( regMae.codigo = -1) then begin
               pos:= (filepos(mae) -1);
               repeat
                   puntero := puntero -1;
                   seek(mae, puntero);
                   read(mae, regMae);
               until (regMae.codigo <> -1) or (puntero <= pos); //encuentro reg valido

               if (pos < puntero) then begin  // sobreescribo
                   seek(mae, pos);
                   write(mae, regMae);
                end;
            end;
     end;

     seek(mae, puntero);
     truncate(mae);
     close(mae);
end;

procedure crearArchivoPrueba(var mae: arc);
var
  reg: ave;
begin
  rewrite(mae);

  reg.codigo := 101;
  reg.especie := 'Cóndor Andino';
  reg.familia := 'Cathartidae';
  reg.desc := 'Ave carroñera de gran tamaño';
  reg.zona_geo := 'Andes Sudamericanos';
  write(mae, reg);

  reg.codigo := 102;
  reg.especie := 'Águila Arpía';
  reg.familia := 'Accipitridae';
  reg.desc := 'Ave rapaz de selvas tropicales';
  reg.zona_geo := 'Selva Amazónica';
  write(mae, reg);

  reg.codigo := 103;
  reg.especie := 'Guacamayo Azul';
  reg.familia := 'Psittacidae';
  reg.desc := 'Ave colorida en peligro crítico';
  reg.zona_geo := 'Pantanal Brasileño';
  write(mae, reg);

  reg.codigo := 104;
  reg.especie := 'Pingüino de Galápagos';
  reg.familia := 'Spheniscidae';
  reg.desc := 'Pingüino que habita zonas ecuatoriales';
  reg.zona_geo := 'Islas Galápagos';
  write(mae, reg);

  reg.codigo := 105;
  reg.especie := 'Zorzal Colorado';
  reg.familia := 'Turdidae';
  reg.desc := 'Ave pequeña con canto melódico';
  reg.zona_geo := 'Bosques de Argentina';
  write(mae, reg);

  close(mae);
  writeln('Archivo de prueba creado con éxito.');
end;

procedure imprimirArchivo(var mae: arc);
var
  reg: ave;
begin
  reset(mae);
  writeln('--- CONTENIDO DEL ARCHIVO ---');
  while not eof(mae) do begin
    read(mae, reg);
    if reg.codigo <> -1 then begin
      writeln('Código: ', reg.codigo);
      writeln('Especie: ', reg.especie);
      writeln('Familia: ', reg.familia);
      writeln('Descripción: ', reg.desc);
      writeln('Zona geográfica: ', reg.zona_geo);
      writeln('-----------------------------');
    end
    else
      writeln('*** REGISTRO MARCADO COMO BORRADO ***');
  end;
  close(mae);
end;


var
mae: arc;
cod,op: integer;
begin
     asignarArchivos(mae);
     crearArchivoPrueba(mae);
     repeat
           writeln('1. eliminar ave por codigo');
           writeln('2. compactar el archivo ');
           writeln('3. truncar el archivo ');
           writeln('4. impirmir archivo');
           writeln('5. Salir');
           readln(op);
           case op of
                1: begin
                    writeln('Ingrese el codigo a eliminar (-1 para salir)');
                    readln(cod);
                    while (cod <> -1) do begin
                          eliminarAve(mae,cod);
                          writeln('Ingrese el codigo a eliminar (-1 para salir)');
                          readln(cod);
                    end;
                  end;
                2: compactarArchivo(mae);
                3: truncarArchivo(mae);
                4: imprimirArchivo(mae);
                5: writeln('Saliendo del program');
           end;
    until(op = 5);
end.
