import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_storage.dart';
import '../../inbound/presentation/receive_inbound_screen.dart';
import '../../inbound/presentation/qc_submit_screen.dart';
import '../../outbound/presentation/create_order_screen.dart';
import '../../outbound/presentation/picking_entry_screen.dart';
import '../../outbound/presentation/pack_container_screen.dart';
import '../../outbound/presentation/dispatch_screen.dart';
import '../../iot/presentation/iot_alerts_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  bool get _isPda => Platform.isAndroid || Platform.isIOS;
  bool get _isDesktop => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStorage = ref.watch(authStorageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PWMS Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authStorage.deleteToken();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: authStorage.getRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final role = snapshot.data ?? '';
          
          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              // PDA-only modules
              if (_isPda && (role == 'ADMIN' || role == 'INBOUND'))
                _buildCard(context, 'Receive Inbound', Icons.inbox, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReceiveInboundScreen()))),
              if (_isPda && (role == 'ADMIN' || role == 'PICKER'))
                _buildCard(context, 'Picking', Icons.qr_code_scanner, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PickingEntryScreen()))),
              if (_isPda && (role == 'ADMIN' || role == 'DISPATCHER'))
                _buildCard(context, 'Dispatch', Icons.local_shipping, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DispatchScreen()))),
              
              // Desktop-only modules
              if (_isDesktop && (role == 'ADMIN' || role == 'QA'))
                _buildCard(context, 'Submit QC', Icons.checklist, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QCSubmitScreen()))),
              if (_isDesktop && (role == 'ADMIN' || role == 'SALES'))
                _buildCard(context, 'Create Order', Icons.shopping_cart, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateOrderScreen()))),
              if (_isDesktop && (role == 'ADMIN' || role == 'PACKER'))
                _buildCard(context, 'Pack Container', Icons.inventory, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PackContainerScreen()))),
              if (_isDesktop && (role == 'ADMIN' || role == 'MANAGER'))
                _buildCard(context, 'IoT Alerts', Icons.thermostat, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IotAlertsScreen()))),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(
              title, 
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
