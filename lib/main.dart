import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:register_openu/login/login.dart';
import 'package:get_storage/get_storage.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // registerWebViewWebImplementation();
  await GetStorage.init();
  runApp(MaterialApp(
    title: 'Student Portal NOU',
    theme: ThemeData(
      primaryColor: Colors.blueAccent
    ),
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}
class Register extends StatefulWidget {

   Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController dateinput = TextEditingController();
  String mail = '';
  String gender = 'Male';
  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();
  void showSnack(String text , Color color){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: Duration(seconds: 3) ,content: Text(text , style: TextStyle(color: color),)),
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(child:
        Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: ListView(children : [Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,
                ),
                Image.asset('assets/images/ltu.png',height: 100,width: 100,),
                SizedBox(height: 10,),
                Text(
                  'Lumbini Technological University',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 500,
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  Color(0xFF7F7FD5),
                                  Color(0xFF86A8E7),
                                  Color(0xFF91EAE4),
                                ]
                              )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 12,),
                                Text('Entrance Registration Form',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black,
                                ),),
                                SizedBox(height: 12,),
                                Text('Please Enter Your Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),)
                              ],
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Container(
                              alignment: Alignment.center,
                              width: 400,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white30.withOpacity(0.1),
                                    spreadRadius: 10,
                                    blurRadius: 10,
                                    offset: Offset(0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child:Padding(
                              padding:EdgeInsets.all(10),
                              child :Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'FORM',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.redAccent[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width :400,
                                  padding: EdgeInsets.all(15),
                                  child: TextFormField(
                                    validator: ValidationBuilder().minLength(1,'*Required').maxLength(50,'Long Expression').build(),
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: 400,
                                    child:TextField(
                                      controller: dateinput, //editing controller of this TextField
                                      decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.event), //icon of text field
                                          labelText: "Date of Birth(AD)" //label text of field
                                      ),
                                      readOnly: true,  //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context, initialDate: DateTime.now(),
                                            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime(2101)
                                        );

                                        if(pickedDate != null ){
                                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                          //you can implement different kind of Date Format here according to your requirement

                                          setState(() {
                                            dateinput.text = formattedDate; //set output date to TextField value.
                                          });
                                        }else{
                                          print("Date is not selected");
                                        }
                                      },
                                    ),
                                  ),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width : 400,
                                  child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text('Gender ',style: TextStyle(fontSize: 9, decoration: TextDecoration.none),),
                                      items:['Male' , 'Female' , 'Other'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    value: gender,
                                    onChanged: (value){
                                        setState(() {
                                          gender = value!;
                                        });
                                    },
                                ),),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width :400,
                                  child: PhoneFormField(
                                    enableInteractiveSelection : false,
                                    defaultCountry : IsoCode.NP,
                                    decoration: InputDecoration(
                                      labelText: 'Phone no.',
                                      suffixIcon: Icon(Icons.phone)
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 400,
                                  padding: EdgeInsets.all(15),
                                  child: TextFormField(
                                    validator:ValidationBuilder().email('Enter Valid Email').build() ,
                                    onChanged: (value) {
                                      mail = value;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Email Address/Username',
                                      hintText: 'mail@mail.com',
                                      suffixIcon: const Icon(Icons.mail, size: 25,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                GestureDetector(
                                  onTap: (){
                                    if (_formKey.currentState!.validate()) {
                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.
                                      showSnack('Processing Data', Colors.purpleAccent);
                                    }
                                    else{showSnack('Invalid Data', Colors.redAccent);}
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF7F7FD5),
                                          Color(0xFF86A8E7),
                                          Color(0xFF91EAE4),
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Text(
                                        'REGISTER',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12,),
                                GestureDetector(
                                  onTap: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  LoginPage()),
                              );
                              },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 300,
                                    child: Text(
                                      'or Login if already Registered',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent[700],
                                      ),
                                    ),
                                  ),
                                ),

                              ],//children of
                            ),),),
                          ),
                        ],
                      )
                    ],
                  ),

              ],

            ),])

          ),


    ));
  }
}
