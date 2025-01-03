// New Page: ScheduleMessagePage

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ScheduleMessagePage extends StatefulWidget {
  const ScheduleMessagePage({Key? key}) : super(key: key);

  @override
  State<ScheduleMessagePage> createState() => _ScheduleMessagePageState();
}

class _ScheduleMessagePageState extends State<ScheduleMessagePage> {
  String? _selectedUserId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TextEditingController _messageController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _registeredUsers = [
    {'uid': 'user1', 'name': 'User 1'},
    {'uid': 'user2', 'name': 'User 2'},
    {'uid': 'user3', 'name': 'User 3'},
  ];

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _scheduleMessage() async {
    if (_selectedUserId == null ||
        _selectedDate == null ||
        _selectedTime == null ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    DateTime scheduledDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot schedule a message in the past")),
      );
      return;
    }

    await _firestore.collection('scheduled_messages').add({
      'senderId': 'currentUserId', // Placeholder for sender ID
      'receiverId': _selectedUserId,
      'message': _messageController.text,
      'scheduledTime': scheduledDateTime,
    });

    setState(() {
      _messageController.clear();
      _selectedDate = null;
      _selectedTime = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Message scheduled successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Message"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          DropdownButtonFormField<String>(
  value: _selectedUserId,
  hint: Text("Select Receiver"),
  onChanged: (value) {
    if (value != null) {
      setState(() {
        _selectedUserId = value;
      });
    }
  },
  items: _registeredUsers.map((user) {
    return DropdownMenuItem<String>(
      value: user['uid'] ?? '',
      child: Text(user['name'] ?? 'Unknown'),
    );
  }).toList(),
),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickDate,
                    child: Text(_selectedDate == null
                        ? "Pick Date"
                        : DateFormat.yMMMd().format(_selectedDate!)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickTime,
                    child: Text(_selectedTime == null
                        ? "Pick Time"
                        : _selectedTime!.format(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scheduleMessage,
              child: Text("Schedule Message"),
            ),
          ],
        ),
      ),
    );
  }
}
