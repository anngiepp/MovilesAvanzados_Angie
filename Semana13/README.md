# Semana 13 - Consumir API desde una aplicación

**Autora:** Angie Portocarrero - angie.portocarrero@tecsup.edu.pe
**Curso:** Programación en Móviles Avanzados - Tecsup

Apps en SwiftUI con arquitectura MVVM que consumen la API de prueba [JSONPlaceholder](https://jsonplaceholder.typicode.com/users).

## Actividad 01 - Semana13_API

Muestra la lista de usuarios de la API (solo los nombres) y tiene un buscador para filtrarlos por nombre.

```
Semana13_API/
├── Models/User.swift
├── View/ContentView.swift
└── ViewModels/UserViewModel.swift
```

- **User:** modelo con `id` y `name`.
- **UserViewModel:** hace la petición GET con `URLSession`, decodifica el JSON y filtra la lista según el texto de búsqueda.
- **ContentView:** el buscador y la lista de usuarios.

## Actividad 02 - Semana13_MetodosAPI

Con la misma estructura MVVM, agrega las acciones de crear, editar y eliminar usuarios.

```
Semana13_MetodosAPI/
├── Models/User.swift
├── View/ContentView.swift
├── View/UserFormView.swift
└── ViewModels/UserViewModel.swift
```

- **GET** `fetchUsers()`: trae la lista de usuarios con su email.
- **POST** `createUser(name:email:)`: crea un usuario nuevo.
- **PUT** `updateUser(user:)`: actualiza un usuario.
- **DELETE** `deleteUser(id:)`: elimina un usuario.
- **UserFormView:** formulario para agregar o editar un usuario.

En la lista, al deslizar un usuario a la izquierda salen los botones de editar y eliminar. Abajo está el botón "Agregar Usuario".

## Actividad 03 - async/await

Sobre el mismo proyecto `Semana13_MetodosAPI`, se cambiaron `UserViewModel` y `ContentView` para usar `async/await` en vez de `dataTask`:

- GET con `URLSession.shared.data(from:)`
- POST, PUT y DELETE con `URLSession.shared.data(for:)`
- Desde la vista, las funciones se llaman dentro de un `Task`.

La versión con `dataTask` de la actividad 2 queda en el historial de commits.

### Rediseño de la interfaz

Después de las actividades se rediseñó `Semana13_MetodosAPI` con un estilo propio en tonos pastel (celeste y rosa), tarjetas redondeadas y botones negros en forma de píldora.

```
View/
├── Theme.swift          → colores, botón píldora, puntitos de adorno y círculo con inicial
├── ContentView.swift    → cabecera con buscador, tarjeta con el total y usuarios en dos columnas
├── UserCard.swift       → tarjeta de cada usuario
├── UserDetailView.swift → perfil del usuario con botones para editar y eliminar
└── UserFormView.swift   → formulario para agregar o editar
```

- Al tocar una tarjeta se entra al **perfil** del usuario, y desde ahí se puede **editar** o **eliminar** (con confirmación).
- También se puede mantener presionada una tarjeta para editar o eliminar rápido.
- Mientras carga sale un `ProgressView`, si la búsqueda no encuentra nada se muestra un aviso, y se puede jalar hacia abajo para recargar.
- El formulario solo deja guardar si el nombre no está vacío y el email es válido.
- La versión con `swipeActions` de la guía queda en el historial de commits.

## Notas

- JSONPlaceholder es una API de prueba: responde como si guardara los cambios, pero no guarda nada. Por eso los cambios del POST, PUT y DELETE solo se ven en la lista de la app.
- Al crear un usuario, la API siempre devuelve `id: 11`. Para que no se repitan los ids si agregas varios, en el POST se le asigna un id local.
- En la guía, el método PUT venía como "TO DO". Se armó siguiendo el mismo modelo del POST, con `httpMethod = "PUT"` y la URL `/users/{id}`.
- En esta versión de Xcode hay que agregar `import Combine` en los ViewModel para usar `ObservableObject` y `@Published`.
