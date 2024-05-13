import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'PaymentPage.dart';
import 'SeatSelectionPage.dart';
import 'booking_detail.dart';
import 'database_helper.dart';
import 'seatbooking.dart';
import 'login_screen.dart'; // Import the login screen
import 'registration_screen.dart';
import 'BookingScreen.dart'; // Import the registration screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await DatabaseHelper.instance.initDatabase();

  // Call addTestData method
  await DatabaseHelper.instance.addTestData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define routes
      routes: {
        '/': (context) => LoginScreen(), // Default route is login screen
        '/registration': (context) => RegistrationScreen(), // Route for registration screen
        '/home': (context) => MyHomePage(username: '', numberOfPassengers: 0, selectedOrigin: '', selectedDestination: '', selectedDepartureDate: '', selectedReturnDate: '',),
        '/booking': (context) => const BookingScreen(username: '',),
        '/bookingdetail': (context) => BookingDetailsPage(username: '', trainId: 0, coachNumber: 0, selectedSeatNumbers: [], numberOfPassengers: 0, selectedOrigin: '', selectedDestination: '', selectedDepartureDate: '', selectedReturnDate: '',),
        '/seatselection': (context) => SeatSelectionPage(numberOfPassengers: null, username: '',),
        '/homepage': (context) => MainPage(username: ''),
        '/payment': (context) => PaymentPage(username: '', totalPrice: 0, trainId: 0, coachNumber: 0, selectedSeatNumbers: [], selectedOrigin: '', selectedDestination: '', selectedDepartureDate: '', selectedReturnDate: '', numberOfPassengers: 0,),// Route for home screen
      },
    );
  }
}
