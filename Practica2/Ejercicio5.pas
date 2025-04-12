{Suponga que trabaja en una oficina donde está montada una  LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las 
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un 
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por 
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos: 
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos 
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha, 
tiempo_total_de_sesiones_abiertas. 
Notas: 
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.  
- El archivo maestro debe crearse en la siguiente ubicación física:  /var/log.
}

program Ejercicio5;
const
df = 5;
impo = -1;

type
    sesiones = record
       codUsu:integer;
       fecha: string[10];
       tiempoSes: double;
    end;

arc = file of sesiones;
detalles = array [1..df] of arc;
registros = array [1..df] of sesiones;

procedure asignarArchivos (var mae:arc; var det:detalles);
var
i:integer;
num:string;
begin
   assign(mae,'/var/log/maestro');
   for i:= 1 to df do begin
       Str(i, num);
       assign(det[i], 'detalle' + num);
   end;
end;

procedure leer (var d:arc; var r:sesiones);
begin
     if (not EOF(d)) then
        read(d,r)
     else
         r.codUsu:= impo;
end;

procedure minimo (var det:detalles; var r:registros; var min:sesiones);
var
i,indice,aux:integer;
begin
     aux:= 9999;
     indice:=-1;
     for i:= 1 to df do begin
         if (r[i].codUsu < aux) then begin
             aux:= r[i].codUsu;
             min:= r[i];
             indice:= i;
         end;
     end;
     leer(det[indice],r[indice]);
end;


procedure crearMaestro (var mae:arc; var det:detalles; var r:registros);
var
min:sesiones;
i,aux:integer;
totT: double;
regMae: sesiones;
fecha: string;
begin
     rewrite(mae);
     for i:= 1 to df do begin
         reset(det[i]);
         leer(det[i],r[i]);
     end;
     minimo(det,r,min);
     while (min.codUsu <> impo) do begin
           aux:= min.codUsu;
           fecha:= min.fecha;
           totT:=0;
           while (min.codUsu = aux) and (min.fecha = fecha) do begin
                 totT:= totT + min.tiempoSes;
                 minimo(det,r,min);
           end;
           regMae.codUsu:= aux;
           regMae.tiempoSes:= totT;
           regMae.fecha:= fecha;
           write(mae,regMae);
     end;
     close(mae);
     for i:= 1 to df do
         close(det[i]);
end;

var
mae:arc;
deta:detalles;
r:registros;
begin
     asignarArchivos(mae,deta);
     crearMaestro(mae,deta,r);
end.

