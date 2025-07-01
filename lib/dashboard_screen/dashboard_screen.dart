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
            child: FutureBuilder<DashboardData>(
              future: _dashboardData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                final data = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      DashboardSection(), // Custom dark-themed component
                      SizedBox(height: 20),
                      // More DashboardSection widgets can be added here
                    ],
                  ),
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
