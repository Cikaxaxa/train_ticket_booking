import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'PaymentPage.dart';
import 'SeatSelectionPage.dart';
import 'database_helper.dart';
import 'seatbooking.dart';

class BookingDetailsPage extends StatelessWidget {
  final String username;
  final int trainId;
  final int coachNumber;
  final List<int> selectedSeatNumbers;
  final String selectedOrigin;
  final String selectedDestination;
  final String selectedDepartureDate;
  final String selectedReturnDate;
  final int numberOfPassengers;

  BookingDetailsPage({
    required this.username,
    required this.trainId,
    required this.coachNumber,
    required this.selectedSeatNumbers,
    required this.numberOfPassengers,
    required this.selectedOrigin,
    required this.selectedDestination,
    required this.selectedDepartureDate,
    required this.selectedReturnDate,
  });



  void handleConfirm(BuildContext context) async {
    // Calculate total price based on the number of seats and the seat price
    double seatprice = 30.00;
    double totalPrice = (selectedSeatNumbers.length * seatprice);



    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage(username: username,
        totalPrice: totalPrice,
        trainId: trainId,
        coachNumber: coachNumber,
        selectedSeatNumbers: selectedSeatNumbers,
        selectedOrigin: selectedOrigin,
        selectedDestination: selectedDestination,
        selectedDepartureDate: selectedDepartureDate,
        selectedReturnDate: selectedReturnDate,
        numberOfPassengers: numberOfPassengers,),
      ),// Replace MyPage with the name of your next page
    );// Pass a value to indicate booking confirmation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text('Username: $username'),
          Text('Train Number: $trainId'),
          Text('Coach Number: $coachNumber'),
          Text('Seats Number: ${selectedSeatNumbers.join(", ")}'),
          Text('Origin: $selectedOrigin'),
          Text('Destination: $selectedDestination'),
          Text('Departure Date: $selectedDepartureDate'),
          Text('Return Date: $selectedReturnDate'),
          Text('Number of Passengers: $numberOfPassengers'),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () => handleConfirm(context),
            child: Text('Confirm'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Reselect Seat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(username: username),
                ),
              );
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
