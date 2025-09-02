import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/CompanyDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ProjectPPtScreen.dart';
import 'package:student_internship_and_jobfair_fyp/CompanyScreens/ProjectpptScreentwoTask.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/SavedStudentsPoster.dart';

class GroupPostersImages extends StatefulWidget {
  @override
  _GroupPostersImagesState createState() => _GroupPostersImagesState();
}

class _GroupPostersImagesState extends State<GroupPostersImages> {
  late Future<List<PosterGroup>> _posterGroups;

  @override
  void initState() {
    super.initState();
    _posterGroups = fetchPosterGroups();
  }

  Future<List<PosterGroup>> fetchPosterGroups() async {
    final response = await CompanyApiServices.fetcgroupstudentposter();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => PosterGroup.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load group posters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CompanyDrawer(),
      appBar: AppBar(title: Text("Group Posters Gallery")),
      body: FutureBuilder<List<PosterGroup>>(
        future: _posterGroups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posters = snapshot.data!;

          return SingleChildScrollView(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: posters.length,
              itemBuilder: (context, index) {
                final group = posters[index];
                return GestureDetector(
                  onTap: () {
                    if (group.jid != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectPPTScreen(
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
                          Text(group.fypTitle!??'',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          group.posterPath != null
                              ? Text("Poster: ${group.posterPath}")
                              : Text("No Poster"),
                          SizedBox(height: 10),
                          Text("Students:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ...group.students.map((s) => ListTile(
                                title: Text(s.sName),
                                subtitle: Text(
                                    "CGPA: ${s.sCgpa} | Semester: ${s.sSemester}"),
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
          );
        },
      ),
    );
  }
}
