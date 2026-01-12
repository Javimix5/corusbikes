# Memoria de pruebas - BiciCoruña (CorusBikes)

## 1. Resumen y objetivo

Documento que recoge la planificación, implementación y resultados de una batería de pruebas (unitarias, integración y sistema) para la app BiciCoruña desarrollada en la TO7.1.

## 2. Batería de pruebas unitarias propuesta

- Modelos (`lib/models`)
  - `Station.updateStatus`: parseo de campos dinámicos y vehicle_types.
  - `Station.isVirtual` / `isActive`: distintos combinaciones de `is_installed` y `is_renting`.
  - Validación de valores por defecto para counts.
- Servicios / Repositorios (`lib/services`)
  - `StationsService.fetchStations`: manejo de errores HTTP.
  - Cache: `fetchStations`/`clearCache`/`forceRefresh`.
  - Separación info/status y combinación correcta.
- ViewModels / Estado (`lib/viewmodels`)
  - `StationsViewModel.fetchStations`: estados `isLoading`, `errorMessage`.
  - Filtros `setSearchQuery`, `toggleFavoritesFilter`, `favoritesCount`.
  - `toggleFavorite` y persistencia en memoria.
- Utilidades / Widgets
  - Indicadores visuales (por ejemplo `BikeQuantityIndicator`) responden a thresholds.

## 3. Implementación: 3 grupos desarrollados

Se implementaron tests en `test/` para:

- Grupo 1: Modelos
  - Archivo: `test/models/station_test.dart` (2 tests)
  - Por qué: El model contiene la lógica de transformación de JSON dinámico; si falla, la UI mostrará datos incorrectos.
  - Tests implementados:
    - `updateStatus parses vehicle types and sets counts`: verifica que los conteos de `FIT`/`EFIT` se asignan.
    - `isVirtual when not installed or not renting`: verifica la propiedad computada `isVirtual`.

- Grupo 2: ViewModel
  - Archivo: `test/viewmodels/stations_vm_test.dart` (2 tests)
  - Por qué: El ViewModel coordina filtros y estado; errores aquí afectan la experiencia de usuario.
  - Tests implementados:
    - `searchQuery filters stations`: comprueba búsqueda case-insensitive.
    - `toggleFavorite updates station and favoritesCount`: comprueba conteo y toggle.

- Grupo 3: Servicio (capa de integración con API)
  - Archivo: `test/services/stations_service_test.dart` (2 tests)
  - Por qué: El servicio combina info y status y aplica cache; fallos producen datos desincronizados o overfetch.
  - Tests implementados:
    - `fetchStations uses cache when not expired`: comprueba que la segunda llamada no realiza nuevas peticiones.
    - `forceRefresh bypasses cache and clearCache clears`: comprueba comportamiento de `clearCache` y recarga.

Para cada test hay una breve explicación en el código y aserciones que muestran la condición de éxito. Si fallase un test de modelo, la UI podría mostrar números incorrectos; si fallase el ViewModel, filtros o favoritos no funcionarían; si fallase el servicio, la app podría mostrar datos desactualizados o lanzar excepciones.

## 4. Integración

- Ascendente (bottom-up): `test/integration/bottom_up_test.dart`
  - Enfoque: Empezar validando `StationsService` junto con `Station` (model). Se usan `MockClient` para simular respuestas HTTP reales y se comprueba la combinación de info+status.
  - Justificación: Garantiza que a partir de las respuestas externas se obtienen objetos correctos usados por capas superiores.

- Descendente (top-down): `test/integration/top_down_test.dart`
  - Enfoque: Empezar por el `StationsViewModel`, inyectando un fake service que devuelve datos controlados.
  - Simulación: Fake que devuelve una lista de `Station` preconstruida.
  - Justificación: Verifica que la lógica del ViewModel responde adecuadamente a las entradas previstas y coordina estados.

## 5. Prueba de sistema (integration_test)

- Archivo: `integration_test/app_test.dart`
- Flujo elegido: Renderizar `HomeScreen` con un `StationsViewModel` prellenado, comprobar que la lista se muestra y que al pulsar una estación se inicia navegación.
- Por qué representativo: Simula una sesión típica del usuario (ver estaciones y abrir detalle) y valida la integración completa de UI, navegación y ViewModel.
- Validaciones realizadas:
  - Existencia del texto con el nombre de la estación.
  - Tap sobre el elemento y comprobación de navegación (sin errores y con renderizado posterior).
- Valor: Complementa los unit/integration tests al cubrir interacción real con widgets y navegación.

## 6. Resultados de ejecución

Ejecuta localmente:

```bash
flutter test
flutter test integration_test/app_test.dart  # o flutter test --platform=chrome según configuración
```

Adjunto los tests en `test/` e `integration_test/`. Para generar el PDF final convierte `memoria_pruebas.md` a PDF (por ejemplo con pandoc o VSCode -> Export as PDF).

---
Ficheros añadidos con los tests y este documento: revisar `test/`, `integration_test/app_test.dart` y `memoria_pruebas.md`.
