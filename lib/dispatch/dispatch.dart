import 'package:flutter/material.dart';
import '../lower_bar/lower_bar.dart';
import '../dispatch/dispatch_service/dispatch_service.dart';
import '../dashboard_screen/dashboard_components/sidebar.dart';

class DispatchScreen extends StatefulWidget {
  const DispatchScreen({super.key});

  @override
  State<DispatchScreen> createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> {
  late Future<List<Map<String, dynamic>>> _futureRides;
  List<Map<String, dynamic>> _rides = [];

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  void _loadRides() {
    setState(() {
      _futureRides = DispatchService.fetchDispatchedRides();
    });
  }

  Future<void> _changeStatus(int rideId) async {
    final flag = await _showStatusDialog();

    if (flag != null) {
      final confirmed = await _showConfirmationDialog(flag);
      if (!confirmed) return;

      final success = await DispatchService.changeRideStatus(rideId, flag);
      if (success) {
        if (flag == 'completed') {
          setState(() {
            _rides.removeWhere((r) => (r['ride_id'] ?? r['id']) == rideId);
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status changed to $flag')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to change status')),
        );
      }
    }
  }

  Future<String?> _showStatusDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Change Ride Status',
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusTile('dispatched', Icons.local_shipping),
              _buildStatusTile('arrived', Icons.location_on),
              _buildStatusTile('pickup', Icons.directions_car),
              _buildStatusTile('completed', Icons.check_circle),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusTile(String flag, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(
        flag.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () => Navigator.pop(context, flag),
    );
  }

  Future<bool> _showConfirmationDialog(String status) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Confirm Action',
                style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            content: Text(
              'This will change the ride status to "$status".\nAre you sure you want to proceed?',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirm', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Dispatch', style: TextStyle(color: Colors.white)),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureRides,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No dispatched rides found',
                    style: TextStyle(color: Colors.white70)));
          }

          _rides = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: _rides.length,
            itemBuilder: (context, index) {
              final ride = _rides[index];
              final rideId = ride['ride_id'] ?? ride['id'];

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
                    // Dater
                    Text(
                      // ride['pickup_date'] ?? 'Unknown Date',
                      "Pickup Date: ${ride['pickup_date'] ?? ''}",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),

                    // From & To
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "From: ${ride['pickup_location'] ?? 'N/A'}",
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
                            "To: ${ride['dropoff_location'] ?? 'N/A'}",
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Ride Type and Price
                    Row(
                      children: [
                        const Icon(Icons.directions_car, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          ride['service_type'] ?? 'Unknown',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          "\$${ride['total_price'] ?? 0}",
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(color: Colors.white24),

                    // Change Status Button (aligned right)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => _changeStatus(rideId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Change Status",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const LowerBar(),
    );
  }
}
