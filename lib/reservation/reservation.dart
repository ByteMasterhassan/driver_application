import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reservation/reservation_service/reservation_service.dart';
import '../lower_bar/lower_bar.dart';

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
    builder: (context) {
      return SimpleDialog(
        title: const Text('Change Ride Status'),
        children: [
          _buildStatusOption(context, rideId, 'dispatched'),
          _buildStatusOption(context, rideId, 'arrived'),
          _buildStatusOption(context, rideId, 'pickup'),
          _buildStatusOption(context, rideId, 'completed'),
        ],
      );
    },
  );

  if (selected != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status changed to "$selected"')),
    );
  }
}

Widget _buildStatusOption(BuildContext context, int rideId, String flag) {
  return SimpleDialogOption(
    onPressed: () async {
      Navigator.pop(context, flag);
      try {
        final result = await ReservationService.changeRideStatus(rideId, flag);
        if (result['success']) {
          setState(() {
            // ✅ Remove ride from list if dispatched
            if (flag == 'dispatched') {
              rides.removeWhere((ride) => ride['id'] == rideId || ride['ride_id'] == rideId);
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
    },
    child: Text(flag.toUpperCase()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        elevation: 0,
        title: const Text(
          "Reservation",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : errorMessage != null
              ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
              : rides.isEmpty
                  ? const Center(child: Text("No accepted rides found", style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ride['pickup_date'] ?? '',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => _changeStatus(ride['ride_id'] ?? ride['id']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Change Status", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
