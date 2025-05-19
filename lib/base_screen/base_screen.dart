import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? drawer;

  const BaseScreen({
    Key? key,
    required this.child,
    this.title,
    this.drawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      backgroundColor: Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Curved blue top background
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          // Manual AppBar with hamburger menu
          SafeArea(
            child: Builder(
                builder: (context) => Row(
                children: [
                    IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                        Scaffold.of(context).openDrawer(); // This now works
                    },
                    ),
                    SizedBox(width: 8),
                    Text(
                    title ?? '',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                    ),
                    ),
                ],
                ),
            ),
            ),

          // Main child content
          Padding(
            padding: const EdgeInsets.only(top: 140), // pushes content down from under header
            child: Center(child: child), // <-- centers the dashboard screen text
          ),
        ],
      ),
    );
  }
}
