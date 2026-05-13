import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/ui/pda_scaffold.dart';

class ProductItem {
  final String id;
  final String name;
  final String tempZone;

  ProductItem({required this.id, required this.name, required this.tempZone});

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'],
      name: json['name'],
      tempZone: json['temp_zone'] ?? 'AMBIENT',
    );
  }
}

class POSummary {
  final String poNumber;
  final String vendorName;
  final String status;
  final DateTime? expectedDate;

  POSummary({required this.poNumber, required this.vendorName, required this.status, this.expectedDate});

  factory POSummary.fromJson(Map<String, dynamic> json) {
    return POSummary(
      poNumber: json['po_number'],
      vendorName: json['vendor_name'] ?? 'N/A',
      status: json['status'],
      expectedDate: json['expected_date'] != null ? DateTime.parse(json['expected_date']) : null,
    );
  }
}

class POManagementScreen extends ConsumerStatefulWidget {
  const POManagementScreen({super.key});

  @override
  ConsumerState<POManagementScreen> createState() => _POManagementScreenState();
}

class _POManagementScreenState extends ConsumerState<POManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final _poNumberCtrl = TextEditingController();
  final _vendorCtrl = TextEditingController();
  DateTime _expectedDate = DateTime.now().add(const Duration(days: 7));
  
  List<ProductItem> _allProducts = [];
  List<POSummary> _poList = [];
  final Map<String, int> _items = {}; // product_id -> qty
  bool _isLoading = false;
  String? _editingPoNumber;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProducts();
    _fetchPOList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('products');
      final List data = res.data as List;
      setState(() {
        _allProducts = data.map((e) => ProductItem.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  Future<void> _fetchPOList() async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('inbound/purchase-orders');
      final List data = res.data as List;
      setState(() {
        _poList = data.map((e) => POSummary.fromJson(e)).toList();
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching POs: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePO(String poNumber) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete PO'),
        content: Text('Are you sure you want to delete $poNumber?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('DELETE')),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.delete('inbound/purchase-orders/$poNumber');
      _fetchPOList();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PO Deleted')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _editPO(String poNumber) async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('inbound/purchase-orders/$poNumber');
      final data = res.data;
      
      setState(() {
        _editingPoNumber = poNumber;
        _poNumberCtrl.text = data['po_number'];
        _vendorCtrl.text = data['vendor_name'] ?? '';
        // Note: Backend doesn't return expected_date in details yet, we'll just keep current or fix it
        _items.clear();
        for (var item in data['items']) {
          _items[item['product_id']] = item['expected_qty'];
        }
        _tabController.animateTo(1); // Switch to Create/Edit tab
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading details: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitPO() async {
    if (_poNumberCtrl.text.isEmpty || _vendorCtrl.text.isEmpty || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final payload = {
        'po_number': _poNumberCtrl.text,
        'vendor_name': _vendorCtrl.text,
        'expected_date': _expectedDate.toIso8601String().split('T')[0],
        'items': _items.entries.map((e) => {'product_id': e.key, 'expected_qty': e.value}).toList(),
      };

      if (_editingPoNumber != null) {
        await dio.put('inbound/purchase-orders/$_editingPoNumber', data: payload);
      } else {
        await dio.post('inbound/purchase-orders', data: payload);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_editingPoNumber != null ? 'PO Updated' : 'PO Created'), backgroundColor: Colors.green));
        _resetForm();
        _fetchPOList();
        _tabController.animateTo(0);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    setState(() {
      _editingPoNumber = null;
      _poNumberCtrl.clear();
      _vendorCtrl.clear();
      _items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'PO Admin',
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'PO List'),
              Tab(text: 'New / Edit'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListTab(),
                _buildFormTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTab() {
    if (_isLoading && _poList.isEmpty) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: _fetchPOList,
      child: ListView.builder(
        itemCount: _poList.length,
        itemBuilder: (context, index) {
          final po = _poList[index];
          return Card(
            child: ListTile(
              title: Text(po.poNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Vendor: ${po.vendorName}\nStatus: ${po.status}'),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editPO(po.poNumber)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deletePO(po.poNumber)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormTab() {
    return Column(
      children: [
        TextField(controller: _poNumberCtrl, decoration: const InputDecoration(labelText: 'PO Number', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _vendorCtrl, decoration: const InputDecoration(labelText: 'Vendor Name', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Expanded(
          child: ListView.builder(
            itemCount: _allProducts.length,
            itemBuilder: (context, index) {
              final p = _allProducts[index];
              final qty = _items[p.id] ?? 0;
              return ListTile(
                title: Text(p.name, style: const TextStyle(fontSize: 14)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _updateQty(p.id, qty - 1), 
                      icon: const Icon(Icons.remove, size: 20, color: Colors.red)
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        key: ValueKey('qty_${p.id}_$qty'), // Force rebuild to show current value
                        initialValue: qty.toString(),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onChanged: (val) {
                          final n = int.tryParse(val) ?? 0;
                          _updateQty(p.id, n, refresh: false);
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        ),
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _updateQty(p.id, qty + 1), 
                      icon: const Icon(Icons.add, size: 20, color: Colors.green)
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitPO,
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          child: Text(_editingPoNumber != null ? 'UPDATE PO' : 'CREATE PO'),
        ),
        if (_editingPoNumber != null)
          TextButton(onPressed: _resetForm, child: const Text('Cancel Edit')),
      ],
    );
  }

  void _updateQty(String id, int newQty, {bool refresh = true}) {
    if (refresh) {
      setState(() {
        if (newQty <= 0) {
          _items.remove(id);
        } else {
          _items[id] = newQty;
        }
      });
    } else {
      if (newQty <= 0) {
        _items.remove(id);
      } else {
        _items[id] = newQty;
      }
    }
  }
}
