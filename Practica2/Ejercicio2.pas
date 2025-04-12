{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock 
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los 
productos que comercializa. De cada producto se maneja la siguiente información: código de 
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se 
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De 
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide 
realizar un programa con opciones para: 
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que: 
? Ambos archivos están ordenados por código de producto. 
? Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del 
archivo detalle. 
? El archivo detalle sólo contiene registros que están en el archivo maestro. 
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo 
stock actual esté por debajo del stock mínimo permitido. 
}

program Ejercicio2;
const
impo = -1;
type
  producto = record
      codigo: integer;
      nombre: string[50];
      precio: real;
      stockAc: integer;
      stockMin: integer;
  end;

  diario = record
     codigo:integer;
     unidadesV: integer;
  end;


 arc= file of producto;
 detalle= file of diario;
 txt= text;

 procedure leerProd (var p:producto);
 begin
      writeln('Ingrese el codigo del producto (-1 para finalizar)');
      readln(p.codigo);
      if (p.codigo <> impo) then begin
         writeln('Ingrese el nombre del producto');
         readln(p.nombre);
         writeln('Ingrese el precio del producto');
         readln(p.precio);
         writeln('Ingrese el stock actual del producto');
         readln(p.stockAc);
         writeln('Ingrese el stock minimo del producto');
         readln(p.stockMin);
      end;
end;


 procedure cargarMaestro (var mae:arc);
 var
 p:producto;
 begin
      rewrite(mae);
      leerProd(p);
      while (p.codigo <> impo) do begin
            write(mae,p);
            leerProd(p);
      end;
      close(mae);
end;

procedure leerDiario (var p:diario);
begin
     writeln('Ingrese el codigo del producto');
     readln(p.codigo);
     if (p.codigo <> impo) then begin
        writeln('Ingrese las unidades vendidas del producto');
        readln(p.unidadesV);
     end;
end;


procedure cargarDetalle (var det:detalle);
 var
 p:diario;
 begin
      assign (det, 'detalleLimpieza');
      rewrite(det);
      leerDiario(p);
      while (p.codigo <> impo) do begin
            write(det,p);
            leerDiario(p);
      end;
      close(det);
end;

procedure leer (var det:detalle; var reg:diario);
begin
     if (not EOF(det)) then
           read(det,reg)
     else
         reg.codigo := impo;
end;

procedure actualizarMaestro (var mae:arc; var det:detalle);
var
reg: producto;
dato: diario;
begin
     assign (det, 'detalleLimpieza');
     reset(mae);  reset(det);
     leer(det, dato);
     while (dato.codigo <> impo) do begin
         read(mae, reg);
         while (reg.codigo<> dato.codigo) do
               read(mae, reg);
         while (dato.codigo<> impo) and (reg.codigo = dato.codigo) do  begin
               reg.stockAc := reg.stockAc - dato.unidadesV;
               leer(det, dato);
         end;
         seek (mae, filepos(mae)-1);
         write(mae,reg);
    end;
    writeln('Actualizacion completa');
    close(mae);
    close(det);
end;

procedure informarProducto (reg: producto);
begin
     writeln(reg.nombre);
     writeln(reg.stockAc);
end;

procedure imprimir(var maestro:arc);
var
reg: producto;
begin
    reset(maestro);
    while (not eof(maestro)) do begin
        read(maestro, reg);
        informarProducto(reg);
    end;
    close(maestro);
end;

procedure listarSinStock (var sinStock: txt; var mae:arc);
var
reg: producto;
begin
     assign(sinStock, 'sinStock.txt');
     rewrite(sinStock);
     reset(mae);
     while (not EOF(mae)) do begin
           read(mae,reg);
           if (reg.stockAc < reg.stockMin) then
              write(sinStock,'codigo: ', reg.codigo,' ','precio: ', reg.precio:0:2,' ','stock actual: ', reg.stockAc,
              ' ','stock minimo: ', reg.stockMin,' ','nombre : ', reg.nombre);
     end;
     close(mae);
     close(sinStock);
     writeln('TXT genereado con exito');
end;

var
mae:arc;
det:detalle;
sinStock: txt;
begin
     assign (mae, 'maestroLimpieza');
     cargarMaestro(mae);
     cargarDetalle(det);
     imprimir(mae);
     actualizarMaestro(mae,det);
     imprimir(mae);
     listarSinStock(sinStock,mae);
     readln();
end.
