import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF121212), // top dark (same as BaseScreen background)
              Color(0xFF1F1F1F), // bottom slightly lighter dark
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1C1C1C), // same as BaseScreen curved top start
                    Color(0xFF2A2A2A), // same as BaseScreen curved top end
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Color(0xFFD7B65D), // gold accent color
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
              icon: Icons.account_circle,
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
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String text,
    required String route,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFD7B65D)), // gold icon color
      title: Text(
        text,
        style: const TextStyle(color: Colors.white), // white text color
      ),
      hoverColor: const Color(0xFF1C1C1C), // hover effect similar to curved top
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
