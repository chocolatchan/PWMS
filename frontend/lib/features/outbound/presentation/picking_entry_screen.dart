import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../models/outbound_dto.dart';
import '../presentation/outbound_providers.dart';
import 'pick_item_screen.dart';
import '../../../core/ui/pda_scan_overlay.dart';

class PickingEntryScreen extends ConsumerStatefulWidget {
  const PickingEntryScreen({super.key});

  @override
  ConsumerState<PickingEntryScreen> createState() => _PickingEntryScreenState();
}

class _PickingEntryScreenState extends ConsumerState<PickingEntryScreen> {
  String? _scannedContainerId;
  late Future<List<PickTask>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = Future.value([]);
  }

  void _loadTasks() {
    if (_scannedContainerId == null) return;
    setState(() {
      _tasksFuture = ref.read(outboundRepositoryProvider).getPickTasks(
        containerId: _scannedContainerId,
      );
    });
  }

  void _onContainerScanned(String barcode) {
    setState(() {
      _scannedContainerId = barcode;
    });
    _loadTasks();
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Icons.hourglass_empty;
      case 'IN_PROGRESS':
        return Icons.sync;
      case 'COMPLETED':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Picking Tasks',
      body: _scannedContainerId == null 
        ? _buildScanPrompt()
        : FutureBuilder<List<PickTask>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          final tasks = snapshot.data ?? [];
          final pending = tasks.where((t) => t.status.toUpperCase() != 'COMPLETED').toList();
          final done = tasks.where((t) => t.status.toUpperCase() == 'COMPLETED').toList();

          if (tasks.isEmpty) {
            return _buildEmpty();
          }

          return RefreshIndicator(
            onRefresh: () async => _loadTasks(),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Summary bar
                _buildSummary(pending.length, done.length, tasks.first.containerId),
                const SizedBox(height: 12),

                if (pending.isNotEmpty) ...[
                  _sectionHeader('📋 To Pick (${pending.length})'),
                  ...pending.map((t) => _buildTaskCard(t)),
                ],
                if (done.isNotEmpty) ...[
                  _sectionHeader('✅ Completed (${done.length})'),
                  ...done.map((t) => _buildTaskCard(t)),
                ],
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Switch Container'),
                    onPressed: () => setState(() => _scannedContainerId = null),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScanPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2, size: 100, color: Colors.blue),
          const SizedBox(height: 24),
          const Text('Scan Container Barcode', 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Scan the tote/box to start picking',
            style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 48),
          ElevatedButton.icon(
            icon: const Icon(Icons.qr_code_scanner, size: 28),
            label: const Text('SCAN NOW', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final barcode = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PdaScanOverlay(
                  onScan: (val) => Navigator.pop(context, val),
                )),
              );
              if (barcode != null) {
                _onContainerScanned(barcode);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(int pending, int done, String containerId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('Container: ${containerId.substring(0, 8).toUpperCase()}', 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem('Remaining', pending.toString(), Colors.white),
              Container(width: 1, height: 40, color: Colors.white30),
              _summaryItem('Completed', done.toString(), Colors.greenAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget _buildTaskCard(PickTask task) {
    final isDone = task.status.toUpperCase() == 'COMPLETED';
    final progress = task.requiredQty > 0
        ? (task.pickedQty / task.requiredQty).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDone ? Colors.green.shade200 : Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isDone
            ? null
            : () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PickItemScreen(
                      taskId: task.id,
                      containerId: task.containerId,
                      productName: task.productName,
                      batchNumber: task.batchNumber,
                      locationCode: task.locationCode,
                      requiredQty: task.requiredQty,
                      pickedQty: task.pickedQty,
                    ),
                  ),
                );
                _loadTasks(); // Refresh after returning
              },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.productName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDone ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(task.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _statusColor(task.status)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon(task.status),
                            size: 14, color: _statusColor(task.status)),
                        const SizedBox(width: 4),
                        Text(task.status,
                            style: TextStyle(
                                fontSize: 12, color: _statusColor(task.status))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(task.locationCode,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  const SizedBox(width: 16),
                  if (task.batchNumber != null) ...[
                    Icon(Icons.tag, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(task.batchNumber!,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDone ? Colors.green : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${task.pickedQty} / ${task.requiredQty}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDone ? Colors.green : Colors.blue,
                    ),
                  ),
                ],
              ),
              if (!isDone)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text('Pick Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PickItemScreen(
                              taskId: task.id,
                              containerId: task.containerId,
                              productName: task.productName,
                              batchNumber: task.batchNumber,
                              locationCode: task.locationCode,
                              requiredQty: task.requiredQty,
                              pickedQty: task.pickedQty,
                            ),
                          ),
                        );
                        _loadTasks();
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('No pick tasks assigned',
              style: TextStyle(fontSize: 20, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Pull down to refresh',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            onPressed: _loadTasks,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $err', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadTasks, child: const Text('Retry')),
        ],
      ),
    );
  }
}
