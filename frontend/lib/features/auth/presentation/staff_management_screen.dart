import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/ui/pda_scaffold.dart';

class UserData {
  final String id;
  final String username;
  final String role;
  final DateTime createdAt;

  UserData({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends ConsumerState<StaffManagementScreen> {
  List<UserData> _users = [];
  bool _isLoading = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'PICKER';

  final List<String> _roles = [
    'ADMIN', 'INBOUND', 'PICKER', 'PACKER', 'QA', 'RUNNER', 'DISPATCHER', 'SALES', 'MANAGER'
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('admin/users');
      final data = response.data as List;
      setState(() {
        _users = data.map((e) => UserData.fromJson(e)).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching users: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createUser() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and password are required')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post('admin/users', data: {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'role': _selectedRole,
      });
      
      if (mounted) {
        Navigator.pop(context); // Close dialog
        _usernameController.clear();
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully'), backgroundColor: Colors.green),
        );
        _fetchUsers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating user: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.delete('admin/users/$id');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted')),
        );
        _fetchUsers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting user: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add New Staff'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setDialogState(() => _selectedRole = v);
                      setState(() => _selectedRole = v);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
            ElevatedButton(onPressed: _createUser, child: const Text('CREATE')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Staff Management',
      body: _isLoading && _users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchUsers,
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Role: ${user.role}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user.id),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
