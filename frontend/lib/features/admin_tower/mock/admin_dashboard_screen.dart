import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_controller.dart';
import 'admin_models.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    _searchController.text = query;
    ref.read(adminTowerControllerProvider.notifier).searchTrace(query);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminTowerControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('CONTROL TOWER', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _searchController.clear();
              ref.read(adminTowerControllerProvider.notifier).clearSearch();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // KPI Section
            const Text('REAL-TIME METRICS', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            _buildKpiGrid(state.metrics),
            const SizedBox(height: 48),

            // Search Section
            const Text('END-TO-END TRACEABILITY', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Search Batch or Tote Code...',
                      hintStyle: const TextStyle(color: Color(0xFF475569)),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF38BDF8)),
                    ),
                    onSubmitted: _onSearch,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _onSearch('BATCH-001'),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Happy Path'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF065F46),
                    foregroundColor: const Color(0xFFA7F3D0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _onSearch('BATCH-ERR'),
                  icon: const Icon(Icons.error_outline, size: 18),
                  label: const Text('Rejected Path'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F1D1D),
                    foregroundColor: const Color(0xFFFECACA),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Timeline Section
            if (state.isSearching)
              const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)))
            else if (state.searchResult.isNotEmpty)
              _buildTimeline(state.searchResult)
            else if (_searchController.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('No traceability data found for this query.', style: TextStyle(color: Color(0xFF94A3B8)))),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiGrid(KpiMetrics metrics) {
    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildKpiCard('Orders Pending Pick', metrics.ordersPendingPick.toString(), Icons.pending_actions, const Color(0xFFF59E0B), constraints.maxWidth),
          _buildKpiCard('Items in Quarantine', metrics.itemsInQuarantine.toString(), Icons.warning_amber, const Color(0xFFEAB308), constraints.maxWidth),
          _buildKpiCard('Dispatch Rate', metrics.dispatchRate, Icons.local_shipping, const Color(0xFF10B981), constraints.maxWidth),
          _buildKpiCard('Critical Alerts', metrics.criticalAlerts.toString(), Icons.campaign, const Color(0xFFEF4444), constraints.maxWidth),
        ],
      );
    });
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color, double maxWidth) {
    final width = (maxWidth - 48) / 4; // 4 cards per row ideally
    return Container(
      width: width > 200 ? width : 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<AuditLogEvent> events) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final isLast = index == events.length - 1;
          final color = event.isSuccess ? const Color(0xFF10B981) : const Color(0xFFEF4444);

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline Graphics
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 3),
                      ),
                      child: Icon(event.isSuccess ? Icons.check : Icons.close, size: 14, color: color),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: const Color(0xFF334155),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 24),
                // Event Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.timestamp, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(event.actionName, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 14, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 4),
                            Text(event.userResponsible, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Text(event.details, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
