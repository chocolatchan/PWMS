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

class CreatePOScreen extends ConsumerStatefulWidget {
  const CreatePOScreen({super.key});

  @override
  ConsumerState<CreatePOScreen> createState() => _CreatePOScreenState();
}

class _CreatePOScreenState extends ConsumerState<CreatePOScreen> {
  final _poNumberCtrl = TextEditingController();
  final _vendorCtrl = TextEditingController();
  DateTime _expectedDate = DateTime.now().add(const Duration(days: 7));
  
  List<ProductItem> _allProducts = [];
  final Map<String, int> _items = {}; // product_id -> qty
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('products');
      final List data = res.data as List;
      setState(() {
        _allProducts = data.map((e) => ProductItem.fromJson(e)).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching products: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitPO() async {
    if (_poNumberCtrl.text.isEmpty || _vendorCtrl.text.isEmpty || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields and add at least one item')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post('inbound/purchase-orders', data: {
        'po_number': _poNumberCtrl.text,
        'vendor_name': _vendorCtrl.text,
        'expected_date': _expectedDate.toIso8601String().split('T')[0],
        'items': _items.entries.map((e) => {
          'product_id': e.key,
          'expected_qty': e.value,
        }).toList(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase Order created successfully!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Create PO',
      body: Column(
        children: [
          _buildHeader(),
          const Divider(height: 32),
          const Text('Select Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: _allProducts.isEmpty && _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _allProducts.length,
                  itemBuilder: (context, index) {
                    final p = _allProducts[index];
                    final qty = _items[p.id] ?? 0;
                    return Card(
                      child: ListTile(
                        title: Text(p.name),
                        subtitle: Text('Zone: ${p.tempZone}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: () => _updateQty(p.id, qty - 10), icon: const Icon(Icons.remove_circle_outline)),
                            Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(onPressed: () => _updateQty(p.id, qty + 10), icon: const Icon(Icons.add_circle_outline)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitPO,
              child: Text(_isLoading ? 'Submitting...' : 'SUBMIT PURCHASE ORDER', style: const TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  void _updateQty(String id, int newQty) {
    setState(() {
      if (newQty <= 0) {
        _items.remove(id);
      } else {
        _items[id] = newQty;
      }
    });
  }

  Widget _buildHeader() {
    return Column(
      children: [
        TextField(
          controller: _poNumberCtrl,
          decoration: const InputDecoration(labelText: 'PO Number *', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _vendorCtrl,
          decoration: const InputDecoration(labelText: 'Vendor Name *', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _expectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _expectedDate = picked);
          },
          child: InputDecorator(
            decoration: const InputDecoration(labelText: 'Expected Date', border: OutlineInputBorder()),
            child: Text('${_expectedDate.year}-${_expectedDate.month.toString().padLeft(2, '0')}-${_expectedDate.day.toString().padLeft(2, '0')}'),
          ),
        ),
      ],
    );
  }
}
