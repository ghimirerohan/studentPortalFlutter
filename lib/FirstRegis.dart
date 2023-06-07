// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'regAttach_ws.dart';

class FirstRegis extends StatefulWidget {
  const FirstRegis({Key? key}) : super(key: key);

  @override
  initState(){

  }

  @override
  State<FirstRegis> createState() => _FirstRegisState();
}
 late final String FullName , FatherName , DOB , Phone , EmailAdd;
  int step = 0;
  int attachAvail = 0;
  String attachName ='';
  List<String> nameCode = [];
  List<Map<String,String>> FieCodeName =[];
  List<String> BpartInfo = [];
Future<FilePickerResult> _pickFile() async {
  // opens storage to pick files and the picked file or files
  // are assigned into result and if no file is chosen result is null.
  // you can also toggle "allowMultiple" true or false depending on your need
  final result = await FilePicker.platform.pickFiles(allowMultiple: false);
  final nameCode = <String>[];
  nameCode.add(result!.files.first.name);
  nameCode.add(uint8ListTob64(result.files.first.bytes));
  return result;

  // if no file is picked
  print('List string');
  // print(nameCode);
  print('List string = name');
  print(nameCode[0]);
  print('List string = code');
  print(nameCode[0].runtimeType);
  // we will log the name, size and path of the
  // first picked file (if multiple are selected)
  // return nameCode;
}
String uint8ListTob64(Uint8List? value) {
  String base64String = base64Encode(value!);
  return base64String;
}
FilePickerResult? result;

class _FirstRegisState extends State<FirstRegis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 6,),
            Image.asset('assets/images/logo.png',height:66,width: 66,),
            SizedBox(height: 6,),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(left: 200 , right: 200 , bottom: 12,),
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
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Please Complete Your Registration First  !',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: ListView(shrinkWrap: true , children: [RegisProcess(step)]),),
                  SizedBox(height: 12,),
                  GestureDetector(
                    onTap: () {
                      if(step >=3 ){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content:  Text('Processing Data') ),);}
                      else{
                      setState(() {
                        step ++;
                      });}
                      // regAttach.send_reg_attach(nameCode[0].toString(), nameCode[1].toString());
                      },
                    child: Container(
                      alignment: Alignment.center,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF11998e),
                            Color(0xFF38ef7d),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          step >= 3 ?
                          'Register !' : 'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12,)
                ],),
              ),
            ),
        ],),),);
  }
}

class ContWithField extends StatelessWidget {
  String label;
  String hint;
  ContWithField(this.label , this.hint, {super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(child :Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: TextFormField(
        onFieldSubmitted: (value) {
         BpartInfo.add(value.toString());
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    ),);
  }
}
class ContWithFieldLabel extends StatelessWidget {
  String label;
  ContWithFieldLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(9),
        padding: const EdgeInsets.all(10),
        color: Color(0x00f5f5f5),
        child: TextFormField(
          onFieldSubmitted: (value) {
            // BpartInfo.add(value.toString());
          },
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
      ),
    );
  }
}


class ContWithFieldLabelandHint extends StatelessWidget {
  String label;
  String hint;
  ContWithFieldLabelandHint(this.label , this.hint);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Color(0x00f5f5f5),
        child: TextFormField(
          onFieldSubmitted: (value) {
            BpartInfo.add(value.toString());
          },
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
          ),
        ),
      ),
    );
  }
}
class ContWithFieldLabelandHintIterable extends StatelessWidget {
  int ind ;
  ContWithFieldLabelandHintIterable(this.ind);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 6,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 6,),
            Text('Experience Detials : ',style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18 , color: Color(0xFF800000),),),
          ],
        ),
       ListView.builder(
         shrinkWrap: true,
         itemCount: ind,
          itemBuilder: (BuildContext ctx, int index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ContWithFieldLabel(ExpInfo[0]),
                      ContWithFieldLabel(ExpInfo[1]),
                      ContWithFieldLabel(ExpInfo[2]),
                    ],
                  ),
                  SizedBox(height: 6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ContWithFieldLabelandHint(ExpInfo[3] , 'Temp/Perm'),
                      ContWithFieldLabelandHint(ExpInfo[4] , 'DD-MM-YYYY'),
                      ContWithFieldLabelandHint(ExpInfo[5], 'DD-MM-YYYY'),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
class ContWithFieldLabelandHintIterableGen extends StatelessWidget {
  int ind ;
  String title;
  ContWithFieldLabelandHintIterableGen(this.ind, this.title);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 6,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 6,),
            Text('$title',style: TextStyle(
    fontWeight: FontWeight.bold, fontSize: 18 , color: Color(0xFF800000),),),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
            itemCount: ind,
            itemBuilder: (BuildContext ctx, int index) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Divider(thickness: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ContWithFieldLabel(ResearchInfo[0]),
                        ContWithFieldLabelandHint(ResearchInfo[4] , 'DD-MM-YYYY'),
                        ContWithFieldLabel(ResearchInfo[1]),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ContWithFieldLabel(ResearchInfo[2]),
                        ContWithFieldLabelandHint(ResearchInfo[3] , 'remarks'),


                      ],
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}


List<String> ResearchInfo =[
  'Publication Name' , 'Journal' , 'Link(if any)', 'Remarks' ,'Year Published(AD)' ,
];

List<String> ExpInfo = [
  'Organization Name' , 'Position' , 'Level' , 'Employment Type' , 'Date From' , 'Date To'
];

List<String> EduInfo = [
  'Level','Program','Board','Institute','Passed Year',
  'Major Subject','Full Marks(% or GPA)','Obtained Marks(% or GPA)'
];
List<String> AcademicsLevel =[
  'SLC/SEE',
  '+2 Level',
  'Bachelor Level',
  'Master Level',
  'MPhil Level',
  'Phd. Level'
];

List<Map<String,String>> BPart = [{
  'label':'Full Name',
  'hint' : 'Your Name',
  'icon' : 'Icon(Icons.perm_identity_outlined, size: 25,)'
},
  {
    'label':'Father\'s Name',
    'hint' : 'father\'s name',
    'icon' : 'Icon(Icons.people, size: 25,)'
  },
  {
    'label':'DOB',
    'hint' : 'YYYY-MM-DD',
    'icon' : 'Icon(Icons.calendar_month, size: 25,)'
  },
  {
    'label':'Phone No.',
    'hint' : '98XXXXXXXX',
    'icon' : 'Icon(Icons.phone, size: 25,)'
  },
  {
    'label':'Email Address',
    'hint' : 'Your Name',
    'icon' : 'Icon(Icons.mail, size: 25,)'
  }
];

class RegisProcess extends StatefulWidget {
  int Step;
  RegisProcess(this.Step);

  State<RegisProcess> createState() => _RegisProcessState();
}
List<String> FileNamesTrans = [];
List<String> FileNamesChar = [];
int slecTrans = 0;
int slecChar = 0;
int ExpRow = 1;
int selecExp = 0;
String FileNamesExp = '..';
int PaperRow = 1;
int selLevel = 0;
int slecPhd = 0;
String FileNamesPhd = '..';
class _RegisProcessState extends State<RegisProcess> {
  @override
  void initState(){
    print('$selLevel Edu level');
    // for (var i = 0; i < 6; i++) {
    //   FileNamesChar[i] = 'Select';
    //   FileNamesTrans[i] = 'Select';
    // }
    // super.initState();
  }
  Widget phdTopic(int level){
    if(level == 6){
      return   Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18,width: 6,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Handwritten Note On Your Research Intention/Purpose[PhD.]', style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 18 , color: Color(0xFF800000),),),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 6,),
                  ContWithFieldLabel('Research Intention/Title'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Attachment : ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18 , color: Color(0xFF800000),),),
                    ElevatedButton(
                      onPressed: ()async {
                        // FilePickerResult rs = await _pickFile();
                        // String Fname = rs.files.first.name;
                        // setState(() {
                        //   FileNamesPhd = Fname;
                        //   slecPhd = 4;
                        // });
                      },
                      child: const Text('Documents :'),
                    ),
                    // Text(
                    //     FileNamesPhd.substring(0,slecPhd)),
                  ],
                ),
              )
            ],
          )
        ],
      );
    }
    else{
      return SizedBox(height: 2,);
    }
  }
  @override
  Widget build(BuildContext context) {
    switch(widget.Step){
    case 0:
        return Form(child:
          ListView.builder(itemCount: BPart.length,
          shrinkWrap: true,
          itemBuilder:  (BuildContext ctx, int index) {
            return Padding(
              padding: const EdgeInsets.only(left:24,top:9,right:24,bottom: 9),
              child: ContWithField(BPart[index]['label'].toString(),
                  BPart[index]['hint'].toString(),
                  ),
            );
          }),
      );
      case 1 :
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Choose your Academic Level : '),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: AcademicsLevel.length,
                  itemBuilder:(BuildContext ctxt, int index) {
                  return RadioListTile(
                    title: Text(AcademicsLevel[index]),
                    value: index+1,
                    groupValue: selLevel,
                    onChanged: (value){
                      setState(() {
                        selLevel = value as int;
                        print('Edu $selLevel');
                        // super.setState(() {});
                      });
                    },
                  );
                  }),
            ],
          ),
        );
      case 2 :
        return Form(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: selLevel,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Column(
                        children: [
                          SizedBox(height: 6,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 27,),
                              Text(AcademicsLevel[index], style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18 , color: Color(0xFF800000),),),
                            ],
                          ),
                          Divider(thickness: 4,),
                          Container(
                            padding: EdgeInsets.all(6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ContWithFieldLabel(EduInfo[0]),
                                    ContWithFieldLabel(EduInfo[1]),
                                    ContWithFieldLabel(EduInfo[2]),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ContWithFieldLabel(EduInfo[3]),
                                    ContWithFieldLabel(EduInfo[4]),
                                    ContWithFieldLabel(EduInfo[5]),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ContWithFieldLabel(EduInfo[6]),
                                    ContWithFieldLabel(EduInfo[7]),
                                  ],
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Attachments : ',style: TextStyle(fontWeight: FontWeight.bold),)],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              // FilePickerResult rs = await _pickFile();
                                              // String fName = rs.files.first.name;
                                              // setState(() {
                                              //   FileNamesTrans.add(fName);
                                              //   slecTrans = 4;
                                              // });
                                            },
                                            child: const Text(
                                                'Marksheet/Transcript :'),
                                          ),
                                          // Text(
                                          //     '${FileNamesTrans[index].substring(0,slecTrans)}..'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              // FilePickerResult rs = await _pickFile();
                                              // String Fname = rs.files.first.name;
                                              // setState(() {
                                              //   FileNamesChar.add(Fname);
                                              //   slecChar = 4;
                                              // });
                                            },
                                            child: const Text(
                                                'Character Certificate :'),
                                          ),
                                          // Text(
                                          //     FileNamesChar[index].substring(0,slecChar)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                phdTopic(selLevel),
              ],
            ),);
      case 3 :
        return Form(
          child: Column(
            children: [
              ContWithFieldLabelandHintIterable(ExpRow),
              SizedBox(height: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                         ExpRow ++;
                        });
                      },
                      child: const Text('Add New Record +'),
                    ),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Attachment : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18 , color: Color(0xFF800000),),),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: ()async {
                            FilePickerResult rs = await _pickFile();
                            String Fname = rs.files.first.name;
                            setState(() {
                              FileNamesExp = Fname;
                              slecTrans = 4;
                            });
                          },
                          child: const Text('Experience Details :'),
                        ),
                        Text(
                            FileNamesExp.substring(0,slecChar)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6,),
              Divider(thickness: 4,),
              SizedBox(height: 6,),
              ContWithFieldLabelandHintIterableGen(PaperRow,'Publication Details :'),
              SizedBox(height: 9,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: ()async {
                    setState(() {
                      PaperRow++;
                    });
                  },
                  child: const Text('Add New Record +'),
                ),),
              SizedBox(height: 6,),
            ],
          ),

        );
      default :
        return Center(
          child: Text('No Options here !'),
        );
    }
  }
  }

