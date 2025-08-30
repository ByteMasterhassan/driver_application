import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../lower_bar/lower_bar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _showDatePicker = false;

  final Color backgroundColor = const Color(0xFF121212);
  final Color secondaryColor = const Color(0xFF1F1F1F);
  final Color goldColor = const Color(0xFFD7B65D);

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('MM/dd/yyyy').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        title: const Text(
          'Calendar',
          style: TextStyle(color: Color(0xFFD7B65D)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFD7B65D)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendarHeader(),
            _buildWeekDaysHeader(),
            _buildCalendarGrid(),
            const SizedBox(height: 16),
            _buildEndsAtSection(),
            const Divider(height: 32, color: Colors.grey),
            _buildAcceptOpportunitiesSection(),
            const SizedBox(height: 16),
            _buildDateSelectionSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
        // 🔑 Fixed sticky bar
        bottomNavigationBar: const LowerBar(),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(_selectedDate),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: goldColor,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Color(0xFFD7B65D)),
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
            });
          },
        ),
      ],
    );
  }

  Widget _buildWeekDaysHeader() {
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((day) => Text(
                day,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD7B65D),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.2,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final dayOffset = index - startingWeekday + 1;
        final day = (dayOffset > 0 && dayOffset <= daysInMonth) ? dayOffset : null;

        final isToday = day == DateTime.now().day &&
            _selectedDate.month == DateTime.now().month &&
            _selectedDate.year == DateTime.now().year;

        return Container(
          alignment: Alignment.center,
          decoration: isToday
              ? BoxDecoration(
                  color: goldColor,
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: day != null
              ? Text(
                  '$day',
                  style: TextStyle(
                    color: isToday ? Colors.black : Colors.white,
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildEndsAtSection() {
    return Row(
      children: [
        const Text('30', style: TextStyle(color: Colors.white)),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ends', style: TextStyle(color: Colors.white)),
            Text(
              _selectedTime.format(context),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAcceptOpportunitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Accept All Opportunities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD7B65D),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Select date',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TIME', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          controller: _dateController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: secondaryColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: goldColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: goldColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: goldColor, width: 2),
            ),
          ),
          readOnly: true,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: goldColor,
                      surface: secondaryColor,
                      background: backgroundColor,
                    ),
                    dialogBackgroundColor: secondaryColor,
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
                _dateController.text = DateFormat('MM/dd/yyyy').format(_selectedDate);
              });
            }
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: goldColor),
                  foregroundColor: goldColor,
                ),
                onPressed: () {
                  setState(() {
                    _showDatePicker = false;
                  });
                },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  // Handle OK button press
                },
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}

