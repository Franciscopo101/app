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
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  // Registrar adaptadores para los modelos
  Hive.registerAdapter(EmpresaAdapter());
  Hive.registerAdapter(ClienteAdapter());
  Hive.registerAdapter(CotizacionAdapter());
  Hive.registerAdapter(ItemAdapter());
  
  // Abrir las cajas (boxes) de Hive
  await Hive.openBox<Empresa>('empresa');
  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Cotizacion>('cotizaciones');
  await Hive.openBox<Item>('items');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DatabaseService(),
      child: MaterialApp(
        title: 'Cotizaciones App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
