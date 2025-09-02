import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudentsPoster.dart';

class ProjectImagePosterScreen extends StatefulWidget {
  final List<PosterStudent> students;
  final int activeJobFairId;

  ProjectImagePosterScreen({
    required this.students,
    required this.activeJobFairId,
  });

  @override
  State<ProjectImagePosterScreen> createState() => _ProjectImagePosterScreenState();
}

class _ProjectImagePosterScreenState extends State<ProjectImagePosterScreen> {
  int currentIndex = 0;
  String? studentImageUrl;
  bool isLoadingImage = true;

  Set<int> selectedStudentIds = {};

  @override
  void initState() {
    super.initState();
    loadStudentImage(widget.students[currentIndex].sid);
  }

  Future<void> loadStudentImage(int sid) async {
    setState(() {
      isLoadingImage = true;
      studentImageUrl = null;
    });

    final response = await http.get(Uri.parse(
      "http://192.168.0.170/SIJBAPI/api/FinalTask/GetStudentImage?sid=$sid",
    ));

    if (response.statusCode == 200) {
      final imageUrl = jsonDecode(response.body)['ImageUrl']
          .replaceFirst("192.168.1.5", "192.168.0.170");

      setState(() {
        studentImageUrl = imageUrl;
        isLoadingImage = false;
      });
    } else {
      setState(() {
        studentImageUrl = null;
        isLoadingImage = false;
      });
    }
  }

  // Future<void> saveStudents() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   int? cid = pref.getInt('companyid');

  //   for (var studentId in selectedStudentIds) {
  //     final body = {
  //       "StudentID": studentId,
  //       "CompanyID": cid!,
  //       "JobFairID": widget.activeJobFairId,
  //       "status":0
  //     };

  //     await http.post(
  //       Uri.parse("http://localhost/SIJBAPI/api/FinalTask/SaveStudentwithclash"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(body),
  //     );
  //   }
  // }


//improve fucntion which show summary sccafoldmessemger each thing separate
  Future<void> saveStudents() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int? cid = pref.getInt('companyid');

  int successCount = 0;
  int alreadyAppliedCount = 0;
  int failedCount = 0;
  int alreadysavedCount=0;

  // Show loading while saving
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    for (var studentId in selectedStudentIds) {
      final body = {
        "StudentID": studentId,
        "CompanyID": cid!,
        "JobFairID": widget.activeJobFairId,
        "status": 0,
      };

      final response = await http.post(
        Uri.parse("http://192.168.0.170/SIJBAPI/api/FinalTask/SaveStudentwithclash"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        successCount++;
      }  else if (response.statusCode == 409) {
        alreadyAppliedCount++;
      } else if (response.statusCode == 302) {
        alreadysavedCount++;
      }
      else {
        failedCount++;
      }
    }

    Navigator.pop(context); // Close loading dialog

    // Final summary message
    String summary = " Saved: $successCount\n Already Applied: $alreadyAppliedCount\n Already Saved: $alreadysavedCount\n Failed: $failedCount";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(summary)),
    );
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occurred: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final student = widget.students[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Poster Image")),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Student Name: ${student.sName}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.green)),
                      Text("CGPA: ${student.sCgpa}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Semester: ${student.sSemester}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                         Text("Fyp Technology: ${student.fyp_technology??'N/A'}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "Technologies: ${student.technologies.isNotEmpty ? student.technologies.join(', ') : "N/A"}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text('Is Favourite??', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Checkbox(
                      value: selectedStudentIds.contains(student.sid),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedStudentIds.add(student.sid);
                          } else {
                            selectedStudentIds.remove(student.sid);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: isLoadingImage
                ? Center(child: CircularProgressIndicator())
                : studentImageUrl == null
                    ? Center(child: Text("No Image Available"))
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                          studentImageUrl!,
                         fit: BoxFit.contain,
                        // fit: BoxFit.none,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (_, __, ___) =>   
                              Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: currentIndex > 0
                    ? () {
                        setState(() {
                          currentIndex--;
                        });
                        loadStudentImage(widget.students[currentIndex].sid);
                      }
                    : null,
                child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Appconstant.appcolor),
                    child: Center(child: Text("<-- Previous Student"))),
              ),
              TextButton(
                onPressed: currentIndex < widget.students.length - 1
                    ? () {
                        setState(() {
                          currentIndex++;
                        });
                        loadStudentImage(widget.students[currentIndex].sid);
                      }
                    : null,
                child: Container(
                    height: 40,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Appconstant.appcolor),
                    child: Center(child: Text("Next Student →"))),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                if (selectedStudentIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select at least one student.")),
                  );
                  return;
                }

                await saveStudents();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected students saved successfully.")),
                );
                Navigator.pop(context);
              },
              child: Text("Save Selected Students"),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
