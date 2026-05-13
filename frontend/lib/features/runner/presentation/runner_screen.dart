import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/ui/pda_scaffold.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tasks: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmTransfer(RunnerTask task) async {
    try {
      final dio = ref.read(dioProvider);
      final endpoint = task.taskType == 'INTERNAL' 
          ? 'runner/internal/transfer' 
          : 'runner/external/transfer';
      
      await dio.post(endpoint, data: {'id': task.id});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfer confirmed')),
      );
      _fetchTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming transfer: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Runner Tasks',
      body: RefreshIndicator(
        onRefresh: _fetchTasks,
        child: _isLoading && _tasks.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
                ? const Center(child: Text('No pending tasks'))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('${task.taskType}: ${task.identifier}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('From: ${task.fromLocation} -> To: ${task.toLocation}'),
                              Text(task.description),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () => _confirmTransfer(task),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
