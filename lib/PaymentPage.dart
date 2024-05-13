import 'package:flutter/material.dart';
import 'package:train_ticket_booking/seatbooking.dart';

import 'MainPage.dart';
import 'database_helper.dart';

class PaymentPage extends StatelessWidget {
  final String username;
  final double totalPrice;
  final int trainId;
  final int coachNumber;
  final List<int> selectedSeatNumbers;
  final String selectedOrigin;
  final String selectedDestination;
  final String selectedDepartureDate;
  final String selectedReturnDate;
  final int numberOfPassengers;

  PaymentPage({required this.username, required this.totalPrice, required this.trainId, required this.coachNumber, required this.selectedSeatNumbers, required this.selectedOrigin, required this.selectedDestination, required this.selectedDepartureDate, required this.selectedReturnDate, required this.numberOfPassengers});

  void handlePayment(BuildContext context) async {
    // Calculate total price based on the number of seats and the seat price
    double seatprice = 30.00;
    double totalPrice = (selectedSeatNumbers.length * seatprice);

    // Save booking details to the database
    await DatabaseHelper.instance.insertBookingSeat(
      trainId: trainId,
      username: username,
      coachNumber: coachNumber,
      seatNumbers: selectedSeatNumbers,
      totalPrice: totalPrice,
      origin: selectedOrigin,
      destination: selectedDestination,
      departureDate: selectedDepartureDate,
      returnDate: selectedReturnDate,
      numberOfPassengers: numberOfPassengers,
    );

    // Update seat status in the 'seats' table (assuming you have a method for this in your DatabaseHelper)
    for (int seatNumber in selectedSeatNumbers) {
      await DatabaseHelper.instance.updateSeatStatus(
        selectedSeatNumbers: selectedSeatNumbers, // Pass the list of selected seat numbers
        coachNumber: coachNumber,
        seatNumber: seatNumber,
        isBooked: 1,
      );
    }

    // Show payment success dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Success'),
        content: Text('Payment successful.'),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate back to the main page after payment success
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(username: username),
                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Price: RM ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => handlePayment(context),
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
