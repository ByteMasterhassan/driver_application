import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../history/history_service/history_service.dart';
import '../lower_bar/lower_bar.dart';
import '../dashboard_screen/dashboard_components/sidebar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _futureRides;

  @override
  void initState() {
    super.initState();
    _futureRides = HistoryService.fetchCompletedRides();
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('EEE, MMM d • hh:mm a').format(date); // e.g. Tue, Oct 1 • 03:45 PM
    } catch (_) {
      return 'Unknown Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Ride History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Sidebar(),
      body: FutureBuilder(
        future: _futureRides,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No completed rides found',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          final rides = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              final date = _formatDate(ride['createdAt'] ?? '');
              final pickup = ride['pickup_location'] ?? 'Unknown';
              final drop = ride['dropoff_location'] ?? 'Unknown';
              final fare = ride['totalPrice']?.toString() ?? 'N/A';

              return _buildHistoryItem(
                date: date,
                pickup: pickup,
                drop: drop,
                fare: fare,
              );
            },
          );
        },
      ),
      bottomNavigationBar: const LowerBar(),
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String pickup,
    required String drop,
    required String fare,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Date + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green, width: 0.8),
                  ),
                  child: const Text(
                    "Completed",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Pickup & Drop section
            Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.orangeAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pickup,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.blueAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    drop,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // const Divider(height: 20, color: Colors.white10),

            // Fare row
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       "Total Fare:",
            //       style: TextStyle(color: Colors.white60, fontSize: 13),
            //     ),
            //     Text(
            //       "PKR $fare",
            //       style: const TextStyle(
            //         color: Color(0xFFD4AF37),
            //         fontWeight: FontWeight.bold,
            //         fontSize: 14,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
