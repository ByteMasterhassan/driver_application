import 'package:flutter/material.dart';
import '../lower_bar/lower_bar.dart';

class DispatchScreen extends StatelessWidget {
  final List<Map<String, String>> quotes = List.generate(3, (index) => {
        'date': '23 SEP 2025',
        'from': 'MANHATTAN',
        'to': 'BROOKLYN',
        'service': 'HOURLY SERVICE',
        'car': 'LINCOLN SEDAN',
        'price': '300\$',
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Dispatch",
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFD700), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quote['date']!,
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
                          Text("From ${quote['from']!}",
                              style: const TextStyle(color: Colors.white)),
                          const Spacer(),
                          const Icon(Icons.location_pin, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text("To ${quote['to']!}",
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(quote['service']!,
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(quote['car']!,
                              style: const TextStyle(color: Colors.white)),
                          const Spacer(),
                          Text(quote['price']!,
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: const Text("Load More",
                  style: TextStyle(color: Colors.white)),
            ),
          ),LowerBar(),
        ],
      ),
    );
  }
}
