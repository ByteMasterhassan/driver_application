import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../quotes/quotes_service/quotes_service.dart';
import '../lower_bar/lower_bar.dart';
import '../dashboard_screen/dashboard_components/sidebar.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final QuotesService _quotesService = QuotesService();
  List<dynamic> _rides = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Future<void> _loadRides() async {
    try {
      final rides = await _quotesService.fetchRidesForDriver();
      setState(() {
        _rides = rides.where((r) => r['accept_ride'] == false).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Failed to load rides: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmRideDecision(int rideId, bool acceptRide) async {
    final action = acceptRide ? 'accept' : 'delete';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          acceptRide ? 'Accept Ride?' : 'Delete Ride?',
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        content: Text(
          acceptRide
              ? 'Are you sure you want to accept this ride?'
              : 'Are you sure you want to delete this ride?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: acceptRide ? Colors.green : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              acceptRide ? 'Accept' : 'Delete',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _handleRideDecision(rideId, acceptRide);
    }
  }

  Future<void> _handleRideDecision(int rideId, bool acceptRide) async {
    await _quotesService.updateRideStatus(rideId, acceptRide);
    setState(() {
      _rides.removeWhere((r) => r['id'] == rideId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Quotes', style: TextStyle(color: Colors.white)),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _rides.isEmpty
              ? const Center(
                  child: Text(
                    "No pending rides found",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _rides.length,
                  itemBuilder: (context, index) {
                    final ride = _rides[index];
                    final formattedDate = DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(ride['createdAt']).toLocal());

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
                          // Created Date
                          Text(
                            "Created Date: $formattedDate",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // From - To Section
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "From: ${ride['pickup_location']}",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.flag, color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "To: ${ride['dropoff_location']}",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Pickup Date & Time
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "Pickup: ${ride['pickup_date']} at ${ride['pickup_time']}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Ride Type & Price
                          Row(
                            children: [
                              const Icon(Icons.directions_car, color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                ride['service_type'] ?? "Service Unavailable",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Spacer(),
                              Text(
                                "\$${ride['total_price']}",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(color: Colors.white24),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 10),
                                ),
                                icon: const Icon(Icons.check, color: Colors.white),
                                label: const Text(
                                  'Accept',
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () =>
                                    _confirmRideDecision(ride['id'], true),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 10),
                                ),
                                icon: const Icon(Icons.close, color: Colors.white),
                                label: const Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () =>
                                    _confirmRideDecision(ride['id'], false),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
      bottomNavigationBar: const LowerBar(),
    );
  }
}
