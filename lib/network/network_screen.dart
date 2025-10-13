import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lower_bar/lower_bar.dart';
import '../network/network_service/network_service.dart';
import '../dashboard_screen/dashboard_components/sidebar.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  List<Map<String, dynamic>> rides = [];
  bool isLoading = true;
  String? errorMessage;
  int? currentDriverId;

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Future<void> _loadRides() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      currentDriverId = prefs.getInt('driverId');

      final data = await NetworkService.fetchExposedRides();
      setState(() {
        rides = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _acceptRide(int rideId) async {
    try {
      final result = await NetworkService.acceptRide(rideId);
      if (result['success']) {
        setState(() {
          rides.removeWhere((ride) => ride['id'] == rideId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride accepted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to accept ride')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showAcceptConfirmation(int rideId) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.amber, size: 50),
                const SizedBox(height: 12),
                const Text(
                  "Accept Ride?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Are you sure you want to accept this ride from the network?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _acceptRide(rideId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Yes, Accept",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Network', style: TextStyle(color: Colors.white)),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : rides.isEmpty
                  ? const Center(
                      child: Text(
                        "No exposed rides found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadRides,
                      color: Colors.amber,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: rides.length,
                        itemBuilder: (context, index) {
                          final ride = rides[index];
                          return _buildRideCard(ride);
                        },
                      ),
                    ),
      bottomNavigationBar: const LowerBar(),
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    final isSelfExposed = ride['driver_id'] == currentDriverId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD700), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pickup Date: ${ride['pickup_date'] ?? ''}",
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ride['pickup_location'] ?? 'N/A',
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_pin, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ride['dropoff_location'] ?? 'N/A',
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.amber),
              const SizedBox(width: 8),
              Text(ride['pickup_time'] ?? '', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.amber),
              const SizedBox(width: 8),
              Text(ride['service_type'] ?? '', style: const TextStyle(color: Colors.white)),
              const Spacer(),
              Text(
                "\$${ride['total_price'] ?? 0}",
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Show info if self-exposed
          if (isSelfExposed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "You exposed this ride",
                  style: TextStyle(color: Colors.amber, fontSize: 12),
                ),
              ),
            ),

          const Divider(color: Colors.white24),

          // Accept button (always active, even for self-exposed)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () async {
                await _showAcceptConfirmation(ride['id']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Accept Ride",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
