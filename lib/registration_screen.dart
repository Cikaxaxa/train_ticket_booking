import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the database helper

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add form key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign form key to the Form widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) { // Validate the form
                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    // Check if username already exists
                    List<Map<String, dynamic>> result =
                    await DatabaseHelper.instance.queryUser(username);
                    if (result.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Username already exists.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Insert new user into database
                      int userId = await DatabaseHelper.instance.insertUser({
                        'username': username,
                        'password': password,
                      });
                      if (userId > 0) {
                        // Registration successful
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Success'),
                            content: Text('Registration successful.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Navigate to the registration page
                                  Navigator.pushNamed(context, '/');
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Registration failed
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Error'),
                            content: Text('Registration failed.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Navigate to the registration page
                                  Navigator.pushNamed(context, '/');
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
