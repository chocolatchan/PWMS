import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in login state
    ref.listen<AsyncValue<void>>(
      loginStateProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
                backgroundColor: Colors.red,
              ),
            );
          },
          data: (_) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
          },
        );
      },
    );

    final loginState = ref.watch(loginStateProvider);
    final loginNotifier = ref.read(loginStateProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warehouse, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text('PWMS V2', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              if (loginState.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await loginNotifier.login(
                        _usernameController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Login'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
