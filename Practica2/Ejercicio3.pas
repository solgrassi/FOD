// consultar si es mejor un minimo o dos while(uno por detalle)

{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un 
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas 
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos 
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de 
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos 
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle. 
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle      
pueden venir 0, 1 ó más registros por cada provincia.
}

program Ejercio3;
const
impo = 'ZZZ';
type
    provincias = record
        prov: string[20];
        cantAl: integer;
        cantTot: integer;
    end;

    agencia = record
        prov: string[20];
        codLoca: integer;
        cantAl: integer;
        cantTot: integer;
    end;

mae = file of provincias;
detalle = file of agencia;

procedure leer (var det:detalle; var reg:agencia);
begin
     if (not EOF(det)) then
        read(det,reg)
     else
         reg.prov:= impo;
end;

procedure asignarArchivos (var m:mae; var det1,det2: detalle);
begin
     assign(m,'maestro');
     assign(det1, 'agencia1');
     assign(det2, 'agencia2');
end;

procedure minimo(var det1, det2: detalle; var r1, r2, min: agencia);
begin
     if (r1.prov<=r2.prov) then begin
        min := r1;
        leer(det1, r1);
     end
     else begin
            min := r2;
            leer(det2, r2);
     end;
end;


procedure actualizarMaestro (var mae:mae; var det1: detalle; var det2: detalle);
var
reg, reg2, min: agencia;
regMae: provincias;
begin
     reset(mae); reset(det1); reset(det2);
     leer(det1, reg);
     leer(det2,reg2);
     read(mae,regMae);
     minimo(det1, det2, reg,reg2, min);
     while (min.prov <> impo) do begin
           while (min.prov<> regMae.prov) do
                 read(mae,regMae);
           while (min.prov = regMae.prov) do begin
                 regMae.cantTot:= regMae.cantTot + min.cantTot;
                 regMae.cantAl:= regMae.cantAl + min.cantAl;
                 minimo(det1,det2,reg,reg2, min);
           end;
           seek(mae, filepos(mae)-1);
           write(mae,regMae);
           read(mae,regMae);
    end;
    close(mae);
    close(det1);
    close(det2);
end;

var
maestro: mae;
det1: detalle;
det2:detalle;
begin
     asignarArchivos(maestro,det1,det2);
     actualizarMaestro(maestro,det1,det2);
end.


