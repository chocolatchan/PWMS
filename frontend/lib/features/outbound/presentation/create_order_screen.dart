import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/outbound_repository.dart';
import '../models/outbound_dto.dart';
import '../presentation/outbound_providers.dart';
import '../../../core/network/dio_client.dart';

// ─────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────
class ProductStock {
  final String id;
  final String name;
  final bool isLasa;
  final String tempZone;
  final int availableQty;

  const ProductStock({
    required this.id,
    required this.name,
    required this.isLasa,
    required this.tempZone,
    required this.availableQty,
  });

  factory ProductStock.fromJson(Map<String, dynamic> j) => ProductStock(
        id: j['id'] as String,
        name: j['name'] as String,
        isLasa: (j['is_lasa'] as bool?) ?? false,
        tempZone: j['temp_zone'] as String? ?? 'AMBIENT',
        availableQty: (j['available_qty'] as num?)?.toInt() ?? 0,
      );
}

class OrderSummary {
  final String id;
  final String customerName;
  final String? status;
  final String? containerId;
  final DateTime? createdAt;

  const OrderSummary({
    required this.id,
    required this.customerName,
    this.status,
    this.containerId,
    this.createdAt,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> j) => OrderSummary(
        id: j['id'] as String,
        customerName: j['customer_name'] as String,
        status: j['status'] as String?,
        containerId: j['container_id'] as String?,
        createdAt: j['created_at'] != null
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
      );
}

// ─────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────
class CreateOrderScreen extends ConsumerStatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Admin'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(icon: Icon(Icons.add_shopping_cart), text: 'New Order'),
            Tab(icon: Icon(Icons.list_alt), text: 'Order History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _NewOrderTab(),
          _OrderHistoryTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NEW ORDER TAB
// ─────────────────────────────────────────────────────────────
class _NewOrderTab extends ConsumerStatefulWidget {
  const _NewOrderTab();

  @override
  ConsumerState<_NewOrderTab> createState() => _NewOrderTabState();
}

class _NewOrderTabState extends ConsumerState<_NewOrderTab> {
  final _customerCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  List<ProductStock> _allProducts = [];
  List<ProductStock> _filtered = [];
  final Map<String, int> _cart = {}; // product_id -> qty
  bool _loadingProducts = false;
  bool _submitting = false;
  String? _lastOrderId;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _customerCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _allProducts
          .where((p) => p.name.toLowerCase().contains(q))
          .toList();
    });
  }

  Future<void> _loadProducts() async {
    setState(() => _loadingProducts = true);
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('products');
      final List data = res.data as List;
      setState(() {
        _allProducts = data.map((j) => ProductStock.fromJson(j as Map<String, dynamic>)).toList();
        _filtered = List.from(_allProducts);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load products: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _loadingProducts = false);
    }
  }

  void _setQty(String productId, int qty) {
    setState(() {
      if (qty <= 0) {
        _cart.remove(productId);
      } else {
        _cart[productId] = qty;
      }
    });
  }

  Future<void> _submitOrder() async {
    if (_customerCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a customer name.'), backgroundColor: Colors.orange));
      return;
    }
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cart is empty. Add at least one product.'), backgroundColor: Colors.orange));
      return;
    }

    setState(() => _submitting = true);
    try {
      final req = CreateOrderReq(
        customerName: _customerCtrl.text.trim(),
        items: _cart.entries
            .map((e) => OrderItemPayload(productId: e.key, requiredQty: e.value))
            .toList(),
      );
      await ref.read(outboundRepositoryProvider).createOrder(req);

      if (mounted) {
        setState(() {
          _lastOrderId = 'Created!';
          _cart.clear();
          _customerCtrl.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Order created & allocated! Pick tasks generated.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
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
    final cartTotal = _cart.values.fold(0, (a, b) => a + b);

    return Column(
      children: [
        // Customer name
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _customerCtrl,
            decoration: const InputDecoration(
              labelText: 'Customer Name *',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        _onSearch();
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Product list
        Expanded(
          child: _loadingProducts
              ? const Center(child: CircularProgressIndicator())
              : _filtered.isEmpty
                  ? const Center(child: Text('No products found'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filtered.length,
                      itemBuilder: (ctx, i) {
                        final p = _filtered[i];
                        final qty = _cart[p.id] ?? 0;
                        final inCart = qty > 0;
                        return Card(
                          elevation: inCart ? 3 : 1,
                          color: inCart ? Colors.blue.shade50 : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: inCart
                                ? BorderSide(color: Colors.blue.shade300, width: 1.5)
                                : BorderSide.none,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Expanded(
                                          child: Text(p.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 15)),
                                        ),
                                        if (p.isLasa)
                                          _badge('LASA', Colors.orange),
                                        const SizedBox(width: 4),
                                        _badge(p.tempZone, _zoneColor(p.tempZone)),
                                      ]),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Available: ${p.availableQty} units',
                                        style: TextStyle(
                                          color: p.availableQty > 0
                                              ? Colors.green.shade700
                                              : Colors.red,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (p.availableQty > 0) ...[
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.remove_circle_outline, size: 24),
                                      color: Colors.blue,
                                      onPressed: qty > 0 ? () => _setQty(p.id, qty - 1) : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 48,
                                    child: Text(
                                      qty.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: qty > 0 ? Colors.blue : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.add_circle_outline, size: 24),
                                      color: Colors.blue,
                                      onPressed: qty < p.availableQty
                                          ? () => _setQty(p.id, qty + 1)
                                          : null,
                                    ),
                                  ),
                                ] else
                                  const Text('Out of stock',
                                      style: TextStyle(color: Colors.red, fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),

        // Footer: cart summary + submit
        if (_cart.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_cart.length} product(s) · $cartTotal units total',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        _cart.entries.take(3).map((e) {
                          final name = _allProducts
                              .firstWhere((p) => p.id == e.key,
                                  orElse: () => ProductStock(
                                      id: '', name: '?', isLasa: false, tempZone: '', availableQty: 0))
                              .name;
                          return '${e.value}x $name';
                        }).join(', ') + (_cart.length > 3 ? '...' : ''),
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: _submitting
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send),
                  label: Text(_submitting ? 'Submitting...' : 'Create Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _submitting ? null : _submitOrder,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _badge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.5))),
        child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
      );

  Color _zoneColor(String zone) {
    switch (zone.toUpperCase()) {
      case 'COLD': return Colors.blue;
      case 'CHILLED': return Colors.cyan;
      default: return Colors.grey;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// ORDER HISTORY TAB
// ─────────────────────────────────────────────────────────────
class _OrderHistoryTab extends ConsumerStatefulWidget {
  const _OrderHistoryTab();

  @override
  ConsumerState<_OrderHistoryTab> createState() => _OrderHistoryTabState();
}

class _OrderHistoryTabState extends ConsumerState<_OrderHistoryTab> {
  List<OrderSummary> _orders = [];
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
      final res = await dio.get('orders');
      final List data = res.data as List;
      setState(() {
        _orders = data
            .map((j) => OrderSummary.fromJson(j as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load orders: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Color _statusColor(String? s) {
    switch (s?.toUpperCase()) {
      case 'PICKING': return Colors.orange;
      case 'AT_PACKING': return Colors.blue;
      case 'PACKED': return Colors.purple;
      case 'DISPATCHED': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No orders yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _load, child: const Text('Refresh')),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _orders.length,
                  itemBuilder: (ctx, i) {
                    final o = _orders[i];
                    final dateStr = o.createdAt != null
                        ? '${o.createdAt!.day}/${o.createdAt!.month}/${o.createdAt!.year} '
                            '${o.createdAt!.hour.toString().padLeft(2, '0')}:'
                            '${o.createdAt!.minute.toString().padLeft(2, '0')}'
                        : '';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: _statusColor(o.status).withOpacity(0.15),
                          child: Icon(Icons.shopping_bag, color: _statusColor(o.status)),
                        ),
                        title: Text(o.customerName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (dateStr.isNotEmpty) Text(dateStr, style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _statusColor(o.status).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _statusColor(o.status)),
                              ),
                              child: Text(o.status ?? 'N/A',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: _statusColor(o.status),
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        trailing: Text(
                          o.id.substring(0, 8).toUpperCase(),
                          style: const TextStyle(fontFamily: 'monospace', color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
