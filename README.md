# BTG Pactual - Manejo de Fondos (Prueba Técnica)

Este proyecto es una aplicación web y móvil desarrollada con Flutter que permite a los usuarios gestionar sus suscripciones a fondos de inversión (FPV/FIC). Ha sido diseñado siguiendo principios de **Clean Architecture** y las mejores prácticas de desarrollo en Flutter.

## 🚀 Características Principales

- **Visualización de Fondos:** Catálogo dinámico con los fondos requeridos (FPV y FIC).
- **Manejo de Saldo:** Saldo inicial de $500.000 COP con actualizaciones en tiempo real tras cada operación.
- **Suscripción con Validaciones:**
  - Validación de saldo suficiente según el monto mínimo de cada fondo.
  - **Formulario de Suscripción:** Validación de formato para Email y SMS (10 dígitos).
- **Cancelación de Fondos:** Permite desvincularse y reintegrar el monto al saldo disponible.
- **Historial de Transacciones:** Registro detallado de aperturas y cancelaciones con el método de notificación utilizado.
- **Diseño Responsivo:**
  - Vista de lista optimizada para móviles.
  - Cuadrícula (Grid) de hasta 4 columnas para versiones Web/Escritorio.
- **Persistencia Local:** Uso de Hive para mantener los datos del usuario, saldo e historial incluso tras cerrar la aplicación.

## 🛠️ Stack Tecnológico

- **Framework:** Flutter 3.x
- **Manejo de Estado:** [Riverpod](https://riverpod.dev/) (con generación de código).
- **Arquitectura:** Clean Architecture (Capa de Dominio, Datos y Presentación).
- **Base de Datos Local:** [Hive](https://pub.dev/packages/hive) (NoSQL ligera y rápida).
- **Formateo:** `intl` para monedas y fechas.

## 📂 Estructura del Proyecto (Clean Architecture)

```
lib/
├── data/              # Implementaciones de repositorios, modelos y fuentes de datos.
├── domain/            # Entidades de negocio, interfaces de repositorios y casos de uso.
├── presentation/      # Lógica de UI: Widgets, Páginas y Providers (Riverpod).
└── main.dart          # Punto de entrada e inicialización de servicios.
```

## ⚙️ Instrucciones de Ejecución

### Requisitos Previos
- Tener instalado el SDK de Flutter ([Guía de instalación](https://docs.flutter.dev/get-started/install)).
- Un navegador (Chrome/Edge) o un emulador de Android/iOS.

### Pasos para ejecutar:

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/tu-usuario/BTG-manejo-de-fondos.git
   cd BTG-manejo-de-fondos
   ```

2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

3. **Generar código necesario (Riverpod y Hive):**
   Este proyecto utiliza generación de código para los modelos y providers. Ejecute el siguiente comando:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecutar la aplicación:**
   - **Para Web:**
     ```bash
     flutter run -d chrome
     ```
   - **Para Móvil:**
     ```bash
     flutter run
     ```

## 🧪 Pruebas Unitarias

Se incluyeron pruebas para validar las reglas de negocio, específicamente la restricción de suscripción por saldo insuficiente. Para ejecutarlas:
```bash
flutter test
```

---
**Desarrollado como parte de la prueba técnica para Ingeniero Front-End.**
