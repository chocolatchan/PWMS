import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inbound_providers.dart';

class AdminDraftsScreen extends ConsumerStatefulWidget {
  const AdminDraftsScreen({super.key});

  @override
  ConsumerState<AdminDraftsScreen> createState() => _AdminDraftsScreenState();
}

class _AdminDraftsScreenState extends ConsumerState<AdminDraftsScreen> {
  List<Map<String, dynamic>> _drafts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(inboundRepositoryProvider);
      final drafts = await repo.listActiveDrafts();
      setState(() {
        _drafts = drafts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _forceUnbind(String poNumber) async {
    try {
      await ref.read(inboundDraftProvider.notifier).unbindDraft(poNumber);
      _loadDrafts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PO $poNumber unbound successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Active Drafts'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadDrafts),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _drafts.isEmpty
              ? const Center(child: Text('No active drafts found'))
              : ListView.builder(
                  itemCount: _drafts.length,
                  itemBuilder: (context, index) {
                    final draft = _drafts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('PO: ${draft['po_number']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Staff: ${draft['staff_name']}'),
                            Text('Started: ${draft['created_at']}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _showConfirmUnbind(draft['po_number']),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                          child: const Text('Force Unbind'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showConfirmUnbind(String poNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Force Unbind'),
        content: Text('This will release PO $poNumber. The staff member currently working on it will lose unsaved progress. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _forceUnbind(poNumber);
            },
            child: const Text('Unbind', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
