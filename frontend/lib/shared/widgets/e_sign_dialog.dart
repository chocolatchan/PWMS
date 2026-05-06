import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pwms_frontend/features/auth/presentation/providers/auth_provider.dart';

class ESignDialog extends ConsumerStatefulWidget {
  const ESignDialog({super.key});

  /// Helper method to show the dialog and wait for the boolean result.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Must tap a button to close
      builder: (context) => const ESignDialog(),
    );
    return result ?? false;
  }

  @override
  ConsumerState<ESignDialog> createState() => _ESignDialogState();
}

class _ESignDialogState extends ConsumerState<ESignDialog> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Password is required.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final isValid = await ref.read(authProvider.notifier).verifyPassword(password);

    if (!mounted) return;

    if (isValid) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid password.';
      });
    }
  }

  void _cancel() {
    if (_isLoading) return;
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    // PopScope prevents Android back button when loading
    return PopScope(
      canPop: !_isLoading,
      child: AlertDialog(
        title: const Text('Chữ ký điện tử / E-Signature'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Vui lòng nhập mật khẩu để xác nhận hành động này.'),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              enabled: !_isLoading,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (!_isLoading) _confirm();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _cancel,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _confirm,
            child: _isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
