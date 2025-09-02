import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';

class AssignRoomPage extends StatefulWidget {
  @override
  _AssignRoomPageState createState() => _AssignRoomPageState();
}

class _AssignRoomPageState extends State<AssignRoomPage> {
  List<Map<String, dynamic>> availableCompanies = [];
  List<Map<String, dynamic>> availableRooms = [];
  int? selectedCompanyId;
  int? selectedRoomId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAvailableData();
  }

  Future<void> fetchAvailableData() async {
    setState(() => isLoading = true);
    try {
      final response = await MemberApi.getAvailableRoomsAndCompanies();
      setState(() {
        availableCompanies = List<Map<String, dynamic>>.from(response['availableCompanies'])
            .where((company) => company['id'] != null)
            .toList();
        availableRooms = List<Map<String, dynamic>>.from(response['availableRooms'])
            .where((room) => room['id'] != null)
            .toList();
      });
    } catch (e) {
      showErrorSnackBar('Error fetching data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> assignRoom() async {
    if (selectedCompanyId == null || selectedRoomId == null) {
      showErrorSnackBar('Please select both a company and a room.');
      return;
    }

    setState(() => isLoading = true);
    try {
      bool success = await MemberApi.assignRoomToCompany(selectedCompanyId!, selectedRoomId!);
      if (success) {
        showSuccessSnackBar('Room assigned successfully!');
        fetchAvailableData(); // Refresh data after assigning
        setState(() {
          selectedCompanyId = null;
          selectedRoomId = null;
        });
      } else {
        showErrorSnackBar('Failed to assign room. Try again. Time Clash Occue for that Room');
      }
    } catch (e) {
      showErrorSnackBar('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(title: Text('Allocate Rooms')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  SizedBox(height: 20),
                  Text('Select Company:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      hintText: 'Choose a company',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Appconstant.appcolor!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedCompanyId,
                    items: availableCompanies.map((company) {
                      return DropdownMenuItem<int>(
                        value: company['id'],
                        child: Text(company['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCompanyId = value;
                        selectedRoomId = null; // Reset room selection when company changes
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  Text('Select Room:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      hintText: 'Choose a room',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Appconstant.appcolor!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedRoomId,
                    items: availableRooms.map((room) {
                      return DropdownMenuItem<int>(
                        value: room['id'],
                        child: Text(room['roomName']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoomId = value;
                      });
                    },
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: selectedCompanyId != null && selectedRoomId != null
                          ? assignRoom
                          : () {
                              showErrorSnackBar('Please select both a company and a room.');
                            },
                      child: Text('Assign Room'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
