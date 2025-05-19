import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/database_service.dart';
import 'models/empresa.dart';
import 'models/cliente.dart';
import 'models/cotizacion.dart';
import 'models/item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive para almacenamiento local
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  
  // Registrar adaptadores para nuestros modelos
  Hive.registerAdapter(EmpresaAdapter());
  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(CotizacionAdapter());
  Hive.registerAdapter(ItemAdapter());
  
  // Abrir boxes (colecciones)
  await Hive.openBox<Empresa>('empresa');
  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Cotizacion>('cotizaciones');
  await Hive.openBox<Item>('items');
  
  // Inicializar servicio de base de datos
  final databaseService = DatabaseService();
  
  // Verificar si hay datos de empresa, si no, crear configuración por defecto
  await databaseService.initializeEmpresaIfNeeded();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => databaseService),
      ],
      child: const CotizacionesApp(),
    ),
  );
}

class CotizacionesApp extends StatelessWidget {
  const CotizacionesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotizaciones App',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E5BFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E5BFF),
          secondary: const Color(0xFFFF6B2E),
          background: const Color(0xFFF5F7FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2138),
          ),
          displayMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2138),
          ),
          displaySmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A2138),
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            color: Color(0xFF1A2138),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF8798AD),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E5BFF),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2E5BFF),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD8DCE2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD8DCE2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2E5BFF)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD63649)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
