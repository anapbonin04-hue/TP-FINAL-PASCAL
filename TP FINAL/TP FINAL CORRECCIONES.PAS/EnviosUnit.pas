unit EnviosUnit;

interface

const
  MAX = 100;

type
  t_envio = record
    CodigoEnvio: string[15];
    DNIdestinatario: string[10];
    Nombredestinatario: string[60];
    CiudadDestino: string[30];
    EstadoEnvio: string[30];
    PesoPaquete: real;
    CostoEnvio: real;
  end;

  t_vector = array[1..MAX] of t_envio;

  t_archivo = file of t_envio;


// Cargar datos en el vector
procedure CargarDatos(var v: t_vector; var n: integer);

// Ordenamiento burbuja
procedure OrdenamientoB(var v: t_vector; n: integer);

// Búsqueda binaria
function BusquedaN(v: t_vector; n: integer; cod: string): integer;

// Listado
procedure Listar(v: t_vector; n: integer);

// Avanzar estado
procedure AvanzarEstado(var e: t_envio);

// Cancelar envío
procedure CancelarEnvio(var e: t_envio);

// Guardar vector en archivo
procedure GuardarArchivo(var arch: t_archivo; v: t_vector; n: integer);

// Cargar vector desde archivo
procedure CargarArchivo(var arch: t_archivo; var v: t_vector; var n: integer);


implementation


procedure CargarDatos(var v: t_vector; var n: integer);
var
  i: integer;
begin
  repeat
    writeln('Ingrese cantidad de envios (max ', MAX, '): ');
    readln(n);
  until (n > 0) and (n <= MAX);

  for i := 1 to n do
  begin
    writeln;
    writeln('--- ENVIO ', i, ' ---');

    with v[i] do
    begin
      write('Codigo de envio: ');
      readln(CodigoEnvio);

      write('DNI: ');
      readln(DNIdestinatario);

      write('Nombre: ');
      readln(Nombredestinatario);

      write('Ciudad de destino: ');
      readln(CiudadDestino);

      EstadoEnvio := 'En preparacion';

      write('Peso paquete: ');
      readln(PesoPaquete);

      write('Costo envio: ');
      readln(CostoEnvio);
    end;
  end;
end;


procedure OrdenamientoB(var v: t_vector; n: integer);
var
  i, j: integer;
  aux: t_envio;
begin
  for i := 1 to n - 1 do
    for j := 1 to n - i do
      if (v[j].CodigoEnvio > v[j + 1].CodigoEnvio) or
         ((v[j].CodigoEnvio = v[j + 1].CodigoEnvio) and
          (v[j].Nombredestinatario > v[j + 1].Nombredestinatario)) then
      begin
        aux := v[j];
        v[j] := v[j + 1];
        v[j + 1] := aux;
      end;
end;


function BusquedaN(v: t_vector; n: integer; cod: string): integer;
var
  pri, ult, med: integer;
begin
  pri := 1;
  ult := n;
  BusquedaN := -1;

  while pri <= ult do
  begin
    med := (pri + ult) div 2;

    if v[med].CodigoEnvio = cod then
    begin
      BusquedaN := med;
      exit;
    end
    else if v[med].CodigoEnvio < cod then
      pri := med + 1
    else
      ult := med - 1;
  end;
end;


procedure Listar(v: t_vector; n: integer);
var
  i: integer;
begin
  writeln;
  writeln('========== LISTADO DE ENVIOS ==========');

  for i := 1 to n do
  begin
    writeln;
    writeln('Codigo: ', v[i].CodigoEnvio);
    writeln('DNI: ', v[i].DNIdestinatario);
    writeln('Nombre: ', v[i].Nombredestinatario);
    writeln('Ciudad: ', v[i].CiudadDestino);
    writeln('Estado: ', v[i].EstadoEnvio);
    writeln('Peso: ', v[i].PesoPaquete:0:2, ' kg');
    writeln('Costo: $', v[i].CostoEnvio:0:2);
  end;
end;


procedure AvanzarEstado(var e: t_envio);
begin
  if e.EstadoEnvio = 'En preparacion' then
    e.EstadoEnvio := 'En camino'
  else if e.EstadoEnvio = 'En camino' then
    e.EstadoEnvio := 'En destino'
  else
    writeln('No se puede avanzar el estado.');
end;


procedure CancelarEnvio(var e: t_envio);
begin
  if e.EstadoEnvio = 'En preparacion' then
    e.EstadoEnvio := 'Envio Cancelado'
  else
    writeln('No se puede cancelar el envio.');
end;


procedure GuardarArchivo(var arch: t_archivo; v: t_vector; n: integer);
var
  i: integer;
begin
  rewrite(arch);

  for i := 1 to n do
    write(arch, v[i]);

  close(arch);
end;


procedure CargarArchivo(var arch: t_archivo; var v: t_vector; var n: integer);
begin
  n := 0;

  reset(arch);

  while (not eof(arch)) and (n < MAX) do
  begin
    n := n + 1;
    read(arch, v[n]);
  end;

  close(arch);
end;


end.