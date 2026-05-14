import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/local_data_source.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/data_providers.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Punto de entrada principal de la aplicación.
void main() async {
  // 1. Asegura que los bindings estén listos.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Preservar el splash mientras cargamos datos pesados (Hive).
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 3. Inicialización de la fuente de datos local (Hive).
  final localDataSource = LocalDataSource();
  try {
    await localDataSource.init();
  } catch (e) {
    debugPrint('Error inicializando Hive: $e');
  }

  // 4. Lanzar la aplicación.
  runApp(
    ProviderScope(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
      ],
      child: const MyApp(),
    ),
  );

  // 5. Quitar el splash una vez que la app ya está montada y cargada.
  // Un retraso de 1 segundo es suficiente para una transición suave.
  _removeSplash();
}

void _removeSplash() async {
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

/// Widget raíz de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTG Pactual - Manejo de Fondos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003D71),
          primary: const Color(0xFF003D71),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003D71),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}
