import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_storage.dart';
import '../../inbound/presentation/receive_inbound_screen.dart';
import '../../inbound/presentation/move_to_quarantine_screen.dart';
import '../../inbound/presentation/qc_submit_screen.dart';
import '../../outbound/presentation/create_order_screen.dart';
import '../../outbound/presentation/picking_entry_screen.dart';
import '../../outbound/presentation/pack_container_screen.dart';
import '../../outbound/presentation/dispatch_screen.dart';
import '../../iot/presentation/iot_alerts_screen.dart';
import '../../inbound/presentation/admin_drafts_screen.dart';
import '../../inbound/presentation/create_po_screen.dart';
import '../../runner/presentation/runner_screen.dart';
import './staff_management_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // During development (kDebugMode), we treat the platform as both PDA and Desktop to allow testing all modules.
  bool get _isPda => kDebugMode || Platform.isAndroid || Platform.isIOS;
  bool get _isDesktop => kDebugMode || Platform.isWindows || Platform.isLinux || Platform.isMacOS;

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
          
          final role = snapshot.data?.toUpperCase() ?? '';
          
          final cards = [
            // Inbound
            if ((_isPda || role == 'ADMIN') && (role == 'ADMIN' || role == 'INBOUND')) ...[
              _buildCard(context, 'Receive Inbound', Icons.inbox, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReceiveInboundScreen()))),
              _buildCard(context, 'Move to Quarantine', Icons.move_to_inbox, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoveToQuarantineScreen()))),
              if (role == 'ADMIN' || role == 'MANAGER')
                _buildCard(context, 'Create PO', Icons.note_add, 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePOScreen()))),
            ],
            
            // Picking
            if ((_isPda || role == 'ADMIN') && (role == 'ADMIN' || role == 'PICKER'))
              _buildCard(context, 'Picking', Icons.qr_code_scanner, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PickingEntryScreen()))),
            
            // Dispatch
            if ((_isPda || role == 'ADMIN') && (role == 'ADMIN' || role == 'DISPATCHER'))
              _buildCard(context, 'Dispatch', Icons.local_shipping, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DispatchScreen()))),
            
            // Runner
            if ((_isPda || role == 'ADMIN') && (role == 'ADMIN' || role == 'RUNNER'))
              _buildCard(context, 'Runner Tasks', Icons.directions_run, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RunnerScreen()))),
            
            // QC
            if ((_isDesktop || role == 'ADMIN') && (role == 'ADMIN' || role == 'QA'))
              _buildCard(context, 'Submit QC', Icons.checklist, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QCSubmitScreen()))),
            
            // Orders
            if ((_isDesktop || role == 'ADMIN') && (role == 'ADMIN' || role == 'SALES'))
              _buildCard(context, 'Create Order', Icons.shopping_cart, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateOrderScreen()))),
            
            // Packing
            if ((_isDesktop || role == 'ADMIN') && (role == 'ADMIN' || role == 'PACKER'))
              _buildCard(context, 'Pack Container', Icons.inventory, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PackContainerScreen()))),
            
            // IoT
            if ((_isDesktop || role == 'ADMIN') && (role == 'ADMIN' || role == 'MANAGER'))
              _buildCard(context, 'IoT Alerts', Icons.thermostat, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IotAlertsScreen()))),
            
            // Admin only
            if (role == 'ADMIN') ...[
              _buildCard(context, 'Manage Active Drafts', Icons.lock_open, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDraftsScreen()))),
              _buildCard(context, 'Staff Management', Icons.people_alt, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffManagementScreen()))),
            ],
          ];

          if (cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No modules available for your role ($role) on this platform.', 
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: cards,
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
