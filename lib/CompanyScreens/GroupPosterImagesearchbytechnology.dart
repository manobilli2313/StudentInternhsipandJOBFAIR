
// s page mai dono search by title project ansd sesrach by fyptechnoogy howay hai at atyiem k chalay ga search mai 
// to ek ko removie kar k listview.builder mai name change krday list ka filetred ka b
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ProjectPosterStudentIamges.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudentsPoster.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SearchStudnetforcomany.dart';
 // Replace with your actual save student screen

class GroupPostersImages extends StatefulWidget {
  @override
  _GroupPostersImagesState createState() => _GroupPostersImagesState();
}

class _GroupPostersImagesState extends State<GroupPostersImages> {
  List<PosterGroup> allPosters = [];
  List<PosterGroup> filteredPosters = [];
    List<SearchStudent> searchedStudents = [];
    List<SearchStudent> searchestudentbytitle = [];
    List<SearchStudent> searchestudentbyskilltable = [];  

  TextEditingController technologySearchController = TextEditingController();
   TextEditingController titleSearchController = TextEditingController();
   TextEditingController skillSearchController = TextEditingController();
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
        filteredPosters = posters;
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
// search by fyp technology 
  Future<void> fetchStudentsByTechnology(String technology) async {
    setState(() {
      isLoading = true;
      isSearching = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

    final response = await CompanyApiServices.fetchstudentfypbase(technology, cid!);

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
        SnackBar(content: Text('Failed to fetch students for $technology')),
      );
    }
  }

  // search on base of studnetskill table techmology 

  Future<void> fetchStudentsByskilstable(String technology) async {
    setState(() {
      isLoading = true;
      isSearching = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

    final response = await CompanyApiServices.fetchstudentskillstablebase(cid!,technology);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final students = data.map((e) => SearchStudent.fromJson(e)).toList();

      setState(() {
      searchestudentbyskilltable = students;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch students for $technology')),
      );
    }
  }

  // search by fyp title
  Future<void> fetchStudentsBytitile(String title) async {
    setState(() {
      isLoading = true;
      isSearching = true;
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    int? cid = pref.getInt('companyid');

    final response = await CompanyApiServices.fetchstudenttitlebasefyp(cid!,title);

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body);
      final students = data.map((e) => SearchStudent.fromJson(e)).toList();

      setState(() {
        searchestudentbytitle = students;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch students for $title')),
      );
    }
  }

  void clearSearch() {
    setState(() {
      technologySearchController.clear();
      isSearching = false;
      searchedStudents = [];
      filteredPosters = allPosters;
      searchestudentbytitle=[];
      searchestudentbyskilltable=[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(title: Text("Group Posters Gallery")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: TextField(
                    //         controller: technologySearchController,
                    //         decoration: InputDecoration(
                    //           labelText: 'Search by Technology',
                    //           prefixIcon: Icon(Icons.search),
                    //           border: OutlineInputBorder(),
                    //         ),
                    //         onSubmitted: (value) {
                    //           if (value.isNotEmpty) {
                    //             fetchStudentsByTechnology(value);
                    //           } else {
                    //             clearSearch();
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //     IconButton(
                    //       icon: Icon(Icons.clear),
                    //       onPressed: clearSearch,
                    //     )
                    //   ],
                    // ),
                    SizedBox(height: 10,),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: TextField(
                    //         controller: titleSearchController,
                    //         decoration: InputDecoration(
                    //           labelText: 'Search by Title',
                    //           prefixIcon: Icon(Icons.search),
                    //           border: OutlineInputBorder(),
                    //         ),
                    //         onSubmitted: (value) {
                    //           if (value.isNotEmpty) {
                    //             fetchStudentsBytitile(value);
                    //           } else {
                    //             clearSearch();
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //     IconButton(
                    //       icon: Icon(Icons.clear),
                    //       onPressed: clearSearch,
                    //     )
                    //   ],
                    // ),


                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: skillSearchController,
                            decoration: InputDecoration(
                              labelText: 'Search by Student Skills',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                fetchStudentsByskilstable(value);
                              } else {
                                clearSearch();
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: clearSearch,
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    // Show Group Posters if not searching
                    if (!isSearching)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredPosters.length,
                        itemBuilder: (context, index) {
                          final group = filteredPosters[index];
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

                    // Show Individual Students if searching
                    if (isSearching)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searchestudentbyskilltable.length,
                        itemBuilder: (context, index) {
                          final student = searchestudentbyskilltable[index];
                          return GestureDetector(
                           onTap: () {
  if (student.jid != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectImagePosterScreen(
          students: [
            // manually convert student 
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
                                    Text("Name: ${student.sName}",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text("FYP Title: ${student.fypTitle}"),
                                    Text("CGPA: ${student.sCgpa}"),
                                    Text("Semester: ${student.sSemester}"),
                                    Text("Technology: ${student.fypTechnology}"),
                                   // Text("Poster: ${student.posterPath}"),
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
