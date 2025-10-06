import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../quotes/quotes_service/quotes_service.dart';
import '../lower_bar/lower_bar.dart';

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

  Future<void> _handleRideDecision(int rideId, bool acceptRide) async {
    await _quotesService.updateRideStatus(rideId, acceptRide);

    // remove from list instantly after action
    setState(() {
      _rides.removeWhere((r) => r['id'] == rideId);
    });
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
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        title: const Text(
          "Quotes",
          style: TextStyle(color: Colors.white),
        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _rides.length,
                  itemBuilder: (context, index) {
                    final ride = _rides[index];
                    final formattedDate = DateFormat('dd MMM yyyy').format(
                        DateTime.parse(ride['createdAt']).toLocal());

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFFFD700), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.amber),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("From ${ride['pickup_location']}",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  color: Colors.amber),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("To ${ride['dropoff_location']}",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.amber),
                              const SizedBox(width: 8),
                              Text(
                                  "${ride['pickup_date']} at ${ride['pickup_time']}",
                                  style:
                                      const TextStyle(color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.directions_car,
                                  color: Colors.amber),
                              const SizedBox(width: 8),
                              Text(
                                  ride['service_type'] ?? "Service Unavailable",
                                  style:
                                      const TextStyle(color: Colors.white)),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green, size: 30),
                                onPressed: () => _handleRideDecision(
                                    ride['id'], true),
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.red, size: 30),
                                onPressed: () => _handleRideDecision(
                                    ride['id'], false),
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
