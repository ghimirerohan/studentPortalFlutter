import 'dart:convert';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sidebarx/sidebarx.dart';
import 'regInfoPost_ws.dart';
import 'entranceOpenWS.dart';
import 'courseregWS.dart';
import 'paymentWS.dart';
import 'dart:html' as html;
import 'package:js/js.dart' ;
import 'package:js/js_util.dart' as js_util;




class DashMenu extends StatefulWidget {
  DashMenu({Key? key}) : super(key: key);

  @override
  State<DashMenu> createState() => _DashMenuState();
}

class _DashMenuState extends State<DashMenu> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  final _key = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headline5: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
              backgroundColor: canvasColor,
                  title: Text(_getTitleByIndex(_controller.selectedIndex)),
                  leading: IconButton(
                    onPressed: () {
                  // if (!Platform.isAndroid && !Platform.isIOS) {
                  //   _controller.setExtended(true);
                  // }
                  _key.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
            )
                : null,
            drawer: DashSidebar(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) DashSidebar(controller: _controller),
                Expanded(
                  child: Center(
                    child: _Screens(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DashSidebar extends StatelessWidget {
  const DashSidebar({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/logo.png',height: 77,width: 77,),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            debugPrint('Home');
          },
        ),
        SidebarXItem(
          icon: Icons.people,
          label: 'Student Info',
          onTap: () {
            debugPrint('Student');
          },
        ),
        SidebarXItem(
          icon: Icons.offline_pin_rounded,
          label: 'Entrance',
          onTap: () {
            debugPrint('Entrance');
          },
        ),
        SidebarXItem(
          icon: Icons.attach_money_outlined,
          label: 'Transactions',
          onTap: () {
            debugPrint('TXN');
          },
        ),
        // const SidebarXItem(
        //   icon: Icons.book,
        //   label: 'Admission',
        // ),
        // const SidebarXItem(
        //   icon: Icons.app_registration,
        //   label: 'Registration',
        // ),
        // const SidebarXItem(
        //   icon: Icons.school_sharp,
        //   label: 'Scholarship',
        // ),
        // const SidebarXItem(
        //   icon: Icons.pending_actions,
        //   label: 'Exam',
        // ),
      ],
    );
  }
}

class _Screens extends StatefulWidget {
  _Screens({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final SidebarXController controller;


  @override
  State<_Screens> createState() => _ScreensState();
}

class _ScreensState extends State<_Screens> {

  final _formKey = GlobalKey<FormState>();

  final GenInfoList = <String>[];

  final LocationInfoList = <String>[];

  final OtherInfoList = <String>[];
  @override
  initState(){
    // int? regStatus = GetStorage().read('reg_st') ;
       runWSServices();
    super.initState();
  }
  entranceOpenInfo eInfoPost = entranceOpenInfo();
  List<String> idOfEntApp = [];
  List<dynamic> dataEntInfofromAPI = [];
  List<dynamic> dataEntInfo = [];
  List<dynamic> CourseInfo = [];
  List<dynamic> CourseInfoAdd = [];
  List<dynamic> dataEntInfoApp = [];
  List<dynamic>? foundRecords = null;
  List<String> acaYearDD = [];
  List<String> inTakeDD = [];
  List<String> FacultyDD = [];
  List<String> ProgramDD = [];
  List<String> SubjectDD = [];
  List<String> acaYearDDF = [];
  List<String> inTakeDDF = [];
  List<String> FacultyDDF = [];
  List<String> ProgramDDF = [];
  List<String> SubjectDDF = [];
  String chosenValueacDD ='';
  String chosenValueitDD ='';
  String chosenValuefcDD ='';
  String chosenValuepgDD ='';
  String chosenValuesubDD ='';
  Map<String,dynamic> acaId ={};
  Map<String,dynamic> intId ={};
  Map<String,dynamic> facId ={};
  Map<String,dynamic> proId ={};
  Map<String,dynamic> subId ={};
  List<int> DDId = [];
  int act = 0;
List<dynamic> paymentDatas = [];
  int len = 0;
  late String amt , remark ;
  late String BPEmail , BPPhone,fname , mname , gfname,gmname,cast,religion , nation,marry,dob,name;


  Future<void> runWSServices()async {
    BPEmail = await GetStorage().read('bPartnerEmail');
    BPPhone = await GetStorage().read('bPartnerPhone');
    fname = await GetStorage().read('bPartnerfname');
    mname = await GetStorage().read('bPartnermname');
    gfname = await GetStorage().read('bPartnergfname');
    gmname = await GetStorage().read('bPartnergmname');
    cast = await GetStorage().read('bPartnercast');
    religion = await GetStorage().read('bPartnerreligion');
    nation = await GetStorage().read('bPartnernationality');
    marry = await GetStorage().read('bPartnermarry');
    dob = await GetStorage().read('bPartnerdob');
    name = await GetStorage().read('bPartnerName');
    print(BPEmail);
    print(BPPhone);
    entranceOpenInfo eInfoApp = entranceOpenInfo();
    dataEntInfoApp = await eInfoApp.getInfo();
    int len = dataEntInfoApp.length;
    entranceOpenInfo eInfo = entranceOpenInfo();
    dataEntInfofromAPI = await eInfo.openInfo();
    dataEntInfo = await eInfo.openInfo();
    if(dataEntInfoApp.isNotEmpty){
      CourseRegInfo cin = CourseRegInfo();
      // CourseInfoAdd = await cin.getCourseInfoListAdmission(dataEntInfoApp);
      CourseInfo = await cin.getCourseInfoList(CourseInfoAdd);


    }
    for(var  i = 0 ; i < dataEntInfo.length ; i++){
      if(!acaYearDDF.contains(dataEntInfo[i]['n_aca_year_ID']['identifier'].toString())){
        acaYearDDF.add(dataEntInfo[i]['n_aca_year_ID']['identifier'].toString());
        String ac = dataEntInfo[i]['n_aca_year_ID']['identifier'].toString();
        int acId = dataEntInfo[i]['n_aca_year_ID']['id'] as int ;
        acaId[ac] = acId;
      }
      if(!inTakeDDF.contains(dataEntInfo[i]['n_intake_ID']['identifier'].toString())){
        inTakeDDF.add(dataEntInfo[i]['n_intake_ID']['identifier'].toString());
        String it = dataEntInfo[i]['n_intake_ID']['identifier'].toString();
        int itId = dataEntInfo[i]['n_intake_ID']['id'] as int ;
        intId[it] = itId;
      }
      if(!FacultyDDF.contains(dataEntInfo[i]['n_faculty_ID']['identifier'].toString())){
        FacultyDDF.add(dataEntInfo[i]['n_faculty_ID']['identifier'].toString());
        String ac = dataEntInfo[i]['n_faculty_ID']['identifier'].toString();
        int acId = dataEntInfo[i]['n_faculty_ID']['id'] as int ;
        facId[ac] = acId;
      }
      if(!ProgramDDF.contains(dataEntInfo[i]['n_program_ID']['identifier'].toString())){
        ProgramDDF.add(dataEntInfo[i]['n_program_ID']['identifier'].toString());
        String ac = dataEntInfo[i]['n_program_ID']['identifier'].toString();
        int acId = dataEntInfo[i]['n_program_ID']['id'] as int ;
        proId[ac] = acId;
      }
      if(!SubjectDDF.contains(dataEntInfo[i]['n_subject_ID']['identifier'].toString())){
        SubjectDDF.add(dataEntInfo[i]['n_subject_ID']['identifier'].toString());
        String ac = dataEntInfo[i]['n_subject_ID']['identifier'].toString();
        int acId = dataEntInfo[i]['n_subject_ID']['id'] as int ;
        subId[ac] = acId;
      }

    }
    for(var i=0 ; i< dataEntInfoApp.length; i++ ){
      idOfEntApp.add(dataEntInfoApp[i]['n_entrance_open_ID']['id'].toString());
    }
    chosenValueacDD =dataEntInfo[0]['n_aca_year_ID']['identifier'].toString();
    acaYearDD = acaYearDDF;
    dataEntInfo = foundRecords ?? dataEntInfofromAPI ;

    }

  Widget offlinePay(BuildContext context , int amt , int type){
    late int id ;
    late String date ;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(66),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 18,),

                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Text('Transaction Details for Payment ',style: TextStyle(color: Colors.grey , fontSize: 25,fontWeight: FontWeight.bold),),
                ],),
            Container(padding: EdgeInsets.all(6),
              child: Text( 'Amount to be paid : $amt',
              ),),
            SizedBox(height: 18,),
                Container(padding: EdgeInsets.all(6),
                  margin: EdgeInsets.only(left: 77,right: 77),
                child: TextField(onChanged: (value){
                  id = value as int;
                },
                  decoration: InputDecoration(
                  labelText: 'Transaction ID : ',
                ),),),
                SizedBox(height: 18,),
            Container(padding: EdgeInsets.all(6),
              margin: EdgeInsets.only(left: 77,right: 77),
              child: TextField(
                onChanged:(value){
                  date = value;
                },
                decoration: InputDecoration(
                labelText: 'Transaction Date : ',
              ),),),
            SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child:Text('<- Back'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content:  Text('Payment Process',style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.withOpacity(.54),
                          ),) ),);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red.withOpacity(.66)),
                    ),
                    SizedBox(width: 18,),
                    ElevatedButton(
                      child:Text('Update ->'),
                      onPressed: () {
                        paymentWS offlinepay = paymentWS() ;
                        offlinepay.postOffline(amt, id, date);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content:  Text('Payment Process',style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),) ),);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.66)),
                    ),
                  ],
                ),
              ],
            ),),
    );

  }
  Widget onlinePay(BuildContext context , int amount , int type){
    // opener.parent.dispatchEvent(new CustomEvent('myCallback', {detail: callbackDetailsObj}));

//     void callbackPopup(js.JsObject ev) {
//       print('Browser Callback');
// //   developer.log('Event type: ${ev['type']}, runtime: ${ev.runtimeType}, target: ${ev['target']}');
// //   developer.log('Detail : ${ev['detail']}');
//     }
//     // void addListener() {
//       var callbackPopupJs = js.allowInterop(callbackPopup);
//       js.JsObject options = js.JsObject.jsify({'once': true});
//       js.context.callMethod('addEventListener', ['click', callbackPopupJs]);
    // }

    String ty = type == 0 ?'Entrance' : 'Admission and Course Registration';
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(66),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 18,),

            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Text('Transaction Details for Payment of $ty',style: TextStyle(color: Colors.grey , fontSize: 25,fontWeight: FontWeight.bold),),
            ],),
            Container(padding: EdgeInsets.all(6),
              child: Text( 'Amount to be paid : $amount}',
              ),),
            SizedBox(height: 18,),
            Container(padding: EdgeInsets.all(6),
              margin: EdgeInsets.only(left: 77,right: 77),
              child: TextField(
                onChanged: (value){
                  amt = value;
                },
                decoration: InputDecoration(
                labelText: 'Enter Amount : ',
              ),),),
            SizedBox(height: 18,),
            Container(padding: EdgeInsets.all(6),
              margin: EdgeInsets.only(left: 77,right: 77),
              child: TextField(
                onChanged: (value){
                  remark = value;
                },
                decoration: InputDecoration(
                labelText: ' Remarks : ',
              ),),),
            SizedBox(height: 18,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child:Text('<- Back'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content:  Text('Payment Process',style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.withOpacity(.54),
                      ),) ),);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red.withOpacity(.66)),
                ),
                const SizedBox(width: 18,),
                ElevatedButton(
                  onPressed: () async {
                    js.context.callMethod('open', ['http://103.235.199.37:9101/npg/v1/generateLink?Amount=$amt&Remarks=$remark', 'loginWindow', 'width=600,height=600,left=600,top=200']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content:  Text('Payment Process',style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),) ),);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.66)),
                  child:const Text('Update ->'),
                ),
              ],
            ),
          ],
        ),),
    );

  }
  Widget secondStepPay(BuildContext context ,amt , type ){
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(66),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 18,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your details of selection : ',style: TextStyle(color: Colors.black , fontSize: 27 ,fontWeight: FontWeight.bold),),
            ],),
          SizedBox(height: 18,),
          Center(child:
          Text('Please select mode of payment'),),
          SizedBox(height: 21,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  child:Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF50C878),
                      ),
                      child: Text('अनलाईन यहाँ क्लिक गर्नुस् ')),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => onlinePay(context , amt , type),);
                  },style: ElevatedButton.styleFrom(primary:Color(0xFF50C878)),
                ),
              ),
              Expanded(flex: 1,
                  child: SizedBox(height: 33,)),
              Expanded(flex: 3,
                child: ElevatedButton(
                  child:Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.all(12),
                      color: Color(0xFF1984F7),
                      child: Text('बैंक भाउचर दर्ता यहाँ क्लिक गर्नुस् ')),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => offlinePay(context , amt ,type),);
                  },
                  style: ElevatedButton.styleFrom(primary:Color(0xFF1984F7)),

  ),
              ),
            ],
          ),
          SizedBox(height: 33,),
          ElevatedButton(
            child: Text('Back'),
            onPressed: (){
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(primary:Colors.black45),
          ),
        ],
      ),
    );
  }
  Widget _buildPopupDialog(BuildContext context , int i ){
      return Container(
         width: double.infinity,
         height: double.infinity,
         margin: EdgeInsets.all(66),
         padding: EdgeInsets.all(24),
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(12),
         ),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             SizedBox(height: 18,),
             Row(mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text('Your details of selection : ',style: TextStyle(color: Colors.black , fontSize: 27 ,fontWeight: FontWeight.bold),),
               ],),
             SizedBox(height: 18,),
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 SizedBox(height: 10,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                   Text('Academic Year : ${dataEntInfo[i]['n_aca_year_ID']['identifier'].toString()}      Intake : ${dataEntInfo[i]['n_intake_ID']['identifier'].toString()}  ',style: TextStyle(color: Colors.black , fontSize: 24),),
                 ],),
                 SizedBox(height: 10,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                   Text('Faculty : ${ dataEntInfo[i]['n_faculty_ID']['identifier'].toString()}',style: TextStyle(color: Colors.black , fontSize: 24),),
                 ],),
                 SizedBox(height: 10,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                   Text('Program : ${dataEntInfo[i]['n_program_ID']['identifier'].toString()}',style: TextStyle(color: Colors.black , fontSize: 24),),
                 ],),
                 SizedBox(height: 10,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                   Text('Subject : ${dataEntInfo[i]['n_subject_ID']['identifier']} ',style: TextStyle(color: Colors.black , fontSize: 24),),
                 ],),
                 SizedBox(height: 23,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                   Text('Entrance fee to be paid : ${dataEntInfo[i]['fee']} ',style: TextStyle(color: Colors.black , fontSize: 24),),
                 ],),
                 SizedBox(height: 18,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                   Text('Please Continue for Payment ! OR Cancel for reselection  ',style: TextStyle(color: Colors.grey , fontSize: 25,fontWeight: FontWeight.bold),),
                 ],),
                 SizedBox(height: 18,),
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                   ElevatedButton(
                     child:Text('X Close'),
                     onPressed: () {
                       Navigator.of(context).pop();
                         // ScaffoldMessenger.of(context).showSnackBar(
                         //   SnackBar(content:  Text('Limitation to apply one test at a time.',style: TextStyle(
                         //     fontSize: 24,
                         //     fontWeight: FontWeight.bold,
                         //     color: Colors.red,
                         //   ),) ),);
                     },
                     style: ElevatedButton.styleFrom(primary: Colors.red.withOpacity(.66)),
                   ),
                   ElevatedButton(
                     child:Text('Pay ->'),
                     onPressed: () {
                       showDialog(
                         context: context,
                         builder: (BuildContext context) => secondStepPay(context , dataEntInfo[i]['fee'],0),);
                     },
                     style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.66)),
                   ),
                 ],),
               ],
             ),
           ],
         ),
       );
    }
    Widget ImageView(BuildContext context  , String base){
    final _byteImage = Base64Decoder().convert(base);
    Widget image = Image.memory(_byteImage);
    return Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(36),
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    ),
    child: image,);
  }
  Widget AdmissionPop( BuildContext context ){
    int? fee = 0;
    for(var i = 0 ; i < CourseInfo.length ; i++){
      fee = (fee! + CourseInfo[i]['RATE_PER_CREDIT_HOUR']) as int?;
    }
      return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(28),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        ),
        child: ListView(
          children : [ Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 30,),
                  ContCustomColor(50, 40, ' SN.', Colors.white,Color(0xFF5F5FA7),2),
                  ContCustomColor(240, 40, 'Name of Course',  Colors.white,Color(0xFF5F5FA7),10),
                  ContCustomColor(120, 40, 'Type',  Colors.white,Color(0xFF5F5FA7),7),
                  ContCustomColor(100, 40, 'Credit',  Colors.white,Color(0xFF5F5FA7),3),
                  ContCustomColor(140, 40, 'Total Fees(NRs)',  Colors.white,Color(0xFF5F5FA7),5),
                ],
              ),
              SizedBox(height: 6,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: CourseInfo.length,
          itemBuilder:(BuildContext ctx, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(value: true, onChanged: null),
              ContCustom(
              80, 40, (index+1).toString(),
              Colors.black,2),
              ContCustom(
              240, 40, CourseInfo[index]['Name'].toString(),
              Colors.black,10),
              ContCustom(
              120, 40, CourseInfo[index]['course_type']['identifier'].toString(),
              Colors.black,7),
              ContCustom(
              100, 40, CourseInfo[index]['CREDIT_HOUR'].toString(),
              Colors.black,3),
              ContCustom(
              140, 40, CourseInfo[index]['RATE_PER_CREDIT_HOUR'].toString(),
              Colors.black,5),
            ],
          );
          }),
              Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('FEE STRUCTURE:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)],),
              SizedBox(height: 12,),
              ListView(padding: EdgeInsets.only(right: 24,left: 24),
                shrinkWrap: true,
                children: [Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      ContCustomColor(100, 40, 'Tuition Fee', Colors.black,Colors.white),
                      ContCustomColor(100, 40, fee.toString(), Colors.white,Colors.black.withOpacity(.77)),
                    ],
                  ),
                  Row(
                    children: [
                      ContCustomColor(100, 40, 'Library Fee',Colors.black,Colors.white),
                      ContCustomColor(100, 40, '${CourseInfoAdd[0]['libraryfee'].toString()}', Colors.white,Colors.black.withOpacity(.77)),
                    ],
                  ),
                  Row(
                    children: [
                      ContCustomColor(100, 40, 'Admission Fee', Colors.black,Colors.white),
                      ContCustomColor(100, 40, '${CourseInfoAdd[0]['admissionfee'].toString()}', Colors.white,Colors.black.withOpacity(.77)),
                    ],
                  ),
                  Row(
                    children: [
                      ContCustomColor(100, 40, 'Practical Fee', Colors.black,Colors.white),
                      ContCustomColor(100, 40, '${CourseInfoAdd[0]['practicalfee'].toString()}', Colors.white,Colors.black.withOpacity(.77)),
                    ],
                  ),
                  Divider(thickness: 4,),
                  Row(
                    children: [
                      ContCustomColor(100, 40, 'Total Fee', Colors.black,Colors.white),
                      ContCustomColor(100, 40, 'Rs - ${(CourseInfoAdd[0]['practicalfee']+CourseInfoAdd[0]['admissionfee']+CourseInfoAdd[0]['libraryfee']+fee).toString()}.00', Colors.black,Colors.white),
                    ],
                  ),
                ],),
              ],),
              SizedBox(height: 6,),
              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Click Below for Payment and Admission',style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5F5FA7).withOpacity(.87),
                ),),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child:Text('Make payment'),
                      onPressed: () {
                        // CourseRegInfo creg = CourseRegInfo();
                        // creg.postCourseEnrollandReg(CourseInfoAdd);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => secondStepPay(context , fee , 0 ),);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.81)),
                    ),
                    SizedBox(width: 15,),
                    ElevatedButton(
                      child:Text('Back'),
                      onPressed: () {
                        // CourseRegInfo creg = CourseRegInfo();
                        // creg.postCourseEnrollandReg(dataEntInfoApp);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black.withOpacity(.72)),
                    ),
                  ],
                ),

              ],),
            ],
          ),],
        ),),
      );

    }
    Widget applyORapplied(BuildContext context , String id , int index){
    if(idOfEntApp.contains(id)){

      return ContCustomColor(100, 40, 'Applied', Colors.white,Color(0xFF5F5FA7),2,3);
  }
    else{
      return Expanded(
        flex: 2,
        key: UniqueKey(),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ElevatedButton(
          child:Text('Apply'),
          onPressed: () {
            if(idOfEntApp.length >= 1){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:  Text('Limitation to apply one test at a time',style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),) ),);
            }
            else{
              showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context , index),);
            setState(() {
              // eInfoPost.postAppInfo(index , dataEntInfo);
            });
            }
          },
          style: ElevatedButton.styleFrom(primary:Colors.green.withOpacity(.66), fixedSize: const Size(96, 37) ),
          ),
        ),
      );
    }
    }

  @override
  Widget build(BuildContext context) {
    String? txnId;
    bool ac = act == 0 ? false : true;
    final theme = Theme.of(context);
    late String FullName,FatherName,DOB,Phone,EmailAdd;
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(widget.controller.selectedIndex);
        switch (widget.controller.selectedIndex) {
          case 0:
            return Container(
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10, right: 12, left: 12,top: 12),
              decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
              ), child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('WELCOME TO YOUR ENTRANCE DASHBOARD ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                      ),)
                  ],
                ),
                const SizedBox(height: 22,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your Entrance Status as of Now :  ',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),)
                  ],
                ),
                SizedBox(height: 32,),
                Padding(
                  padding: const EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustomColor(100, 40, 'Year', Colors.white,Color(0xFF5F5FA7),2),
                      ContCustomColor(120, 40, 'Intake',  Colors.white,Color(0xFF5F5FA7),2),
                      ContCustomColor(200, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),7),
                      ContCustomColor(200, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),5),
                      ContCustomColor(200, 40, 'Subject',  Colors.white,Color(0xFF5F5FA7),5),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: 100,
                          height :40 ,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.33),
                            borderRadius: BorderRadius.circular(3),),
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(4),
                          child: const Center(child: Text('Status',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6,),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                    key: UniqueKey(),
                      itemCount: dataEntInfoApp.length,
                      itemBuilder:(BuildContext ctx, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 33, right: 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ContCustom(100, 40, dataEntInfoApp[index]['n_aca_year_ID']['identifier'], Colors.black,2),
                              ContCustom(120, 40, dataEntInfoApp[index]['n_intake_ID']['identifier'], Colors.black,2),
                              ContCustom(200, 40, dataEntInfoApp[index]['n_faculty_ID']['identifier'], Colors.black,7),
                              ContCustom(200, 40, dataEntInfoApp[index]['n_program_ID']['identifier'], Colors.black,5),
                              ContCustom(200, 40, dataEntInfoApp[index]['n_subject_ID']['identifier'], Colors.black,5),
                              Expanded(
                                flex : 2,
                                child: Container(
                                  width: 100,
                                  height :40 ,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(3),),
                                  margin: const EdgeInsets.all(3),
                                  padding: const EdgeInsets.all(5),
                                  child: Center(child: Text('APPLIED',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                ),
                              ),
                            ],
                          ),
                        );
                      } ),
                ),
                SizedBox(height: 21,),
                Expanded(flex: 3,
                  child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child:
                        Text('Congratulations ! Passed through Entry level test . ',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),),)
                      ],
                    ),
                    SizedBox(height: 21,),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child:
                      Text('Click below for further Admission Process :',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),)
                    ],
                  ),
                    SizedBox(height: 21,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child:Text('Click for Admission'),
                          onPressed: ()  {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AdmissionPop(context ),);
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.66)),
                        ),
                      ],
                    ),
                  ],
                ),),
              ],
            ),
            ); //Home DashBoard
          case 1:
            return Form(
              key: _formKey ,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                padding: EdgeInsets.all(21),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF7F7FD5),
                        const Color(0xFF86A8E7),
                        const Color(0xFF91EAE4),
                      ]
                  ),

                ),
                child: ListView(
                  children:[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 8,),
                        const SizedBox(width: 8,),
                        const Text('ADMISSION',style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),),
                        const SizedBox(height: 8,),
                        Container(
                          padding: EdgeInsets.only(left: 21,right: 21,top: 21,bottom: 21),
                          height: 244,
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              bottom: 21, right: 10, left: 10,top: 9),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 8,),
                                  const Text(
                                    'General Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  const SizedBox(height:30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          width: 250,
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: name),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Full Name',
                                              suffixIcon: Icon(Icons.perm_identity_outlined, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container(
                                        width: 250,
                                        padding: EdgeInsets.only(left: 21,right: 21),
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: fname),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'Father\'s Name',
                                            suffixIcon: Icon(Icons.people, size: 25,),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          width: 250,
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: dob),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'DOB',
                                              hintText: 'DD-MM-YY',
                                              suffixIcon: const Icon(Icons.calendar_month, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height:12,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 105,left: 60),
                                          width: 250,
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: BPPhone),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Phone no.',
                                              suffixIcon: Icon(Icons.phone, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(child:Container(
                                        width: 250,
                                        padding: EdgeInsets.only(right: 60,left: 105),
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: BPEmail),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'Email Address/Username',
                                            hintText: 'mail@mail.com',
                                            suffixIcon: const Icon(Icons.mail, size: 25,),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height:12,),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 21,right: 21,top: 12,bottom: 12),
                          height: 291,
                          width: double.infinity,
                          margin:  const EdgeInsets.only(
                            bottom: 21, right: 10, left: 10,top: 9),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 8,),
                                  Text(
                                    'Address Infromation',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  const SizedBox(height:30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width:15),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Permanent',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 250,
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: "Not Assigned"),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Province',
                                              suffixIcon: Icon(Icons.place, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child:Container(
                                        width: 250,
                                        padding: EdgeInsets.only(left: 21,right: 21),
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: "Not Assigned"),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'District',
                                            suffixIcon: Icon(Icons.location_on_outlined, size: 25,),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                        child: Container(
                                          width: 250,
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: "Not Assigned"),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Municipality',
                                              suffixIcon: Icon(Icons.location_city_outlined, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container(
                                        width: 250,
                                        padding: EdgeInsets.only(left: 21,right: 21),
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: "Not Assigned"),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'Tole',
                                            suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height:12,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width:15),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Permanent',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 250,
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: "Not Assigned"),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Province',
                                              suffixIcon: Icon(Icons.place, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child:Container(
                                        width: 250,
                                        padding: EdgeInsets.only(left: 21,right: 21),
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: "Not Assigned"),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'District',
                                            suffixIcon: Icon(Icons.location_on_outlined, size: 25,),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                        child: Container(
                                          width: 250,
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: "Not Assigned"),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Municipality',
                                              suffixIcon: Icon(Icons.location_city_outlined, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container(
                                        width: 250,
                                        padding: EdgeInsets.only(left: 21,right: 21),
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: "Not Assigned"),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'Tole',
                                            suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height:12,)
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 21,right: 21,top: 12,bottom: 21),
                          height: 222,
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              bottom: 21, right: 10, left: 10,top: 9),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 8,),
                                  const Text(
                                    'Other Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  const SizedBox(height:30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 250,
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: gmname),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Grand Mother\'s Name',
                                              suffixIcon: const Icon(Icons.people, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container(
                                        width: 250,
                                        padding: EdgeInsets.only(left: 21,right: 21),
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: gfname),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'Grand Father\'s Name',
                                            suffixIcon: const Icon(Icons.person, size: 25,),
                                          ),
                                        ),
                                      ),),
                                      Expanded(
                                        child: Container(
                                          width: 250,
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: cast),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Cast Ethnicity',
                                              suffixIcon: Icon(Icons.star, size: 25,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height:12,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(child: Container(
                                        padding: EdgeInsets.only(left: 21,right: 21),
                                        width: 250,
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: religion),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'Religion.',
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 21,right: 21),
                                          width: 250,
                                          child: TextField(
                                            enabled: ac,
                                            controller:
                                            TextEditingController(text: nation),
                                            onChanged: (value) {},
                                            decoration: const InputDecoration(
                                              labelText: 'Nationality',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container(
                                        padding: EdgeInsets.only(left: 21,right: 21),
                                        width: 250,
                                        child: TextField(
                                          enabled: ac,
                                          controller:
                                          TextEditingController(text: marry),
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            labelText: 'Maritial Status',
                                          ),
                                        ),
                                      ),),
                                    ],
                                  ),
                                  const SizedBox(height:12,),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Processing Data')),
                                    );
                                  }
                                  setState(() {
                                    act = 1;
                                  });
                                },
                                child: const Text('Edit'),
                              ),
                            ),
                            const SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Saving Data')),
                                    );
                                  }
                                  setState(() {
                                    act = 0;
                                  });
                                },
                                child: const Text('Save'),
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ],),),
            ); // Student Info
          case 2:
            return Container(
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 18,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child:
                            Text('ENTRANCE INFO ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),),)
                      ],
                    ),
                  const SizedBox(height: 22,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child:
                         Text('Open Entrance as of Now :  ',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),),
                        ),
                    ],
                  ),
                  SizedBox(height: 6,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Year',style: TextStyle(fontWeight: FontWeight.bold),),
                                Container(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: chosenValueacDD,
                                    dropdownColor: Colors.white,
                                    //elevation: 5,
                                    style: TextStyle(color: Colors.black),

                                    items: acaYearDD.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Select",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onChanged: (value) async {
                                      DDId = [];
                                      chosenValueacDD = value!;
                                      DDId.add(acaId[chosenValueacDD]);
                                      entranceOpenInfo eInfo = entranceOpenInfo();
                                      var list = await eInfo.getDDList(DDId, 0);
                                      var records = await eInfo.getFilteredRecords(DDId, 0);
                                      setState(() {
                                        chosenValueacDD = value;
                                        inTakeDD =list;
                                        chosenValueitDD = inTakeDD.first;
                                        FacultyDD = [];
                                        ProgramDD = [];
                                        SubjectDD = [];
                                        dataEntInfo = records;
                                      });
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Intake',style: TextStyle(fontWeight: FontWeight.bold),),
                            Container(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: chosenValueitDD,
                                dropdownColor: Colors.white,
                                //elevation: 5,
                                style: TextStyle(color: Colors.black),

                                items: inTakeDD.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Select",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (value) async {
                                  entranceOpenInfo eInfo = entranceOpenInfo();
                                  DDId = [];
                                  chosenValueitDD = value!;
                                  DDId.add(acaId[chosenValueacDD]);
                                  DDId.add(intId[chosenValueitDD]);
                                  var lsit = await eInfo.getDDList(DDId, 1);
                                  var records = await eInfo.getFilteredRecords(DDId, 1);
                                  print(records);
                                  setState(() {
                                    chosenValueitDD = value;
                                    FacultyDD = lsit;
                                    chosenValuefcDD = FacultyDD.first;
                                    ProgramDD = [];
                                    SubjectDD = [];
                                    dataEntInfo = records;
                                  });
                                },
                              ),
                            ),

                          ],
                        ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Faculty',style: TextStyle(fontWeight: FontWeight.bold),),
                                Container(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: chosenValuefcDD,
                                    dropdownColor: Colors.white,
                                    //elevation: 5,
                                    style: TextStyle(color: Colors.black),

                                    items: FacultyDD.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Please select your faculty",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onChanged: (value) async {
                                      entranceOpenInfo eInfo = entranceOpenInfo();
                                      DDId = [];
                                      chosenValuefcDD = value!;
                                      DDId.add(acaId[chosenValueacDD]);
                                      DDId.add(intId[chosenValueitDD]);
                                      DDId.add(facId[chosenValuefcDD]);
                                      var list = await eInfo.getDDList(DDId, 2);
                                      var records = await eInfo.getFilteredRecords(DDId, 2);
                                      setState(() {
                                        chosenValuefcDD = value;
                                        ProgramDD = list;
                                        chosenValuepgDD =  ProgramDD.first;
                                        SubjectDD = [];
                                        dataEntInfo = records;
                                      });
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Program',style: TextStyle(fontWeight: FontWeight.bold),),
                                Container(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: chosenValuepgDD,
                                    dropdownColor: Colors.white,
                                    //elevation: 5,
                                    style: TextStyle(color: Colors.black),

                                    items: ProgramDD.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Please select your program",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onChanged: (value) async {
                                      entranceOpenInfo eInfo = entranceOpenInfo();
                                      DDId = [];
                                      chosenValuepgDD = value!;
                                      DDId.add(acaId[chosenValueacDD]);
                                      DDId.add(intId[chosenValueitDD]);
                                      DDId.add(facId[chosenValuefcDD]);
                                      DDId.add(proId[chosenValuepgDD]);
                                      var list = await eInfo.getDDList(DDId, 3);
                                      var records = await eInfo.getFilteredRecords(DDId, 3);
                                      setState((){
                                        chosenValuepgDD = value;
                                        SubjectDD =list;
                                        chosenValuesubDD = SubjectDD.first;
                                        dataEntInfo = records;
                                      });
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Subject',style: TextStyle(fontWeight: FontWeight.bold),),
                              Container(
                                child: DropdownButton<String>(
                                  value: chosenValuesubDD,
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.black),

                                  items: SubjectDD.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "Please choose ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onChanged: (value) async {
                                    entranceOpenInfo eInfo = entranceOpenInfo();
                                    chosenValuesubDD = value!;
                                    DDId = [];
                                    DDId.add(acaId[chosenValueacDD]);
                                    DDId.add(intId[chosenValueitDD]);
                                    DDId.add(facId[chosenValuefcDD]);
                                    DDId.add(proId[chosenValuepgDD]);
                                    DDId.add(subId[chosenValuesubDD]);
                                    var records = await eInfo.getFilteredRecords(DDId, 4);
                                    setState(() {
                                      chosenValuesubDD = value;
                                      dataEntInfo = records;
                                    });
                                  },
                                ),
                              ),

                            ],
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  const SizedBox(height: 32,),
                  Padding(
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ContCustomColor(100, 40, 'Year', Colors.white,Color(0xFF5F5FA7),2),
                        ContCustomColor(120, 40, 'Intake', Colors.white,Color(0xFF5F5FA7),2),
                        ContCustomColor(200, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),7),
                        ContCustomColor(200, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),5),
                        ContCustomColor(200, 40, 'Subject',  Colors.white,Color(0xFF5F5FA7),5),
                        Expanded(flex: 2,
                        child:Container(
                          width: 100,
                          height :40 ,
                          decoration: BoxDecoration(
                            color:Colors.grey.withOpacity(.33),
                            borderRadius: BorderRadius.circular(3),),
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(4),
                          child: Center(child: Text('Apply',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
                        )),

                      ],
                    ),
                  ),
                  SizedBox(height: 6,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22,right: 22),
                      child: ListView.builder(
                          itemCount: dataEntInfo.length,
                            itemBuilder:(BuildContext ctx, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ContCustom(100, 40, dataEntInfo[index]['n_aca_year_ID']['identifier'], Colors.black,2),
                                ContCustom(120, 40, dataEntInfo[index]['n_intake_ID']['identifier'], Colors.black,2),
                                ContCustom(200, 40, dataEntInfo[index]['n_faculty_ID']['identifier'], Colors.black,7),
                                ContCustom(200, 40, dataEntInfo[index]['n_program_ID']['identifier'], Colors.black,5),
                                ContCustom(200, 40, dataEntInfo[index]['n_subject_ID']['identifier'], Colors.black,5),
                                applyORapplied(context , dataEntInfo[index]['id'].toString(), index),
                              ],
                            );
                            } ),
                    ),
                  ),
                  SizedBox(height: 21,),

                ],
              ),
            ); // Open Entrance
          case 3:
            return Container(
              height: double.infinity,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10, right: 12, left: 12,top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ), child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('WELCOME TO YOUR TRANSACTIONS DASHBOARD',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                      ),)
                  ],
                ),
                const SizedBox(height: 22,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Check Your Transactions Report as of Now :  ',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),)
                  ],
                ),
                SizedBox(height: 32,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 21,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child:
                        Text('Enter your transaction id for retriveing your transaction history :',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),)
                      ],
                    ),
                    SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.numbers_outlined),
                              hintText: 'txnid',
                              labelText: 'TXN ID',
                            ),
                            onSaved: (String? value) {
                             txnId = value;
                            },
                            validator: (String? value) {
                              return (value != null ) ? 'Transaction Id required' : null;
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child:Text('Click for Report'),
                          onPressed: ()  async {
                            paymentWS report = paymentWS();
                            String base64 = await report.getReport(txnId!);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => ImageView(context , base64),);
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.66)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            ); // Transaction Dashboard
          default :
            return Text(
              pageTitle,
              style: theme.textTheme.headline5,
            );
        };
      }
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Student Info';
    case 2:
      return 'Entrance';
    case 3:
      return 'Transactions';
    // case 4:
    //   return 'Exam';
    default:
      return 'Not found page';
  }
}
class ContCustom extends StatelessWidget {
  int width , height ;
  String textLabel ;
  Color textColor;
  var flex;
  ContCustom(this.width , this.height , this.textLabel , this.textColor,[this.flex] );


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Container(
        width: width as double,
        height :height as double ,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.33),
          borderRadius: BorderRadius.circular(3),),
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Text(textLabel,
            style: TextStyle(color: textColor ,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
class ContCustomColor extends StatelessWidget {
  double width , height ;
  String textLabel ;
  Color textColor;
  Color contColor;
  var flex;
  var marg;
  ContCustomColor(this.width , this.height , this.textLabel , this.textColor,this.contColor,[this.flex,this.marg]) ;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex??1,
      child: Container(
      width: width ,
      height :height  ,
      decoration: BoxDecoration(
        color: contColor,
        borderRadius: BorderRadius.circular(3),),
      margin:  EdgeInsets.all(marg??3),
      padding: const EdgeInsets.all(5),
      child: Center(
        child: Text(textLabel,
          style: TextStyle(color: textColor ,fontWeight: FontWeight.bold),),
      ),
    ),);
  }
}


class CustField extends StatelessWidget {
  final String label ;
   CustField({required this.label}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width :250,
      child: TextField(
        onChanged: (value){},
        decoration: InputDecoration(
          labelText: label,

        ),
      ),
    );
  }
}

const primaryColor = Colors.blueAccent;
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);

