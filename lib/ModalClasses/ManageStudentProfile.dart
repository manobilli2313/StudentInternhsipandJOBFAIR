import 'dart:io';

class StudentProfileModel {
  int sid;
  String? fypTitle;
  String? fypTechnology;
  bool isFypChecked;
  List<int> selectedTechnologies;
  File? cvFile;
  File? pptFile; // ✅ Must be added

  StudentProfileModel({
    required this.sid,
    this.fypTitle,
    this.fypTechnology,
    required this.isFypChecked,
    required this.selectedTechnologies,
    this.cvFile,
    this.pptFile,
  });
}
