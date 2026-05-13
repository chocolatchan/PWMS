import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_scan_overlay.dart';

class RunnerTask {
  final String id;
  final String taskType;
  final String identifier;
  final String fromLocation;
  final String toLocation;
  final String description;

  RunnerTask({
    required this.id,
    required this.taskType,
    required this.identifier,
    required this.fromLocation,
    required this.toLocation,
    required this.description,
  });

  factory RunnerTask.fromJson(Map<String, dynamic> json) {
    return RunnerTask(
      id: json['id'],
      taskType: json['task_type'],
      identifier: json['identifier'],
      fromLocation: json['from_location'],
      toLocation: json['to_location'],
      description: json['description'],
    );
  }
}

class RunnerScreen extends ConsumerStatefulWidget {
  const RunnerScreen({super.key});

  @override
  ConsumerState<RunnerScreen> createState() => _RunnerScreenState();
}

class _RunnerScreenState extends ConsumerState<RunnerScreen> {
  List<RunnerTask> _tasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('runner/tasks');
      final data = response.data as List;
      setState(() {
        _tasks = data.map((e) => RunnerTask.fromJson(e)).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching tasks: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmTransfer(String id, String type) async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final endpoint = type == 'INTERNAL' 
          ? 'runner/internal/transfer' 
          : 'runner/external/transfer';
      
      await dio.post(endpoint, data: {'id': id});
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transfer confirmed'), backgroundColor: Colors.green),
        );
        _fetchTasks();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error confirming transfer: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _scanAndMove() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (val) => Navigator.pop(context, val))),
    );

    if (barcode == null) return;

    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final lookupRes = await dio.get('runner/lookup/$barcode');
      final type = lookupRes.data['type'];
      final id = lookupRes.data['id'];
      final identifier = lookupRes.data['identifier'];

      // Show confirmation dialog before moving
      if (mounted) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Confirm Move: $identifier'),
            content: Text('Move this ${type == 'INTERNAL' ? 'Container' : 'Batch'} to its destination?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('CONFIRM')),
            ],
          ),
        );

        if (confirm == true) {
          await _confirmTransfer(id, type);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lookup failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Runner Logistics',
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _fetchTasks,
            child: _isLoading && _tasks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _tasks.isEmpty
                    ? const Center(child: Text('No pending tasks'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          final isInternal = task.taskType == 'INTERNAL';
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isInternal ? Colors.blue.shade100 : Colors.orange.shade100,
                                child: Icon(
                                  isInternal ? Icons.move_to_inbox : Icons.warning_amber_rounded,
                                  color: isInternal ? Colors.blue : Colors.orange,
                                ),
                              ),
                              title: Text(task.identifier, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${task.fromLocation} ➔ ${task.toLocation}', 
                                      style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                                  Text(task.description, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green, size: 32),
                                onPressed: () => _confirmTransfer(task.id, task.taskType),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          if (_isLoading) 
            const Positioned.fill(child: Center(child: CircularProgressIndicator())),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanAndMove,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('SCAN TO MOVE'),
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }
}
