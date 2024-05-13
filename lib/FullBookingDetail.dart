


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart'; // Import the printing package
import 'database_helper.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class FullBookingDetail extends StatefulWidget {
  final String username;

  FullBookingDetail({required this.username});

  @override
  _FullBookingDetailState createState() => _FullBookingDetailState();
}

class _FullBookingDetailState extends State<FullBookingDetail> {
  Future<List<Map<String, dynamic>>> _fetchUserData() async {
    // Fetch data from both tables based on the username
    List<Map<String, dynamic>> bookings = await DatabaseHelper.instance.queryBookings(widget.username);

    // Combine and return the data
    List<Map<String, dynamic>> userData = [...bookings];
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              _printUserData(); // Call method to print as PDF
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> userData = snapshot.data ?? [];
            Set<int> uniqueIds = userData.map<int>((data) => data['id']).toSet();
            int totalPrice = uniqueIds.length * 30; // Replace YOUR_PRICE_PER_TICKET with the actual price per ticket
            return Column(
              children: [
                ListTile(
                  title: Text('Total Price: RM$totalPrice'),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: userData.length,
                    separatorBuilder: (BuildContext context, int index) => Divider(), // Add Divider between list items
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = userData[index];
                      return ListTile(
                        title: Text('Ticket Train'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username: ${data['username']}'),
                            if (data.containsKey('origin')) Text('Origin: ${data['origin']}'),
                            if (data.containsKey('destination')) Text('Destination: ${data['destination']}'),
                            if (data.containsKey('departureDate')) Text('Departure Date: ${data['departureDate']}'),
                            if (data.containsKey('returnDate')) Text('Return Date: ${data['returnDate']}'),
                            if (data.containsKey('trainId')) Text('Train ID: ${data['trainId']}'),
                            if (data.containsKey('coachNumber')) Text('Coach Number: ${data['coachNumber']}'),
                            if (data.containsKey('seatNumber')) Text('Seat Number: ${data['seatNumber']}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }



  Future<void> _printUserData() async {
    final userData = await _fetchUserData();

    final pdf = await _generatePdf(userData);

    // Save the PDF to local storage or share it
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/user_data.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf);

    // Open the PDF in a viewer
    // Note: You may need to handle opening the PDF file according to your app's requirements.
    // For example, you can use packages like `open_file` to open the PDF.
    // For simplicity, this example just prints the path to the console.
    print('PDF saved at: $path');

    final snackBar = SnackBar(
      content: Text('PDF successfully saved at: $path'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Uint8List> _generatePdf(List<Map<String, dynamic>> userData) async {
    final pdf = pw.Document();

    List<pw.Widget> ticketDetails = [];

    // Iterate through user data to add ticket details and dividers
    for (var data in userData) {
      ticketDetails.addAll([
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Ticket Train', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Username: ${data['username']}'),
            if (data.containsKey('origin')) pw.Text('Origin: ${data['origin']}'),
            if (data.containsKey('destination')) pw.Text('Destination: ${data['destination']}'),
            if (data.containsKey('departureDate')) pw.Text('Departure Date: ${data['departureDate']}'),
            if (data.containsKey('returnDate')) pw.Text('Return Date: ${data['returnDate']}'),
            if (data.containsKey('trainId')) pw.Text('Train ID: ${data['trainId']}'),
            if (data.containsKey('coachNumber')) pw.Text('Coach Number: ${data['coachNumber']}'),
            if (data.containsKey('seatNumber')) pw.Text('Seat Number: ${data['seatNumber']}'),
            if (data.containsKey('seatNumber')) pw.Text('Total Price: RM30'),
          ],
        ),
        // Add a line divider between each ticket, except for the last one
        if (userData.indexOf(data) != userData.length - 1) pw.Divider(),
      ]);
    }

    // Add all ticket details and dividers to the PDF on a single page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: ticketDetails,
          );
        },
      ),
    );

    return pdf.save();
  }
}
