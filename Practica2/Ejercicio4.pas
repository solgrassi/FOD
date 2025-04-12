{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible, 
stock mínimo y precio del producto. 
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se 
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo 
maestro. La información que se recibe en los detalles es: código de producto y cantidad 
vendida. Además, se deberá informar en un archivo de texto: nombre de producto, descripción,
stock disponible y precio de aquellos productos que tengan stock disponible por debajo del stock
mínimo.
Pensar alternativas sobre realizar el informe en el mismo procedimiento de actualización,
o realizarlo en un procedimiento separado (analizar ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle 
puede venir 0 o N registros de un determinado producto.
}

program Ejercicio4;
const
impo= -1;
df= 30;
type
producto = record
     cod: integer;
     nom: string[20];
     desc: string;
     stockDis: integer;
     stockMin: integer;
     precio: real;
end;

diario = record
    cod: integer;
    cantVen: integer;
end;

detalle = file of diario;
sucursales = array [1..df] of detalle;
txt = text;
arc = file of producto;
registros = array [1..df] of diario;

procedure asignarArchivos ( var mae:arc; var d:sucursales; var stock: txt);
var
i:integer;
num:string;
begin
     assign(stock, 'menosStock.txt');
     assign(mae, 'productos');
     for i:= 1 to df do begin
         Str(i, num);
         assign (d[i], 'det' + num);
     end;
end;

procedure leer (var d: detalle; var r:diario);
begin
     if (not EOF (d)) then
        read(d,r)
     else
        r.cod:= impo;
end;

procedure minimo (var d:sucursales; var r:registros; var min: diario);
var
i,indice:integer;
begin
     min.cod:= 9999;
     for i:= 1 to df do begin
       if (r[i].cod < min.cod) then begin
          min:= r[i];
          indice:= i;
       end;
     end;
     leer(d[indice], r[indice]);
end;

procedure agregarAltxt (var stock:txt; reg:producto);
begin
     writeln(stock, 'stock disponible: ', reg.stockDis, ' ','precio: ', reg.precio:0:2, ' ','nombre: ', reg.nom);
     writeln(stock, 'descripcion: ', reg.desc);
end;

procedure actualizarMaestro (var mae:arc; var d: sucursales; var r:registros; var stock: txt);
var
regmae: producto;
i: integer;
min: diario;
begin
     reset(mae);
     rewrite(stock);
     for i:= 1 to df do begin
         reset(d[i]);
         leer(d[i],r[i]);
     end;
     minimo(d,r,min);
     while (min.cod <> impo) do begin
         read(mae,regmae);
         while (regmae.cod <> min.cod) do
               read(mae,regmae);
         while (regmae.cod = min.cod) do begin
               regmae.stockDis := regmae.stockDis - min.cantVen;
               minimo(d,r,min);
         end;
         seek(mae, filepos(mae)-1);
         write(mae,regmae);
         if (regmae.stockDis < regmae.stockMin) then
            agregarAltxt(stock,regmae);
    end;

    close(mae);
    close(stock);
    for i:= 1 to df do
        close(d[i]);
end;

var
mae:arc;
d: sucursales;
r:registros;
stock:txt;
begin
     asignarArchivos(mae,d, stock);
     actualizarMaestro(mae,d,r,stock);
end.
