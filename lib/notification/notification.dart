import 'package:flutter/material.dart';
import '../lower_bar/lower_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Color(0xFFD7B65D)),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD7B65D)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.26, 1.0],
            colors: [
              Color(0xFF121212),
              Color(0xFF1F1F1F),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // New Notifications Section
            _buildSectionHeader('New'),
            _buildNotificationItem(
              title: 'Reservation of sedan',
              time: '24',
              isNew: true,
            ),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 20),
            const LowerBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD7B65D),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String time,
    bool isNew = false,
  }) {
    return Container(
      color: isNew ? const Color(0xFFD7B65D).withOpacity(0.05) : Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomMenuItem(String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }
}
