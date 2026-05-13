import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_button.dart';
import '../data/outbound_repository.dart';
import '../models/outbound_dto.dart';
import '../presentation/outbound_providers.dart';
import 'pick_item_screen.dart';

class PickListScreen extends ConsumerStatefulWidget {
  final String containerId;
  final String locationCode;

  const PickListScreen({super.key, required this.containerId, required this.locationCode});

  @override
  ConsumerState<PickListScreen> createState() => _PickListScreenState();
}

class _PickListScreenState extends ConsumerState<PickListScreen> {
  late Future<List<PickTask>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    _tasksFuture = ref.read(outboundRepositoryProvider).getPickTasks(
      containerId: widget.containerId, 
      locationCode: widget.locationCode
    );
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Picking List',
      body: FutureBuilder<List<PickTask>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final tasks = snapshot.data!;
          if (tasks.isEmpty) {
            return const Center(child: Text('No pick tasks for this area.'));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(task.productName, style: const TextStyle(fontSize: 20)),
                  subtitle: Text('Qty: ${task.requiredQty} | Picked: ${task.pickedQty}'),
                  trailing: task.pickedQty >= task.requiredQty
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 40)
                      : SizedBox(
                          width: 100,
                          child: PdaButton(
                            label: 'Pick',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PickItemScreen(
                                    taskId: task.id,
                                    containerId: widget.containerId,
                                    productName: task.productName,
                                    batchNumber: task.batchNumber,
                                    locationCode: task.locationCode,
                                    requiredQty: task.requiredQty,
                                    pickedQty: task.pickedQty,
                                  ),
                                ),
                              );
                              setState(() {
                                _fetchTasks();
                              });
                            },
                            backgroundColor: Colors.blue,
                          ),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
