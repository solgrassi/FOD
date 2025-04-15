{Suponga que usted es administrador de un servidor de correo electr�nico. En los logs del 
mismo (informaci�n guardada acerca de los movimientos que ocurren en el server) que se 
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente informaci�n: 
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el 
servidor de correo genera un archivo con la siguiente informaci�n: nro_usuario, 
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los 
usuarios en un d�a determinado. Ambos archivos est�n ordenados por nro_usuario y se 
sabe que un usuario puede enviar cero, uno o m�s mails por d�a. 
a. Realice el procedimiento necesario para actualizar la informaci�n del log en un 
d�a particular. Defina las estructuras de datos que utilice su procedimiento. 
b. Genere un archivo de texto que contenga el siguiente informe dado un archivo 
detalle de un d�a determinado: 
nro_usuarioX����..cantidadMensajesEnviados ����.
nro_usuarioX+n���..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deber�n aparecer todos los usuarios que 
existen en el sistema.

}

program ejercicio13;
const
impo = 9999;
type
    usuario = record
        nroUsu: integer;
        usuario:string[30];
        nom: string[20];
        ape: string[20];
        cantEn: integer;
    end;

    diario = record
       nroUsu:integer;
       cuentaDes: string[30];
       msj: string;
    end;

txt = text;
arc = file of usuario;
det= file of diario;

procedure asignarArchivos (var mae:arc; var informe:txt; var dt: det);
begin
     assign(mae,'/var/log/logmail.dat');
     assign(informe, 'informeUsuarios.txt');
     assign(dt, 'detalleMailDiario');
end;

procedure leer (var dt:det; var d:diario);
begin
     if (not EOF(dt)) then
        read(dt,d)
     else
         d.nroUsu:= impo;
end;

procedure agregarAInforme (var informe:txt; usu:integer; cant:integer);
begin
     writeln(informe, 'nro_usuario: ',usu, ' ', 'cantidad de mensajes enviados: ',cant);
end;

procedure actualizarMaestro (var mae:arc; var dt:det; var informe:txt);
var
d:diario;
regMae: usuario;
cant:integer;
begin
     reset(mae);
     reset(dt);
     rewrite(informe);
     leer(dt, d);

     while not EOF(mae) do begin
        read(mae, regMae);
        cant := 0;
        while (regMae.nroUsu = d.nroUsu) do begin
            cant := cant + 1;
            leer(dt, d);
        end;
        regMae.cantEn := regMae.cantEn + cant;
        seek(mae, filepos(mae) - 1);
        write(mae, regMae);
        agregarAInforme(informe, regMae.nroUsu, cant);
    end;

     close(mae);
     close(dt);
     close(informe);
end;

var
mae:arc;
dt:det;
informe:txt;
begin
     asignarArchivos(mae,informe,dt);
     actualizarMaestro(mae,dt,informe);
end.
