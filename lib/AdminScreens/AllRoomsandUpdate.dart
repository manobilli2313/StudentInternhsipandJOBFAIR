import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Rooms.dart';

class AllRooms extends StatefulWidget {
  const AllRooms({super.key});

  @override
  State<AllRooms> createState() => _AllRoomsState();
}

class _AllRoomsState extends State<AllRooms> {
  TextEditingController namecont = TextEditingController();
  TextEditingController updatecont = TextEditingController();
  List<RoomModel> tlist = [];

  @override
  void initState() {
    super.initState();
    getrooms();
  }

  Future<void> getrooms() async {
    try {
      var response = await AdminAPI.fetchrooms();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        tlist.clear();
        for (var i in data) {
          tlist.add(RoomModel.fromJson(i));
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Some Internal Error 500!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exception Occurred!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> addtech() async {
    RoomModel modelll = RoomModel(name: namecont.text);
    var response = await AdminAPI.addroom(modelll);
    if (response.statusCode == 200) {
      namecont.text = '';
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await getrooms();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Room added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while adding room!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updatetechnology(int id, String name) async {
    var response = await AdminAPI.editroom(id, name);
    if (response.statusCode == 200) {
      updatecont.text = '';
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await getrooms();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Room updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating room!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deltechnology(int id) async {
    var response = await MemberApi.deletetechnology(id);
    if (response.statusCode == 200) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await getrooms();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room deleted successfully!')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting room!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: AdminDrawer(),
      appBar: AppBar(title: Text('All Rooms')),
      body: tlist.isEmpty
          ? Center(
              child: Text(
                'No Rooms found yet!',
                style: Appconstant.appcardstyle,
              ),
            )
          : ListView.builder(
              itemCount: tlist.length,
              itemBuilder: (context, index) {
                RoomModel model = tlist[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              model.name ?? 'No Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              updatecont.text = model.name ?? '';
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Update Room'),
                                    content: CustomTextField(
                                      controller: updatecont,
                                      label: 'Update Room',
                                      hint: 'Enter Room Name',
                                      prefixIcon: Icon(Icons.update),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          String inputData = updatecont.text.trim();
                                          if (inputData.isNotEmpty && model.id != null) {
                                            Navigator.pop(context);
                                            await updatetechnology(model.id!, inputData);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Room ID is missing!')),
                                            );
                                          }
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Edit'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              await deltechnology(model.id!);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enter Room'),
                content: CustomTextField(
                  controller: namecont,
                  label: 'Room',
                  hint: 'Enter Room Name',
                  prefixIcon: Icon(Icons.add),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String inputData = namecont.text.trim();
                      if (inputData.isNotEmpty) {
                        Navigator.pop(context);
                        await addtech();
                      }
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
