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
