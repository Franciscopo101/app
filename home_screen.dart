import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/cotizacion.dart';
import 'cotizacion_form_screen.dart';
import 'cotizacion_detail_screen.dart';
import '../widgets/cotizacion_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotizaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navegar a la pantalla de configuración
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ConfiguracionScreen()));
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de creación de cotización
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CotizacionFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBar.item(
            icon: Icon(Icons.description),
            label: 'Cotizaciones',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
          BottomNavigationBar.item(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // Mostrar diferentes pantallas según el índice seleccionado
    switch (_selectedIndex) {
      case 0:
        return _buildCotizacionesTab();
      case 1:
        return _buildClientesTab();
      case 2:
        return _buildConfiguracionTab();
      default:
        return _buildCotizacionesTab();
    }
  }

  Widget _buildCotizacionesTab() {
    return Consumer<DatabaseService>(
      builder: (context, databaseService, child) {
        final cotizaciones = databaseService.getCotizaciones();
        
        if (cotizaciones.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.description_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No hay cotizaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Toca el botón + para crear una nueva cotización',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CotizacionFormScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Cotización'),
                ),
              ],
            ),
          );
        }
        
        return Column(
          children: [
            // Tarjeta de resumen
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        'Total',
                        cotizaciones.length.toString(),
                        Icons.description,
                        Colors.blue,
                      ),
                      _buildSummaryItem(
                        'Pendientes',
                        cotizaciones.where((c) => c.estado == 'Creada' || c.estado == 'Enviada').length.toString(),
                        Icons.pending_actions,
                        Colors.orange,
                      ),
                      _buildSummaryItem(
                        'Aceptadas',
                        cotizaciones.where((c) => c.estado == 'Aceptada' || c.estado == 'En Ejecucion').length.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Lista de cotizaciones
            Expanded(
              child: ListView.builder(
                itemCount: cotizaciones.length,
                itemBuilder: (context, index) {
                  final cotizacion = cotizaciones[index];
                  final cliente = databaseService.getClienteById(cotizacion.idCliente);
                  
                  return CotizacionListItem(
                    cotizacion: cotizacion,
                    clienteNombre: cliente?.nombreRazonSocial ?? 'Cliente no encontrado',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CotizacionDetailScreen(cotizacionId: cotizacion.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildClientesTab() {
    // Implementar la pestaña de clientes
    return const Center(
      child: Text('Pantalla de Clientes - Por implementar'),
    );
  }

  Widget _buildConfiguracionTab() {
    // Implementar la pestaña de configuración
    return const Center(
      child: Text('Pantalla de Configuración - Por implementar'),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
