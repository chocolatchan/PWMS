import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../models/outbound_dto.dart';
import '../presentation/outbound_providers.dart';

// ─────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────
class ContainerSummary {
  final String id;
  final String customerName;
  final String status;
  final int totalTasks;
  final int doneTasks;
  final DateTime? createdAt;

  const ContainerSummary({
    required this.id,
    required this.customerName,
    required this.status,
    required this.totalTasks,
    required this.doneTasks,
    this.createdAt,
  });

  factory ContainerSummary.fromJson(Map<String, dynamic> j) => ContainerSummary(
        id: j['id'] as String,
        customerName: j['customer_name'] as String,
        status: j['status'] as String? ?? '',
        totalTasks: (j['total_tasks'] as num?)?.toInt() ?? 0,
        doneTasks: (j['done_tasks'] as num?)?.toInt() ?? 0,
        createdAt: j['created_at'] != null
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
      );
}

class ContainerItem {
  final String id;
  final String productName;
  final String? batchNumber;
  final int requiredQty;
  final int pickedQty;
  final String status;
  final String? locationCode;
  final String? expiryDate;

  const ContainerItem({
    required this.id,
    required this.productName,
    this.batchNumber,
    required this.requiredQty,
    required this.pickedQty,
    required this.status,
    this.locationCode,
    this.expiryDate,
  });

  factory ContainerItem.fromJson(Map<String, dynamic> j) => ContainerItem(
        id: j['id'] as String,
        productName: j['product_name'] as String,
        batchNumber: j['batch_number'] as String?,
        requiredQty: (j['required_qty'] as num).toInt(),
        pickedQty: (j['picked_qty'] as num?)?.toInt() ?? 0,
        status: j['status'] as String? ?? '',
        locationCode: j['location_code'] as String?,
        expiryDate: j['expiry_date'] as String?,
      );
}

// Checklist items per plan.md
const _checklistItems = [
  // Section 1: Verification
  _ChecklistSection('1. VERIFICATION', [
    'Cross-check items against Picking List and Order',
    'Drug name & concentration: 100% correct',
    'Batch No & Expiry Date: match between physical and documents',
    'Quantity: recount all units (boxes/blisters/bottles) before loading',
  ]),
  // Section 2: Visual QC
  _ChecklistSection('2. VISUAL QUALITY CHECK', [
    'Products not damaged/dented during movement from inventory',
    'Drug labels clean, batch/barcode readable',
    'Seal/tamper-evident sticker intact (if applicable)',
  ]),
  // Section 3: Packing specs
  _ChecklistSection('3. PACKING SPECS', [
    'Outer carton: clean, dry, correct size',
    'Padding material (foam/air bags) used — items secured',
    'Cold chain: insulated box, gel packs placed per cold-chain diagram',
    'Data Logger placed in correct position (cold chain items)',
  ]),
  // Section 4: Labeling & Sealing
  _ChecklistSection('4. LABELING & SEALING', [
    'Shipping label affixed: recipient info clear',
    'Warning labels: "Fragile", "Keep away from light", "Keep refrigerated"',
    'Box sealed with branded tape or lead seal',
    'Documents inside/on box: Invoice, COA, Delivery Note',
  ]),
];

class _ChecklistSection {
  final String title;
  final List<String> items;
  const _ChecklistSection(this.title, this.items);
}

// ─────────────────────────────────────────────────────────────
// MAIN SCREEN — Container List
// ─────────────────────────────────────────────────────────────
class PackContainerScreen extends ConsumerStatefulWidget {
  const PackContainerScreen({super.key});

  @override
  ConsumerState<PackContainerScreen> createState() => _PackContainerScreenState();
}

class _PackContainerScreenState extends ConsumerState<PackContainerScreen> {
  List<ContainerSummary> _containers = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('containers', queryParameters: {'status': 'AT_PACKING'});
      final List data = res.data as List;
      setState(() {
        _containers = data.map((j) => ContainerSummary.fromJson(j as Map<String, dynamic>)).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pack Containers'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _containers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No containers ready for packing',
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 8),
                      const Text('All pick tasks must be completed first.',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                        onPressed: _load,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _containers.length,
                    itemBuilder: (ctx, i) => _buildContainerCard(_containers[i]),
                  ),
                ),
    );
  }

  Widget _buildContainerCard(ContainerSummary c) {
    final timeStr = c.createdAt != null
        ? '${c.createdAt!.day}/${c.createdAt!.month} '
            '${c.createdAt!.hour.toString().padLeft(2, '0')}:'
            '${c.createdAt!.minute.toString().padLeft(2, '0')}'
        : '';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.orange.shade200, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => _PackWorkflowScreen(container: c)),
          );
          _load();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.orange.shade50,
                child: const Icon(Icons.inventory_2, color: Colors.orange, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.customerName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    const SizedBox(height: 4),
                    Text('${c.doneTasks}/${c.totalTasks} items picked  ·  $timeStr',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    const SizedBox(height: 6),
                    Text(c.id.substring(0, 8).toUpperCase(),
                        style: const TextStyle(fontFamily: 'monospace', color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Text('AT PACKING',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PACK WORKFLOW SCREEN
// ─────────────────────────────────────────────────────────────
class _PackWorkflowScreen extends ConsumerStatefulWidget {
  final ContainerSummary container;
  const _PackWorkflowScreen({required this.container});

  @override
  ConsumerState<_PackWorkflowScreen> createState() => _PackWorkflowScreenState();
}

class _PackWorkflowScreenState extends ConsumerState<_PackWorkflowScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  List<ContainerItem> _items = [];
  bool _loadingItems = false;

  // Checklist state: flat list of all checks across all sections
  late final List<bool> _checked;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    final totalChecks = _checklistItems.fold(0, (s, sec) => s + sec.items.length);
    _checked = List.filled(totalChecks, false);
    _loadItems();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() => _loadingItems = true);
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('containers/${widget.container.id}/items');
      final List data = res.data as List;
      setState(() {
        _items = data.map((j) => ContainerItem.fromJson(j as Map<String, dynamic>)).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading items: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _loadingItems = false);
    }
  }

  bool get _allChecked => _checked.every((c) => c);

  Future<void> _confirmPack() async {
    if (!_allChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete all checklist items before confirming.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final req = PackContainerReq(
        containerId: widget.container.id,
        packerId: 'self', // backend uses JWT claims
      );
      await ref.read(outboundRepositoryProvider).packContainer(req);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Container packed! Ready for dispatch.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      final msg = (e.response?.data is Map)
          ? (e.response?.data as Map)['error'] ?? e.message
          : e.message ?? 'Unknown error';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $msg'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkedCount = _checked.where((c) => c).length;
    final totalCount = _checked.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.container.customerName),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(icon: Icon(Icons.inventory), text: 'Items'),
            Tab(icon: Icon(Icons.checklist), text: 'Checklist'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress header
          Container(
            color: Colors.orange.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Container: ${widget.container.id.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(fontFamily: 'monospace', color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('Checklist: $checkedCount / $totalCount completed',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: totalCount > 0 ? checkedCount / totalCount : 0,
                        backgroundColor: Colors.orange.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            _allChecked ? Colors.green : Colors.orange),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _buildItemsTab(),
                _buildChecklistTab(),
              ],
            ),
          ),

          // Footer confirm button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: _submitting
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Icon(_allChecked ? Icons.check_circle : Icons.lock, size: 24),
                label: Text(
                  _submitting
                      ? 'Confirming...'
                      : _allChecked
                          ? 'Confirm Pack ✓'
                          : 'Complete checklist first ($checkedCount/$totalCount)',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _allChecked ? Colors.green : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitting ? null : _confirmPack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTab() {
    if (_loadingItems) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) return const Center(child: Text('No items found'));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (ctx, i) {
        final item = _items[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medication, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Text('${item.pickedQty} units',
                          style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    if (item.batchNumber != null)
                      _infoChip(Icons.tag, 'Batch: ${item.batchNumber}'),
                    if (item.expiryDate != null)
                      _infoChip(Icons.event, 'Exp: ${item.expiryDate}'),
                    if (item.locationCode != null)
                      _infoChip(Icons.location_on, item.locationCode!),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChecklistTab() {
    int globalIndex = 0;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _checklistItems.length,
      itemBuilder: (ctx, sectionIndex) {
        final section = _checklistItems[sectionIndex];
        final sectionStartIndex = globalIndex;
        globalIndex += section.items.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: sectionIndex > 0 ? 16 : 0, bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  section.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ),
            ...section.items.asMap().entries.map((entry) {
              final itemIndex = sectionStartIndex + entry.key;
              final isChecked = _checked[itemIndex];
              return Card(
                margin: const EdgeInsets.only(bottom: 6),
                elevation: 0,
                color: isChecked ? Colors.green.shade50 : Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isChecked ? Colors.green.shade200 : Colors.grey.shade200,
                  ),
                ),
                child: CheckboxListTile(
                  value: isChecked,
                  onChanged: (v) => setState(() => _checked[itemIndex] = v ?? false),
                  title: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: isChecked ? Colors.green.shade800 : Colors.black87,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.blue.shade700),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
          ],
        ),
      );
}
