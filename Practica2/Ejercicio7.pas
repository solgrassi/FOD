{ Se dispone de un archivo maestro con información de los alumnos de la Facultad de 
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre, 
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo 
maestro está ordenado por código de alumno. 
Además, se tienen dos archivos detalle con información sobre el desempeño académico de 
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de 
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro 
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la 
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales 
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de 
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle 
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o 
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia 
muchas veces, así como también podría rendir el final de una materia en múltiples 
ocasiones. 
Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad 
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la 
información de los archivos detalle. Las reglas de actualización son las siguientes: 
- Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas
aprobadas. 
- Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad
de materias con final aprobado. 
Notas: 
- Los archivos deben procesarse en un único recorrido.
- No es necesario comprobar que no haya inconsistencias en la información de los
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una 
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar 
ocurre con los exámenes finales. 
}

program Ejercicio7;
const
impo =-1;

type
    alumnos = record
        codAlu: integer;
        apeynom: string [50];
        cursadaTot: integer;
        finalTot: integer;
    end;

    cursada = record
        codAlu: integer;
        codMate:integer;
        anioC: integer;
        resul: string;
    end;

    final = record
        codAlu:integer;
        codMate:integer;
        fecha: string[10];
        nota: double;
    end;

arc  = file of alumnos;
cursadas = file of cursada;
finales = file of final;


procedure leerC (var cur:cursadas; var c:cursada);
begin
     if (not EOF(cur)) then
        read(cur,c)
     else
         c.codAlu:= impo;
end;

procedure leerF (var fin:finales; var f:final);
begin
     if (not EOF(fin)) then
        read(fin,f)
     else
        f.codAlu:= impo;
end;

procedure asignarArchivos (var cur:cursadas; var fin:finales; var mae:arc);
begin
     assign(cur,'cursadasDet' );
     assign(fin,'finalesDet');
     assign(mae, 'maestroAlumnos');
end;

procedure actualizarMaestro (var mae:arc; var cur:cursadas; var fin:finales);
var
f:final;
c:cursada;
regMae: alumnos;
actualizado:boolean;
begin
     reset(mae);
     reset(fin);
     reset(cur);
     leerC(cur,c);
     leerF(fin,f);
     while (f.codAlu<> impo) or (c.codAlu <> impo) do begin
            read(mae,regMae);
            actualizado:= false;
            while (regMae.codAlu = c.codAlu) do begin
                if (c.resul = 'A') then begin
                   regMae.cursadaTot := regMae.cursadaTot + 1;
                   actualizado:= true;
                end;
                leerC(cur, c);
            end;
            while (regMae.codAlu = f.codAlu) do begin
                if (f.nota>= 4) then begin
                   regMae.finalTot:= regMae.finalTot +1;
                   actualizado:= true;
                end;
                leerF(fin,f);
            end;
            if actualizado then begin
               seek(mae, FilePos(mae) - 1);
               write(mae, regMae);
            end;
     end;
     close(mae);
     close(fin);
     close(cur);
end;

var
mae:arc;
fin:finales;
cur:cursadas;
begin
     asignarArchivos(cur,fin,mae);
     actualizarMaestro(mae,cur,fin);
end.
