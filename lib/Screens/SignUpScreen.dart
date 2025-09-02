import 'package:flutter/material.dart';
import 'package:student_internship_and_jobfair_fyp/APIServices/CompanyAPIServices/CompanyAPI.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/Constant.dart';
import 'package:student_internship_and_jobfair_fyp/Custom_Widgets/TextField.dart';
import 'package:student_internship_and_jobfair_fyp/ModalClasses/CompanySignUp.dart';
import 'package:student_internship_and_jobfair_fyp/Screens/LoginPage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name=TextEditingController();
  TextEditingController emailcont=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController contact=TextEditingController();
  TextEditingController description=TextEditingController();
  TextEditingController noofemployee=TextEditingController();
  
  
  

  void signup() async {
  if (_formKey.currentState!.validate()) {
    
    SignupCompanyModel companyModel = SignupCompanyModel(
      username: emailcont.text,
      password: password.text,
      name: name.text,
      contact: contact.text,
      description: description.text,
      noOfEmployees: int.tryParse(noofemployee.text) ?? 0,
    );

    bool success = await CompanyApiServices.companysignup(companyModel);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Successful!",)),
        
      );

      emailcont.text='';
      name.text='';
      password.text='';
      contact.text='';
      description.text='';
      noofemployee.text='';
       Navigator.pushReplacement
                          (
                            context, MaterialPageRoute(builder: (context) =>LoginPage() ),
                          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Failed!",))
      );
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(padding: EdgeInsets.all(16),
        child:  SafeArea(
          
          child: 
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Color.fromARGB(218, 97, 233, 70)),),
              const SizedBox(height: 25,),
             
              CustomTextField(controller:name ,
               label: "Company Name",
               hint: "Enter Company Name",
               prefixIcon: Icons.person,
                validator: (value)
                {
                  if (value == null || value.isEmpty) 
                  {
                        return "Name cannot be empty";
                  }
                  return null;
                },
          
              ),
              SizedBox(height: 8,),
              CustomTextField(controller: emailcont,
               label: 'Email',
                hint: 'Enter Username',
                prefixIcon: Icons.email,
                 validator: (value)
                {
                  if (value == null || value.isEmpty) 
                  {
                        return "Username cannot be empty";
                  }
                  return null;
                },
          
              ),
              SizedBox(height: 8,),
              CustomTextField(controller: password,
               label: 'Password',
                hint: 'Enter Your Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                 validator: (value)
                {
                  if (value == null || value.isEmpty) 
                  {
                        return "Password cannot be empty";
                  }
                  return null;
                },
          
              ),
              SizedBox(height: 8,),
              CustomTextField(controller: contact,
               label: 'Contact',
                hint: 'Enter Contact No',
                prefixIcon: Icons.phone,
                
                validator: (value)
                {
                  if (value == null || value.isEmpty) 
                  {
                        return "Contact cannot be empty";
                  }
                  return null;
                },
          
              ),
              SizedBox(height: 8,),
              CustomTextField(controller: description,
               label: 'Description',
                hint: 'Enter Description',
                prefixIcon: Icons.add,
                
                validator: (value)
                {
                  if (value == null || value.isEmpty) 
                  {
                        return "Description cannot be empty";
                  }
                  return null;
                },
          
              ),
               SizedBox(height: 8,),
              CustomTextField(controller: noofemployee,
               label: 'No Of Employees',
                hint: 'Total Number ',
                prefixIcon: Icons.group,
                
                validator: (value)
                {
                  if (value == null || value.isEmpty) 
                  {
                        return "Employees cannot be empty";
                  }
                  return null;
                },
          
              ),
              SizedBox(height: 5,),
               Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Already have an account?",style: TextStyle(fontSize: 12,color:Colors.black),),
                        const SizedBox(width: 6,),
                        GestureDetector
                        (onTap: (){
                          Navigator.pushReplacement
                          (
                            context, MaterialPageRoute(builder: (context) =>LoginPage() ),
                          );

                        },
                          child: Text('Login',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:const Color.fromARGB(218, 97, 233, 70), decoration: TextDecoration.underline,
                           decorationColor: Color.fromARGB(218, 97, 233, 70),),)),
                        
                      ],

                    ),

                      const SizedBox(height: 10),
              ElevatedButton(
                
                onPressed: (){
                  setState(() {
                      signup();
                    

                    
                  });
                
                 
            
              }, child: Text('Sign Up'),
              ),
              
              
          
            ],
          ),
        )
        )
        ),
        ),
      );
  
  }
}