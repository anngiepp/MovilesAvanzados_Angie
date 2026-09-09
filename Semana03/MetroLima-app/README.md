# MetroSmart Lima

## Sistema Inteligente de Consulta y Planificación de Rutas del Metro de Lima

---

## Descripción del Proyecto

MetroSmart Lima es una aplicación de consola desarrollada en Swift utilizando Xcode Playground. Su finalidad es brindar a los usuarios información organizada sobre las líneas y estaciones del Metro de Lima, permitiendo consultar el estado de cada estación, sus conexiones, lugares cercanos y calcular rutas entre un origen y un destino mediante algoritmos de búsqueda.

El sistema implementa estructuras de datos basadas en diccionarios (clave-valor), programación orientada a objetos y teoría de grafos para representar la red ferroviaria y ofrecer consultas eficientes.

---

# Objetivo General

Desarrollar una aplicación de consola que permita consultar información del Metro de Lima mediante estructuras de datos, algoritmos de búsqueda y programación orientada a objetos, proporcionando al usuario una herramienta interactiva para la planificación de rutas y consulta de estaciones.

---

# Objetivos Específicos

- Modelar las líneas y estaciones del Metro de Lima mediante estructuras de datos.
- Implementar un sistema de almacenamiento utilizando diccionarios clave-valor.
- Permitir la búsqueda inteligente de estaciones.
- Mostrar información detallada de cada estación.
- Calcular la ruta más corta entre dos estaciones mediante el algoritmo Breadth-First Search (BFS).
- Mostrar el estado actual de cada estación (operativa, en construcción o proyecto).
- Presentar estadísticas generales del sistema.
- Mantener un historial de consultas realizadas por el usuario.

---

# Requerimientos Funcionales

### RF01. Consulta de estaciones

El sistema debe permitir buscar una estación mediante su nombre, aceptando coincidencias exactas y parciales.

### RF02. Información detallada

El sistema debe mostrar la siguiente información de cada estación:

- Nombre
- Código
- Línea
- Color de la línea
- Estado
- Tipo de estación
- Distrito
- Estación anterior
- Estación siguiente
- Conexiones
- Lugares cercanos
- Destino inicial
- Destino final
- Observaciones

### RF03. Consulta de líneas

El sistema debe permitir consultar las líneas existentes y mostrar todas las estaciones que pertenecen a cada una.

### RF04. Clasificación por estado

El sistema debe listar las estaciones según su estado:

- Operativas
- En construcción
- Proyecto futuro

### RF05. Planificación de rutas

El sistema debe calcular la ruta más corta entre una estación de origen y una estación de destino utilizando el algoritmo Breadth-First Search (BFS).

### RF06. Detección de transbordos

El sistema debe identificar automáticamente las estaciones de intercambio y mostrar los cambios de línea cuando sean necesarios.

### RF07. Historial de consultas

El sistema debe almacenar y mostrar las últimas búsquedas realizadas por el usuario durante la ejecución.

### RF08. Estadísticas

El sistema debe generar estadísticas generales de la red, incluyendo:

- Total de líneas.
- Total de estaciones.
- Cantidad de estaciones operativas.
- Cantidad de estaciones en construcción.
- Cantidad de proyectos futuros.
- Cantidad de estaciones de intercambio.

---

# Requerimientos No Funcionales

- La aplicación debe desarrollarse utilizando Swift.
- El entorno de desarrollo será Xcode Playground.
- La interfaz será completamente mediante consola.
- El código deberá organizarse de forma modular.
- La información deberá almacenarse utilizando estructuras de datos eficientes.
- Las búsquedas deberán responder en tiempos reducidos.
- El sistema deberá ser fácil de mantener y ampliar.
- La arquitectura deberá separar modelos, datos, lógica de negocio y menú de usuario.

---

# Tecnologías Utilizadas

- Swift
- Xcode Playground
- Programación Orientada a Objetos
- Diccionarios (Clave-Valor)
- Algoritmo Breadth-First Search (BFS)
- Teoría de Grafos

---

# Estructura del Proyecto

```
MetroSmartLima.playground
│
├── Pages
│   ├── 01_Modelos
│   ├── 02_BaseDatos
│   ├── 03_Funciones
│   ├── 04_Menu
│   └── 05_Main
│
└── Sources
    ├── Modelos.swift
    ├── Datos.swift
    ├── Busquedas.swift
    └── Rutas.swift
```

---

# Funcionalidades Implementadas

- Registro de las líneas del Metro de Lima.
- Registro de las estaciones con información detallada.
- Consulta inteligente de estaciones.
- Consulta por líneas.
- Visualización del estado de las estaciones.
- Identificación de estaciones de intercambio.
- Cálculo de rutas mediante BFS.
- Historial de consultas.
- Estadísticas generales del sistema.

---

# Resultados Esperados

La aplicación proporciona una herramienta interactiva para consultar información del Metro de Lima, facilitando la planificación de recorridos y el acceso a datos relevantes de cada estación mediante una interfaz de consola organizada y de fácil utilización.

---

# Autor

Proyecto académico desarrollado para el curso de Programación en Swift utilizando Xcode Playground.
