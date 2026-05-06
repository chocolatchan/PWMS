import 'package:flutter/material.dart';
import 'package:pwms_frontend/features/phase6_returns/mock/recall_screen.dart';
import 'return_screen.dart';

class Phase6Dashboard extends StatefulWidget {
  const Phase6Dashboard({super.key});

  @override
  State<Phase6Dashboard> createState() => _Phase6DashboardState();
}

class _Phase6DashboardState extends State<Phase6Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const EmergencyRecallScreen(),
    const ReturnsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: _currentIndex == 0
            ? const Color(0xFFEF4444)
            : const Color(0xFF38BDF8),
        unselectedItemColor: const Color(0xFF64748B),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_rounded),
            label: 'EMERGENCY RECALL',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_return_rounded),
            label: 'RETURNS',
          ),
        ],
      ),
    );
  }
}
