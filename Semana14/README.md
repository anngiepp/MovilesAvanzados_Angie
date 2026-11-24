# Semana 14 - Autenticación con Firebase

**Autora:** Angie Portocarrero - angie.portocarrero@tecsup.edu.pe
**Curso:** Programación en Móviles Avanzados - Tecsup

App en SwiftUI (`Lab14IntroFirebase`) que usa Firebase para registrar e iniciar sesión con correo y contraseña, y para un chat sencillo que guarda los mensajes en Cloud Firestore y los muestra en tiempo real.

```
Lab14IntroFirebase/
├── Lab14IntroFirebaseApp.swift
├── ContentView.swift
├── AuthView.swift
├── MessagesView.swift
└── DatabaseService.swift
```

## Actividad 01 - Autenticación

- **Lab14IntroFirebaseApp:** configura Firebase al iniciar la app.
- **AuthView:** formulario con email y contraseña. Tiene **Sign Up** para crear la cuenta, **Sign In** para entrar y **Sign Out** para salir, usando Firebase Authentication. Escucha los cambios de sesión para saber si el usuario ya entró.
- **ContentView:** muestra `AuthView`.

Los usuarios registrados aparecen en la consola de Firebase, en **Authentication → Usuarios**.

## Actividad 02 - Mensajes con Firestore

- **DatabaseService:** guarda cada mensaje en la colección `messages` de Firestore (texto, correo del usuario y hora) y escucha los cambios en tiempo real, ordenados por hora.
- **MessagesView:** lista de mensajes con el correo y la hora de quien lo envió, un campo para escribir y el botón **Send**.
- **AuthView:** cuando el usuario inicia sesión, muestra `MessagesView`.

Si entras con varios usuarios, los mensajes de todos aparecen en la misma lista.

## Para ejecutarla

1. Crear un proyecto en Firebase y activar **Authentication → Correo electrónico/contraseña**.
2. Crear una base de **Cloud Firestore** (en modo de prueba para el laboratorio).
3. Registrar una app iOS con el Bundle ID `pe.edu.tecsup.dma.Lab14IntroFirebase`, descargar `GoogleService-Info.plist` y ponerlo dentro de la carpeta `Lab14IntroFirebase`.
4. Abrir el proyecto en Xcode; los paquetes de Firebase (FirebaseAuth, FirebaseCore, FirebaseDatabase y FirebaseFirestore) se descargan solos con Swift Package Manager.

## Notas

- El archivo `GoogleService-Info.plist` no está en el repositorio (está en el `.gitignore`) porque tiene la configuración del proyecto de Firebase.
- La colección `messages` no se crea a mano: Firestore la crea cuando se envía el primer mensaje.
- Aunque la guía habla de base de datos en tiempo real, el chat usa **Cloud Firestore**, que también actualiza los datos en tiempo real con `addSnapshotListener`.
- En esta versión de Xcode hay que agregar `import Combine` en `DatabaseService` para usar `ObservableObject` y `@Published`.
