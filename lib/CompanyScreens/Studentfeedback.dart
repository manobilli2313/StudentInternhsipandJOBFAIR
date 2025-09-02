import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/studentFeedback.dart';

class StudentFeedbackPage extends StatefulWidget {
  int? sid, cid, jid;
  StudentFeedbackPage({super.key, this.sid, this.cid, this.jid});

  @override
  State<StudentFeedbackPage> createState() => _StudentFeedbackPageState();
}

class _StudentFeedbackPageState extends State<StudentFeedbackPage> {
  String interviewskills = 'Excellent';
  String dressing = 'Excellent';
  String confidence = 'Excellent';
  String knowledge = 'Excellent';
  String problem = 'Excellent';

  void submitstudentfeedback() async {
    StudentFeedbackJB fed = StudentFeedbackJB(
      companyID: widget.cid!,
      jobfairID: widget.jid!,
      studentID: widget.sid!,
      interviewSkills: interviewskills,
      dressing: dressing,
      confidence: confidence,
      knowledge: knowledge,
      problemSolving: problem,
    );

    final response = await CompanyApiServices.submitstudentfeedback(fed);

    // if (response.statusCode == 200) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text("Student Feedback"),
    //       content: Text("Student Feedback submitted successfully to Mentors.."),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //             Navigator.pop(context);
    //             Navigator.pop(context); // Close dialog
    //           },
    //           child: Text("Yes"),
    //         ),
    //       ],
    //     ),
    //   );
    // }
    if (response.statusCode == 200) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Student Feedback"),
      content: Text("Student Feedback submitted successfully to Mentors."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
             Navigator.pop(context);
             Navigator.pop(context,'next');

             // Close dialog
          //  Navigator.pop(context, 'next'); // 🔥 Return 'next'
          },
          child: Text("OK")
        ),
      ],
    ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Feedback')),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(

              children: [

                
                Text('1) How would you rate the student Interview skills during the interview?'),
                buildRadioButtonRow(interviewskills, (String? value) {
                  setState(() {
                    interviewskills = value!;
                  });
                }),

                SizedBox(height: 8),

                Text('2) How would you rate the student Dressing during the interview?'),
                buildRadioButtonRow(dressing, (String? value) {
                  setState(() {
                    dressing = value!;
                  });
                }),

                SizedBox(height: 8),

                Text('3) How would you rate the student Confidence during the interview?'),
                buildRadioButtonRow(confidence, (String? value) {
                  setState(() {
                    confidence = value!;
                  });
                }),

                SizedBox(height: 8),

                Text('4) How would you rate the student Knowledge during the interview?'),
                buildRadioButtonRow(knowledge, (String? value) {
                  setState(() {
                    knowledge = value!;
                  });
                }),

                SizedBox(height: 8),

                Text('5) How would you rate the student Problem Solving skills during the interview?'),
                buildRadioButtonRow(problem, (String? value) {
                  setState(() {
                    problem = value!;
                  });
                }),

                SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    submitstudentfeedback();
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
