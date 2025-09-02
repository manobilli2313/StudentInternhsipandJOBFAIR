import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDashboard.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Event.dart';

class EventFeedback extends StatefulWidget {
  int? jid; 
  

  EventFeedback({super.key,this.jid});

  @override
  State<EventFeedback> createState() => _EventFeedbackState();
}

class _EventFeedbackState extends State<EventFeedback> {
  
  String managmentRating= 'Excellent';
  String facilityRating = 'Excellent';
  String overallRating = 'Excellent';
  String future_attandance = 'Yes';
  String studentquality = 'Excellent';

  void EventFeedbackstore() async {

    SharedPreferences pref=await SharedPreferences.getInstance();
    int? cid=await pref.getInt('companyid');
   Eventfeedbackcompany fed=Eventfeedbackcompany
   (
    
    CompanyID: cid!,
    JobFairID: widget.jid!,
    managmentRating: managmentRating,
    facilityRating: facilityRating,
    futureattandance: future_attandance,
    overallRating: overallRating,
    studentquality: studentquality,
   );
    


    
   

    final response = await CompanyApiServices.EventFeedbackcomp(fed);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Event Feedback"),
          content: Text("Event Feedback submitted successfully to Mentors.."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
               // Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
                return CompanyHomePage();
              }));
                // Close dialog
              },
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } 
    else if(response.statusCode==404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are not participate in Event.", ),
         backgroundColor: Colors.red,),
      );
    }

    else if(response.statusCode==409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Already provided feedback one time", ),
         backgroundColor: Colors.red,),
      );
    }

    else if(response.statusCode==400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit feedback. Invalid Data.", ),
         backgroundColor: Colors.red,),
      );
    }
    
    
    
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit feedback. Try again.", ),
         backgroundColor: Colors.red,),
      );
    }

  }

 

  Widget buildRadioButtonRow(String groupValue, Function(String?) onChanged) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Radio<String>(
            value: 'Excellent',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text('Excellent'),
          SizedBox(width: 10),
          Radio<String>(
            value: 'Good',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text('Good'),
          SizedBox(width: 10),
          Radio<String>(
            value: 'Fair',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text('Fair'),
          SizedBox(width: 10),
          Radio<String>(
            value: 'Poor',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text('Poor'),
        ],
      ),
    );
  }

  
   Widget buildRadioButtonRow2(String groupValue, Function(String?) onChanged) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Radio<String>(
            value: 'Yes',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text('Yes'),
          SizedBox(width: 10),
          Radio<String>(
            value: 'No',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text('No'),
          SizedBox(width: 10),
          Radio<String>(
            value: 'Maybe',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text('Maybe'),
          SizedBox(width: 10),
          Radio<String>(
            value: 'MaybeMaybeNot',
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text('Maybe || Maybe Not'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Feedback')),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('1) How would you rate the Management work during the Job Fair?'),
                buildRadioButtonRow(managmentRating, (String? value) {
                  setState(() {
                    managmentRating = value!;
                  });
                }),

                SizedBox(height: 8),

                Text('2) How would you rate the Facilities  during the Job Fair?'),
                buildRadioButtonRow(facilityRating, (String? value) {
                  setState(() {
                    facilityRating = value!;
                  });
                }),

                SizedBox(height: 8),

                Text('3) How would you rate the Overall Experience during the Job Fair?'),
                buildRadioButtonRow(overallRating, (String? value) {
                  setState(() {
                    overallRating = value!;
                  });
                }),

                SizedBox(height: 8),

                Text('4) How would you rate your willingness to attend a future event by this organization?'),
                buildRadioButtonRow2(future_attandance, (String? value) {
                  setState(() {
                    future_attandance = value!;
                  });
                }),

                SizedBox(height: 8),

                Text('5) How would you rate the quality of the candidates you interacted with?'),
                buildRadioButtonRow(studentquality, (String? value) {
                  setState(() {
                    studentquality = value!;
                  });
                }),

                SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    EventFeedbackstore();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
