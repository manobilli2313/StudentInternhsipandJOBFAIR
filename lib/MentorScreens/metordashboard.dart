import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';

class MentorHomePage extends StatelessWidget {
  const MentorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),
      appBar: AppBar(
        
        title: Text('Mentor Dashboard'),
      ),
    );
  }
}