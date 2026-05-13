import 'package:flutter/material.dart';

class PdaScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const PdaScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: actions,
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: false,
    );
  }
}
