import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'registration_screen.dart';
import 'BookingScreen.dart'; // Import the booking screen
import 'database_helper.dart'; // Import the database helper


class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;

                // Check if username and password are valid
                List<Map<String, dynamic>> result =
                await DatabaseHelper.instance.queryUser(username);
                if (result.isNotEmpty && result[0]['password'] == password) {
                  print('Username before navigation: $username'); // Debugging
                  // Navigate to booking screen with the username
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(username: username,), // Pass the username
                    ),
                  );
                } else {
                  // Show error message for invalid credentials
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Invalid username or password.'),
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
              child: Text('Login'),
            ),
        SizedBox(height: 10), // Add some space between buttons
        ElevatedButton(
          onPressed: () {
            // Navigate to registration screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationScreen()),
            );
          },
          child: Text('Register'),
        ),
          ],
        ),
      ),
    );
  }
}
