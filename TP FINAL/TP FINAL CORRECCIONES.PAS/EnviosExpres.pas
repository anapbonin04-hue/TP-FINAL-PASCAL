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

program EnviosExpres;

uses
  EnviosUnit;

var
  v: t_vector;
  n, pos: integer;
  cod: string;
  arch: t_archivo;

begin

  assign(arch, 'envios.dat');

  // 1. Cargar los datos
  CargarDatos(v, n);

  // 2. Ordenar por codigo y nombre
  OrdenamientoB(v, n);

  // 3. Guardar los envios en el archivo
  GuardarArchivo(arch, v, n);

  // 4. Mostrar los datos
  Listar(v, n);

  // 5. Buscar un envio
  writeln;
  write('Ingrese codigo a buscar: ');
  readln(cod);

  pos := BusquedaN(v, n, cod);

  if pos <> -1 then
  begin
    writeln;
    writeln('Envio encontrado.');

    writeln('Estado actual: ', v[pos].EstadoEnvio);

    // 6. Avanzar estado
    AvanzarEstado(v[pos]);

    writeln('Nuevo estado: ', v[pos].EstadoEnvio);

    // 7. Intentar cancelar
    CancelarEnvio(v[pos]);

    writeln('Estado final: ', v[pos].EstadoEnvio);

    // 8. Volver a guardar el vector actualizado
    GuardarArchivo(arch, v, n);
  end
  else
    writeln('Envio no encontrado.');

  writeln;
  writeln('--- LISTADO FINAL ---');
  Listar(v, n);

  // 9. Leer nuevamente desde el archivo
  CargarArchivo(arch, v, n);

  writeln;
  writeln('Datos cargados nuevamente desde el archivo.');

  Listar(v, n);

  readln;

end.