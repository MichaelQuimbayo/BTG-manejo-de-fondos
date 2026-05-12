import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/local_data_source.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/data_providers.dart';

/// Punto de entrada principal de la aplicación.
void main() async {
  // Asegura que los bindings de Flutter estén listos antes de inicializar servicios externos.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización de la fuente de datos local (Hive).
  final localDataSource = LocalDataSource();
  await localDataSource.init();

  runApp(
    // ProviderScope es necesario para que Riverpod funcione en toda la aplicación.
    ProviderScope(
      overrides: [
        // Sobrescribimos el provider de la fuente de datos con la instancia ya inicializada.
        localDataSourceProvider.overrideWithValue(localDataSource),
      ],
      child: const MyApp(),
    ),
  );
}

/// Widget raíz de la aplicación.
/// Configura el tema global y la página inicial.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTG Pactual - Manejo de Fondos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Configuración de colores corporativos (Azul BTG).
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003D71), 
          primary: const Color(0xFF003D71),
        ),
        useMaterial3: true,
        // Estilo global para las barras de navegación superiores.
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003D71),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // Punto de partida visual de la app.
      home: const HomePage(),
    );
  }
}
