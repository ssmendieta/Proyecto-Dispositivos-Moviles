# Salud Piel App — Plan de Desarrollo

## Stack Tecnológico

| Capa | Tecnología |
|---|---|
| Frontend | Flutter + Dart 3.11+ |
| State Management | GetX (rutas, controladores, DI) |
| Base de Datos | SQLite (sqflite) |
| ML | TFLite (on-device) |
| Login | Local con SQLite + password hashing (crypto) |
| Plataformas | Android, iOS |

## Arquitectura

```
lib/
├── main.dart
├── datos/                          # Capa de datos
│   ├── datos/                      # SQLite (app_database.dart)
│   ├── modelos/                    # DTOs
│   └── repositorios/               # Implementaciones SQLite
├── dominio/                        # Capa de dominio
│   ├── entidades/                  # Usuario, Diagnostico, Producto, Rutina
│   ├── enumeraciones/              # CondicionPiel, TipoPiel, MomentoRutina
│   └── repositorios/               # Interfaces
├── nucleo/                         # Servicios transversales
│   ├── servicios/                  # ML, Auth, dependencias (DI)
│   └── utilidades/                 # imagen_util
├── presentacion/                   # Capa de UI
│   ├── rutas/                      # app_routes.dart
│   ├── tema/                       # AppTheme (light/dark)
│   ├── constantes/                 # Strings, assets
│   ├── compartidos/                # Widgets + modales globales
│   │   ├── widget/
│   │   └── modales/
│   ├── carga/                      # SplashScreen
│   ├── bienvenida/                 # WelcomeScreen
│   ├── autenticacion/              # Login + Register
│   ├── inicio/                     # Home con BottomNav (5 tabs)
│   ├── escaneo/                    # Cámara
│   ├── diagnostico/                # Resultado del análisis
│   ├── productos/                  # Catálogo + detalle
│   ├── rutinas/                    # Progreso + gestión
│   ├── perfil/                     # Perfil del usuario
│   └── historial/                  # Lista + detalle
└── ml/                             # Modelo TFLite (assets)
```

## Base de Datos (SQLite)

```sql
CREATE TABLE usuarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  fecha_creacion TEXT NOT NULL
);

CREATE TABLE diagnosticos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  imagen_path TEXT NOT NULL,
  condicion TEXT NOT NULL,
  confianza REAL NOT NULL,
  fecha TEXT NOT NULL,
  descripcion TEXT
);

CREATE TABLE diagnosticos_productos (
  diagnostico_id INTEGER NOT NULL,
  producto_id INTEGER NOT NULL,
  FOREIGN KEY (diagnostico_id) REFERENCES diagnosticos(id),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE productos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  descripcion TEXT,
  ingredientes TEXT,
  tipo_piel TEXT,
  condicion TEXT,
  imagen_path TEXT,
  como_usar TEXT
);

CREATE TABLE rutinas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  momento TEXT NOT NULL,
  fecha_creacion TEXT NOT NULL
);

CREATE TABLE rutinas_productos (
  rutina_id INTEGER NOT NULL,
  producto_id INTEGER NOT NULL,
  orden INTEGER NOT NULL DEFAULT 0,
  completado INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (rutina_id) REFERENCES rutinas(id),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);
```

## División del Trabajo (3 Devs)

### Dev A — ML Engineer

| Tarea | Archivos a entregar |
|---|---|
| Definir taxonomía de condiciones de piel (5-8 clases) | — |
| Curar dataset etiquetado | `dataset/` (imágenes + CSV) |
| Entrenar modelo CNN | `notebooks/entrenamiento.ipynb` |
| Exportar a TFLite cuantizado | `modelo/modelo.tflite` |
| Documentar API del modelo | `modelo/etiquetas.txt` + `docs/api_modelo.md` |

**Criterios:** Accuracy >80%, tamaño <20MB, inferencia <2s en mobile.

---

### Dev B — Backend / Integración

| Ruta | Archivo | Propósito |
|---|---|---|
| `pubspec.yaml` | — | Dependencias: `get`, `sqflite`, `path`, `crypto`, `camera`, `image_picker`, `tflite_flutter`, `intl` |
| `lib/main.dart` | — | `GetMaterialApp`, rutas, tema, DI init |
| **Dominio — Entidades** | | |
| | `lib/dominio/entidades/usuario.dart` | Usuario (id, username, passwordHash, fechaCreacion) |
| | `lib/dominio/entidades/diagnostico.dart` | Diagnostico (id, imagenPath, condicion, confianza, fecha, descripcion, productosRecomendados) |
| | `lib/dominio/entidades/producto.dart` | Producto (id, nombre, descripcion, ingredientes, tipoPiel, condicion, imagenPath, comoUsar) |
| | `lib/dominio/entidades/rutina.dart` | Rutina + RutinaProducto |
| **Dominio — Enumeraciones** | | |
| | `lib/dominio/enumeraciones/condicion_piel.dart` | enum CondicionPiel |
| | `lib/dominio/enumeraciones/tipo_piel.dart` | enum TipoPiel |
| | `lib/dominio/enumeraciones/momento_rutina.dart` | enum MomentoRutina |
| **Dominio — Interfaces** | | |
| | `lib/dominio/repositorios/i_auth_repositorio.dart` | registrar, login, usuarioActual |
| | `lib/dominio/repositorios/i_diagnostico_repositorio.dart` | guardar, obtenerPorId, listarTodos, eliminar |
| | `lib/dominio/repositorios/i_producto_repositorio.dart` | listar, obtenerPorId, buscar |
| | `lib/dominio/repositorios/i_rutina_repositorio.dart` | crear, obtener, listar, actualizar, eliminar, agregarProducto, quitarProducto, marcarCompletado |
| **Datos** | | |
| | `lib/datos/datos/app_database.dart` | Singleton SQLite con tablas y migraciones |
| | `lib/datos/repositorios/auth_repositorio.dart` | Implementación SQLite + crypto |
| | `lib/datos/repositorios/diagnostico_repositorio.dart` | CRUD diagnosticos |
| | `lib/datos/repositorios/producto_repositorio.dart` | CRUD productos + seed data |
| | `lib/datos/repositorios/rutina_repositorio.dart` | CRUD rutinas |
| **Núcleo** | | |
| | `lib/nucleo/servicios/auth_servicio.dart` | Lógica auth + sesión con Rx |
| | `lib/nucleo/servicios/ml_servicio.dart` | Cargar TFLite, preprocesar, inferir |
| | `lib/nucleo/servicios/dependencias.dart` | Get.put() de todos los servicios |
| | `lib/nucleo/utilidades/imagen_util.dart` | Redimensionar, comprimir, rotar imagen |

---

### Dev C — UI/UX

| Módulo | Archivos |
|---|---|
| **carga/** | `carga_controller.dart` + `splash_screen.dart` |
| **bienvenida/** | `bienvenida_controller.dart` + `welcome_screen.dart` |
| **autenticacion/** | `autenticacion_controller.dart` + `login_page.dart` + `register_page.dart` |
| **inicio/** | `inicio_controller.dart` + `home_page.dart` (shell con BottomNav 5 tabs: Home, Rutinas, Scan, Productos, Perfil) |
| **escaneo/** | `escaneo_controller.dart` + `escaneo_page.dart` + `widget/camera_preview.dart` |
| **diagnostico/** | `diagnostico_controller.dart` + `diagnostico_page.dart` + `widget/resultado_card.dart` + `widget/producto_recomendado_card.dart` |
| **productos/** | `productos_controller.dart` + `productos_page.dart` + `producto_detalle_page.dart` + `widget/producto_card.dart` |
| **rutinas/** | `rutinas_controller.dart` + `rutinas_page.dart` + `gestionar_rutina_page.dart` + `widget/rutina_card.dart` + `widget/producto_en_rutina_tile.dart` |
| **perfil/** | `perfil_controller.dart` + `perfil_page.dart` |
| **historial/** | `historial_controller.dart` + `historial_page.dart` + `widget/diagnostico_historial_card.dart` + `escaneo_detalle_page.dart` |
| **compartidos/widget/** | `loading_screen.dart`, `empty_state.dart`, `confianza_indicator.dart` |
| **compartidos/modales/** | `agregar_a_rutina_sheet.dart` |
| **rutas/** | `app_routes.dart` (todas las rutas GetX) |
| **tema/** | `app_tema.dart` (light/dark) |
| **constantes/** | Strings, assets, iconos |

## Navegación (GetX Routes)

```
/                   → SplashScreen
/bienvenida         → WelcomeScreen
/login              → LoginPage
/registro           → RegisterPage
/inicio             → HomePage (BottomNav)
/escaneo            → EscaneoPage
/diagnostico        → DiagnosticoPage
/productos          → ProductosPage
/productos/detalle  → ProductoDetallePage
/rutinas            → RutinasPage
/rutinas/gestionar  → GestionarRutinaPage
/perfil             → PerfilPage
/historial          → HistorialPage
/historial/detalle  → EscaneoDetallePage
```

## Flujo de la App

```
App Inicia → Splash
  └── ¿Usuario registrado?
        ├── No  → Bienvenida → Register
        └── Sí  → Login → Home (BottomNav)

Home (BottomNav 5 tabs)
├── Tab 1: Inicio     → resumen rutina, botón escanear, botón historial
├── Tab 2: Rutinas    → progreso diario → gestionar rutina → productos
├── Tab 3: Escaneo    → cámara → diagnóstico → productos (filtrados)
├── Tab 4: Productos  → catálogo → detalle → agregar a rutina
└── Tab 5: Perfil     → datos → historial → detalle escaneo
```

## Dependencias (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.0
  sqflite: ^2.4.0
  path: ^1.9.0
  crypto: ^3.0.0
  camera: ^0.11.0
  image_picker: ^1.1.0
  tflite_flutter: ^0.11.0
  intl: ^0.19.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```
