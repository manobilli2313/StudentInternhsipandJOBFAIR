import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ProjectPosterStudentIamges.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudentsPoster.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SearchStudnetforcomany.dart';

class GroupPostersImages extends StatefulWidget {
  @override
  _GroupPostersImagesState createState() => _GroupPostersImagesState();
}

class _GroupPostersImagesState extends State<GroupPostersImages> {
  List<PosterGroup> allPosters = [];
  List<SearchStudent> searchedStudents = [];
   List<SearchStudent> searchedStudents2= [];

  TextEditingController technologySearchController = TextEditingController();
  TextEditingController titleSearchController = TextEditingController();

  bool isLoading = true;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchPosterGroups();
  }

  Future<void> fetchPosterGroups() async {
    setState(() => isLoading = true);

    final response = await CompanyApiServices.fetcgroupstudentposter();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final posters = data.map((e) => PosterGroup.fromJson(e)).toList();

      setState(() {
        allPosters = posters;
        isLoading = false;
        isSearching = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load group posters')),
      );
    }
  }


  // fetch on base of fyptitle ans fy technoogy 

  Future<void> fetchStudentsByFYPAndTechnology() async {
    String technology = technologySearchController.text.trim();
    String title = titleSearchController.text.trim();

    if (technology.isEmpty && title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter Technology or FYP Title to search')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      isSearching = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

    final response = await CompanyApiServices.fetchstudentfypandtechnologybase(technology, cid!, title);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final students = data.map((e) => SearchStudent.fromJson(e)).toList();

      setState(() {
        searchedStudents = students;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch students')),
      );
    }
  }


  // serach on base of studentskill base etchnlgoy and fy title 

   Future<void> fetchStudentsskillsAndTechnology() async {
    String technology = technologySearchController.text.trim();
    String title = titleSearchController.text.trim();

    if (technology.isEmpty && title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter Technology or FYP Title to search')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      isSearching = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

    final response = await CompanyApiServices.fetchstudentfypandtechnologybase(technology, cid!, title);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final students = data.map((e) => SearchStudent.fromJson(e)).toList();

      setState(() {
        searchedStudents2 = students;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch students')),
      );
    }
  }

  void clearSearch() {
    setState(() {
      technologySearchController.clear();
      titleSearchController.clear();
      isSearching = false;
      searchedStudents = [];
      searchedStudents2=[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(title: Text("Group Posters")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: technologySearchController,
                            decoration: InputDecoration(
                              labelText: 'Enter Technology',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: titleSearchController,
                            decoration: InputDecoration(
                              labelText: 'Enter FYP Title',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: fetchStudentsByFYPAndTechnology,
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: clearSearch,
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    // Show Posters if not searching
                    if (!isSearching)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allPosters.length,
                        itemBuilder: (context, index) {
                          final group = allPosters[index];
                          return GestureDetector(
                            onTap: () {
                              if (group.jid != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectImagePosterScreen(
                                      students: group.students,
                                      activeJobFairId: group.jid!,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("This group has no Job Fair ID")),
                                );
                              }
                            },
                            child: Card(
                              margin: EdgeInsets.all(10),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(group.fypTitle ?? '',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 6),
                                    group.posterPath != null && group.posterPath!.isNotEmpty
                                        ? Text("Poster: ${group.posterPath}")
                                        : Text("No Poster"),
                                    SizedBox(height: 10),
                                    Text("Students:", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ...group.students.map((s) => ListTile(
                                          title: Text(s.sName),
                                          subtitle: Text("CGPA: ${s.sCgpa} | Semester: ${s.sSemester}"),
                                          trailing: s.pptFile != null
                                              ? Icon(Icons.picture_as_pdf)
                                              : Icon(Icons.file_present_outlined),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    // Show Students if searching
                    if (isSearching)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searchedStudents2.length,
                        itemBuilder: (context, index) {
                          final student = searchedStudents2[index];
                          return GestureDetector(
                            onTap: () {
                              if (student.jid != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectImagePosterScreen(
                                      students: [
                                        PosterStudent(
                                          
                                          sid: student.sid,
                                          sName: student.sName,
                                          sCgpa: student.sCgpa,
                                          sSemester: student.sSemester,
                                          pptFile: student.posterPath,
                                          fyp_technology: student.fypTechnology,
                                          technologies: student.technologies,
                                        )
                                      ],
                                      activeJobFairId: student.jid!,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("This student has no Job Fair ID")),
                                );
                              }
                            },
                            child: Card(
                              margin: EdgeInsets.all(10),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name: ${student.sName}",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text("FYP Title: ${student.fypTitle ?? ''}"),
                                    Text("CGPA: ${student.sCgpa}"),
                                    Text("Semester: ${student.sSemester}"),
                                    Text("Technology: ${student.fypTechnology}"),
                                    Text("Poster: ${student.posterPath ?? ''}"),
                                    SizedBox(height: 6),
                                    Text("Skills: ${student.technologies.join(', ')}"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
