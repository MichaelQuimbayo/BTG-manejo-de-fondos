# BTG Pactual - Manejo de Fondos (Prueba Técnica)

Este proyecto es una aplicación web y móvil desarrollada con Flutter que permite a los usuarios gestionar sus suscripciones a fondos de inversión (FPV/FIC). Ha sido diseñado siguiendo principios de **Clean Architecture** y las mejores prácticas de desarrollo en Flutter.

##  Características Principales

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

- **Framework:** Flutter 3..35.4
- **Manejo de Estado:** [Riverpod](https://riverpod.dev/) (con generación de código).
- **Arquitectura:** Clean Architecture (Capa de Dominio, Datos y Presentación).
- **Base de Datos Local:** [Hive](https://pub.dev/packages/hive) (NoSQL ligera y rápida).
- **Test:** [Mockito]
- **Formateo:** `intl` para monedas y fechas.

##  Estructura del Proyecto (Clean Architecture)

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
- Implementar con FVM: fvm install 3.35.4
- Tomar version instalada: fvm use 3.35.4

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
   
   - **Para Generar APK:**
     ```bash
      P:\BTG-manejo-de-fondos> fvm flutter build apk --release
     ```

##  Pruebas Unitarias

Se incluyeron pruebas para validar las reglas de negocio, específicamente la restricción de suscripción por saldo insuficiente. Para ejecutarlas:
```bash
flutter test
```

## Implementacion de Git Action CI/CD
Al realizar push a main o develope automatiza los siguiente:
- Correr tests
- Compilar Flutter
- Generar APK

  
Nota: Falto realizar configuracion de pipeline para automatizar despliegue. Mediante un pipeline de CI/CD con GitHub Actions, donde cada cambio en el repositorio activa automáticamente procesos de validación, como análisis de código, pruebas unitarias y generación de builds. Posteriormente, el flujo compila la aplicación para cada plataforma (Android, iOS y Web) y distribuye los artefactos: el APK o AAB a Google Play Store, el build de iOS a App Store Connect mediante Xcode y TestFlight, y la versión web a Firebase Hosting o un servidor estático. De esta forma, se garantiza un proceso continuo, controlado y sin intervención manual, reduciendo errores y acelerando la entrega de nuevas versiones a producción con control de versiones.

<img width="1026" height="435" alt="image" src="https://github.com/user-attachments/assets/a826cb4d-7927-4e6a-80b4-d361f24843e7" />

## App en acción
-Web: Despliegue con firebase hosting
url: https://btg-fondos.web.app/
<img width="1905" height="956" alt="image" src="https://github.com/user-attachments/assets/0eeb2391-8292-4580-abc8-210300e4ad47" />

-Mobile: aplicativo APK(Android)
url:https://drive.google.com/file/d/197K9Vtu6nSSMbXWt8QbG99RQgnKKxg2R/view?usp=sharing

Imagenes:


<img width="743" height="1280" alt="WhatsApp Image 2026-05-12 at 3 14 43 PM" src="https://github.com/user-attachments/assets/20281133-a30b-47d9-905e-777a2fc845c0" />
<img width="738" height="1280" alt="WhatsApp Image 2026-05-12 at 3 15 22 PM" src="https://github.com/user-attachments/assets/3b655101-1b3d-4946-a8f7-80d638abe34d" />
<img width="738" height="1280" alt="WhatsApp Image 2026-05-12 at 3 15 46 PM" src="https://github.com/user-attachments/assets/da753d18-e488-4d88-9d02-064f732c4d6e" />
<img width="746" height="1280" alt="WhatsApp Image 2026-05-12 at 3 13 56 PM" src="https://github.com/user-attachments/assets/ac36afd3-7e91-43f1-8283-daa6eba267ee" />
<img width="746" height="1280" alt="WhatsApp Image 2026-05-12 at 3 14 17 PM" src="https://github.com/user-attachments/assets/dfad12c5-df57-4633-80b1-98d4e1e0204a" />

Gif:


<img width="426" height="240" alt="BTG" src="https://github.com/user-attachments/assets/f59eaeda-958c-4c5b-962b-78a8f29d3ae8" />


## NOTA IMPORTANTE:
Esta prueba tecnica fue construida siguiendo un proceso de planificación previa. Se utilizó IA como asistente de productividad para la generación de estructuras base, pero la lógica de negocio, la arquitectura de capas y las decisiones críticas de estado fueron planificadas y supervisadas paso a paso por el desarrollador. Esto me permite llevar un historial de commits limpio y un desarrollo orientado a la calidad y escalabilidad.
