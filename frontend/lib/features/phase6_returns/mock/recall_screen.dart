import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recall_controller.dart';
import 'recall_models.dart';

class EmergencyRecallScreen extends ConsumerStatefulWidget {
  const EmergencyRecallScreen({super.key});

  @override
  ConsumerState<EmergencyRecallScreen> createState() => _EmergencyRecallScreenState();
}

class _EmergencyRecallScreenState extends ConsumerState<EmergencyRecallScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _batchController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _batchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showLockdownDialog(String report) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF450A0A),
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.yellow, size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'LOCKDOWN PROTOCOL ACTIVATED',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              report,
              style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 16, fontFamily: 'monospace'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ACKNOWLEDGE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phase6ControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('EMERGENCY RECALL', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: const Color(0xFF7F1D1D),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(phase6ControllerProvider.notifier).resetRecall();
              _batchController.clear();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'BIOHAZARD RECALL PROTOCOL',
              style: TextStyle(color: Color(0xFFEF4444), fontSize: 24, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the compromised batch number to initiate a global warehouse lockdown. This action will immediately freeze all associated inventory across all zones.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _batchController,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Enter Batch Number...',
                      hintStyle: const TextStyle(color: Color(0xFF475569)),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () => _batchController.text = 'BATCH-DEADLY-01',
                  icon: const Icon(Icons.bolt, color: Colors.orange),
                  tooltip: 'Mock Demo Batch',
                ),
              ],
            ),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: () {
                if (_batchController.text.isEmpty) return;
                ref.read(phase6ControllerProvider.notifier).initiateRecall(_batchController.text);
                
                // Show dialog after the next frame to ensure state is updated
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final latestState = ref.read(phase6ControllerProvider);
                  if (latestState.lastRecallReport != null) {
                    _showLockdownDialog(latestState.lastRecallReport!);
                  }
                });
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDC2626).withOpacity(0.5 + (_animationController.value * 0.5)),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.warning_rounded, color: Colors.white, size: 48),
                          SizedBox(width: 16),
                          Text(
                            'INITIATE RECALL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            if (state.isRecallActive) ...[
              const Text(
                'AFFECTED INVENTORY',
                style: TextStyle(color: Color(0xFFFCA5A5), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: state.inventory.where((i) => i.status == InventoryStatus.recalled).length,
                  itemBuilder: (context, index) {
                    final item = state.inventory.where((i) => i.status == InventoryStatus.recalled).toList()[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF450A0A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF991B1B)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock, color: Color(0xFFFCA5A5)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.location, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text('${item.quantity} units - ${item.batchCode}', style: const TextStyle(color: Color(0xFFFCA5A5))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
