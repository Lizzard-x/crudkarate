 Pruebas de API con Karate

Suite de pruebas automatizadas para un **CRUD** (Crear, Leer, Actualizar y Eliminar) escrita con [Karate DSL](https://github.com/karatelabs/karate). Incluye pruebas para servicios **REST** y **SOAP**.

## Tabla de contenidos

- [Descripción](#descripción)
- [Tecnologías](#tecnologías)
- [Requisitos previos](#requisitos-previos)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Configuración](#configuración)
- [Ejecución de las pruebas](#ejecución-de-las-pruebas)
- [Casos de prueba](#casos-de-prueba)
- [Reportes](#reportes)
- [Buenas prácticas aplicadas](#buenas-prácticas-aplicadas)
- [Autor](#autor)

## Descripción

Este proyecto valida el comportamiento de las operaciones CRUD de [describe tu API: por ejemplo, gestión de usuarios, productos, etc.] expuestas mediante:

- **REST (JSON):** verbos `POST`, `GET`, `PUT`/`PATCH` y `DELETE`.
- **SOAP (XML):** operaciones definidas en el WSDL del servicio.

Las pruebas verifican códigos de estado, estructura de las respuestas, datos devueltos y manejo de errores.
