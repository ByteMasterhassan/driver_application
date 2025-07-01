import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../lower_bar/lower_bar.dart';

class WalletAccountScreen extends StatelessWidget {
  const WalletAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Wallet', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildLastMonthSummary(),
            const SizedBox(height: 24),
            _buildWalletBalance(),
            const SizedBox(height: 24),
            _buildChartPlaceholder(),
            const SizedBox(height: 24),
            _buildWithdrawalHistory(),
            const SizedBox(height: 24),
            const LowerBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildLastMonthSummary() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Last Month',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('\$ 12,491.22',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('244 Miles', Icons.directions_car),
              _buildStatItem('255 min', Icons.timer),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.amber),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }

  Widget _buildWalletBalance() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Wallet Balance',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 8),
          Text('\$ 1544.00',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 8),
          Text('USD/Annual',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text('Earnings Overview',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 16),
          SizedBox(height: 200, child: CustomPaint(painter: _ChartPainter())),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('No', style: TextStyle(color: Colors.white70)),
              Text('T1', style: TextStyle(color: Colors.white70)),
              Text('Mt', style: TextStyle(color: Colors.white70)),
              Text('Th', style: TextStyle(color: Colors.white70)),
              Text('F7', style: TextStyle(color: Colors.white70)),
              Text('S8', style: TextStyle(color: Colors.white70)),
              Text('S6', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalHistory() {
    final withdrawals = [
      {'date': '14/04/2021 14:24 AM', 'amount': '\$110'},
      {'date': '34/06/2021 22:30 AM', 'amount': '\$224'},
      {'date': '11/04/2021 16:20 AM', 'amount': '\$300'},
      {'date': '11/04/2021 16:20 AM', 'amount': '\$300'},
      {'date': '11/04/2021 16:20 AM', 'amount': '\$300'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Withdrawal History',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: withdrawals.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey[800]),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(withdrawals[index]['date']!,
                      style: const TextStyle(color: Colors.white70)),
                  Text(withdrawals[index]['amount']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.amber)),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text('View All', style: TextStyle(color: Colors.amber)),
          ),
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.amber.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.7),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.5),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    for (var point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    final filledPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(filledPath, fillPaint);
    canvas.drawPath(path, paint);

    final pointPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
