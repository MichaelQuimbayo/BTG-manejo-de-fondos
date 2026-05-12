import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/local_data_source.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/data_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localDataSource = LocalDataSource();
  await localDataSource.init();

  runApp(
    ProviderScope(
      overrides: [
        localDataSourceProvider.overrideWithValue(localDataSource),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTG Pactual - Manejo de Fondos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003D71), // Azul BTG
          primary: const Color(0xFF003D71),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003D71),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
