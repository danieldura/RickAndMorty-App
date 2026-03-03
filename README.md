# Rick and Morty App

Una aplicación iOS moderna y robusta construida con SwiftUI que consume la API pública de Rick and Morty. La aplicación implementa Clean Architecture con MVVM, seguiendo las mejores prácticas de desarrollo iOS para 2026.

![Swift](https://img.shields.io/badge/Swift-6.0-orange)
![iOS](https://img.shields.io/badge/iOS-18.2+-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Latest-green)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVVM-purple)

## Demo:


https://github.com/user-attachments/assets/43c8a07a-6b59-4648-9bb7-179cfb5f221f



## 📱 Características

### Funcionalidades Principales

- ✅ **Listado de Personajes**: Vista de lista con carga incremental de personajes
- ✅ **Paginación Automática**: Carga automática de más personajes al hacer scroll
- ✅ **Búsqueda en Tiempo Real**: Búsqueda con debounce de 400ms que consulta la API
- ✅ **Pull to Refresh**: Actualización manual de datos
- ✅ **Detalle del Personaje**: Vista detallada con animación fluida
- ✅ **Soporte Offline**: Persistencia local con SwiftData para el primer conjunto de datos
- ✅ **Gestión de Estados**: Loading, Error con Retry, Empty State, y Loading de paginación
- ✅ **Accesibilidad**: Etiquetas y hints de accesibilidad en todos los elementos

### Características Técnicas

- 🏗️ **Clean Architecture + MVVM**: Separación clara de responsabilidades
- 🔄 **UDF (Unidirectional Data Flow)**: Flujo de datos unidireccional
- 🎯 **State Hoisting**: Gestión de estado inmutable con `@Observable`
- ⚡ **Swift Concurrency**: async/await para operaciones asíncronas
- 💾 **SwiftData**: Persistencia local moderna
- 🧪 **Swift Testing**: Tests unitarios con el framework Testing de Apple
- ♿ **Accesibilidad**: Soporte completo de VoiceOver

## 🏛️ Arquitectura

### Clean Architecture con MVVM

La aplicación está estructurada en 3 capas principales:

```
RickAndMorty-App/
├── Presentation/          # Capa de Presentación (MVVM)
│   ├── CharacterList/
│   │   ├── CharacterListView.swift
│   │   └── CharacterListViewModel.swift
│   ├── CharacterDetail/
│   │   └── CharacterDetailView.swift
│   └── Components/        # Componentes reutilizables
│       ├── CharacterRowView.swift
│       ├── LoadingView.swift
│       ├── ErrorView.swift
│       ├── EmptyStateView.swift
│       └── CachedAsyncImage.swift
│
├── Domain/                # Capa de Dominio
│   ├── Models/
│   │   └── Character.swift
│   ├── Repositories/
│   │   └── CharacterRepositoryProtocol.swift
│   └── UseCases/
│       └── GetCharactersUseCase.swift
│
├── Data/                  # Capa de Datos
│   ├── Network/
│   │   ├── APIClient.swift
│   │   └── NetworkError.swift
│   ├── DTOs/
│   │   ├── CharacterDTO.swift
│   │   └── CharacterMapper.swift
│   ├── Persistence/
│   │   └── CharacterEntity.swift
│   └── Repositories/
│       └── CharacterRepository.swift
│
└── Core/                  # Infraestructura
    └── DI/
        └── DependencyContainer.swift
```

### Flujo de Datos (UDF)

```
View → ViewModel → UseCase → Repository → API/Cache
                                            ↓
View ← ViewModel ← UseCase ← Repository ← Data
```

### Capas en Detalle

#### 1. Presentation Layer (MVVM)

**ViewModels:**
- Utilizan `@Observable` (iOS 17+) para gestión de estado reactiva
- Implementan lógica de presentación y transformación de datos
- Manejan estados de UI (Loading, Loaded, Error, Empty)
- `@MainActor` para garantizar actualizaciones en el hilo principal

**Views:**
- SwiftUI puro sin lógica de negocio
- State Hoisting: el estado se gestiona en el ViewModel
- Componentes pequeños y reutilizables para optimizar rendimiento

#### 2. Domain Layer

**Models:**
- Entidades de dominio inmutables
- No dependen de frameworks externos
- Representan el core business logic

**Use Cases:**
- Encapsulan la lógica de negocio específica
- Orquestan el flujo entre el ViewModel y el Repository
- Un Use Case = Una acción específica

**Repository Protocols:**
- Definen contratos para acceso a datos
- Permiten inyección de dependencias y testing

#### 3. Data Layer

**Network:**
- `APIClient` con URLSession y async/await
- Gestión de errores HTTP centralizada
- No bloquea el hilo principal

**DTOs (Data Transfer Objects):**
- Objetos para serialización/deserialización de JSON
- Separados de los modelos de dominio

**Mappers:**
- Transforman DTOs → Domain Models
- Aíslan cambios en la API del resto de la app

**Persistence:**
- SwiftData para caché offline
- Estrategia: Cache-First con actualización en segundo plano

**Repository Implementation:**
- Implementa el protocolo del dominio
- Coordina entre API y caché
- Estrategia offline-first

## 🔧 Stack Tecnológico

### Lenguaje y Framework
- **Swift 6.0**: Última versión con mejoras de concurrencia
- **SwiftUI**: Framework declarativo de UI
- **Swift Concurrency**: async/await, Task, @MainActor

### Gestión de Estado
- **@Observable**: Macro para observación de cambios (iOS 17+)
- **@State**: Para estado local de vistas
- **@Environment**: Para inyección de dependencias

### Networking
- **URLSession**: Cliente HTTP nativo
- **Codable**: Serialización JSON

### Caché de Imágenes
- **Kingfisher 8.7+**: Librería moderna para caché de imágenes
  - Caché en memoria y disco automático
  - Downsampling para optimizar memoria
  - Carga asíncrona con placeholders
  - Componentes reutilizables (`CharacterThumbnail`, `CharacterHeroImage`, `CachedImage`)

### Persistencia
- **SwiftData**: Framework moderno de persistencia (iOS 17+)
- **@Model**: Macro para definir entidades persistentes

### Testing
- **Swift Testing**: Framework oficial de Apple (iOS 18+)
- **@Test**: Macro para definir tests
- **Mocks**: Protocolos para testing sin dependencias externas

### Herramientas
- **Xcode 16.2+**: IDE oficial
- **iOS Deployment Target**: iOS 18.2+

## 🚀 Instrucciones de Ejecución

### Requisitos Previos

- macOS Sequoia 15.3+
- Xcode 16.2 o superior
- iOS 18.2+ (simulador o dispositivo físico)
- Swift 6.0

### Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd RickAndMorty-App
```

2. **Abrir el proyecto en Xcode**
```bash
open RickAndMorty-App.xcodeproj
```

3. **Resolver dependencias de Swift Package Manager**
   - Xcode resolverá automáticamente las dependencias (Kingfisher 8.7+)
   - Espera unos segundos mientras se descargan los paquetes

4. **Seleccionar un simulador o dispositivo**
   - En Xcode, selecciona un simulador iOS 18.2+ o conecta un dispositivo físico

5. **Compilar y ejecutar**
   - Presiona `Cmd + R` o click en el botón "Run"
   - La app se compilará y ejecutará automáticamente

### Dependencias

**Swift Package Manager (SPM):**
- ✅ **Kingfisher 8.7+**: Para caché de imágenes optimizado
  - Se resuelve automáticamente al abrir el proyecto
  - No requiere configuración manual

**Otras características:**
- ✅ No requiere API Keys (la API de Rick and Morty es pública)
- ✅ No necesita Firebase, backend propio, ni servicios externos

## 🧪 Ejecución de Tests

### Tests Unitarios

```bash
# Desde línea de comandos
xcodebuild test -scheme RickAndMorty-App -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# O desde Xcode
Cmd + U
```

### Cobertura de Tests

La suite de tests incluye:

**Presentation Layer:**
- `CharacterListViewModelTests`: 10 tests
  - Estados iniciales
  - Carga de personajes
  - Búsqueda con debounce
  - Paginación
  - Gestión de errores

**Domain Layer:**
- `GetCharactersUseCaseTests`: 4 tests
  - Ejecución exitosa
  - Búsqueda
  - Paginación por URL
  - Manejo de errores

**Data Layer:**
- `CharacterMapperTests`: 5 tests
  - Mapeo DTO → Domain Model
  - Mapeo de arrays
  - Manejo de estados desconocidos
  - Mapeo de paginación

**Total: 19 tests unitarios**

## 📊 Decisiones Técnicas y Trade-offs

### 1. Clean Architecture + MVVM

**Decisión:** Implementar Clean Architecture con MVVM en lugar de arquitecturas más simples (MVC, MVP)

**Razones:**
- ✅ Separación clara de responsabilidades
- ✅ Código altamente testeable
- ✅ Facilita el escalado y mantenimiento
- ✅ Independencia de frameworks
- ✅ Cambios en una capa no afectan a otras

**Trade-offs:**
- ❌ Mayor complejidad inicial
- ❌ Más archivos y estructura
- ❌ Curva de aprendizaje para nuevos desarrolladores

**Alternativas consideradas:**
- MVC: Demasiado simple, tiende a ViewControllers masivos
- TCA (The Composable Architecture): Más complejo de lo necesario para este proyecto

### 2. @Observable en lugar de @StateObject/@ObservableObject

**Decisión:** Usar el macro `@Observable` de Swift 5.9+ en lugar de `ObservableObject`

**Razones:**
- ✅ Sintaxis más limpia y moderna
- ✅ Mejor rendimiento (observación granular)
- ✅ Menos boilerplate
- ✅ Integración nativa con SwiftUI

**Trade-offs:**
- ❌ Requiere iOS 17+ (deployment target más alto)
- ❌ Menos documentación/ejemplos disponibles

### 3. SwiftData en lugar de CoreData

**Decisión:** Usar SwiftData para persistencia local

**Razones:**
- ✅ API moderna y declarativa
- ✅ Mejor integración con Swift
- ✅ Menos boilerplate que CoreData
- ✅ Type-safe con macros

**Trade-offs:**
- ❌ Requiere iOS 17+
- ❌ Menos maduro que CoreData
- ❌ Funcionalidades avanzadas limitadas

**Alternativas consideradas:**
- CoreData: Más maduro pero más verboso
- Realm: Dependencia externa no deseada
- UserDefaults: Insuficiente para este caso de uso

### 4. URLSession en lugar de librerías third-party

**Decisión:** Usar URLSession nativo con async/await

**Razones:**
- ✅ Sin dependencias externas
- ✅ API moderna con async/await
- ✅ Suficiente para las necesidades del proyecto
- ✅ Mantenido por Apple

**Trade-offs:**
- ❌ Más código manual para features avanzados
- ❌ Sin interceptors out-of-the-box

**Alternativas consideradas:**
- Alamofire: Overkill para este proyecto
- Moya: Abstracción innecesaria

### 5. Kingfisher para caché de imágenes

**Decisión:** Usar Kingfisher en lugar de AsyncImage nativo

**Razones:**
- ✅ Caché inteligente en memoria y disco
- ✅ Downsampling automático para optimizar memoria
- ✅ Mejor rendimiento en listas largas
- ✅ Componentes reutilizables especializados
- ✅ Animaciones de carga fluidas
- ✅ Ampliamente testeado y mantenido

**Trade-offs:**
- ❌ Dependencia externa (SPM)
- ❌ Ligero incremento en tamaño de app

**Implementación:**
```swift
// Componentes creados:
- CharacterThumbnail: Optimizado para listas (80x80)
- CachedImage: Componente genérico reutilizable
```

**Alternativas consideradas:**
- AsyncImage nativo: Sin caché avanzado, peor rendimiento
- SDWebImage: Más antiguo, Kingfisher es más moderno
- Nuke: Similar pero menos adoptado

### Image Loading & Rate Limiting

Las imágenes de los personajes se cargan con Kingfisher, y durante el desarrollo se detectaron errores de descarga con el siguiente código de respuesta:
`HTTP 429 - Too Many Requests`

Este error lo devuelve el servidor (Rick & Morty API, protegida por Cloudflare) cuando recibe demasiadas peticiones en un periodo corto de tiempo. Ocurre especialmente al hacer scroll rápido en la lista de personajes, ya que se lanzan múltiples descargas simultáneas.

La propia respuesta del servidor incluía el header `retry-after: 4`, indicando que hay que esperar 4 segundos antes de reintentar.
Solución aplicada

Se tomaron dos medidas complementarias:
1. Retry automático con espera
Se configuró un `DelayRetryStrategy` en Kingfisher para que, ante un fallo de descarga, reintente automáticamente hasta 3 veces esperando 4 segundos entre cada intento, respetando así la indicación del servidor.
2. Límite de conexiones simultáneas

Se limitó a 2 el número máximo de descargas simultáneas hacia el mismo host `(httpMaximumConnectionsPerHost = 2)`, reduciendo la probabilidad de que el servidor vuelva a aplicar rate limiting.


### 6. Swift Testing en lugar de XCTest

**Decisión:** Usar el nuevo framework Swift Testing

**Razones:**
- ✅ Sintaxis moderna con macros
- ✅ Mejor ergonomía
- ✅ Integración nativa con Swift
- ✅ Futuro de testing en iOS

**Trade-offs:**
- ❌ Requiere iOS 18+
- ❌ Menos recursos disponibles

### 7. Estrategia de Caché: Cache-First

**Decisión:** Implementar una estrategia offline-first donde se devuelve el caché primero

**Razones:**
- ✅ Experiencia de usuario instantánea
- ✅ Funciona sin conexión
- ✅ Reduce latencia percibida

**Trade-offs:**
- ❌ Datos pueden estar desactualizados
- ❌ Complejidad adicional en sincronización

**Implementación:**
```swift
// 1. Retornar caché inmediatamente (si existe)
// 2. Hacer fetch de API en segundo plano
// 3. Actualizar caché y UI
```

### 7. Debounce de 400ms para búsqueda

**Decisión:** Implementar debounce de 400ms antes de consultar la API

**Razones:**
- ✅ Reduce llamadas innecesarias a la API
- ✅ Mejor experiencia de usuario
- ✅ Evita rate limiting

**Trade-offs:**
- ❌ Ligero delay en mostrar resultados
- ❌ Complejidad adicional en la gestión de Tasks

## 🔄 Estrategia de Paginación

### Implementación

La paginación se implementa de forma automática e inteligente:

1. **Detección de proximidad**: Cuando el usuario llega a 5 elementos del final
2. **Carga en segundo plano**: No bloquea la UI
3. **Indicador visual**: ProgressView en la parte inferior
4. **URL-based**: Usa la URL `next` proporcionada por la API

```swift
func loadMoreCharactersIfNeeded(currentCharacter: Character) {
    let thresholdIndex = displayedCharacters.count - 5
    if index >= thresholdIndex && paginationInfo?.hasNextPage == true {
        // Cargar más...
    }
}
```

### Gestión de Estados

- `loading`: Carga inicial
- `loaded`: Datos cargados, lista visible
- `loadingMore`: Cargando página adicional (indicador al final)
- `error`: Error con botón de retry
- `empty`: Sin resultados

### Componentes Reutilizables

- `CharacterRowView`: Fila de personaje en la lista
- `LoadingView`: Indicador de carga
- `ErrorView`: Vista de error con retry
- `EmptyStateView`: Estado vacío para búsquedas sin resultados

### Optimización de Rendimiento

- **LazyVStack/List**: Carga perezosa de vistas
- **Componentes pequeños**: SwiftUI solo redibuja lo necesario

## ♿ Accesibilidad

### Implementación

- `accessibilityLabel`: Etiquetas descriptivas para VoiceOver
- `accessibilityHint`: Hints de acción
- `accessibilityAddTraits`: Traits apropiados (.isButton, .isHeader)
- `accessibilityHidden`: Oculta elementos decorativos

### Ejemplos

```swift
.accessibilityLabel("Nombre: \(character.name)")
.accessibilityHint("Toca para ver más detalles")
.accessibilityAddTraits(.isButton)
```

## 🚧 Mejoras Futuras

Si tuviera más tiempo, implementaría:

### Funcionalidades
1. **Favoritos**: Marcar personajes como favoritos con persistencia local
2. **Filtros avanzados**: Por especie, género, status
3. **Compartir**: Compartir personajes en redes sociales
4. **Modo oscuro personalizado**: Temas personalizables
5. **Búsqueda offline**: Búsqueda en caché local
6. **Detalles de episodios**: Vista de episodios con personajes

### Técnicas
1. **UI Tests**: Tests de integración con XCUITest
2. **Snapshot Testing**: Tests de UI con capturas de pantalla
3. **Analytics**: Tracking de eventos con Firebase Analytics
4. **Crash Reporting**: Integración con Crashlytics
5. **Performance Monitoring**: Métricas de rendimiento
6. **CI/CD**: GitHub Actions para builds y tests automáticos
7. **Modularización**: Dividir en frameworks/modules (Networking, UI, Domain)
8. **Prefetching**: Precarga de imágenes para mejorar scroll
9. **Localización**: Soporte multiidioma
10. **Widget**: Widget de iOS con personajes favoritos

### Optimizaciones
1. **Image Caching avanzado**: Librería dedicada como Kingfisher
2. **Pagination precargada**: Cargar siguiente página antes de llegar al final
3. **Compresión de datos**: Reducir tamaño de caché
4. **Background Refresh**: Actualizar caché en segundo plano

## 📝 Notas Adicionales

### API Utilizada

**Rick and Morty API**
- Base URL: `https://rickandmortyapi.com/api`
- Endpoint: `/character`
- Documentación: https://rickandmortyapi.com/documentation

### Deployment Target

**iOS 26.2+** requerido por:
- `@Observable` macro (iOS 17+)
- SwiftData (iOS 17+)
- Swift Testing (iOS 18+)
- ContentUnavailableView mejoras (iOS 17+)

Si se necesitara soportar iOS 16 o inferior:
- Reemplazar `@Observable` con `ObservableObject`
- Reemplazar SwiftData con CoreData
- Usar XCTest en lugar de Swift Testing

### Rendimiento

- **Tiempo de carga inicial**: < 2s (con conexión)
- **Scroll fluido**: 60 FPS en dispositivos modernos
- **Memoria**: ~50-80 MB en uso normal
- **Tamaño de app**: ~15 MB (sin optimizaciones de distribución)

## 👨‍💻 Autor

Desarrollado por Dani Durà siguiendo las mejores prácticas de iOS para 2026, con especial atención a:
- Clean Code
- SOLID Principles
- Design Patterns
- Modern Swift Features
- Apple Human Interface Guidelines

## 📄 Licencia

Este proyecto es de propósito educativo y utiliza la API pública de Rick and Morty.

---

** 🚀**
