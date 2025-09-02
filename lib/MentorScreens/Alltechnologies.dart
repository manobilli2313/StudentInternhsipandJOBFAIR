import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/InternsRequestandTechnologies.dart';

class TechnologiesALL extends StatefulWidget {
  const TechnologiesALL({super.key});

  @override
  State<TechnologiesALL> createState() => _TechnologiesALLState();
}

class _TechnologiesALLState extends State<TechnologiesALL> {
  
  @override
  void initState(){
    super.initState();
    gettechnologies();
  }
  
  TextEditingController namecont=TextEditingController();
  TextEditingController updatecont=TextEditingController();
  List<TechnologyModel> tlist=[];
  void gettechnologies()async{
    var response=await MemberApi.fetchTechnology();
    if(response.statusCode==200){
      tlist.clear();
      setState(() {
        var data= jsonDecode(response.body.toString());
       for(var i in data){
        tlist.add(TechnologyModel.fromJson(i));
       }

        
      });
    }else{
      setState(() {
        
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some Internal Error 500!',), backgroundColor: Colors.red,));
    }
  }

  void addtech()async{
    Addtechnology modelll=Addtechnology(name: namecont.text);
    var response=await MemberApi.addtechnology(modelll);
    if(response.statusCode==200){
     
      setState(() {
       
      
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Technology added succesfully!',),backgroundColor: Colors.green,));
      namecont.text='';
      gettechnologies();
      
    }
    else{
      setState(() {
        
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error while adding Technology Failed!!!',), backgroundColor: Colors.red,));
    }
  }

  void updatetechnology(int id,String name)async{
     var response=await MemberApi.edittechnology(id,name);
    if(response.statusCode==200){
     
      setState(() {
        
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Technology Updated succesfully!',),backgroundColor: Colors.green,));
       gettechnologies();
       updatecont.text='';
    }
    else{
      setState(() {
        
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error while Updateding Technology Failed!!!',), backgroundColor: Colors.red,));
    }
    

  }
   void deltechnology(int id)async{
     var response=await MemberApi.deletetechnology(id);
    if(response.statusCode==200){
      
     // namecont.text='';
      setState(() {
        
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Technology deleted succesfully!',)));
      gettechnologies();
    }
    else{
      setState(() {
        
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error while deleted Technology Failed!!!',)));
    }
    

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),

      appBar: AppBar(
        title: Text('Technologies'),

      ),
     body: tlist.isEmpty
    ? Center(
        child: Text(
          'No Technology found yet!',
          style: Appconstant.appcardstyle,
        ),
      )
    : ListView.builder(
      shrinkWrap: true, // Ensures it doesn't take infinite height
      itemCount: tlist.length,
      itemBuilder: (context, index) {
        TechnologyModel model = tlist[index];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 7,
            
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(model.name??'', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
              children: [
                Container(
              height: 30,
              width: 90,
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Update Technology'),
                  content: CustomTextField(
                    controller: updatecont,
                    label: 'Update Technology',
                    hint: 'Enter Technology Name',
                    prefixIcon: Icon(Icons.update),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        String inputData = updatecont.text.trim();
                        if (inputData.isNotEmpty) {
                          updatetechnology(model.id!, updatecont.text);
                          Navigator.pop(context);
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
                ),
                SizedBox(width: 8), // Spacing between buttons
              //   Container(
              // height: 30,
              // width:90,
              // child: ElevatedButton(
                 
              //     onPressed: () {
              //       showDialog(
              // context: context,
              // builder: (BuildContext context) {
              //   return AlertDialog(
              //     title: Text('Delete Technology'),
              //     content: Text('Are you sure you want to delete this technology?'),
              //     actions: [
              //       TextButton(
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //         child: Text('Cancel'),
              //       ),
              //       TextButton(
              //         onPressed: () {
              //           deltechnology(model.id!);
              //           Navigator.pop(context);
              //         },
              //         child: Text('OK', style: TextStyle(color: Colors.red)),
              //       ),
              //     ],
              //   );
              // },
              //       );
              //     },
              //     child: Text('Delete'),
              // ),
              //   ),
              ],
                    ),
                  
                  ],
                  
                  ),
            ),
          ),
        );
    
        
      },
    ),





// to ad technology 
      floatingActionButton: 
      FloatingActionButton(
  onPressed: () {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Technology'),
          content: CustomTextField(controller: namecont,
           label: 'Technology', hint: 'Enter Technology Name',
           prefixIcon: Icon(Icons.add),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without saving
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String inputData = namecont.text.trim();
                if (inputData.isNotEmpty) {
                  addtech();// Use inputData as needed
                  Navigator.pop(context); // Close dialog after adding
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