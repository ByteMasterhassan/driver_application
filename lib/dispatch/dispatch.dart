import 'package:flutter/material.dart';
import '../lower_bar/lower_bar.dart';
import '../dispatch/dispatch_service/dispatch_service.dart';

class DispatchScreen extends StatefulWidget {
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
      final success = await DispatchService.changeRideStatus(rideId, flag);
      if (success) {
        if (flag == 'completed') {
          // Remove completed ride from list
          setState(() {
            _rides.removeWhere((r) => (r['ride_id'] ?? r['id']) == rideId);
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status changed to $flag')),
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
          title: const Text('Change Ride Status', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusButton('dispatched'),
              _buildStatusButton('arrived'),
              _buildStatusButton('pickup'),
              _buildStatusButton('completed'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(String flag) {
    return ListTile(
      title: Text(flag.toUpperCase(), style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.pop(context, flag),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        title: const Text("Dispatch", style: TextStyle(color: Colors.white)),
        actions: [
          Row(
            children: const [
              Text("Sort by: ", style: TextStyle(color: Colors.grey)),
              Text("Weekly", style: TextStyle(color: Colors.white)),
              Icon(Icons.keyboard_arrow_down, color: Colors.white),
              SizedBox(width: 10)
            ],
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureRides,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No dispatched rides found', style: TextStyle(color: Colors.white)));
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
                    Text(
                      ride['pickup_date'] ?? 'Unknown Date',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text("From ${ride['pickup_location'] ?? 'N/A'}", style: const TextStyle(color: Colors.white)),
                        const Spacer(),
                        const Icon(Icons.location_pin, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text("To ${ride['dropoff_location'] ?? 'N/A'}", style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.directions_car, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text("${ride['service_type'] ?? 'Unknown'}", style: const TextStyle(color: Colors.white)),
                        const Spacer(),
                        Text("\$${ride['total_price'] ?? 0}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _changeStatus(rideId),
                      child: const Text('Change Status', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: LowerBar(),
    );
  }
}
