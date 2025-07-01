import 'package:flutter/material.dart';

class LowerBar extends StatelessWidget {
  const LowerBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: const Border(
          top: BorderSide(color: Color(0xFFD4AF37), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBarItem(
            context: context,
            icon: Icons.person,
            label: 'Home',
            route: '/dashboard',
          ),
          _buildBarItem(
            context: context,
            icon: Icons.history,
            label: 'History',
            route: '/history',
          ),
          _buildBarItem(
            context: context,
            icon: Icons.store,
            label: 'Wallet',
            route: '/account',
          ),
          _buildBarItem(
            context: context,
            icon: Icons.account_circle,
            label: 'Profile',
            route: '/profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
