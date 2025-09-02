import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';

class MyInternshipfeedback extends StatefulWidget {
  final int? sid;

  MyInternshipfeedback({super.key, this.sid});

  @override
  State<MyInternshipfeedback> createState() => _MyInternshipfeedbackState();
}

class _MyInternshipfeedbackState extends State<MyInternshipfeedback> {
  Map<String, dynamic>? feedbackData;
  bool isLoading = true;
  String? message;

  @override
  void initState() {
    super.initState();
    loadFeedback();
  }

  Future<void> loadFeedback() async {
    try {
      var response = await StudentApiService.fetchinternrecordfeedback(widget.sid!);

      if (response is String) {
        setState(() {
          message = response;
          isLoading = false;
        });
      } else {
        setState(() {
          feedbackData = response;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error fetching feedback.';
        isLoading = false;
      });
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    return dateString.split('T')[0];
  }

  Widget buildRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Appconstant.appcardstyle),
          Text(value ?? 'N/A', style: Appconstant.appcardstyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Internship Feedback')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : feedbackData == null
              ? Center(
                  child: Text(
                    message ?? 'No Feedback Found.',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRow('Company Name', feedbackData!['CompanyName']),
                            buildRow('Joining Date', formatDate(feedbackData!['joiningDate'])),
                            buildRow('Ending Date', formatDate(feedbackData!['endingDate'])),
                            buildRow('Communication Rating', feedbackData!['communicationRating'].toString()),
                            buildRow('Skills Rating', feedbackData!['skillsRating'].toString()),
                            buildRow('Result Remarks', feedbackData!['resultRemarks']),
                            const SizedBox(height: 10),
                           
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
