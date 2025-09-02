import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/MentorAPIServices/MentorAPi.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/MentorScreens/Drawer.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/jobfair.dart';

class Jobfairadd extends StatefulWidget {
  const Jobfairadd({super.key});

  @override
  State<Jobfairadd> createState() => _JobfairaddState();
}

class _JobfairaddState extends State<Jobfairadd> {
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  TextEditingController year=TextEditingController();
  TextEditingController venue=TextEditingController();
   TextEditingController startdate=TextEditingController();
  TextEditingController enddate=TextEditingController();
   TextEditingController dateofjobfair=TextEditingController();

 void addnewJobFair()async{
    if (_formKey.currentState!.validate()) 
    {
      DateTime crdate=DateTime.now();
      String? crrdate='${crdate.year}-${crdate.month}-${crdate.day}';

      NewJobFair jf=NewJobFair
      (
        year: int.parse(year.text),
        venue: venue.text,
        startdate: startdate.text,
        enddate: enddate.text,
        jobfairdate: dateofjobfair.text,
        createdate: crrdate,

        


      );
      var response=await MemberApi.addjobfair(jf);
      if(response.statusCode==200){
        year.clear();
        venue.clear();
        crrdate='';
        startdate.clear();
        enddate.clear();
        dateofjobfair.clear();

      
        

        setState(() {
          
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job Fair added Successfully',),
        backgroundColor: Colors.green,));
        

      }
      else{
        setState(() {
          
        });
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some Internal Issue',),
            backgroundColor: Colors.red,));

      }

    }
  }
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MentorDrawer(),
      appBar: AppBar(
        title: Text('Add Job Fair'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height:25),
          
              CustomTextField
              (
               controller: year,
               label: 'Year',
               hint: 'Enter Year',
              // prefixIcon: Icon(Icons.numbers_outlined),
               validator: (value)
               {
                  if (value == null || value.isEmpty) 
                  {
                     return "Year cannot be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5,),
               CustomTextField
              (
               controller: venue,
               label: 'Venue',
               hint: 'Enter Job Fair Venue',
               prefixIcon: Icon(Icons.place),
               validator: (value)
               {
                  if (value == null || value.isEmpty) 
                  {
                     return "Venue cannot be empty";
                  }
                  return null;
                },
              ),
               const SizedBox(height: 10,),
          
              
              TextFormField(
                controller: startdate,
                readOnly: true,
                onTap: (){
                  setState(() {
                    pickdatetime(startdate);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter Apply Start Date',
                  labelText: 'Start Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color:Appconstant.appcolor!),
                  ),
                ),
                validator: (value)
               {
                  if (value == null || value.isEmpty) 
                  {
                     return "Start Date cannot be empty";
                  }
                  return null;
                },
              ),
          
              const SizedBox(height: 20,),
              TextFormField(
                readOnly: true,
                controller: enddate,
               // keyboardType: TextInputType.,
                onTap: (){
                  setState(() {
                    pickdatetime(enddate);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter Last Apply Date',
                  labelText: 'End Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color:Appconstant.appcolor!),
                  ),
                ),
                validator: (value)
               {
                  if (value == null || value.isEmpty) 
                  {
                     return "End Date cannot be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                readOnly: true,
                controller: dateofjobfair,
               // keyboardType: TextInputType.,
               
                onTap: (){
                  setState(() {
                    pickdatetime(dateofjobfair);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter Date of Job Fair',
                  labelText: 'Job Fair Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color:Appconstant.appcolor!),
                  ),
                ),
                validator: (value)
               {
                  if (value == null || value.isEmpty) 
                  {
                     return "Job Fair cannot be empty";
                  }
                  return null;
                },
              ),
          
              const SizedBox(height: 40,),
          
              ElevatedButton(onPressed: (){
                setState(() {
                  addnewJobFair();
                  
                });
              }, child: Text('Add Job Fair'))
          
             
            ],
          ),),
        ),
      ),

    );
    
    
  }
  Future<void> pickdatetime(TextEditingController controller)async{
    DateTime? _picked=await showDatePicker(
      context: context,
    initialDate: DateTime.now(),
     firstDate:DateTime(2000),
      lastDate: DateTime(2100)
      );

      if(_picked!=null){
        setState(() {
         controller.text = "${_picked.year}-${_picked.month}-${_picked.day}";

          
        });
      }


  }
  
}