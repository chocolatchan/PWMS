import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatchTrackingScreen extends ConsumerStatefulWidget {
  const BatchTrackingScreen({super.key});

  @override
  ConsumerState<BatchTrackingScreen> createState() => _BatchTrackingScreenState();
}

class _BatchTrackingScreenState extends ConsumerState<BatchTrackingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All';

  final List<Map<String, dynamic>> _mockBatches = [
    {
      'id': '1',
      'productName': 'Amoxicillin 500mg',
      'batchNumber': 'BAT-2024-001',
      'expiryDate': '2025-06-15',
      'quantity': 5000,
      'status': 'Available',
      'temp': 22.5,
      'zone': 'Ambient',
      'health': 0.95,
    },
    {
      'id': '2',
      'productName': 'Insulin Glargine',
      'batchNumber': 'BAT-2024-005',
      'expiryDate': '2024-12-20',
      'quantity': 1200,
      'status': 'Quarantine',
      'temp': 4.2,
      'zone': 'Chilled',
      'health': 0.88,
    },
    {
      'id': '3',
      'productName': 'Paracetamol 500mg',
      'batchNumber': 'BAT-2023-112',
      'expiryDate': '2024-08-10',
      'quantity': 15000,
      'status': 'Available',
      'temp': 24.1,
      'zone': 'Ambient',
      'health': 0.98,
    },
    {
      'id': '4',
      'productName': 'Propofol 1% 20ml',
      'batchNumber': 'BAT-2024-012',
      'expiryDate': '2026-01-30',
      'quantity': 450,
      'status': 'Reserved',
      'temp': 21.8,
      'zone': 'Ambient',
      'health': 1.0,
    },
    {
      'id': '5',
      'productName': 'Vitamin C 1000mg',
      'batchNumber': 'BAT-2024-008',
      'expiryDate': '2024-06-01',
      'quantity': 8000,
      'status': 'Expired',
      'temp': 23.0,
      'zone': 'Ambient',
      'health': 0.1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Batch Tracking System', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          _buildSummaryStats(),
          _buildFilters(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _mockBatches.length,
              itemBuilder: (context, index) {
                final batch = _mockBatches[index];
                if (_filterStatus != 'All' && batch['status'] != _filterStatus) {
                  return const SizedBox.shrink();
                }
                return _buildBatchCard(batch);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Batches', '142', Colors.blue),
          _buildStatItem('In Quarantine', '12', Colors.orange),
          _buildStatItem('Low Stock', '5', Colors.red),
          _buildStatItem('Expiring Soon', '8', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search batch or product...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filterStatus,
                items: ['All', 'Available', 'Quarantine', 'Reserved', 'Expired']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _filterStatus = val!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard(Map<String, dynamic> batch) {
    final statusColor = _getStatusColor(batch['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6,
                color: statusColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  batch['productName'],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Batch: ${batch['batchNumber']}',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          _buildStatusBadge(batch['status'], statusColor),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Expiry Date', batch['expiryDate'], Icons.event),
                          _buildInfoColumn('Quantity', '${batch['quantity']} units', Icons.inventory_2),
                          _buildInfoColumn('Zone', batch['zone'], Icons.thermostat, 
                            color: batch['zone'] == 'Chilled' ? Colors.blue : Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('Batch Health', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: batch['health'],
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(_getHealthColor(batch['health'])),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(batch['health'] * 100).toInt()}%',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _getHealthColor(batch['health'])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available': return Colors.teal;
      case 'Quarantine': return Colors.orange;
      case 'Reserved': return Colors.blue;
      case 'Expired': return Colors.red;
      default: return Colors.grey;
    }
  }

  Color _getHealthColor(double health) {
    if (health > 0.8) return Colors.teal;
    if (health > 0.5) return Colors.orange;
    return Colors.red;
  }
}
