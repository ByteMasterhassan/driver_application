import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lower_bar/lower_bar.dart';
import '../accounts/account_service/account_service.dart';

class WalletAccountScreen extends StatefulWidget {
  const WalletAccountScreen({super.key});

  @override
  State<WalletAccountScreen> createState() => _WalletAccountScreenState();
}

class _WalletAccountScreenState extends State<WalletAccountScreen> {
  final AccountService _accountService = AccountService();

  double totalEarnings = 0.0;
  Map<String, int> weeklyChartData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccountData();
  }

  Future<void> _fetchAccountData() async {
    try {
      final data = await _accountService.fetchDriverAccountData();

      setState(() {
        totalEarnings = data['totalEarnings'];
        weeklyChartData = data['weeklyChartData'];
        isLoading = false;
      });
    } catch (e) {
      print('❌ Failed to load account data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  _buildTotalEarningsCard(
                      currentMonth, '\$${totalEarnings.toStringAsFixed(2)}'),
                  const SizedBox(height: 24),
                  _buildChartSection(weeklyChartData),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      bottomNavigationBar: const LowerBar(),
    );
  }

  Widget _buildTotalEarningsCard(String month, String amount) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(month,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            amount,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 6),
          const Text('Total Earnings',
              style: TextStyle(color: Colors.amber, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildChartSection(Map<String, int> chartData) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Earnings Overview',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: CustomPaint(
              painter: _DynamicChartPainter(chartData),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Mon', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Tue', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Wed', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Thu', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Fri', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Sat', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Sun', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DynamicChartPainter extends CustomPainter {
  final Map<String, int> data;
  _DynamicChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.amber.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = days.map((d) => (data[d] ?? 0).toDouble()).toList();

    final maxVal = (values.reduce((a, b) => a > b ? a : b)) + 1;
    final stepX = size.width / (values.length - 1);

    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final double x = i * stepX;
      final double y = size.height - (values[i] / maxVal * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
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

    for (int i = 0; i < values.length; i++) {
      final double x = i * stepX;
      final double y = size.height - (values[i] / maxVal * size.height);
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
