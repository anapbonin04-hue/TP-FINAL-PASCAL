//Se tienen los datos de la empresa "Envíos Exprés", la cual se encarga de realizar envíos 
//de paquetes a distintos destinos dentro del país. Para mejorar su sistema interno, se desea 
//desarrollar una aplicación que permita gestionar los envíos del día. Dichos datos se 
//almacenan en una estructura de datos diseñada para tal fin. Por cada envío se registra: 
//● Código de envío: string [15] ● DNI del destinatario: string [10] ● Nombre del destinatario: string [60] 
//● Ciudad destino: string [30] ● Estado envío: string[30] ● Peso del paquete (en kg): real 
//● Costo del envío ($AR): real Se pide: Crear una Unit de archivos de tipo registro con los siguientes proce:
//1. Cargar la estructura de envíos. 
//2. Ordenamiento burbuja por campo Código de envío. 
//3. Búsqueda binaria por el mismo campo. 
//4. Listado completo y ordenado por campo Código de envío y Nombre Destinatario. 
//5. Generar un subprograma para avanzar el estado del envío (En preparación → En 
//camino → En destino), sin posibilidad de retroceso. 
//6. Generar un subprograma para cancelar un envío (Envío Cancelado), permitiendo la 
//cancelación únicamente cuando el estado se encuentre en En preparación. 
//7. Crear el cuerpo principal para invocar los procedimientos anteriores. 

   //PROGRAMA 2 CON MEJORAS
program EnviosExpres;

const 
  MAX = 100; // Definicion de una constante

type                                      // definicion de los diferentes campos del tipo record
  t_envio = record
    CodigoEnvio : string[15];   
    DNIdestinatario : string[10];
    Nombredestinatario : string[60];
    CiudadDestino : string[30];
    EstadoEnvio : string[30];
    PesoPaquete : real;
    CostoEnvio : real;
  end;

  t_vector = array [1 .. MAX] of t_envio;   //definicion del tipo vector, del tipo t_envio

var 
  v : t_vector;      // declaracion del vector
  n, pos : integer;
  cod : string;

//------------procedimientos y funciones -----------------------

procedure CargarDatos (var v : t_vector; var n: integer);  // carga de los fiferentes campos en el vector
var i : integer;
begin
  repeat
    writeln('Ingrese cantidad de envios (max ', MAX, '): ');
    readln(n);
  until (n > 0) and (n <= MAX);

  for i := 1 to n do
  begin
    writeln('Envio ', i);

    with v[i] do   // usamos with para ahorrar codigo
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

 
procedure OrdenamientoB (var v: t_vector; n: integer); //ordenamos los diferentes campos para despues poder realizar la busqueda B
var 
  i, j : integer;
  aux : t_envio;
begin
  for i := 1 to n-1 do
    for j := 1 to n-i do
      if (v[j].CodigoEnvio > v[j+1].CodigoEnvio) OR
         ((v[j].CodigoEnvio = v[j+1].CodigoEnvio) AND
          (v[j].Nombredestinatario > v[j+1].Nombredestinatario)) then
      begin
        aux := v[j];
        v[j] := v[j+1];
        v[j+1] := aux;
      end;
end;


function BusquedaN (v: t_vector; n: integer; cod: string): integer; //Buscamos el codigo requerido por el usuario
var 
  pri, ult, med : integer;
begin
  pri := 1;
  ult := n;
  BusquedaN := -1;

  while (pri <= ult) do
  begin
    med := (pri + ult) div 2;

    if v[med].CodigoEnvio = cod then
    begin
      BusquedaN := med;
      exit;  // corta la búsqueda cuando lo encuentra
    end
    else if v[med].CodigoEnvio < cod then
      pri := med + 1
    else
      ult := med - 1;
  end;
end;


procedure listar(v: t_vector; n: integer);  //mostramos los datos ordenados 
var i: integer;
begin
  writeln('--- LISTADO DE ENVIOS ---');
  for i := 1 to n do
  begin
    writeln('Codigo: ', v[i].CodigoEnvio);
    writeln('Nombre: ', v[i].Nombredestinatario);
    writeln('Ciudad: ', v[i].CiudadDestino);
    writeln('Estado: ', v[i].EstadoEnvio);
  end;
end;


procedure avanzar_estado(var e: t_envio); //estado en el que se encuentra el paquete
begin
  if e.EstadoEnvio = 'En preparacion' then
    e.EstadoEnvio := 'En camino'
  else if e.EstadoEnvio = 'En camino' then
    e.EstadoEnvio := 'En destino'
  else
    writeln('No se puede avanzar el estado');
end;


procedure cancelar_envio(var e: t_envio); //cancelar envio de ser posible
begin
  if e.EstadoEnvio = 'En preparacion' then
    e.EstadoEnvio := 'Envio Cancelado'
  else
    writeln('No se puede cancelar el envio');
end;


//------------------ PROGRAMA PRINCIPAL ------------------

BEGIN  

  CargarDatos(v, n);     

  OrdenamientoB(v, n);

  listar(v, n);

  writeln('Ingrese codigo a buscar: ');
  readln(cod);

  pos := BusquedaN(v, n, cod);

  if pos <> -1 then
  begin
    writeln('Envio encontrado');

    avanzar_estado(v[pos]);
    cancelar_envio(v[pos]);
  end
  else
    writeln('No encontrado');

  listar(v, n);

END.