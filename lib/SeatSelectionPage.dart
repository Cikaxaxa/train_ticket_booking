import 'package:flutter/material.dart';
import 'database_helper.dart';

class SeatSelectionPage extends StatefulWidget {
  final String username;
  final int? numberOfPassengers;

  SeatSelectionPage({
    required this.numberOfPassengers,
    required this.username,
  });

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late List<int> _coaches = [];
  late List<int> _seats = [];
  late List<Map<String, dynamic>> _trains = [];
  String? _selectedTrain;
  String? _selectedCoach;
  String? _selectedSeat;

  @override
  void initState() {
    super.initState();
    _fetchTrains(); // Call method to fetch trains
  }

  Future<void> _fetchTrains() async {
    final trains = await DatabaseHelper.instance.getTrainNames(); // Fetch trains from database
    setState(() {
      _trains = trains.map((name) => {'name': name}).toList();

    });
  }

  Future<void> _fetchCoaches(int trainId) async {
    final coaches = await DatabaseHelper.instance.fetchCoachNumbers(trainId);
    setState(() {
      _coaches = coaches.cast<int>();
    });
  }

  Future<void> _fetchSeats(int trainId, int coachNumber) async {
    final seats = await DatabaseHelper.instance.querySeats(trainId, coachNumber);
    setState(() {
      _seats = seats.cast<int>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Selection'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedTrain,
              onChanged: (value) async {
                setState(() {
                  _selectedTrain = value;
                  _selectedCoach = null;
                  _selectedSeat = null;
                });
                await _fetchCoaches(int.parse(value!));
              },
              items: _trains
                  .map((train) => DropdownMenuItem<String>(
                value: train['id'].toString(),
                child: Text('Train ${train['name']}'),
              ))
                  .toList(),
            ),
            SizedBox(height: 20),
            if (_coaches.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedCoach,
                onChanged: (value) async {
                  setState(() {
                    _selectedCoach = value;
                    _selectedSeat = null;
                  });
                  await _fetchSeats(int.parse(_selectedTrain!), int.parse(value!));
                },
                items: _coaches
                    .map((coach) => DropdownMenuItem<String>(
                  value: coach.toString(),
                  child: Text('Coach $coach'),
                ))
                    .toList(),
              ),
            SizedBox(height: 20),
            if (_seats.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedSeat,
                onChanged: (value) {
                  setState(() {
                    _selectedSeat = value;
                  });
                },
                items: _seats
                    .map((seat) => DropdownMenuItem<String>(
                  value: seat.toString(),
                  child: Text('Seat $seat'),
                ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
