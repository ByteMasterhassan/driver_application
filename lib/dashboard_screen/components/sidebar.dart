// dashboard_screen/components/sidebar.dart
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle the Home click event
              Navigator.pushReplacementNamed(context, '/Home');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Accounts'),
            onTap: () {
              // Handle Profile click event
              Navigator.pushReplacementNamed(context, '/Accounts');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Reservation'),
            onTap: () {
              // Handle Settings click event
              Navigator.pushReplacementNamed(context, '/Reservation');
            },
          ),
          ListTile(
            leading: Icon(Icons.local_shipping),
            title: Text('Dispatch'),
            onTap: () {
              // Handle Settings click event
              Navigator.pushReplacementNamed(context, '/Dispatch');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Billing'),
            onTap: () {
              // Handle Settings click event
              Navigator.pushReplacementNamed(context, '/Billing');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Handle Settings click event
              Navigator.pushReplacementNamed(context, '/Notifications');
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_chart),
            title: Text('Reports'),
            onTap: () {
              // Handle Settings click event
              Navigator.pushReplacementNamed(context, '/Reports');
            },
          ),
          // Add more items here as needed
        ],
      ),
    );
  }
}
