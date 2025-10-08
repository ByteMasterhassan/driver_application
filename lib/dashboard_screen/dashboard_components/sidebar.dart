import 'package:flutter/material.dart';
import '../../login_screen/login_screen.dart'; // <-- make sure path is correct

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF121212),
              Color(0xFF1F1F1F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // ===== Custom Header with Profile =====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Color(0xFF1C1C1C),
                //     Color(0xFF2A2A2A),
                //   ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(40),
                //   bottomRight: Radius.circular(40),
                // ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/images/profile.png"), 
                    // <-- replace with actual profile image
                  ),
                  SizedBox(height: 10),
                  Text(
                    "John Doe", // dummy username
                    style: TextStyle(
                      color: Color(0xFFD7B65D),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ===== Menu Items =====
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildTile(
                    icon: Icons.home,
                    text: 'Home',
                    route: '/dashboard',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.account_circle,
                    text: 'Accounts',
                    route: '/account',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.history,
                    text: 'Network',
                    route: '/network',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.assignment,
                    text: 'Quotes',
                    route: '/quotes',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.calendar_today,
                    text: 'Reservation',
                    route: '/reservation',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.local_shipping,
                    text: 'Dispatch',
                    route: '/dispatch',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.history,
                    text: 'History',
                    route: '/history',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.payment,
                    text: 'Calendar',
                    route: '/calender',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.notifications,
                    text: 'Notifications',
                    route: '/notification',
                    context: context,
                  ),
                  _buildTile(
                    icon: Icons.insert_chart,
                    text: 'Reports',
                    route: '/report',
                    context: context,
                  ),
                ],
              ),
            ),

            // ===== Logout Button at Bottom =====
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()), // <-- your login
                      (route) => false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String text,
    required String route,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFD7B65D)),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      hoverColor: const Color(0xFF1C1C1C),
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
