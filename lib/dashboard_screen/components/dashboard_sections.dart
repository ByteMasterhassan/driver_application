import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            TripOperatorSection(),
            SizedBox(height: 24),
            DashboardSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xFFFFD700),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class TripOperatorSection extends StatelessWidget {
  const TripOperatorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Оператор Trip',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Text('Управляемый', style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(width: 8),
            VerticalDivider(color: Colors.grey, thickness: 1),
            SizedBox(width: 8),
            Text('от 12', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        SizedBox(height: 16),
        Divider(thickness: 1, color: Colors.grey),
        SizedBox(height: 8),
        Text('Оператор Trip (3)', style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _todayCard(),
        const SizedBox(height: 16),
        _walletCard(context),
        const SizedBox(height: 16),
        _ongoingTripCard(context),
        const SizedBox(height: 16),
        _previousTripCard(),
      ],
    );
  }

  static Widget _todayCard() {
    return _goldBorderCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('\$ 244.00',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            _buildCheckRow('At Rides'),
            const SizedBox(height: 8),
            _buildCheckRow('23/1'),
          ],
        ),
      ),
    );
  }

  static Widget _walletCard(BuildContext context) {
    return _goldBorderCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wallet Balance', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('\$ 1544.00',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            _buildActionButton(context, 'View Pending Tasks', Icons.task, Color(0xFFFFD700)),
            const SizedBox(height: 12),
            _buildActionButton(context, 'Withdrawal', Icons.account_balance_wallet, Colors.green),
          ],
        ),
      ),
    );
  }

  static Widget _ongoingTripCard(BuildContext context) {
    return _goldBorderCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/megan_fox.jpg'),
              radius: 24,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Megan Fox',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('⭐ 4.8', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigation clicked')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD700),
                foregroundColor: Colors.black,
              ),
              child: const Text('Navigation'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _previousTripCard() {
    return _goldBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/trip_map.png',
            fit: BoxFit.cover,
            height: 120,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/jon_doe.jpg'),
                  radius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Jon doe', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                Text('Total : \$500',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildCheckRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Color(0xFFFFD700), size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }

  static Widget _buildActionButton(BuildContext context, String text, IconData icon, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(text, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text clicked')));
        },
      ),
    );
  }

  static Widget _goldBorderCard({required Widget child}) {
    return Card(
      color: const Color(0xFF1A1A1A),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFFFD700), width: 1),
      ),
      child: child,
    );
  }
}
