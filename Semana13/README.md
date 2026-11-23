# Semana 13 - Consumir API desde una aplicación

**Autora:** Angie Portocarrero - angie.portocarrero@tecsup.edu.pe
**Curso:** Programación en Móviles Avanzados - Tecsup

## Actividad 01 - Lista de usuarios (MVVM)

App en SwiftUI que consume `https://jsonplaceholder.typicode.com/users` y muestra solo los nombres, con un buscador para filtrarlos.

```
Semana13_API/
├── Models/User.swift
├── View/ContentView.swift
└── ViewModels/UserViewModel.swift
```

- **User:** el modelo con `id` y `name`, usa `Codable` e `Identifiable`.
- **UserViewModel:** hace la petición con `URLSession`, decodifica el JSON y tiene el filtro.
- **ContentView:** el buscador y la lista.

### Preguntas

**¿Cuál es la función del @Published?**
Hace que la propiedad avise cuando cambia su valor. Como el ViewModel es un `ObservableObject` y la vista lo usa con `@StateObject`, cada vez que cambia `users` o `searchText` SwiftUI vuelve a dibujar la vista sola.

**Explique brevemente qué se realiza dentro de filteredUsers**
Es una propiedad calculada que devuelve la lista según lo que se escribe en el buscador. Si `searchText` está vacío devuelve todos los usuarios, y si no, usa `filter` para quedarse solo con los que tienen ese texto en el nombre. Pasa todo a minúsculas con `lowercased()` para que no importe si escribes con mayúsculas o no.

### Nota
En esta versión de Xcode hubo que agregar `import Combine` en el ViewModel, porque `@Published` y `ObservableObject` vienen de ese framework y solo con `Foundation` el proyecto no compilaba.

## Actividad 02 - Métodos POST, PUT y DELETE

Proyecto `Semana13_MetodosAPI`, con la misma estructura MVVM y un `UserFormView` en la carpeta `View` para agregar o editar usuarios.

```
Semana13_MetodosAPI/
├── Models/User.swift
├── View/ContentView.swift
├── View/UserFormView.swift
└── ViewModels/UserViewModel.swift
```

- **GET** `fetchUsers()`: trae la lista de usuarios.
- **POST** `createUser(name:email:)`: manda el usuario nuevo en JSON y lo agrega a la lista.
- **PUT** `updateUser(user:)`: en la guía venía como "TO DO", así que lo armé igual que el POST pero con `httpMethod = "PUT"` y la URL `/users/{id}`.
- **DELETE** `deleteUser(id:)`: elimina por id.

En la lista, al deslizar un usuario salen los botones de editar (lápiz) y eliminar (tacho). Abajo está el botón "Agregar Usuario".

### Preguntas

**¿Cuál es la finalidad de la función resume()?**
`dataTask` solo crea la tarea de red, pero la deja en pausa. Con `resume()` recién se inicia la petición. Si no lo llamas, nunca se hace la llamada a la API.

**¿Qué función cumple DispatchQueue?**
Maneja en qué hilo se ejecuta el código. La respuesta de `URLSession` llega en un hilo secundario, y la interfaz solo se puede actualizar en el hilo principal, por eso usamos `DispatchQueue.main.async` para cambiar `users` y que la vista se refresque bien.

**¿Qué función cumple la clase JSONDecoder()?**
Convierte el JSON que devuelve la API en objetos de Swift, en este caso en `User` o `[User]`. Funciona porque el modelo es `Codable`. Su contrario es `JSONEncoder()`, que usamos en el POST y el PUT para mandar el usuario como JSON.

**@State private var editingUser: User? = nil**
Guarda el usuario que se está editando. Es opcional: si es `nil` el formulario se abre para crear uno nuevo, y si tiene un usuario se abre en modo edición con sus datos.

**@StateObject private var viewModel = UserViewModel()**
Crea el ViewModel y lo mantiene vivo mientras exista la vista, aunque SwiftUI la vuelva a dibujar. Además la vista escucha sus `@Published`, así que se actualiza sola cuando cambian los usuarios.

**.swipeActions**
Agrega botones que aparecen al deslizar una fila de la lista. Aquí pusimos "Eliminar" (con `role: .destructive`, sale en rojo) y "Editar" (en azul).

**.sheet(isPresented: $showingForm)**
Muestra el `UserFormView` como una ventana que sube desde abajo cuando `showingForm` es `true`. Al guardar se cierra con `dismiss()` y `showingForm` vuelve a `false`.

### Notas
- JSONPlaceholder es una API de prueba: responde como si guardara los cambios, pero no guarda nada. Por eso el PUT y el DELETE actualizan la lista localmente.
- Al crear un usuario la API siempre devuelve `id: 11`. Si agregas dos, se repite el id y al editar o eliminar uno se afectan los dos. Para evitarlo, en el POST se le asigna un id local que no se repite.
- El PUT a un usuario creado por nosotros (id mayor a 10) devuelve error en la API porque ese usuario no existe allá, pero igual se actualiza en la lista.

## Actividad 03 - URLSession con async/await

Sobre el mismo proyecto `Semana13_MetodosAPI` se cambiaron `UserViewModel` y `ContentView` para usar `async/await` en vez de `dataTask` con closures. La versión de la actividad 2 queda en el historial de commits.

- **GET:** `URLSession.shared.data(from: url)`
- **POST, PUT y DELETE:** `URLSession.shared.data(for: request)`
- Las funciones del ViewModel ahora son `async`, y en la vista se llaman dentro de un `Task { await ... }`.
- La lista se actualiza con `await MainActor.run { ... }` en vez de `DispatchQueue.main.async`.

### Preguntas

**¿Cuál es la diferencia de usar URLSession.shared.data en vez de URLSession.shared.dataTask?**
`dataTask` trabaja con un closure (callback): creas la tarea, le pasas un bloque de código que se ejecuta cuando llega la respuesta y tienes que acordarte de llamar a `resume()`. Además, los errores llegan como un parámetro opcional que hay que revisar a mano. `data` usa async/await: devuelve directamente `(data, response)` con `try await`, no necesita `resume()` y los errores se manejan con `do/catch`. El código queda más ordenado, de arriba hacia abajo, sin closures anidados.

**¿Para qué sirve la palabra reservada await?**
Marca el punto donde el código espera el resultado de una función asíncrona, como la respuesta de la API. Mientras espera no bloquea la app: la interfaz sigue funcionando y, cuando llega la respuesta, el código continúa en la siguiente línea. Solo se puede usar dentro de una función `async` o de un `Task`.

**¿Para qué sirve la estructura Task?**
Crea un contexto asíncrono desde código que no es `async`, por ejemplo la acción de un botón o el `onAppear`. Sin `Task` no podríamos llamar con `await` a `fetchUsers()`, `createUser()`, `updateUser()` o `deleteUser()` desde la vista.

## Conclusiones

1. Separar el proyecto con MVVM (Models, View, ViewModels) ayuda a mantener la lógica de la API fuera de la vista. Así la vista solo muestra los datos y reacciona sola a los cambios gracias a `@Published` y `@StateObject`.
2. Con `URLSession` y `Codable` se pueden consumir los cuatro métodos de una API REST (GET, POST, PUT y DELETE), mandando y recibiendo JSON con `JSONEncoder` y `JSONDecoder`. Hay que tomar en cuenta que JSONPlaceholder es una API de prueba que no guarda los cambios.
3. `async/await` deja el código más claro que `dataTask`, porque se lee en orden, no necesita `resume()` y maneja los errores con `do/catch`. La interfaz igual se tiene que actualizar en el hilo principal, con `MainActor.run` o `DispatchQueue.main.async`.
