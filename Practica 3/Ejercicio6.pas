{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con 
la información correspondiente a las prendas que se encuentran a la venta. De cada 
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y 
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las 
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las 
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba 
ambos archivos y  realice la baja lógica de las prendas, para ello deberá modificar el 
stock de la prenda correspondiente a valor negativo. 
Adicionalmente, deberá implementar otro procedimiento que se encargue de 
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la 
información de las prendas a la venta. Para ello se deberá utilizar una estructura 
auxiliar (esto es, un archivo nuevo),  en el cual se copien únicamente aquellas prendas 
que no están marcadas como borradas. Al finalizar este proceso de compactación 
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro 
original.
}

program ejercicio6;
const
valorAlto = 9999;
type
    prenda = record
      cod_prenda: integer;
      desc: string;
      colores: string;
      tipo_prenda: string;
      stock: integer;
      precio_uni: real;
    end;

obsoletas = file of integer;
arc = file of prenda;

procedure asignarArchivos (var mae,nuevo:arc; var ob:obsoletas);
begin
     assign(mae, 'maestroPrendas');
     assign(nuevo, 'actualPrendas');
     assign(ob, 'prendasObsoletas');
end;

procedure leer (var ob:obsoletas; var cod:integer);
begin
     if (not EOF(ob)) then
        read(ob,cod)
     else
         cod := valorAlto;
end;


procedure bajasLogicas (var mae:Arc; var ob:obsoletas);
var
regMae:prenda;
cod:integer;
begin
     reset(mae);
     reset(ob);
     leer(ob, cod);
     while (cod <> valorAlto) do begin
           read(mae, regMae);
           while (cod <> regMae.cod_prenda) do
                 read(mae, regMae);
           regMae.stock:= -1;
           seek(mae, filepos(mae)-1);
           write(mae, regMae);
           seek(mae, 0);
           leer(ob, cod);
    end;
    close(mae);
    close(ob);
end;

procedure copiarSinBajas (var mae:arc; var nuevo:arc);
var
regMae:prenda;
begin
     reset(mae);
     rewrite(nuevo);
     while (not EOF(mae)) do begin
          read(mae, regMae);
          if (regMae.stock <> -1) then
             write(nuevo,regMae);
     end;
     close (mae);
     close(nuevo);
     Rename (mae, 'maestroPrendasOLD');
     Rename(nuevo, 'maestroPrendas');
end;

var
mae, nuevo:ArC;
ob:obsoletas;
begin
     asignarArchivos(mae,nuevo,ob);
     bajasLogicas(mae,ob);
     copiarSinBajas(mae,nuevo);
end.

