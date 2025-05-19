import 'package:flutter/material.dart';
import '../dashboard_screen/components/dashboard_sections.dart';
import '../dashboard_screen/service/dashboard_service.dart';
import 'components/sidebar.dart';
import '../base_screen/base_screen.dart';
import '../lower_bar/lower_bar.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardService dashboardService;

  const DashboardScreen({Key? key, required this.dashboardService}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardData> _dashboardData;

  @override
  void initState() {
    super.initState();
    _dashboardData = widget.dashboardService.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Dashboard",
      drawer: Sidebar(),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<DashboardData>(
              future: _dashboardData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final data = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Today's Earnings Section
                      DashboardCard(
                        title: 'Today',
                        value: '\$${data.todayEarnings}',
                        subtitle: data.todayDateSuffix,
                      ),
                      const SizedBox(height: 16),
                      
                      // Wallet Balance Section
                      DashboardCard(
                        title: 'Wallet Balance',
                        value: '\$${data.walletBalance}',
                        actionText: 'Withdrawal',
                        onActionPressed: () {
                          // Handle withdrawal action
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Pending Task Button
                      DashboardActionButton(
                        text: 'View Pending Task (${data.pendingTasksCount})',
                        onPressed: () {
                          // Handle view pending task
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Ongoing Trip Section
                      SectionHeader(
                        title: 'Ongoing Trip',
                        actionText: 'Navigation',
                        onActionPressed: () {
                          // Handle navigation action
                        },
                      ),
                      const SizedBox(height: 8),
                      if (data.ongoingTrip != null)
                        LegendBox(
                          items: [
                            LegendItem(
                              color: Colors.red, 
                              label: 'Pickup: ${data.ongoingTrip!.pickupLocation}',
                            ),
                            LegendItem(
                              color: Colors.green, 
                              label: 'Destination: ${data.ongoingTrip!.destination}',
                            ),
                          ],
                        )
                      else
                        const Text('No ongoing trip', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      
                      // Upcoming Trips Section
                      SectionHeader(
                        title: 'Upcoming Trip (${data.upcomingTrips.length})',
                        actionText: 'Previous Trip',
                        onActionPressed: () {
                          // Handle previous trip action
                        },
                      ),
                      const SizedBox(height: 8),
                      if (data.upcomingTrips.isNotEmpty)
                        ...data.upcomingTrips.map((trip) => Column(
                          children: [
                            TripCard(
                              time: trip.time,
                              destination: trip.destination,
                              total: trip.total,
                              onTap: () {
                                // Handle trip card tap
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        )).toList()
                      else
                        const Text('No upcoming trips', textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
          LowerBar(),  // Keep the lower bar at the bottom
        ],
      ),
    );
  }
}