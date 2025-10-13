import 'package:flutter/material.dart';
import '../reservation/reservation_service/reservation_service.dart';
import '../lower_bar/lower_bar.dart';
import '../dashboard_screen/dashboard_components/sidebar.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<Map<String, dynamic>> rides = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Future<void> _loadRides() async {
    try {
      final data = await ReservationService.fetchAcceptedRides();
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

  Future<void> _changeStatus(int rideId) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => _buildActionDialog(context, rideId),
    );

    if (selected != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action performed: "$selected"')),
      );
    }
  }

  Widget _buildActionDialog(BuildContext context, int rideId) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Select Action',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusOption(context, rideId, 'dispatched', Icons.local_shipping),
          _buildStatusOption(context, rideId, 'arrived', Icons.location_on),
          _buildStatusOption(context, rideId, 'pickup', Icons.directions_car),
          _buildStatusOption(context, rideId, 'completed', Icons.done_all),
          const Divider(color: Colors.white24, height: 25),
          _buildExposeOption(context, rideId),
        ],
      ),
    );
  }

  Widget _buildStatusOption(
      BuildContext context, int rideId, String flag, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(flag.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      onTap: () async {
        final confirmed = await _showConfirmDialog(
          context,
          title: "Change Status",
          message: "Are you sure you want to mark this ride as '$flag'?",
          confirmColor: Colors.teal,
        );
        if (confirmed == true) {
          Navigator.pop(context, flag);
          await _updateRideStatus(rideId, flag);
        }
      },
    );
  }

  Widget _buildExposeOption(BuildContext context, int rideId) {
    return ListTile(
      leading: const Icon(Icons.public, color: Colors.orange),
      title: const Text("Expose to Network",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
      onTap: () async {
        final confirmed = await _showConfirmDialog(
          context,
          title: "Expose Ride",
          message:
              "Are you sure you want to expose this ride to the network?",
          confirmColor: Colors.orange,
        );
        if (confirmed == true) {
          Navigator.pop(context, 'expose');
          await _exposeRide(rideId);
        }
      },
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context,
      {required String title,
      required String message,
      required Color confirmColor}) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(
                color: Colors.amber, fontWeight: FontWeight.bold)),
        content: Text(message,
            style: const TextStyle(color: Colors.white70, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateRideStatus(int rideId, String flag) async {
    try {
      final result = await ReservationService.changeRideStatus(rideId, flag);
      if (result['success']) {
        setState(() {
          if (flag == 'dispatched') {
            rides.removeWhere((ride) =>
                ride['id'] == rideId || ride['ride_id'] == rideId);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to "$flag"')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _exposeRide(int rideId) async {
    try {
      final result = await ReservationService.exposeRideToNetwork(rideId);
      if (result['success']) {
        setState(() {
          rides.removeWhere(
              (ride) => ride['id'] == rideId || ride['ride_id'] == rideId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride exposed to network')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to expose ride')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exposing ride: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Reservation', style: TextStyle(color: Colors.white)),
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
                  child: Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                )
              : rides.isEmpty
                  ? const Center(
                      child: Text("No accepted rides found",
                          style: TextStyle(color: Colors.white70)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: rides.length,
                      itemBuilder: (context, index) {
                        final ride = rides[index];
                        return _buildRideCard(ride);
                      },
                    ),
      bottomNavigationBar: const LowerBar(),
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD700), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Text(
            "Pickup Date: ${ride['pickup_date'] ?? ''}",
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          // Pickup Location
          Row(
            children: [
              const Icon(Icons.my_location, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "From: ${ride['pickup_location'] ?? 'N/A'}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Dropoff Location
          Row(
            children: [
              const Icon(Icons.flag, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "To: ${ride['dropoff_location'] ?? 'N/A'}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Pickup Time
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text("Time: ${ride['pickup_time'] ?? ''}",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),

          // Service & Price
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(ride['service_type'] ?? 'Unknown',
                  style: const TextStyle(color: Colors.white)),
              const Spacer(),
              Text(
                "\$${ride['total_price'] ?? 0}",
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),

          // Action Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _changeStatus(ride['ride_id'] ?? ride['id']),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text("Change Status",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
