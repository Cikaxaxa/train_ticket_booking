import 'package:flutter/material.dart';
import 'booking_detail.dart';
import 'database_helper.dart'; // Import the new page

class MyHomePage extends StatefulWidget {
  final String username;
  final int numberOfPassengers;
  final String selectedOrigin;
  final String selectedDestination;
  final String selectedDepartureDate;
  final String selectedReturnDate;

  MyHomePage({required this.username,
    required this.numberOfPassengers,
    required this.selectedOrigin,
    required this.selectedDestination,
    required this.selectedDepartureDate,
    required this.selectedReturnDate});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Train> _trains = [];
  Train? _selectedTrain;
  List<int> _coachNumbers = [];
  int? _selectedCoachNumber;
  List<int> _seatNumbers = [];
  List<int> _selectedSeatNumbers = [];

  @override
  void initState() {
    super.initState();
    fetchTrains();
  }

  void fetchTrains() async {
    List<Train> trains = await DatabaseHelper.instance.fetchTrains();
    setState(() {
      _trains = trains;
    });
  }

  void fetchCoachNumbers(int trainId) async {
    List<int> coachNumbers = await DatabaseHelper.instance.fetchCoachNumbers(trainId);
    setState(() {
      _coachNumbers = coachNumbers;
    });
  }

  void fetchSeatNumbers(int coachId) async {
    List<int> seatNumbers = await DatabaseHelper.instance.fetchSeatNumbers(coachId);
    setState(() {
      _seatNumbers = seatNumbers;
    });
  }

  void handleSubmit() {
    // Handle the submission here, e.g., save selected data to database
    print('Selected Train: $_selectedTrain');
    print('Selected Coach Number: $_selectedCoachNumber');
    print('Selected Seat Numbers: $_selectedSeatNumbers');
    // Add your logic to save the selected data
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trains'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Label for Train dropdown
              Text(
                'Select Train:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Train dropdown
              DropdownButton<Train>(
                value: _selectedTrain,
                onChanged: (Train? newValue) {
                  setState(() {
                    _selectedTrain = newValue;
                    _selectedCoachNumber = null; // Reset selected coach number when train changes
                    _selectedSeatNumbers.clear(); // Clear selected seat numbers when train changes
                    if (_selectedTrain != null) {
                      fetchCoachNumbers(_selectedTrain!.id);
                    }
                  });
                },
                items: _trains.map((Train train) {
                  return DropdownMenuItem<Train>(
                    value: train,
                    child: Text(train.name),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              if (_selectedTrain != null && _coachNumbers.isNotEmpty) ...[
                // Label for Coach dropdown
                Text(
                  'Select Coach Number:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Coach dropdown
                DropdownButton<int>(
                  value: _selectedCoachNumber,
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedCoachNumber = newValue;
                      _selectedSeatNumbers.clear(); // Clear selected seat numbers when coach changes
                      if (_selectedCoachNumber != null) {
                        fetchSeatNumbers(_selectedCoachNumber!);
                      }
                    });
                  },
                  items: _coachNumbers.map((int coachNumber) {
                    return DropdownMenuItem<int>(
                      value: coachNumber,
                      child: Text(coachNumber.toString()),
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 20),
              if (_selectedCoachNumber != null && _seatNumbers.isNotEmpty) ...[
                // Heading for seat selection
                Text(
                  'Select ${widget.numberOfPassengers} Seat Numbers:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Seat checkboxes
                Wrap(
                  children: _seatNumbers.map((int seatNumber) {
                    return CheckboxListTile(
                      title: Text('Seat $seatNumber'), // Label for each CheckboxListTile
                      value: _selectedSeatNumbers.contains(seatNumber),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            if (_selectedSeatNumbers.length < widget.numberOfPassengers) {
                              _selectedSeatNumbers.add(seatNumber);
                            } else {
                              // If already selected two seats, uncheck the last selected one
                              _selectedSeatNumbers.removeAt(1);
                              _selectedSeatNumbers.add(seatNumber);
                            }
                          } else {
                            _selectedSeatNumbers.remove(seatNumber);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: _selectedTrain != null &&
                    _selectedCoachNumber != null &&
                    _selectedSeatNumbers.length == widget.numberOfPassengers
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(
                        username: widget.username,
                        trainId: _selectedTrain!.id,
                        coachNumber: _selectedCoachNumber!,
                        selectedSeatNumbers: _selectedSeatNumbers,
                        numberOfPassengers: widget.numberOfPassengers,
                        selectedOrigin : widget.selectedOrigin,
                        selectedDestination: widget.selectedDestination,
                        selectedDepartureDate: widget.selectedDepartureDate,
                        selectedReturnDate: widget.selectedReturnDate,
                      ),
                    ),
                  );
                }
                    : null,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
