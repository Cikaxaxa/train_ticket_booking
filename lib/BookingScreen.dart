import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'seatbooking.dart';

class BookingScreen extends StatefulWidget {
  final String username;

  const BookingScreen({required this.username});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? _selectedOrigin;
  String? _selectedDestination;
  String? _selectedDepartureDate;
  String? _selectedReturnDate;
  int _numberOfPassengers = 1;

  List<String> _stations = [
    'Station A',
    'Station B',
    'Station C',
    // Add more stations as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedOrigin,
                onChanged: (value) {
                  setState(() {
                    _selectedOrigin = value!;
                  });
                },
                items: _stations.map((station) {
                  return DropdownMenuItem<String>(
                    value: station,
                    child: Text(station),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Origin',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedDestination,
                onChanged: (value) {
                  setState(() {
                    _selectedDestination = value!;
                  });
                },
                items: _stations.map((station) {
                  return DropdownMenuItem<String>(
                    value: station,
                    child: Text(station),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Departure Date'),
                trailing: Text(_selectedDepartureDate ?? 'Select Date'),
                onTap: () async {
                  await _showDatePicker(true);
                },
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Return Date'),
                trailing: Text(_selectedReturnDate ?? 'Select Date'),
                onTap: () async {
                  await _showDatePicker(false);
                },
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numberOfPassengers = int.tryParse(value) ?? 1;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Number of Passengers',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedOrigin != null &&
                      _selectedDestination != null &&
                      _selectedDepartureDate != null &&
                      _selectedReturnDate != null &&
                      _numberOfPassengers > 0) {
                    // Booking successful
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(
                          username: widget.username,
                          numberOfPassengers: _numberOfPassengers,
                          selectedOrigin: _selectedOrigin!,
                          selectedDestination: _selectedDestination!,
                          selectedDepartureDate: _selectedDepartureDate!,
                          selectedReturnDate: _selectedReturnDate!,
                        ),
                      ),
                    );
                  } else {
                    // Show error message if any required field is missing
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please fill in all required fields.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Book Ticket'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final formattedDate = DateFormat('d MMMM y', 'en_US').format(picked); // Format the selected date
      setState(() {
        if (isDeparture) {
          _selectedDepartureDate = formattedDate;
        } else {
          _selectedReturnDate = formattedDate;
        }
      });
    }
  }
}
