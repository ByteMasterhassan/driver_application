import 'package:flutter/material.dart';

class DashboardSection extends StatefulWidget {
  final Map<String, dynamic>? dashboardData;

  const DashboardSection({super.key, this.dashboardData});

  @override
  State<DashboardSection> createState() => _DashboardSectionState();
}

class _DashboardSectionState extends State<DashboardSection> {
  @override
  Widget build(BuildContext context) {
    // If we have data passed from parent, use it directly
    if (widget.dashboardData != null) {
      return _buildContent(widget.dashboardData!);
    }

    // Otherwise show no data state
    return _buildNoDataState();
  }

  Widget _buildContent(Map<String, dynamic> dashboardData) {
    final dailyEarnings = dashboardData['dailyEarnings'] ?? 0;
    final weeklyEarnings = dashboardData['weeklyEarnings'] ?? 0;
    final totalEarnings = dashboardData['totalEarnings'] ?? 0;

    return Column(
      children: [
        _buildSectionHeader("Quick Overview"),
        const SizedBox(height: 16),
        _statsRow(dailyEarnings, weeklyEarnings),
        const SizedBox(height: 20),
        _walletCard(context, totalEarnings),
        const SizedBox(height: 20),
        _buildSectionHeader("Current Trip"),
        const SizedBox(height: 12),
        _currentTripCard(context),
        const SizedBox(height: 20),
        _buildSectionHeader("Recent Trips"),
        const SizedBox(height: 12),
        _recentTripCard(),
      ],
    );
  }

  Widget _buildNoDataState() {
    return Column(
      children: [
        _buildSectionHeader("Quick Overview"),
        const SizedBox(height: 16),
        _buildNoDataStats(),
      ],
    );
  }

  Widget _statsRow(double dailyEarnings, double weeklyEarnings) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            title: "Today",
            value: "\$${dailyEarnings.toStringAsFixed(2)}",
            subtitle: "Earnings",
            icon: Icons.today,
            color: const Color(0xFFFFD700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            title: "This Week",
            value: "\$${weeklyEarnings.toStringAsFixed(2)}",
            subtitle: "Earnings",
            icon: Icons.calendar_view_week,
            color: const Color(0xFFD7B65D),
          ),
        ),
      ],
    );
  }

  Widget _walletCard(BuildContext context, double totalEarnings) {
    return _goldBorderCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${totalEarnings.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0x15FFD700),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFFFFD700),
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _walletActionButton(
                    context,
                    'Withdraw',
                    Icons.arrow_upward,
                    const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _walletActionButton(
                    context,
                    'Pending',
                    Icons.pending,
                    const Color(0xFFFFA000),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataStats() {
    return _goldBorderCard(
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return _goldBorderCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentTripCard(BuildContext context) {
    return _goldBorderCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFFD700), width: 2),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Megan Fox',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                          const SizedBox(width: 4),
                          const Text(
                            '4.8',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0x154CAF50),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '15 min away',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _actionIconButton(
                  context,
                  Icons.navigation,
                  'Navigate',
                  const Color(0xFFFFD700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFD7B65D)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trip in progress...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  '32% completed',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentTripCard() {
    return _goldBorderCard(
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              image: const DecorationImage(
                image: NetworkImage('https://via.placeholder.com/400x120.png?text=Trip+Route'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=2'),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jon Doe',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Downtown to Airport',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '\$500',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0x1532CD32),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF32CD32),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletActionButton(BuildContext context, String text, IconData icon, Color color) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text clicked')));
        },
      ),
    );
  }

  Widget _actionIconButton(BuildContext context, IconData icon, String tooltip, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$tooltip clicked')));
        },
      ),
    );
  }

  Widget _goldBorderCard({required Widget child}) {
    return Card(
      color: const Color(0xFF1A1A1A).withOpacity(0.95),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD7B65D),
        ),
      ),
    );
  }
}