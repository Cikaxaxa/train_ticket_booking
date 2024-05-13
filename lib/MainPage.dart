import 'package:flutter/material.dart';
import 'package:train_ticket_booking/FullBookingDetail.dart';

import 'BookingScreen.dart';

class MainPage extends StatelessWidget {
  final String username;

  MainPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Booking Apps'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(username: username,),
                  ),
                );
              },
              child: const Text('Book Train Ticket'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullBookingDetail(username: username),
                  ),
                );
              },
              child: const Text('Print Ticket Train'),
            ),
          ],
        ),
      ),
    );
  }
}
