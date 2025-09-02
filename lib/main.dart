import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AllVenue.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDashboard.dart';

import 'package:student_internship_and_jobfair_fyp/StudentScreens/MatchedCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDashboard.dart';

import 'Screens/LoginPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       appBarTheme: AppBarTheme(
    color: Color.fromARGB(218, 97, 233, 70), // AppBar color
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black), // Icon color
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
   bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(218, 97, 233, 70), // Background color
    selectedItemColor: Colors.white, // Selected item color
    unselectedItemColor: Colors.black, // Unselected item color
  showSelectedLabels: true, // Show labels for selected items
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed, // Show labels for unselected items
    //elevation: 10, // Elevation for shadow effect
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(218, 97, 233, 70), // Same as AppBar color
      foregroundColor: Colors.white, // Text color
      minimumSize: Size(double.infinity, 50), // Full-width button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      elevation: 5, // Button shadow
    ), 
  ),
  
       
        
      ),
      home: SplashScreen(),
      
    );
  }
}
// Import your login page




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Color appPrimaryColor = Color.fromARGB(218, 97, 233, 70);
  final Color textColor = Color.fromARGB(218, 97, 233, 70);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 4), () {
      if (mounted) {
        goToLogin();
      }
    });
  }

  void goToLogin() {
    // Cancel timer to prevent double navigation
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always clean up timers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circle Avatar Logo
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/biit.png'),
                ),

                SizedBox(height: 30),

                Text(
                  'Student Internship & Job Fair',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 1.1,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Empowering Students for Future Careers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor.withOpacity(0.9),
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: 50),

                ElevatedButton(
                  onPressed: goToLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Let's Go",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

