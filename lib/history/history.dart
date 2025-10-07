import 'package:flutter/material.dart';
import '../history/history_service/history_service.dart';
import '../lower_bar/lower_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('History', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: _futureRides,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final rides = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              final date = ride['createdAt'] ?? 'N/A';
              final pickup = ride['pickup_location'] ?? 'Unknown';
              final drop = ride['dropoff_location'] ?? 'Unknown';

              return _buildHistoryItem(
                date: date.toString(),
                items: [
                  'Pickup: $pickup',
                  'Drop: $drop',
                  'Status: Completed ✅',
                ],
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
    required List<String> items,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
