import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/StudentAPiServices/StudentApi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/ManageStudentProfile.dart';
import 'package:student_internship_and_jobfair_fyp/StudentScreens/StudentDrawer.dart';
import 'package:file_picker/file_picker.dart';



class StudentProfileScreen extends StatefulWidget {
  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool isFypChecked = false;
  bool _showTechnologyDropdown = false;

  TextEditingController fypTitleController = TextEditingController();
  TextEditingController fypTechnologyController = TextEditingController();
  List<TechnologyModel> _technologies = [];
  List<int> _selectedTechnologyIds = [];
  File? _cvFile;
  File? _pptFile; // ✅ New variable for PPT

  @override
  void initState() {
    super.initState();
    _loadTechnologies();
  }

  Future<void> _loadTechnologies() async {
    List<TechnologyModel> fetchedTechnologies =
        await StudentApiService.fetchTechnologies();
    setState(() {
      _technologies = fetchedTechnologies;
    });
  }

  void _pickCvFile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _cvFile = File(pickedFile.path);
      });
    }
  }

 void _pickPptFile() async {
  // FilePickerResult? result = await FilePicker.platform.pickFiles(
  //   type: FileType.custom,
  //   allowedExtensions: ['ppt', 'pptx'],
  // );

  // if (result != null && result.files.single.path != null) {
  //   setState(() {
  //     _pptFile = File(result.files.single.path!);
  //   });
  // }
  final result=
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        _pptFile= File(result.path);
      });
    }
}


  void _submitProfile() async {
    if (isFypChecked) {
      if (fypTitleController.text.isEmpty ||
          fypTechnologyController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                "FYP Title and Technology are required if FYP is completed!",
                
              ), backgroundColor: Colors.red,),
        );
        return;
      }
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('studentid') ?? 0;

    StudentProfileModel studentProfile = StudentProfileModel(
      sid: id,
      fypTitle: isFypChecked ? fypTitleController.text : '',
      fypTechnology: isFypChecked ? fypTechnologyController.text : null,
      isFypChecked: isFypChecked,
      selectedTechnologies: _selectedTechnologyIds,
      cvFile: _cvFile,
      pptFile: _pptFile, // ✅ Add ppt to model
    );

    bool success =
        await StudentApiService.manageStudentProfile(studentProfile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Profile updated successfully!" : "Failed to update profile.${id}",
          //style: Appconstant.scaffoldcolor,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentdrawerScreen(),
      appBar: AppBar(title: Text("Manage Student Profile")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                title: Text("Have you been assigned an FYP?"),
                value: isFypChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isFypChecked = value ?? false;
                    if (!isFypChecked) {
                      fypTitleController.clear();
                      fypTechnologyController.clear();
                    }
                  });
                },
              ),
              if (isFypChecked) ...[
                CustomTextField(
                  controller: fypTitleController,
                  label: 'FYP Title',
                  hint: 'Enter Your FYP Title',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: fypTechnologyController,
                  label: 'FYP Technology',
                  hint: 'Enter Your FYP Technology',
                ),
              ],
              SizedBox(height: 10),
              GestureDetector(
                onTap: () =>
                    setState(() => _showTechnologyDropdown = !_showTechnologyDropdown),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Technologies"),
                      Icon(_showTechnologyDropdown
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              if (_showTechnologyDropdown)
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                  constraints: BoxConstraints(maxHeight: 200),
                  child: ListView(
                    shrinkWrap: true,
                    children: _technologies.map((tech) {
                      return CheckboxListTile(
                        title: Text(tech.name!),
                        value: _selectedTechnologyIds.contains(tech.id),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedTechnologyIds.add(tech.id!);
                            } else {
                              _selectedTechnologyIds.remove(tech.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: 20),

              // ✅ CV Button
              ElevatedButton(
                onPressed: _pickCvFile,
                child: Text("Upload CV"),
              ),

              // ✅ CV Preview
              if (_cvFile != null)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: FileImage(_cvFile!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              SizedBox(height: 20),

              // ✅ PPT Button
              ElevatedButton(
                onPressed: _pickPptFile,
                child: Text("Upload PPT"),
              ),

              // ✅ PPT Preview (name only)
              if (_pptFile != null)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        _pptFile!.path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitProfile,
                child: Text("Submit Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
