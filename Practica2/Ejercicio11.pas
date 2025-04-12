{ Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento, 
división, número de empleado, categoría y cantidad de horas extras realizadas por el 
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por 
división y, por último, por número de empleado. Presentar en pantalla un listado con el 
siguiente formato: 
Departamento:
División:
Número de Empleado    Total de Hs.   Importe a cobrar 
 ...                      ...             ...

Total de horas división:  ____ 

Monto total por división: ____ 
                                                    
Total horas departamento: ____ 
Monto total departamento: ____ 

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al 
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía 
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número 
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la 
posición del valor coincidente con el número de categoría.
}

program Ejericio11;
const
impo= -1;
df= 15;
type
categorias = 1..15;

    empleado = record
        depto:integer;
        divi: integer;
        numEmple: integer;
        cate: categorias;
        cantExtra: integer;
   end;


txt = text;
catego = array [categorias] of double;
arc= file of empleado;

procedure asignarArchivos (var mae:arc; var horas:txt);
begin
     assign(mae, 'maestroEmpleados');
     assign(horas, 'horasExtra.txt');
end;

procedure leer (var mae:arc; var emple:empleado);
begin
     if (not EOF(mae)) then
        read(mae,emple)
     else
         emple.depto:= impo;
end;

procedure cargarArreglo (var horas:txt; var extra:catego);
var
i: integer;
cate: integer;
valor:double;
begin
     reset(horas);
     for i:= 1 to df do begin
         read(horas, cate, valor);
         extra[cate]:= valor;
     end;
     close(horas);
end;

procedure informarEmpleado (r: empleado; var tot: double; extra:catego);
var
aux:double;
begin
     aux:= r.cantExtra * extra[r.cate];
     tot:= tot + aux;
     writeln(r.numEmple:10, '    ', r.cantExtra:15, '    ', aux:15:2);
end;

procedure procesarMaestro (var mae:arc; extra:catego);
var
reg: empleado;
depActual, divActual :integer;
totDivi, totDepto: double;
horasDivi, horasDepto: integer;
begin
     reset(mae);
     leer(mae,reg);
     while (reg.depto <> impo) do begin
         depActual:= reg.depto;
         writeln('Departamento: ', depActual);
         horasDepto:=0;
         totDepto:=0;
         while (reg.depto = depActual) do begin
             divActual:= reg.divi;
             writeln('Division: ', divActual);
             writeln('numero de empleado    horas extras    monto a cobrar');
             horasDivi:=0;
             totDivi:=0;
             while (reg.depto = depActual) and (reg.divi = divActual) do begin
                   informarEmpleado(reg,totDivi,extra);
                   horasDivi := horasDivi + reg.cantExtra;
                   leer(mae,reg);
             end;
             writeln('Total de horas de la division: ', horasDivi);
             writeln('Monto total de la division: ', totDivi:0:2);
             totDepto:= totDepto + totDivi;
             horasDepto:= horasDepto + horasDivi;
         end;
         writeln('El total de horas del departamento es de: ', horasDepto);
         writeln('Monto total del departamento es de: ', totDepto:0:2);
     end;
     close(mae);
end;

var
mae:arc;
horas:txt;
extra:catego;
begin
     asignarArchivos(mae,horas);
     cargarArreglo(horas,extra);
     procesarMaestro(mae,extra);
     readln();
end.
