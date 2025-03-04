# Proyecto Rack API con Redis y WebSockets

## Instalación y ejecución del proyecto

### Clonar el repositorio

```sh
git clone https://github.com/andres-benavides/fudo-challenge
cd fudo-challenge
```

### Construcción del proyecto

Ejecuta el siguiente comando para construir las imágenes de Docker:

```sh
docker compose build
```

### Levantar los servicios

Una vez construido el proyecto, ejecuta:

```sh
docker compose up
```

Esto levantará:

- El servidor del proyecto en Rack (escuchando en el puerto `9292`).
- Un servidor Redis para el manejo de colas de trabajo.

## Uso del API

### Usuario pre-cargado

El proyecto ya incluye un usuario de prueba:

```json
{
  "email": "admin@test.com",
  "password": "mytest123"
}
```

### Registro de un nuevo usuario

Si necesitas crear un usuario nuevo, puedes hacer una solicitud `POST` al endpoint `/signup` con el siguiente cuerpo en formato JSON:

```json
{
  "email": "andre0198@gmail.com",
  "password": "micontracom3"
}
```

### Inicio de sesión

Para autenticarte, haz una solicitud `POST` a `/login` con el email y la contraseña. El servidor responderá con un token JWT que debes usar para acceder a los endpoints protegidos.

Ejemplo de solicitud:

```json
{
  "email": "admin@test.com",
  "password": "mytest123"
}
```

### Endpoints protegidos

Para acceder a los endpoints protegidos, como `/products`, necesitas incluir el token obtenido en el header `Authorization` como `Bearer <token>`.

Ejemplo:

```
Authorization: Bearer eyJhbGciOiJIUzI1...
```

### Comprimir la respues

Los endpoints tienen la capacidad de comprimir la respuesta. Si deseas habilitar esta compresión en un endpoint, debes incluir el siguiente encabezado en la solicitud:

```
Accept-Encoding: application/gzip
```

### WebSockets

El proyecto incluye soporte para WebSockets. Puedes conectarte a `ws://localhost:9292/ws` para recibir mensajes cuando se cree un producto de forma asíncrona.

### Pruebas con Postman

En la raíz del repositorio hay un archivo `fudo-challenge.postman_collection.json`, el cual puedes importar en Postman para probar la API fácilmente.

También puedes usar Postman para crear una solicitud WebSocket apuntando a `ws://localhost:9292/ws` y recibir notificaciones cuando se cree un producto en segundo plano.

### Pruebas unitarias

El proyecto cuenta con pruebas unitarias realizadas en rspec, para los request que se crearon, para ejecutar las prueas se puede ejecutar el comando:

```sh
docker compose run --rm rack_app sh -c "rspec spec"
```
