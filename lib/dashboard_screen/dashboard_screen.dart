import 'package:flutter/material.dart';
import '../dashboard_screen/dashboard_components/dashboard_sections.dart';
import '../dashboard_screen/service/dashboard_service.dart';
import 'dashboard_components/sidebar.dart';
import '../base_screen/base_screen.dart';
import '../lower_bar/lower_bar.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardService dashboardService;

  const DashboardScreen({Key? key, required this.dashboardService}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _dashboardData;

  @override
  void initState() {
    super.initState();
    _dashboardData = widget.dashboardService.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Sidebar(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _dashboardData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
                }

                if (snapshot.hasError) {
                  return SingleChildScrollView( // Add scroll to error state too
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.redAccent),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _dashboardData = widget.dashboardService.fetchDashboardData();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4AF37),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // FIX: Use ListView instead of Column inside SingleChildScrollView
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    DashboardSection(dashboardData: snapshot.data!),
                    const SizedBox(height: 20),
                    // More DashboardSection widgets can be added here
                  ],
                );
              },
            ),
          ),
          const LowerBar(),
        ],
      ),
    );
  }
}