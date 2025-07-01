import 'package:flutter/material.dart';
import '../lower_bar/lower_bar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHistoryItem(
            date: '23-SEP 2025',
            items: ['Menu', 'MANHATTAN', 'INQUIRY SERVICE', 'LINCOLN SEGUM'],
          ),
          _buildHistoryItem(
            date: '24-SEP 2025',
            items: ['Menu', 'MANHATTAN', 'INQUIRY SERVICE', 'LINCOLN SEGUM'],
          ),
          _buildHistoryItem(
            date: '25-SEP 2025',
            items: ['Menu', 'MANHATTAN', 'INQUIRY SERVICE', 'LINCOLN SEGUM'],
          ),
          _buildHistoryItem(
            date: '30DS',
            items: ['Menu', 'MANHATTAN', 'INQUIRY SERVICE', 'LINCOLN SEGUM'],
          ),
          _buildHistoryItem(
            date: '31-SEP 2025',
            items: ['Menu', 'MANHATTAN', 'INQUIRY SERVICE', 'LINCOLN SEGUM'],
          ),
          _buildHistoryItem(
            date: '3DDS',
            items: ['Menu'],
          ),
          const SizedBox(height: 16),
          const LowerBar(),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({required String date, required List<String> items}) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
