import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/AdminAPIServices/AdminAPI.dart';
import 'package:student_internship_and_jobfair_fyp/AdminScreens/AdminDrawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/Rooms.dart';

import '../Custom_Widgets/TextField.dart';

class ALlVenue extends StatefulWidget {
  const ALlVenue({super.key});

  @override
  State<ALlVenue> createState() => _ALlVenueState();
}

class _ALlVenueState extends State<ALlVenue> {

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    floatingActionButton: FloatingActionButton(onPressed: (){
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


    },child: Icon(Icons.add),),

      drawer: AdminDrawer(),
      appBar: AppBar(title: Text('All Venue'),),
      body:tlist.isEmpty? Center(child: Text('No Venue available right now'),):
      ListView.builder(itemCount: tlist.length,itemBuilder: (context,index){
        RoomModel model=tlist[index];
        return Card(
          child: ListTile(
            title: Text(model.name??'no name'),
            trailing: SizedBox(
              width: 120,height: 30,
              child: ElevatedButton(
                
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
                 child: Text("Edit",style: TextStyle(color: Colors.white),)))


          ),
        );

      }
    ));
  }
}