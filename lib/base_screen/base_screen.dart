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
      backgroundColor: Colors.black, // fallback in case gradient fails
      body: Stack(
        children: [
          // Full screen dark gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.26, 1.0],
                colors: [
                  Color(0xFF121212), // top dark
                  Color(0xFF1F1F1F), // bottom slightly lighter dark
                ],
              ),
            ),
          ),

          // Curved top dark gradient
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.26, 1.0],
                colors: [
                  Color(0xFF1C1C1C),
                  Color(0xFF2A2A2A),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          // Custom AppBar with menu and title
          SafeArea(
            child: Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content below AppBar
          Padding(
            padding: const EdgeInsets.only(top: 140),
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}
