import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../core/hardware/haptic_service.dart';
import '../../../core/hardware/scanner_service.dart';
import '../../../core/widgets/scanner_wrapper.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  StreamSubscription? _scannerSub;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _scannerSub = GetIt.I<ScannerService>().barcodeStream.listen((data) {
      if (data.startsWith('EMP:')) {
        final parts = data.split(':');
        if (parts.length >= 3) {
          _usernameController.text = parts[1];
          _passwordController.text = parts[2];
          context.read<AuthBloc>().add(LoginRequested(parts[1], parts[2]));
        }
      }
    });
  }

  @override
  void dispose() {
    _scannerSub?.cancel();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ScannerWrapper(
      child: Scaffold(
        backgroundColor: cs.primary,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              GetIt.I<GoRouter>().go('/dashboard', extra: state.user);
            } else if (state is AuthFailure) {
              GetIt.I<HapticService>().vibrateError();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(children: [
                  const Icon(Icons.error_outline, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.error)),
                ]),
                backgroundColor: cs.error,
              ));
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  // ── Header ───────────────────────────
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.warehouse, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'PWMS',
                            style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w900,
                              color: Colors.white, letterSpacing: 4,
                              fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pharma Warehouse — Chuẩn GSP',
                            style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7), letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Form card ────────────────────────
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Đăng nhập',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Hoặc quét thẻ nhân viên trên PDA',
                            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                          ),
                          const SizedBox(height: 28),

                          // Username
                          TextField(
                            controller: _usernameController,
                            focusNode: _usernameFocus,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Tên đăng nhập',
                              prefixIcon: Icon(Icons.badge_outlined),
                              hintText: 'staff / qa / inbound01',
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Password
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _login(),
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Submit
                          if (state is AuthLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            FilledButton.icon(
                              onPressed: _login,
                              icon: const Icon(Icons.login),
                              label: const Text('ĐĂNG NHẬP'),
                            ),

                          const Spacer(),

                          // Scan hint
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_scanner, size: 16, color: cs.onSurfaceVariant),
                              const SizedBox(width: 6),
                              Text(
                                'Quét thẻ nhân viên để đăng nhập tức thì',
                                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                              ),
                            ],
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
      ),
    );
  }

  void _login() {
    final user = _usernameController.text.trim();
    final pass = _passwordController.text;
    if (user.isEmpty || pass.isEmpty) return;
    context.read<AuthBloc>().add(LoginRequested(user, pass));
  }
}
