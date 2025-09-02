import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudents.dart';

class showppt extends StatefulWidget {
  final int? sid, jid, cid;

  showppt({super.key, this.sid, this.jid, this.cid});

  @override
  State<showppt> createState() => _showpptState();
}

class _showpptState extends State<showppt> {
  List<String> imageUrls = [];
  PageController _pageController = PageController();
  int currentPage = 0;
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSlides();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

 void fetchSlides() async {
  final sid = widget.sid ?? 0;
  final response = await http.get(Uri.parse(
    "http://localhost/SIJBAPI/api/Company/GetStudentPPTSlides?sid=$sid"));

  if (response.statusCode == 200) {
    final List<dynamic> slides = json.decode(response.body);
    setState(() {
      imageUrls = List<String>.from(slides).map((url) {
        // Replace backend IP with localhost for browser
        return url.replaceFirst("192.168.1.5", "localhost");
      }).toList();
      _isLoading = false;
    });

    if (imageUrls.isNotEmpty) {
      startAutoSlide();
    }
  } else {
    print("Failed to load slides: ${response.body}");
    setState(() {
      _isLoading = false;
    });
  }
}


  void startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients && imageUrls.isNotEmpty) {
        currentPage = (currentPage + 1) % imageUrls.length;
        _pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void SaveStudent() async {
    SavedStudent save = SavedStudent(
      jobFairId: widget.jid!,
      studentId: widget.sid!,
      companyId: widget.cid!,
    );

    var response = await CompanyApiServices.savedstudent(save);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Saved Student"),
          content: Text("Student saved successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student already saved. No need to save again."),
         backgroundColor: Colors.red,),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save student. Try again."),
         backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Project PPT')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : imageUrls.isEmpty
              ? Center(
                  child: Text(
                    "No PPT available for this student",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300, // or use MediaQuery height
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Text("Failed to load image"));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Save Student"),
                                content: Text("Are you sure you want to save this student?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      SaveStudent();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Yes"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text('Save Student'),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
