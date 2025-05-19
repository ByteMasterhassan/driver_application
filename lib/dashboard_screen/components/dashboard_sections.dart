import 'package:flutter/material.dart';

// Dashboard Card Component
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                if (actionText != null)
                  TextButton(
                    onPressed: onActionPressed,
                    child: Text(actionText!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Section Header Component
class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.actionText,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        TextButton(
          onPressed: onActionPressed,
          child: Text(actionText),
        ),
      ],
    );
  }
}

// Legend Box Component
class LegendBox extends StatelessWidget {
  final List<LegendItem> items;

  const LegendBox({
    Key? key,
    this.items = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: items.map((item) => _buildLegendRow(item)).toList(),
      ),
    );
  }

  Widget _buildLegendRow(LegendItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(item.label),
        ],
      ),
    );
  }
}

class LegendItem {
  final Color color;
  final String label;

  LegendItem({required this.color, required this.label});
}

// Trip Card Component
class TripCard extends StatelessWidget {
  final String time;
  final String destination;
  final String total;
  final VoidCallback? onTap;

  const TripCard({
    Key? key,
    required this.time,
    required this.destination,
    required this.total,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$time $destination',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Total: $total',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dashboard Action Button Component
class DashboardActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DashboardActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}