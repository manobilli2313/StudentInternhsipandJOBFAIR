import 'dart:async';

import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudentsPoster.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectPPTScreen extends StatefulWidget {
  final List<PosterStudent> students;
  final int activeJobFairId;

  ProjectPPTScreen({
    required this.students,
    required this.activeJobFairId,
  });

  @override
  State<ProjectPPTScreen> createState() => _ProjectPPTScreenState();
}

class _ProjectPPTScreenState extends State<ProjectPPTScreen> {
  int currentIndex = 0;
  List<String> slideUrls = [];
  bool isLoadingSlides = true;
  PageController _pageController = PageController();
  Timer? _slideTimer;
  int currentSlideIndex = 0;

  @override
  void initState() {
    super.initState();
    loadSlidesForStudent(widget.students[currentIndex].sid);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideTimer?.cancel();
    super.dispose();
  }

  void startAutoSlide() {
    _slideTimer?.cancel();
    if (slideUrls.isEmpty) return;

    _slideTimer = Timer.periodic(Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        currentSlideIndex = (currentSlideIndex + 1) % slideUrls.length;
        _pageController.animateToPage(
          currentSlideIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

Future<void> loadSlidesForStudent(int sid) async {
  if (!mounted) return;
  setState(() {
    isLoadingSlides = true;
    slideUrls = [];
    currentSlideIndex = 0;
  });

  _slideTimer?.cancel();

  final response = await http.get(Uri.parse(
    "http://10.130.184.162/SIJBAPI/api/Company/GetStudentPPTSlides?sid=$sid",
  ));

  if (!mounted) return;

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    final urls = List<String>.from(data)
        .map((url) => url.replaceFirst("192.168.1.5", "10.130.184.162"))
        .toList();

  

    if (!mounted) return;
    setState(() {
      slideUrls = urls;
      isLoadingSlides = false;
    });

    startAutoSlide();
  } else {
    if (!mounted) return;
    setState(() {
      slideUrls = [];
      isLoadingSlides = false;
    });
  }
}


// here add if already exist student then no need to add 
  Future<void> saveStudents() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

    for (var student in widget.students) {
      final body = {
        "StudentID": student.sid,
        "CompanyID": cid!,
        "JobFairID": widget.activeJobFairId,
      };

      await http.post(
        Uri.parse("http://10.130.184.162/SIJBAPI/api/Company/SaveStudent"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.students[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("PPT Slides")),
      body: Column(
        children: [
          SizedBox(height: 10),
         Text("Student Name: ${student.sName}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green)),
Text("CGPA: ${student.sCgpa}", style: TextStyle(fontWeight: FontWeight.bold)),
Text("Semester: ${student.sSemester}", style: TextStyle(fontWeight: FontWeight.bold)),
Text("Fyp Technology: ${student.fyp_technology??'--'}", style: TextStyle(fontWeight: FontWeight.bold)),

 
SizedBox(height: 6),
Text(
  "Technologies: ${student.technologies.isNotEmpty ? student.technologies.join(', ') : "N/A"}",
  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
),

          SizedBox(height: 10),
          Expanded(
            child: isLoadingSlides
                ? Center(child: CircularProgressIndicator())
                : slideUrls.isEmpty
                    ? Center(child: Text("No PPT slides available"))
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: slideUrls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.network(
                              slideUrls[index],
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (_, __, ___) =>
                                  Center(child: Icon(Icons.broken_image)),
                            ),
                          );
                        },
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
                        loadSlidesForStudent(widget.students[currentIndex].sid);
                      }
                    : null,
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Appconstant.appcolor
                  ),
                  child: Center(child: Text("<--Previous Student"))),
              ),
              TextButton(
                onPressed: currentIndex < widget.students.length - 1
                    ? () {
                        setState(() {
                          currentIndex++;
                        });
                        loadSlidesForStudent(widget.students[currentIndex].sid);
                      }
                    : null,
                child: Container(
                  height: 40,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Appconstant.appcolor
                  ),
                  child: Center(child: Text("Next Student →"))),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                await saveStudents();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Students saved successfully.")),
                );
                Navigator.pop(context);
              },
              child: Text("Save Students"),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
