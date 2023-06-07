import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:register_openu/ad_user_ws.dart';
import 'package:register_openu/authentication_ws.dart';
import 'package:form_validator/form_validator.dart';
import 'package:register_openu/dash_menu_student.dart';
import 'package:register_openu/main.dart';
import 'package:smart_timer/smart_timer.dart';

import '../dash_menu.dart';
import 'package:register_openu/FirstRegis.dart';

class LoginPage extends StatefulWidget {
   LoginPage({Key? key}) : super(key: key);


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String imageDPPhoto = '';
  Future<void> StartService(String user_id , String user_pass , BuildContext ctx)async {

    // user_id = 'koiralanabina@gmail.com';
    // user_pass = 'nabina@987';
    GetStorage().write('id' , user_id);
    await login_ws.second_token(user_id, user_pass , ctx);
    status = await GetStorage().read('LoginStatus');
    if(status == 200){
      await ad_user_ws.check_reg();
      Future.delayed(Duration(seconds: 2));
      imageDPPhoto = GetStorage().read('bPartnerimg').toString();
    }
  }
  var status = 0;
  int LoginStat = 0;
   String user_id ='';

   String user_pass ='';

   int pass = 0;
   void initState()  {
     super.initState();
   }

  final _formKey = GlobalKey<FormState>();

   Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF7F7FD5),
                  Color(0xFF86A8E7),
                  Color(0xFF91EAE4),
                ]
            )
        ),
        child: ListView(
          children: [Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18,),
              Image.asset('assets/images/ltu.png',height: 100,width: 100,),
              SizedBox(height: 15,),
              Text('Lumbini Technological University',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15,),
              Form(
                key: _formKey,
                child: Container(
                  height: 522,
                  width: 420,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 21,),
                      Text(
                        'Student Panel',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Please Login To Your Account',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey
                        ),
                      ),
                      SizedBox(height: 21,),
                      Padding(padding: EdgeInsets.all(12),child: SizedBox(
                        child: LoginStat == 0 ? Text('') : Container(
                          color: Color(0xFFFF9494),
                          child: Text('Provided Credentials Are InCorrect . Please Recheck !',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        ),
                      ),),
                      Container(
                        width :300,
                        child: TextFormField(
                          // controller: TextEditingController(text: 'koiralanabina@gmail.com'),
                          validator: ValidationBuilder().minLength(1,'*Required').maxLength(50,'Long Expression').build() ,
                          onChanged: (value){user_id = value;GetStorage().write('id' , user_id);},
                          onTap: (){setState(() {
                            LoginStat == 1 ? LoginStat = 0 : null;
                          });},
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            suffixIcon: Icon(Icons.mail, size: 25,),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          // controller: TextEditingController(text: 'nabina@987'),
                          validator: ValidationBuilder().minLength(1,'*Required').maxLength(50,'Long Expression').build() ,
                          onChanged: (value){user_pass = value;},
                          onTap: (){setState(() {
                            LoginStat == 1 ? LoginStat = 0 : null;
                          });},
                          obscureText: pass==0 ? true: false,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  pass == 0 ? pass = 1 : pass = 0;
                                });
                              },
                                child: pass==0 ? Icon(Icons.remove_red_eye_sharp, size:25,) : Icon(Icons.remove_red_eye_outlined, size:25,),
                                    ),
                                ),
                                ),
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(25, 25, 50, 25),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                Text(
                                'Forget Password ?',
                                style
                              : TextStyle(
                                color: Colors.redAccent[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {
                            await StartService(user_id, user_pass , context);
                            print(status);
                            // var regStatus = await GetStorage().read('reg_st');
                            if (status != 200) {
                              setState(() {
                                LoginStat = 1;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(seconds: 3),
                                    content: Text('Invalid ID/Password',
                                      style: TextStyle(
                                          color: Colors.redAccent),)),
                              );
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(seconds: 3) ,content: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    Text('Loading' , style: TextStyle(color: Colors.black),),
                                  ],
                                )),
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      DashMenuStd(imageDPPhoto)));
                            }
                          }},

                          child :Container(
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
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shadowColor: Colors.white,elevation: 0),),
                      SizedBox(height: 21,),
                      Text('Or Register here for first Entrance Appear',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6,),
                      Padding(padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap:() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        Register()));
                                       },
                              child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.redAccent[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),],
        ),
      ),
    );
  }
}
