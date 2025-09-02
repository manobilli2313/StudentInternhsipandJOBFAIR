import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/MyInterns.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternFeedback.dart';
import 'package:intl/intl.dart';

class InternFeedback extends StatefulWidget {
  int sid;
  int cid;
  String? sname, regno;

  InternFeedback({super.key, required this.sid, required this.cid, this.sname, this.regno});

  @override
  State<InternFeedback> createState() => _InternFeedbackState();
}

class _InternFeedbackState extends State<InternFeedback> {
  TextEditingController joindate = TextEditingController();
  TextEditingController endingdate = TextEditingController();

  int communicationmarks = 0;
  int skillsmarks = 0;
  String? resultstatus;

  List<int> marks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<String> result = ['Passed', 'Failed'];

  Future<void> pickdatetime(TextEditingController controller) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      setState(() {
        controller.text = formatter.format(_picked);
      });
    }
  }

  // Correct Date Parser
  DateTime? parseDate(String dateString) {
    try {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  void addfeedback() async {
    SubmitInternsFeedback feedback = SubmitInternsFeedback(
      companyID: widget.cid,
      studentID: widget.sid,
      joiningDate: parseDate(joindate.text),
      endingDate: parseDate(endingdate.text),
      communicationRating: communicationmarks,
      skillsRating: skillsmarks,
      resultRemarks: resultstatus!,
    );

    var response = await CompanyApiServices.internrequessubmit(feedback);

    if (response.statusCode == 200) {
      communicationmarks = 0;
      skillsmarks = 0;
      joindate.clear();
      endingdate.clear();

      setState(() {});

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Intern Feedback"),
          content: Text("Intern Feedback added Successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllInterns(),
                  ),
                );
              },
              child: Text("OK"),
            ),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Intern Feedback Successfully Submitted'),
        backgroundColor: Colors.green,
      ));
    } else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Some Internal Issue'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(
        title: Text('Submit Feedback'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Student Name: ${widget.sname}', style: Appconstant.appcardstyle),
              SizedBox(height: 10),
              Text('Reg-No: ${widget.regno}', style: Appconstant.appcardstyle),
              SizedBox(height: 25),

              TextFormField(
                controller: joindate,
                readOnly: true,
                onTap: () => pickdatetime(joindate),
                decoration: InputDecoration(
                  hintText: 'Date of Joining',
                  labelText: 'Joining Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Appconstant.appcolor!),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: endingdate,
                readOnly: true,
                onTap: () => pickdatetime(endingdate),
                decoration: InputDecoration(
                  hintText: 'Date of Ending',
                  labelText: 'End Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Appconstant.appcolor!),
                  ),
                ),
              ),
              SizedBox(height: 10),

              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.star),
                  labelText: 'Communication Marks',
                  border: OutlineInputBorder(),
                ),
                value: communicationmarks,
                items: marks.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    communicationmarks = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),

              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.star),
                  labelText: 'Skills Marks',
                  border: OutlineInputBorder(),
                ),
                value: skillsmarks,
                items: marks.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    skillsmarks = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Result Remarks',
                  border: OutlineInputBorder(),
                ),
                value: resultstatus,
                items: result.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    resultstatus = newValue!;
                  });
                },
              ),
              SizedBox(height: 25),

              ElevatedButton(
                onPressed: addfeedback,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
