import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // 👈 add this
import '../../lower_bar/lower_bar.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'dart:ui_web' as ui; // 👈 required for platformViewRegistry
// import 'dart:html';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Color(0xFFD7B65D), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1C1C1C), Color(0xFF0D0D0D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TripOperatorSection(),
            SizedBox(height: 24),
            DashboardSection(),
            SizedBox(height: 24),
            // const LiveLocationSection(), // 👈 new section at bottom
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const LowerBar(),
    );
  }
}

class TripOperatorSection extends StatelessWidget {
  const TripOperatorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Оператор Trip',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD7B65D),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: const [
            Text('Управляемый', style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(width: 8),
            VerticalDivider(color: Colors.grey, thickness: 1),
            SizedBox(width: 8),
            Text('от 12', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 8),
        const Text('Оператор Trip (3)', style: TextStyle(fontSize: 16, color: Colors.white)),
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
        _buildSectionHeader("Earnings Overview"),
        _todayCard(),
        const SizedBox(height: 16),
        _walletCard(context),
        const SizedBox(height: 24),
        _buildSectionHeader("Trips"),
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
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
              radius: 28,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Navigate'),
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
          Image.network(
            'https://via.placeholder.com/400x140.png?text=Trip+Map',
            fit: BoxFit.cover,
            height: 140,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=2'),
                  radius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Jon Doe', style: TextStyle(fontSize: 16, color: Colors.white)),
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text clicked')));
        },
      ),
    );
  }

  static Widget _goldBorderCard({required Widget child}) {
    return Card(
      color: const Color(0xFF1A1A1A).withOpacity(0.95),
      elevation: 6,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFFFD700), width: 1),
      ),
      child: child,
    );
  }

  static Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD7B65D)),
        ),
      ),
    );
  }
}

/// 🗺️ New Live Location Section
// class LiveLocationSection extends StatelessWidget {
//   const LiveLocationSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Register view type for iframe
//     ui.platformViewRegistry.registerViewFactory(
//       'map-view',
//       (int viewId) => IFrameElement()
//         ..src =
//             "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3153.019153484721!2d-122.4194!3d37.7749!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8085809c2baa1a25%3A0x9f5b4e26f!2sSan%20Francisco!5e0!3m2!1sen!2sus!4v1688598765432"
//         ..style.border = 'none',
//     );
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Live Location",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFFD7B65D),
//           ),
//         ),
//         const SizedBox(height: 12),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(14),
//           child: SizedBox(
//             height: 200,
//             child: HtmlElementView(viewType: 'map-view'), // ✅ fixed
//           ),
//         ),
//       ],
//     );
//   }
// }