import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/LoginAPIs/LoginApiService.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AbsentCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AppliedCompanies.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AppliedStudents.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/Dashboard.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/TotalInterviewedStudents.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/TotalShortlistedStudent.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDashboard.dart';

import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Home.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/PendingCompanyAccount.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/metordashboard.dart';
import 'package:student_internship_and_jobfair_fyp/Screens/SignUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDashboard.dart';
// Import your CustomTextField file

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences pref;
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   bool isLoading = false;

  
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error',),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  void _login() async {
  if (_formKey.currentState!.validate()) {
     setState(() {
        isLoading = true; // show loading
      });
    try {
      var response = await LoginApi().login(
        usernameController.text,
        passwordController.text,
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        print("Login Success: $responseBody"); // Debugging line

        // Fix response field
        String role = responseBody['urole']; // Change from 'role' to 'urole'
        int roleSpecificId = responseBody['roleSpecificId'];

        pref = await SharedPreferences.getInstance();

        setState(() {
            isLoading = false; // stop loading before navigation
          });

        if (role == 'company') {
          pref.setInt('companyid', roleSpecificId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CompanyHomePage()),
          );
        } else if (role == 'student') {
          pref.setInt('studentid', roleSpecificId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentHomePage()),
          );
        } else if (role == 'societymember') {
          pref.setInt('mentorid', roleSpecificId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MentorHome()),
          );
        }

        else if (role == 'admin') {
         pref.setInt('adminid', roleSpecificId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
          );
        }
      } else {
        setState(() {
            isLoading = false; // stop loading on failure
          });
        print("Login Failed: ${response.statusCode} ${response.body}"); // Debugging
        showErrorDialog('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
          isLoading = false; // stop loading on exception
        });
      print("Login Error: $e"); // Debugging
      showErrorDialog('An error occurred during login: $e');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Form(
          key: _formKey,
          child: Container(
        height: double.infinity,
        width: double.infinity,
        color:const Color.fromARGB(218, 97, 233, 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: const Text(
              
                "Login",
                style: TextStyle(fontSize: 50, color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
            const SizedBox(height: 80),
            Expanded(
              child: Container(
                 
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60,),
                     // Text('User Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:  const Color.fromARGB(255, 120, 5, 143),),),
                     CustomTextField
                     (
                       controller: usernameController,
                       label: 'Username',
                       hint: 'Enter your Username',
                       prefixIcon: Icon(Icons.email),
                     ),

                      const SizedBox(height: 20),
                       // Text('Password',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:const Color.fromARGB(255, 120, 5, 143)),),
                      CustomTextField
                      (controller: passwordController, 
                       label: 'Password',
                       hint: 'Enter Your Password',
                       obscureText: true,
                       prefixIcon: Icon(Icons.lock),
                      ),  
                     
                      const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Don't have an account?",style: TextStyle(fontSize: 12,color:Colors.black),),
                        const SizedBox(width: 6,),
                        GestureDetector
                        (onTap: (){
                          Navigator.pushReplacement
                          (
                            context, MaterialPageRoute(builder: (context) =>SignupPage() ),
                          );

                        },
                          child: Text('Sign up',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:const Color.fromARGB(218, 97, 233, 70), decoration: TextDecoration.underline,
                           decorationColor: Color.fromARGB(218, 97, 233, 70),),)),
                        
                      ],

                    ),
                    const SizedBox(height: 60,),
                    // ElevatedButton(onPressed: ()
                    // {
                    //   _login();
                    // }, child: Text('Login'))
                    ElevatedButton(
  onPressed: isLoading ? null : _login, // Disable button when loading
  child: isLoading
      ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
      : Text('Login'),
)


                    


                     

                        

                      






                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        ),
      
    );
  }
}
