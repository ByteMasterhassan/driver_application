import 'package:flutter/material.dart';

class LowerBar extends StatelessWidget {
  const LowerBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(top: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBarItem(Icons.person, 'Name'),
          _buildBarItem(Icons.history, 'History'),
          _buildBarItem(Icons.store, 'Market'),
          _buildBarItem(Icons.account_circle, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBarItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}