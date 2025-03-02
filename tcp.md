# Protocolo TCP

El protocolo TCP (Transmission Control Protocol) es un estándar de comunicación que permite la transferencia confiable de datos entre sistemas a través de una red. Sus principales características incluyen:

- **Fiabilidad**: Garantiza que los datos lleguen al destino sin errores y en el mismo orden en que fueron enviados.
- **Uso de puertos**: Permite que varias aplicaciones en un mismo dispositivo puedan enviar y recibir datos simultáneamente.
- **Encabezado estructurado**: Contiene información clave para establecer y mantener la comunicación.

### Encabezado TCP

El encabezado TCP incluye los siguientes campos esenciales:

- **Puerto de origen**: Identifica el puerto del remitente.
- **Puerto de destino**: Indica el puerto del receptor.
- **Número de secuencia**: Especifica el orden de los datos transmitidos.
- **Número de confirmación**: Confirma la recepción de los datos enviados.
- **Offset**: Define la longitud del encabezado.
- **Reservado**: Espacio reservado para futuras implementaciones.
- **Flags**: Controla la conexión y gestión de datos.
- **Tamaño de ventana**: Indica la cantidad de datos que pueden enviarse sin confirmación.
- **Suma de comprobación**: Permite la detección de errores en la transmisión.

TCP es fundamental para la comunicación en redes, asegurando que los datos sean entregados de manera confiable y ordenada.
