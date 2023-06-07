import 'dart:convert';
import 'dart:math';
import 'package:flutter_html/flutter_html.dart';
import 'dart:html' as html;
import 'dart:io';
import 'dart:js' as js;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:register_openu/attachWS.dart';
import 'package:register_openu/bPartnerWS.dart';
import 'package:register_openu/examWS.dart';
import 'package:register_openu/locationWS.dart';
import 'package:register_openu/paymentWS.dart';
import 'package:register_openu/reportAndProcessWS.dart';
import 'package:register_openu/studentInfoWS.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:smart_timer/smart_timer.dart';
import 'courseregWS.dart';
import 'cust_icon_icons.dart';
import 'entranceOpenWS.dart';
import 'login/login.dart';
import 'nouRegWS.dart';
import 'scholarshipWS.dart';
import 'constants.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
class DashMenuStd extends StatefulWidget {
  String imagebase64;
  DashMenuStd(this.imagebase64);

  @override
  State<DashMenuStd> createState() => _DashMenuStdState();
}
class _DashMenuStdState extends State<DashMenuStd> {
  initState()  {
    SmartTimer(
      duration: Duration(minutes: 30 ,seconds: 24),
      onTick: () =>  showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("AlertDialog"),
          content: Text("Session Ended , Please Re-Login."),
          actions: [
            ElevatedButton(
              child: Text("Okay"),
              onPressed:  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        LoginPage()));
              },
            )
          ],
        );
      }),

    );
  }
  void updateDP(String img){
    setState(() {
      widget.imagebase64 = img;
    });
  }
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
            drawer: DashSidebar(controller: _controller, BPimg: widget.imagebase64),
            body: Row(
              children: [
                if (!isSmallScreen) DashSidebar(controller: _controller, BPimg: widget.imagebase64),
                Expanded(
                  child: Center(
                    child: _Screens(
                      controller: _controller,
                      dpImg : widget.imagebase64,
                      updatecallBack : updateDP,
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
class DashSidebar extends StatefulWidget {
  String BPimg;
   DashSidebar({
    Key? key,
     required this.BPimg,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<DashSidebar> createState() => _DashSidebarState();
}

class _DashSidebarState extends State<DashSidebar> {

   @override
   initState()  {
   }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: widget._controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(5),
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
          child: GestureDetector(
            onTap:(){

            },
            child: Padding(
              padding: const EdgeInsets.only(  left: 9 , right : 9 ,),
              child:widget.BPimg == 'null' ? Image.asset('assets/images/noimage.jpeg',height: 100,width: 150,) :
              Image.memory(base64Decode(widget.BPimg),height: 100,width: 150,),
            ),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.people,
          label: 'Student Info',
          onTap: () {
          },
        ),
        SidebarXItem(
          icon: CustIcon.school,
          label: 'Academics',
          onTap: () {
          },
        ),
        SidebarXItem(
          icon: CustIcon.work,
          label: 'Experience',
          onTap: () {
          },
        ),
        SidebarXItem(
          icon: CustIcon.library_books,
          label: 'Publications',
          onTap: () {
          },
        ),
        SidebarXItem(
          icon: Icons.offline_pin_rounded,
          label: 'Entrance',
        ),
        SidebarXItem(
          icon: Icons.add_task_outlined,
          label: 'NOU Register',
        ),
        SidebarXItem(
          icon: Icons.person_add_alt_rounded,
          label: 'Admission',
        ),
        SidebarXItem(
          icon: Icons.app_registration,
          label: 'Course Register',
          onTap: () {
          },
        ),
        SidebarXItem(
            icon: Icons.pending_actions,
            label: 'Exam',
          ),
          SidebarXItem(
            icon: Icons.school_sharp,
            label: 'Scholarship',
          ),
          SidebarXItem(
            icon: Icons.attach_money,
            label: 'Payments',
          ),
        SidebarXItem(
          icon: Icons.power_settings_new,
          label: 'Logout',
          onTap: () {
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text("AlertDialog"),
                content: Text("Sure to Logout?"),
                actions: [
                  ElevatedButton(
                    child: Text("Yes"),
                    onPressed:  () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              LoginPage()));
                    },
                  ),
                  ElevatedButton(
                    child: Text("No"),
                    onPressed:  () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
          },
        ),
      ],
    );
  }
}
class _Screens extends StatefulWidget {
  _Screens({
    Key? key,
    required this.dpImg,
    required this.updatecallBack,
    required this.controller,
  }) : super(key: key);
  final SidebarXController controller;
  final String dpImg ;
  final updatecallBack;


  @override
  State<_Screens> createState() => _ScreensState();
}
class _ScreensState extends State<_Screens> {

  final GenInfoList = <String>[];

  final LocationInfoList = <String>[];

  final OtherInfoList = <String>[];
  var nameCode = <String>[];
  var nameCodeAcaMark = <String>[];
  var nameCodeExpAtt = <String>[];
  var nameCodeVoucher= <String>[];
  var nameCodeAcaTrans = <String>[];
  var nameCodeAcaOther = <String>[];
  var nameCodeExp = <String>[];
  var nameCodePub = <String>[];
  entranceOpenInfo eInfoPost = entranceOpenInfo();
  List<String> idOfEntApp = [];
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
  TextEditingController dateinput = TextEditingController();
  TextEditingController dateinputDepDate = TextEditingController();
  TextEditingController dateinputOffDate = TextEditingController();
  TextEditingController dateinputExpFrom = TextEditingController();
  TextEditingController dateinputExpTo = TextEditingController();
  List<dynamic>? ddDist = [];List<dynamic>? ddLoc = [];
  List<dynamic>? ddDistTem = [];List<dynamic>? ddLocTem = [];
  List<dynamic> bPartData = [];List<dynamic> bPartDatatem = [];
  Map<String,dynamic> provinceID ={};
  Map<String,dynamic> districtID ={};
  Map<String,dynamic> localgovID ={};
  List<String> localgov = [];
  List<String> province = [];
  List<String> district = [];
  List<String> localgovtem = [];
  List<String> districttem = [];
  int uploaded = 0;
  int uploadedExpAtt = 0;
  int uploadedVoucher = 0;
  int uploadedAcamark = 0;
  int uploadedAcatrans = 0;
  int uploadedAcaother = 0;
  int uploadedExp = 0;
  int uploadedPub = 0;
  int selLevel = 0;
  FilePickerResult? result;
  List<dynamic> scholarshipOpen = [];
  List<bool> checkStat = [];
  List<dynamic> examOpen = [];
  List<dynamic> examOpenDet = [];
  List<String> idOfRegCourse = [];
  List<String> idOfAdmissionCourse = [];
  List<String> idOfScholarshipApp = [];
  List<dynamic> dataEntInfofromAPI = [];
  List<dynamic> dataEntInfo = [];
  List<dynamic> CourseInfo = [];
  List<dynamic> ScholarAppInfo = [];
  List<dynamic> CourseOpenInfo = [];
  List<dynamic> CourseRegApp = [];
  List<dynamic> CourseRegAppDet = [];
  List<dynamic> CourseOpenInfoDetailed = [];
  List<dynamic> dataRegCourseInfo = [];
  List<dynamic> cBpartLocation = [];
  List<dynamic> tempProv = [];
  List<dynamic> examApp = [];
  List<dynamic> examAppDet = [];
  List<dynamic> admissonOpen = [];
  List<dynamic> admissonOpenDet = [];
  List<dynamic> admissonApp = [];
  List<dynamic> admissonAppDet = [];
  List<dynamic> nouRegList = [];

  String amt = ''; String  remark = '' ;
  bool check = true;
  String selProv = '';
  String selDis = '';
  String selLocGov = '';
  String selWard = '';
  String selTole = '';
  String selProvTem = '';
  String selDisTem = '';
  String selLocGovTem = '';
  String selWardTem = '';
  String selToleTem = '';
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String name =  GetStorage().read('bPartnerName');
  String nepname =  GetStorage().read('bPartnerNepName');
  String BPEmail =  GetStorage().read('bPartnerEmail');
  String BPPhone =  GetStorage().read('bPartnerPhone');
  String fname =  GetStorage().read('bPartnerfname');
  String mname =  GetStorage().read('bPartnermname');
  String gfname =  GetStorage().read('bPartnergfname');
  String gmname =  GetStorage().read('bPartnergmname');
  String cast =  GetStorage().read('bPartnercast');
  String religion =  GetStorage().read('bPartnerreligion');
  String nation =  GetStorage().read('bPartnernationality');
  String marry =  GetStorage().read('bPartnermarry');
  String dob =  GetStorage().read('bPartnerdob');
  String dobbs =  GetStorage().read('bPartnerdobbs');
  List<String> scholarshipTypes = ['Exceptional Hardworking', 'Financial Promotion', 'Female Quota', 'Others'];
  List<String> ResearchInfo =['Publication Name' , 'Journal' , 'Link(if any)' ,'Year Published(AD)' ,];
  List<String> ExpInfo = ['Organization Name' , 'Position' , 'Employment Type' , 'Date From' , 'Date To' , 'Supervisor\’s Name' ,
  'Supervisor\’s Mobile' , 'Supervisor\’s Email' , 'Descriptions'];
  List<String> ExpInfoDet = ['Organization Name' , 'Position' , 'Employment Type' , 'Date From' , 'Date To' , 'Supervisor\’s Name' ,
    'Supervisor\’s Mobile' , 'Supervisor\’s Email' , 'Descriptions'];
  List<String> EduInfo = ['Level','Program','Board','Institute','Passed Year(AD)','Total Marks(% or GPA)','Obtained Marks(% or GPA)','Major'];
  List<String> EduInfoDet = ['Level','Program','Board','Institute','Passed Year(AD)','Total Marks(% or GPA)','Obtained Marks(% or GPA)','Major'];
  List<String> AcademicsLevel =[
    'SLC/SEE',
    '+2 Level',
    'Bachelor Level',
    'Master Level',
    'MPhil Level',
    'Phd. Level'
  ];
  List<String> FeeType= ['Admission and Semester Fee', 'Entrance Fee','Examination Fee','NOU Registration Fee','Other Student Fee'];
  Map<String , int> C_DocType_ID = {
    'Admission and Semester Fee' : 1000052,
    'Entrance Fee' : 1000051,
    'Examination Fee' : 1000054,
    'NOU Registration Fee' : 1000053,
    'Other Student Fee' : 1000055
  };
  List<String> markingSys = ['Grade(GPA)','Percent%'];
  List<String> expType = ['Permanent' , 'Temporary'];
  List<String> payType = ['Admission Fee','NOU Registration Fee','Course Registration','Examination Fee','Other Fee'];
  String selExpType = '';
  String selPayType = '';
  String selAcaLevel = '';
  String selAcaMark = '';
  List<String> stdInfoTitle = ['Academics' , 'Experience', 'Publications'];
  int first = 0;
  List<dynamic> selScholarship = [false,false,false,false];
  int tableIDofnscholarreg = 0;
  late Uint8List AttachmentsScholar ;
  Map<dynamic,dynamic> dataofScholarAppIDforAttach = {};
  int isSchAppAttachEmpty = 0;
  int noOfStdInfo  = 0 ;
  var STDInfoAca = [];
  var STDInfoExp = [];
  var STDInfoPub = [];
  var DDCBPlocation = [];
  var DDCBPlocationTemp = [];
  List<dynamic> creditHour = [];
  late Future<List<dynamic>> _cbpLocationData;
  String schAttType = '';
  List<dynamic> tempDist = [];
  List<dynamic> tempLocGov = [];
  List<int> scholarshipAppIds = [];
  String firstDist = '' ; String firstLoc = '';
  List<dynamic> entranceForm = [];
  List<dynamic> entranceExamCard = [];
  List<dynamic> scholarshipAppForm = [];
  List<dynamic> paymentDatas = [];
  List<PdfDocument> entrancePDF = [];
  String getfileExtType(String fName){
    String result = fName.substring(fName.lastIndexOf('.')+1 , fName.length);
    print(result);
    return result;
  }
  Map<int, Widget> Coursechildren = <int, Widget>{
    0: const Text("Open",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
    1: const Text("Applied ",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
  };
  Map<int, Widget> Examchildren = <int, Widget>{
    0: const Text("Open",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
    1: const Text("Applied ",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
  };
  Map<int, Widget> Scholarshipchildren = <int, Widget>{
    0: const Text("Open",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
    1: const Text("Applied ",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
  };
  Map<int, Widget> Entrancechildren = <int, Widget>{
    0: const Text("Open",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
    1: const Text("Applied ",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
  };
  Map<int, Widget> Asmissionchildren = <int, Widget>{
    0: const Text("Open",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
    1: const Text("Applied ",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
  };
  Map<int, Widget> NOUregchildren = <int, Widget>{
    0: const Text("Open",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
    1: const Text("Applied ",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
  };
  Map<String , int> remAmounttoPay = {};

  int act = 0;
  int len = 0;
  int fee = 0 ;
  final _formKey = GlobalKey<FormState>();
  final _formKeyAca = GlobalKey<FormState>();
  final _formKeyExp = GlobalKey<FormState>();
  final _formKeyPub = GlobalKey<FormState>();
  List<String> DPImage = [];
  void addAcaInfo(var record){
    setState(() {
      STDInfoAca = record;
    });
  }
  void addExpInfo(var record){
    setState(() {
      STDInfoExp = record;
    });
  }
  void addPubInfo(var record){
    setState(() {
      STDInfoPub = record;
    });
  }
  Future<void> runEntranceWS()async{
    selAcaMark = markingSys.first;
    //Load the existing PDF document.
    selAcaLevel = AcademicsLevel.first;
    entranceOpenInfo eInfoApp = entranceOpenInfo();
    dataEntInfoApp = await eInfoApp.getInfo();
    if(dataEntInfoApp.isNotEmpty){
      repProsWS rp = repProsWS();
      entranceForm = (await rp.getEntranceFrom(dataEntInfoApp))!;
      entranceExamCard = (await rp.getEntranceExamCard(dataEntInfoApp))!;
      // for(var i = 0 ; i <entranceForm)
    }
    int len = dataEntInfoApp.length;
    entranceOpenInfo eInfo = entranceOpenInfo();
    dataEntInfofromAPI = await eInfo.openInfo();
    dataEntInfo = await eInfo.openInfo();
    // if(dataEntInfoApp.isNotEmpty){
    //   CourseRegInfo cin = CourseRegInfo();
    //   CourseInfoAdd = await cin.getCourseInfoListAdmission(dataEntInfoApp);
    //   CourseInfo = await cin.getCourseInfoList(CourseInfoAdd);
    //
    //
    // }
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
      if(!idOfEntApp.contains(dataEntInfoApp[i]['n_entrance_open_ID']['id'].toString())){
      idOfEntApp.add(dataEntInfoApp[i]['n_entrance_open_ID']['id'].toString());}
    }
    chosenValueacDD =dataEntInfo[0]['n_aca_year_ID']['identifier'].toString();
    acaYearDD = acaYearDDF;
    dataEntInfo = foundRecords ?? dataEntInfofromAPI ;
  }
  Future<void> getAppScholarFromOpenId(int schOpenId) async {
    scholarInfo scin = scholarInfo();
    ScholarAppInfo = await scin.getscholarListApp();
    int indx = 0;
    for(var i = 0 ; i <= ScholarAppInfo.length-1 ; i++){
      if(ScholarAppInfo[i]['n_scholarship_open_ID']['id'] == schOpenId){
        indx = i;dataofScholarAppIDforAttach = ScholarAppInfo[i];
      }
    }
    attachWS attach  =attachWS();
    isSchAppAttachEmpty = (await attach.isAttachmentEmpty(ScholarAppInfo[indx]))!;

    if (kDebugMode) {
      print(isSchAppAttachEmpty);
    }
    // tableIDofnscholarreg = (await attach.getTableID('n_scholarship_reg'))!;
    if(isSchAppAttachEmpty == 0){
      schAttType = (await attach.AttchType(ScholarAppInfo[indx]))!;
      AttachmentsScholar = (await attach.getAttachment( ScholarAppInfo[indx]))!;}
    // scholarshipOpen = await scin.getscholarList(dataRegCourseInfo);
  }
  Future<void> runStdInfoWS()async{
    studentInfoWS stdinfo = studentInfoWS();
    STDInfoAca = (await stdinfo.getAcaInfo())!;
    STDInfoExp = (await stdinfo.getExpInfo())!;
    STDInfoPub = (await stdinfo.getPubInfo())!;
  }
  Future<void> runLocWS()async{
    locationWS loc = locationWS();
    if(tempProv.isEmpty){
      tempProv = (await loc.getProvince())!;
      for(var i = 0 ;  i< tempProv.length ; i ++){
        provinceID['${tempProv[i]['Name']}'] = tempProv[i]['id'];
        if(!province.contains(tempProv[i]['Name'].toString())){
          province.add(tempProv[i]['Name'].toString());}
        tempDist = (await loc.getDistrict(tempProv[i]['id'] as int))!;
        for(var j = 0 ; j< tempDist.length ; j ++){
          i == 0 && j==0 ?firstDist=tempDist[j]['Name'] : null;
          districtID[tempDist[j]['Name']] = tempDist[j]['id'];
          tempLocGov = (await loc.getLocalGov(tempDist[j]['id'] as int))!;
          for(var k = 0 ; k< tempLocGov.length ; k ++)
          {
            i == 0 && j==0 && k==0 ? firstLoc = tempLocGov[k]['Name'] : null;
            localgovID[tempLocGov[k]['Name']] = tempLocGov[k]['id'];
          }
        }
      } }
    ddDist=ddDistTem=bPartData=ddLoc=ddLocTem=bPartDatatem = [];
    bPartnerWS bpLocation = bPartnerWS();
    // print(await bpLocation.getImage());
    if(DDCBPlocationTemp.isEmpty){
      DDCBPlocationTemp = (await bpLocation.getBpartLocationTemp())!;
      if(DDCBPlocationTemp.isNotEmpty){
        selProvTem = DDCBPlocationTemp[0]['n_province_ID']['identifier'].toString();
        selDisTem = DDCBPlocationTemp[0]['n_district_ID']['identifier'].toString();
        selLocGovTem = DDCBPlocationTemp[0]['n_locgov_ID']['identifier'].toString();
        selWardTem =  DDCBPlocationTemp[0]['ward_no'].toString();
        selToleTem = DDCBPlocationTemp[0]['tole_name'].toString();
      }else{
         selProvTem = tempProv[0]['Name'].toString();
         selDisTem = firstDist;
         selLocGovTem = firstLoc;
      }
    }

    if(cBpartLocation.isEmpty){
      cBpartLocation = (await bpLocation.getBpartLocationPer())!;
      DDCBPlocation = cBpartLocation;
      if(DDCBPlocation.isNotEmpty){
        selProv = DDCBPlocation[0]['n_province_ID']['identifier'].toString();
        selDis = DDCBPlocation[0]['n_district_ID']['identifier'].toString();
        selLocGov = DDCBPlocation[0]['n_locgov_ID']['identifier'].toString();
        selWard =  DDCBPlocation[0]['ward_no'].toString();
        selTole = DDCBPlocation[0]['tole_name'].toString();
      }else{
        selProv = tempProv[0]['Name'].toString();
        selDis = firstDist;
        selLocGov = firstLoc;
      }
    }


  }
  Future<void> runWSServices()async {
    selPayType = payType.first;
    selExpType = expType.first;
    CourseRegInfo cin = CourseRegInfo();
    await runLocWS();
    await runStdInfoWS();
    await runEntranceWS();
    if(STDInfoPub.isEmpty){noOfStdInfo = 2;}else{noOfStdInfo = 3;}
    ExamRegInfo ereg = ExamRegInfo();
    await cin.updateEnrollId();
    dataRegCourseInfo = await cin.getCourseRegList();
    CourseRegApp = await cin.getAppCourseRegList();
    admissonOpen = await cin.getOpenAdmission(dataRegCourseInfo);
    admissonApp = await cin.getAdmissionRegList();
    if(admissonOpen.isNotEmpty){
      admissonOpenDet = await cin.getCourseInfoList(admissonOpen);
    }
    if(admissonApp.isNotEmpty){
      admissonAppDet = await cin.getCourseInfoList(admissonApp);
    }
    if(CourseRegApp.isNotEmpty){
      int total = 0;
      CourseRegAppDet = await cin.getCourseInfoList(CourseRegApp);
      for(var i = 0 ; i < CourseRegApp.length ; i++){
        int feeInc = CourseRegApp[i]['totalfee'];
        int feePaid = CourseRegApp[i]['totalfee_paid'];
        int rem = feeInc - feePaid;
        total = total + rem;
      }
      remAmounttoPay[payType[2]] = total ;
    }
    if(dataRegCourseInfo.isNotEmpty){
      CourseInfo = await cin.getCourseInfoList(dataRegCourseInfo);
      CourseOpenInfo = await cin.getOpenCreg(dataRegCourseInfo);
      if(CourseOpenInfo.isNotEmpty){
        CourseOpenInfoDetailed = await cin.getCourseInfoList(CourseOpenInfo);
      }
      examOpen = await ereg.getExamInfoList(dataRegCourseInfo);
      examApp = await ereg.getExamApp();
      int total = 0;
      for(var i = 0 ; i < examApp.length ; i++){
        int rem = examApp[i]['totalfee'] - examApp[i]['feepaid'];
        total = total + rem;
      }
      remAmounttoPay[payType[3]] = total;
      examAppDet = await ereg.getExamAppDet(examApp);
      if(examOpen.isNotEmpty){
        examOpenDet = await cin.getCourseInfoList(examOpen[0]);
      }
      scholarInfo scin = scholarInfo();
      scholarshipOpen = await scin.getscholarList(dataRegCourseInfo);
      ScholarAppInfo = await scin.getscholarListApp();
      nouRegWS nou = nouRegWS();
      paymentWS payData = paymentWS();
      paymentDatas = await payData.getPayments();
      nouRegList = await nou.getNouReg();
      int remtt = nouRegList[0]['totalfee'] - nouRegList[0]['feepaid'];
      remAmounttoPay[payType[1]] = remtt ;
      if(ScholarAppInfo.isNotEmpty){
        print('scholarship insidee : ');
        repProsWS rp = repProsWS();
        scholarshipAppForm = (await rp.getScholarshipAppPrint(ScholarAppInfo))!;
        idOfScholarshipApp = [];
        for(var i = 0 ; i <= ScholarAppInfo.length-1 ; i++){
          if(!idOfScholarshipApp.contains(ScholarAppInfo[i]['n_scholarship_open_ID']['id'].toString())){
            idOfScholarshipApp.add(ScholarAppInfo[i]['n_scholarship_open_ID']['id'].toString());
          }
        }
      }idOfRegCourse = [];
      idOfAdmissionCourse = [];
      for(var i = 0 ; i < CourseRegApp.length ; i ++){
        if(!idOfRegCourse.contains(CourseRegApp[i]['n_program_cregopen_ID']['id'].toString())){
          idOfRegCourse.add(CourseRegApp[i]['n_program_cregopen_ID']['id'].toString());
        }
      }
      for(var i = 0 ; i < admissonApp.length ; i ++){
        if(!idOfAdmissionCourse.contains(admissonApp[i]['n_program_cregopen_ID']['id'].toString())){
          idOfAdmissionCourse.add(admissonApp[i]['n_program_cregopen_ID']['id'].toString());
        }
      }
      if(dataRegCourseInfo[0]['n_sem_year_ID']['identifier'] == 1 ){
        int totall = dataRegCourseInfo[0]['admissionfee'] ;
        remAmounttoPay[payType[0]] =  totall;
      }else{
        remAmounttoPay[payType[0]] =  0;
      }

    }
    print(remAmounttoPay);
  }
  Future<void> _pickFile(List<String> Data) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png' , 'jpeg'],);
    Data.add(result!.files.first.name);
    // nameCode.add(result.files.first.bytes.toString());
    Data.add(uint8ListTob64(result.files.first.bytes));
  }
  Future<void> _pickDP(List<String> Data) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png' , 'jpeg'],);
    Data.add(result!.files.first.name);
    // nameCode.add(result.files.first.bytes.toString());
    Data.add(uint8ListTob64(result.files.first.bytes));
  }
  String uint8ListTob64(Uint8List? value) {
    String base64String = base64Encode(value!);
    return base64String;
  }
  Future<List<String>> getCBLocation() async {
    await runLocWS();
    locationWS loca = locationWS();
    print(provinceID);
    if(ddDistTem!.isEmpty){
      ddDistTem = await loca.getDistrict(provinceID[selProvTem] as int);
      for(var  i = 0 ; i < ddDistTem!.length ; i ++){
        if(!districttem.contains(ddDistTem![i]['Name'].toString())){
          districttem.add(ddDistTem![i]['Name'].toString());
        }
      }
    }
    if(ddLocTem!.isEmpty){
      ddLocTem = await loca.getLocalGov(districtID[selDisTem] as int);
      for(var  i = 0 ; i < ddLocTem!.length ; i ++){
        if(!localgovtem.contains(ddLocTem![i]['Name'].toString())){
          localgovtem.add(ddLocTem![i]['Name'].toString());
        }
      }
    }
    if(ddDist!.isEmpty){
      ddDist = await loca.getDistrict(provinceID[selProv] as int);
      for(var  i = 0 ; i < ddDist!.length ; i ++){
        if(!district.contains(ddDist![i]['Name'].toString())){
          district.add(ddDist![i]['Name'].toString());
        }
      }
    }
    if(ddLoc!.isEmpty){ddLoc = await loca.getLocalGov(districtID[selDis] as int);
    for(var  i = 0 ; i < ddLoc!.length ; i ++){
      if(!localgov.contains(ddLoc![i]['Name'].toString())){
        localgov.add(ddLoc![i]['Name'].toString());
      }
    }}
    bPartnerWS bp = bPartnerWS();
    bPartData = (await bp.getBparData())!;
    bPartDatatem = bPartData;

    // print(bPartDatatem);
    return localgov;
  }
  Uint8List base64Decode(String source) => base64.decode(source);
  void showSnackwithCtx(BuildContext ctx ,String text , Color color){
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(duration: Duration(seconds: 3) ,content: Text(text , style: TextStyle(color: color),)),
    );
  }
  void showSnack(String text , Color color){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: Duration(seconds: 3) ,content: Text(text , style: TextStyle(color: color),)),
    );
  }
  @override
  initState()  {
    dateinput.text = GetStorage().read('bPartnerdob').toString();
    runWSServices();
    _cbpLocationData = getCBLocation();
    super.initState();
  }

  showAttach(BuildContext context , String type , var data){
    if(type == 'application/pdf'){
      showDialog(
        context: context,
        builder: (BuildContext context) => sdtInfoPdfPop(context , data ),);
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) => ImageView(context , data ),);}
  }

  ////Payments
  Widget offlinePay(BuildContext context , int amt , int type){
    String ty = FeeType[type];
    var amount =0;
    late String dmarks ;
    int txnid = 0;
    String model_name = 'C_BPartner';
    return StatefulBuilder(builder:(BuildContext context ,  StateSetter setState) {
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
              SizedBox(height: 18,),

              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('OFFLINE Payment ',style: TextStyle(color: Colors.grey , fontSize: 18,fontWeight: FontWeight.bold),),
              ],),
              Container(padding: EdgeInsets.all(6),
                child: Text( 'Amount to be paid : $amt',
                ),),
              Container(padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 77,right: 77),
                child: TextField(
                  controller: TextEditingController(text:  amt.toString() ),
                  onChanged: (value){
                    amount =int.parse(value) ;
                  },
                  decoration: InputDecoration(
                    labelText: 'Deposit amount',
                  ),),),
              SizedBox(height: 18,),
              Container(padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 77,right: 77),
                child: TextField(
                  onChanged: (value){
                    txnid = int.parse(value) ;
                  },
                  decoration: InputDecoration(
                    labelText: 'Transaction ID',
                  ),),),
              SizedBox(height: 18,),
              Container(padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 77,right: 77),
                child: TextField(
                  controller: dateinputOffDate, //editing controller of this TextField
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
                        dateinputOffDate.text = formattedDate; //set output date to TextField value.
                      });
                    }else{
                      print("Date is not selected");
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Deposit Date : ',
                  ),),),
              SizedBox(height: 18,),
              Container(padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 77,right: 77),
                child: TextField(
                  onChanged: (value){
                    dmarks = value ;
                  },
                  decoration: InputDecoration(
                    labelText: ' Deposit Remarks',
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
                    onPressed: () async {
                      paymentWS off = paymentWS();
                      await off.OfflinePay(amount == 0 ? amt : amount, dateinputOffDate.text, dmarks, txnid , FeeType[type] , C_DocType_ID[FeeType[type]]!);
                      Navigator.of(context).pop();
                      showSnackwithCtx(context, 'Payement Processing', Colors.green);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.withOpacity(.66)),
                  ),
                ],
              ),
            ],
          ),),
      );});

  }
  Widget voucherPay(BuildContext context , int amt , int type){
    String ty = FeeType[type];
    var amount =0;
    late String dmarks ;
    String model_name = 'C_BPartner';
    return StatefulBuilder(builder:(BuildContext context ,  StateSetter setState) {
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
              SizedBox(height: 18,),

              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('VOUCHER Payment ',style: TextStyle(color: Colors.grey , fontSize: 25,fontWeight: FontWeight.bold),),
              ],),
              Container(padding: EdgeInsets.all(6),
                child: Text( 'Amount to be paid : $amt',
                ),),
              Container(padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 77,right: 77),
                child: TextField(
                  controller: TextEditingController(text: amt.toString()),
                  onChanged: (value){
                    amount =  int.parse(value) ;
                  },
                  decoration: InputDecoration(
                    labelText: 'Deposit amount',
                  ),),),
              SizedBox(height: 18,),
              Container(padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 77,right: 77),
                child: TextField(
                  controller: dateinputDepDate, //editing controller of this TextField
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
                        dateinputDepDate.text = formattedDate; //set output date to TextField value.
                      });
                    }else{
                      print("Date is not selected");
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Deposit Date : ',
                  ),),),
              SizedBox(height: 18,),
              Container(padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(left: 77,right: 77),
                child: TextField(
                  onChanged: (value){
                    dmarks = value ;
                  },
                  decoration: InputDecoration(
                    labelText: ' Deposit Remarks',
                  ),),),
              SizedBox(height: 18,),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _pickFile(nameCodeVoucher);
                      setState(() {
                        if(nameCodeVoucher.isNotEmpty){
                          uploadedVoucher = 1;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                    child:Text('Voucher Upload :'),
                  ),
                  Text(
                      uploadedVoucher == 0 ?'' : nameCodeVoucher[0]),
                  Center(
                    child: SizedBox(
                      child: uploadedVoucher == 0 ? Text('') : ElevatedButton(
                        child: Text('X-cancel',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          setState((){
                            nameCodeVoucher =[];
                            uploadedVoucher = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(primary:Colors.red.withOpacity(0.5)),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child:Text('<- Back'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red.withOpacity(.66)),
                  ),
                  SizedBox(width: 18,),
                  ElevatedButton(
                    child:Text('Update ->'),
                    onPressed: () async {
                      paymentWS vouch = paymentWS();
                      int? PayId = await vouch.VoucherPay(amount == 0? amt
                          : amount, dateinputDepDate.text, dmarks, FeeType[type] , C_DocType_ID[FeeType[type]]!);
                      attachWS at = attachWS();
                      await at.uploadVoucher(PayId!, nameCodeVoucher[0], nameCodeVoucher[1]);
                      int? tId = await at.getTableID('C_Payment');
                      int? Aid = await at.getAttachmentID(tId!,PayId );
                      await vouch.updateVoucherAttachId(Aid! , PayId);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      showSnack( 'Payment Processing', Colors.green);
                      nameCodeVoucher =[];
                      uploadedVoucher = 0;
                      dateinputDepDate.text = '';
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.withOpacity(.66)),
                  ),
                ],
              ),
            ],
          ),),
      );});

  }
  Widget onlinePay(BuildContext context , int amount , int type){
    String ammt = amount.toString();
    String ty = FeeType[type];
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
    int amt = 0;
    String dmarks = '';
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
              child: Text( 'Amount to be paid : $amount',
              ),),
            SizedBox(height: 18,),
            Container(padding: EdgeInsets.all(6),
              margin: EdgeInsets.only(left: 77,right: 77),
              child: TextField(controller: TextEditingController(text : ammt),
                onChanged: (value){
                  amt = int.parse(value);
                },
                decoration: InputDecoration(
                  labelText: 'Enter Amount : ',
                ),),),
            SizedBox(height: 18,),
            Container(padding: EdgeInsets.all(6),
              margin: EdgeInsets.only(left: 77,right: 77),
              child: TextField(
                onChanged: (value){
                  dmarks = value;
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
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red.withOpacity(.66)),
                ),

                const SizedBox(width: 18,),
                ElevatedButton(
                  onPressed: () async {
                    int txn = bPartData[0]['id'];
                    String genCode = '${txn.toString()}000${Random().nextInt(1000).toString()}';
                    txn = int.parse(genCode);
                    print(txn);
                    js.context.callMethod('open', ['${ApiConstants.protocol}://${ApiConstants
                        .baseUrl}/npg/v1/generateLink?Amount=$ammt&Remarks=$dmarks&MerchantTxnID=$txn', 'loginWindow', 'width=600,height=600,left=600,top=200']);
                    paymentWS online = paymentWS();
                    online.OnlinePay(amount == 0? amt
                        : amount, dmarks,txn, FeeType[type] , C_DocType_ID[FeeType[type]]!);
                    // online.OnlinePay(, ddate, dmarks, txnId)
                    Navigator.of(context).pop();
                    showSnack('Payment Process', Colors.green);
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
      child: ListView(
          children: [Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18,),
              Text('Your details of selection : ',style: TextStyle(color: Colors.black , fontSize: 27 ,fontWeight: FontWeight.bold),),
              SizedBox(height: 24,),
              Center(child:
              Text('Please select mode of payment'),),
              SizedBox(height: 57,),
              ElevatedButton(
                child:Container(
                    height: 81,
                    width:250,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF50C878),
                    ),
                    child: Center(child: Text('अनलाईन यहाँ क्लिक गर्नुस्',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),))),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => onlinePay(context , amt , type),);
                },style: ElevatedButton.styleFrom(primary:Color(0xFF50C878)),
              ),
              SizedBox(height: 40,),
              ElevatedButton(
                child:Container(
                    height: 81,
                    width:250,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey2,
                    ),
                    child: Center(child: Text('अफलाइन यहाँ क्लिक गर्नुस्',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),))),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => offlinePay(context , amt , type),);
                },style: ElevatedButton.styleFrom(primary:CupertinoColors.systemGrey2),
              ),
              SizedBox(height: 40,),
              ElevatedButton(
                child:Container(
                    height: 81,
                    width:250,
                    margin: EdgeInsets.all(12),
                    color: Color(0xFF1984F7),
                    child: Center(child: Text('बैंक भाउचर दर्ता यहाँ क्लिक गर्नुस् ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)))),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => voucherPay(context , amt ,type),);
                },
                style: ElevatedButton.styleFrom(primary:Color(0xFF1984F7)),

              ),
              SizedBox(height: 40,),
              ElevatedButton(
                child: Text('Back'),
                onPressed: (){
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(primary:Colors.black45),
              ),
            ],
          ),]
      ),
    );
  }
  Widget addPayPop(BuildContext context ){
    return StatefulBuilder( builder:(context ,  StateSetter setState) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView(
            children: [
            Container(
            alignment: FractionalOffset.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear),
            ),),
              Center(child : Text('Payment Window' , style : TextStyle(color : Colors.green , fontSize: 21)) ,
              ),
              Center(child : Text('Select Payment Type:' , style : TextStyle(color : Colors.black , fontSize: 15)) ,
              ),
              Container(
                padding: EdgeInsets.only(left: 21,right: 21),
                width: 250,
                child:  DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Payment Type : ',style: TextStyle(fontSize: 9, decoration: TextDecoration.none ),),
                  items:payType.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      enabled: true,
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  dropdownColor: Colors.white,
                  focusColor: Colors.grey,
                  value: selPayType,
                  onChanged: (value)  {
                    setState(() {
                      selPayType = value!;
                    });
                  },
                ),
              ),
              Visibility( visible : selPayType != 'Other Fee',
                  child: Text('Fee to be paid : ${remAmounttoPay['selPayType']}' ,)),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: CupertinoColors.systemBlue),
                  onPressed: (){
                int type = 0;
                if(selPayType == 'Admission Fee'){type = 0;}else if(selPayType == 'NOU Registration Fee'){type = 1;}
                else if(selPayType == 'Course Registration'){type = 2;}else if(selPayType == 'Examination Fee'){type = 3;}
                else{type = 4;}
                showDialog(context: context,
                    builder: (BuildContext context) => secondStepPay(context, selPayType != 'Other Fee' ? remAmounttoPay[selPayType] : 0, type));
              }
                  , child: Text('Make Payment' , style : TextStyle(color : Colors.white))),
            ]
        ),
      ),
    );});
  }

  Widget addAcaRecordPop(BuildContext context , addCallback ){
    return Scaffold(
      body: StatefulBuilder( builder:(context ,  StateSetter setState) {
        return Form(
          key: _formKeyAca,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(left:66 , right : 66 , top:66 , bottom: 150),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),),
            child: (Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Center(
                                child: Text('Level'),
                              ),
                              SizedBox(height: 6,),
                              Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child:  DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Level : ',style: TextStyle(fontSize: 9, decoration: TextDecoration.none ),),
                                  items:AcademicsLevel.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      enabled: true,
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  dropdownColor: Colors.white,
                                  focusColor: Colors.grey,
                                  value: selAcaLevel,
                                  onChanged: (value)  {
                                    setState(() {
                                      selAcaLevel = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextFormField(
                                validator: ValidationBuilder().minLength(3,'*Required').maxLength(50,'Long Expression').build() ,
                                enabled : true,
                                onChanged: (value) {
                                  EduInfoDet[1] = value;
                                },
                                decoration:  InputDecoration(
                                  labelText: EduInfo[1],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextFormField(
                                validator: ValidationBuilder().minLength(3,'*Required').maxLength(50,'Long Expression').build() ,
                                enabled : true,
                                onChanged: (value) {EduInfoDet[2] = value;
                                },
                                decoration:  InputDecoration(
                                  labelText: EduInfo[2],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(flex:6,
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextFormField(

                                validator: ValidationBuilder().minLength(3,'*Required').maxLength(50,'Long Expression').build() ,
                                enabled : true,
                                onChanged: (value) {EduInfoDet[3] = value;
                                },
                                decoration:  InputDecoration(
                                  labelText: EduInfo[3],
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex:4,
                              child:Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 400,
                                child: TextFormField(
                                  validator: ValidationBuilder().minLength(4,'*Required').maxLength(50,'Long Expression').build() ,
                                  enabled : true,
                                  onChanged: (value) {EduInfoDet[7] = value;
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[7],
                                  ),
                                ),
                              )),
                          Expanded(flex:2,
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextFormField(
                                validator: ValidationBuilder().minLength(4,'*Required').maxLength(4,'Long Expression').build() ,
                                enabled : true,
                                onChanged: (value) {EduInfoDet[4] = value;
                                },
                                decoration:  InputDecoration(
                                  labelText: EduInfo[4],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text('Marking System'),
                              ),
                              SizedBox(height: 6,),
                              Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child:  DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Marking System',style: TextStyle(fontSize: 9, decoration: TextDecoration.none ),),
                                  items:markingSys.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      enabled: true,
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  dropdownColor: Colors.white,
                                  focusColor: Colors.grey,
                                  value: selAcaMark,
                                  onChanged: (value)  {
                                    setState(() {
                                      selAcaMark = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextFormField(
                                validator: ValidationBuilder().minLength(1,'*Required').maxLength(3,'Long Expression').build() ,
                                enabled : true,
                                onChanged: (value) {EduInfoDet[5] = value;
                                },
                                decoration:  InputDecoration(
                                  labelText: EduInfo[5],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextFormField(
                                validator: ValidationBuilder().minLength(1,'*Required').maxLength(3,'Long Expression').build() ,
                                enabled : true,
                                onChanged: (value) {EduInfoDet[6] = value;
                                },
                                decoration:  InputDecoration(
                                  labelText: EduInfo[6],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Center(child: SizedBox(child: Text('Attachments' , style : TextStyle(fontSize: 12 , fontWeight: FontWeight.bold)),)),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await _pickFile(nameCodeAcaMark);
                                  setState(() {
                                    if(nameCodeAcaMark.isNotEmpty){
                                      uploadedAcamark = 1;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                                child:Text('Marksheet'),
                              ),
                              Text(
                                  uploadedAcamark == 0 ?'' : nameCodeAcaMark[0]),
                              Center(
                                child: SizedBox(
                                  child: uploadedAcamark == 0 ? Text('') : ElevatedButton(
                                    child: Text('X-cancel',style: TextStyle(color: Colors.white),),
                                    onPressed: (){
                                      setState((){
                                        nameCodeAcaMark =[];
                                        uploadedAcamark = 0;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(primary:Colors.red.withOpacity(0.5)),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await _pickFile(nameCodeAcaTrans);
                                  setState(() {
                                    if(nameCodeAcaTrans.isNotEmpty){
                                      uploadedAcatrans = 1;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                                child:Text('Transcript'),
                              ),
                              Text(
                                  uploadedAcatrans == 0 ?'' : nameCodeAcaTrans[0]),
                              Center(
                                child: SizedBox(
                                  child: uploadedAcatrans == 0 ? Text('') : ElevatedButton(
                                    child: Text('X-cancel',style: TextStyle(color: Colors.white),),
                                    onPressed: (){
                                      setState((){
                                        nameCodeAcaTrans =[];
                                        uploadedAcatrans = 0;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(primary:Colors.red.withOpacity(0.5)),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await _pickFile(nameCodeAcaOther);
                                  setState(() {
                                    if(nameCodeAcaOther.isNotEmpty){
                                      uploadedAcaother = 1;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                                child:Text('Other'),
                              ),
                              Text(
                                  uploadedAcaother == 0 ?'' : nameCodeAcaOther[0]),
                              Center(
                                child: SizedBox(
                                  child: uploadedAcaother == 0 ? Text('') : ElevatedButton(
                                    child: Text('X-cancel',style: TextStyle(color: Colors.white),),
                                    onPressed: (){
                                      setState((){
                                        nameCodeAcaOther =[];
                                        uploadedAcaother = 0;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(primary:Colors.red.withOpacity(0.5)),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(thickness: 2, color: Colors.black54,),
                      SizedBox(height: 5,),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(child:Text('Add Record') ,
                          onPressed: (){
                            showDialog(context: context, builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("AlertDialog"),
                                content: Text("Would you like to save your informations ?"),
                                actions: [
                                  ElevatedButton(
                                    child: Text("Yes"),
                                    onPressed:  () async{
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKeyAca.currentState!.validate()) {
                                        if(uploadedAcamark == 0 || uploadedAcatrans == 0){
                                          Navigator.of(context).pop();
                                          showSnackwithCtx(context,'Marksheet and Transcript Compulsory', Colors.redAccent);
                                        }  else{
                                          studentInfoWS stdinfo= studentInfoWS();
                                          attachWS att = attachWS();
                                          await stdinfo.UploadAcaInfo(AcademicsLevel.indexOf(selAcaLevel), EduInfoDet, markingSys.indexOf(selAcaMark));
                                          var updatedAca = await stdinfo.getAcaInfo();
                                          if(selAcaLevel == 'SLC/SEE'){selAcaLevel='SLC_SEE';}
                                          String ext = getfileExtType(nameCodeAcaMark[0]);
                                          String ext2 = getfileExtType(nameCodeAcaTrans[0]);
                                          await att.uploadAttachmentSingle(updatedAca?.last, '$CBpartnerID'+'_'+selAcaLevel+'_Marksheet.$ext', nameCodeAcaMark[1]);
                                          await att.uploadAttachmentSingle(updatedAca?.last, '$CBpartnerID'+'_'+selAcaLevel+'_Transcript.$ext2', nameCodeAcaTrans[1]);
                                          if(uploadedAcaother == 1){
                                            String ext3 = getfileExtType(nameCodeAcaOther[0]);
                                            await att.uploadAttachmentSingle(updatedAca?.last, '$CBpartnerID'+'_'+selAcaLevel+'_Others.$ext3', nameCodeAcaOther[1]);
                                          }
                                          addCallback(updatedAca);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          showSnack('Processing Data', Colors.greenAccent);
                                          showSnack('Added Data', Colors.greenAccent);
                                        }

                                      }else{Navigator.of(context).pop();}
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("No"),
                                    onPressed:  () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                          },),
                          SizedBox(width : 12),
                          ElevatedButton(child:Text('Back') ,
                            onPressed: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("AlertDialog"),
                                  content: Text("Would you like to go back ?"),
                                  actions: [
                                    ElevatedButton(
                                      child: Text("Yes"),
                                      onPressed:  () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text("No"),
                                      onPressed:  () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  )
                ),
          ),
        );}),
    );
  }
  Widget addExpRecordPop(BuildContext context , addCallback ){
    return Scaffold(
      body: StatefulBuilder( builder:(context ,  StateSetter setState) {
        return Form(
          key: _formKeyExp,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(left:66 , right : 66 , top:66 , bottom: 150),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),),
            child: (Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Expanded(flex:5,
                      child: Container(
                        padding: EdgeInsets.only(left: 21,right: 21),
                        width: 250,
                        child: TextFormField(
                          validator: ValidationBuilder().minLength(3,'*Required').maxLength(50,'Long Expression').build() ,
                          enabled : true,
                          onChanged: (value) {
                            ExpInfoDet[0] = value;
                          },
                          decoration:  InputDecoration(
                            labelText: ExpInfo[0],
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(left: 21,right: 21),
                        width: 250,
                        child: TextFormField(
                          validator: ValidationBuilder().minLength(3,'*Required').maxLength(50,'Long Expression').build() ,
                          enabled : true,
                          onChanged: (value) {ExpInfoDet[1] = value;
                          },
                          decoration:  InputDecoration(
                            labelText: ExpInfo[1],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Text('Employement Type'),
                          ),
                          SizedBox(height: 6,),
                          Container(
                            padding: EdgeInsets.only(left: 21,right: 21),
                            width: 250,
                            child:  DropdownButton<String>(
                              isExpanded: true,
                              hint: Text('Type : ',style: TextStyle(fontSize: 9, decoration: TextDecoration.none ),),
                              items:expType.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  enabled: true,
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              dropdownColor: Colors.white,
                              focusColor: Colors.grey,
                              value: selExpType,
                              onChanged: (value)  {
                                setState(() {
                                  selExpType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 21,right: 21),
                        width: 250,
                        child: TextFormField(
                          controller: dateinputExpFrom, //editing controller of this TextField
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
                              ExpInfoDet[3] = formattedDate;

                              setState(() {
                                dateinputExpFrom.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
                          onChanged: (value){
                            ExpInfoDet[3] = value;
                          },
                          decoration: InputDecoration(
                            labelText: ExpInfo[3],
                          ),),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 21,right: 21),
                        width: 250,
                        child: TextFormField(
                          controller: dateinputExpTo, //editing controller of this TextField
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
                              ExpInfoDet[4] = formattedDate;

                                  setState(() {
                                dateinputExpTo.text = formattedDate; //set output date to TextField value.
                              });
                            }else{
                              print("Date is not selected");
                            }
                          },
                          onChanged: (value){
                            ExpInfoDet[4] = value;
                          },
                          decoration: InputDecoration(
                            labelText: ExpInfo[4],
                          ),),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 21,right: 21),
                        width: 250,
                        child: TextFormField(
                          validator: ValidationBuilder().minLength(1,'*Required').maxLength(50,'Long Expression').build() ,
                          enabled : true,
                          onChanged: (value) {ExpInfoDet[5] = value;
                          },
                          decoration:  InputDecoration(
                            labelText: ExpInfo[5],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 21,right: 21),
                        width: 250,
                        child: TextFormField(
                          validator: ValidationBuilder().minLength(10,'*Required').maxLength(10,'Long Expression').build() ,
                          enabled : true,
                          onChanged: (value) {ExpInfoDet[6] = value;
                          },
                          decoration:  InputDecoration(
                            labelText: ExpInfo[6],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 21,right: 21),
                        width: 250,
                        child: TextFormField(
                          validator: ValidationBuilder().minLength(5,'*Required').maxLength(22,'Long Expression').build() ,
                          enabled : true,
                          onChanged: (value) {ExpInfoDet[7] = value;
                          },
                          decoration:  InputDecoration(
                            labelText: ExpInfo[7],
                          ),
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
                        padding: EdgeInsets.only(left: 21,right: 21),
                        width: 250,
                        child: TextFormField(
                          validator: ValidationBuilder().minLength(1,'*Required').maxLength(50,'Long Expression').build() ,
                          enabled : true,
                          onChanged: (value) {ExpInfoDet[8] = value;
                          },
                          decoration:  InputDecoration(
                            labelText: ExpInfo[8],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(child: SizedBox(child: Text('Attachments' , style : TextStyle(fontSize: 12 , fontWeight: FontWeight.bold)),)),
                Center(child:Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _pickFile(nameCodeExpAtt);
                        setState(() {
                          if(nameCodeExpAtt.isNotEmpty){
                            uploadedExpAtt = 1;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                      child:Text('Upload'),
                    ),
                    Text(
                        uploadedExpAtt == 0 ?'' : nameCodeExpAtt[0]),
                    Center(
                      child: SizedBox(
                        child: uploadedExpAtt == 0 ? Text('') : ElevatedButton(
                          child: Text('X-cancel',style: TextStyle(color: Colors.white),),
                          onPressed: (){
                            setState((){
                              nameCodeExpAtt =[];
                              uploadedExpAtt = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(primary:Colors.red.withOpacity(0.5)),
                        ),
                      ),
                    ),

                  ],
                )),
                SizedBox(height: 10,),
                Divider(thickness: 2, color: Colors.black54,),
                SizedBox(height: 5,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(child:Text('Add Record') ,
                      onPressed: (){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("AlertDialog"),
                            content: Text("Would you like to save your informations ?"),
                            actions: [
                              ElevatedButton(
                                child: Text("Yes"),
                                onPressed:  () async{
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKeyExp.currentState!.validate()) {
                                    if(uploadedExpAtt == 0 ){
                                      Navigator.of(context).pop();
                                      showSnackwithCtx(context,'Marksheet and Transcript Compulsory', Colors.redAccent);
                                    }  else{
                                      studentInfoWS stdinfo= studentInfoWS();
                                      attachWS att = attachWS();
                                      await stdinfo.UploadExpInfo( ExpInfoDet, expType.indexOf(selExpType));
                                      var updatedExp = await stdinfo.getExpInfo();
                                      String ext = getfileExtType(nameCodeExpAtt[0]);
                                      await att.uploadAttachmentSingle(updatedExp?.last, '$CBpartnerID'+'_Exp.$ext', nameCodeExpAtt[1]);
                                      addCallback(updatedExp);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      showSnack('Processing Data', Colors.greenAccent);
                                      showSnack('Added Data', Colors.greenAccent);
                                    }

                                  }else{Navigator.of(context).pop();}
                                },
                              ),
                              ElevatedButton(
                                child: Text("No"),
                                onPressed:  () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                      },),
                    SizedBox(width : 12),
                    ElevatedButton(child:Text('Back') ,
                      onPressed: (){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("AlertDialog"),
                            content: Text("Would you like to go back ?"),
                            actions: [
                              ElevatedButton(
                                child: Text("Yes"),
                                onPressed:  () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text("No"),
                                onPressed:  () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                      },
                    ),
                  ],
                )
              ],
            )
            ),
          ),
        );}),
    );
  }
  Widget stdInfoSubBox(BuildContext context , int index ){
    switch(index){
      case 0:
        return(
            Container(
              padding: EdgeInsets.only(left: 45 , right: 45 , top: 18 , bottom: 18),
              child: (ListView.builder(itemCount: STDInfoAca.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctxt, int index){
                    attachWS at = attachWS();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child: TextField(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  enabled : false,
                                  controller:
                                  TextEditingController(text: STDInfoAca[index]['Value']['identifier'].toString()),
                                  onChanged: (value) {
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[0],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child: TextField(
                                  enabled : false,
                                  controller:
                                  TextEditingController(text: STDInfoAca[index]['Name'].toString()),
                                  onChanged: (value) {
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[1],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child: TextField(
                                  enabled : false,
                                  controller:
                                  TextEditingController(text: STDInfoAca[index]['uni_board'].toString()),
                                  onChanged: (value) {
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[2],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(flex : 6,
                              child: Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child: TextField(
                                  enabled : false,
                                  controller:
                                  TextEditingController(text: STDInfoAca[index]['institute'].toString()),
                                  onChanged: (value) {
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[3],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                            visible : STDInfoAca[index]['Description'].toString() == 'null' ? false : true,
                              child: Expanded(
                                flex : 4,
                                child: Container(
                                  padding: EdgeInsets.only(left: 21,right: 21),
                                  width: 250,
                                  child: TextField(
                                    enabled : false,
                                    controller:
                                    TextEditingController(text: STDInfoAca[index]['Description'].toString()),
                                    onChanged: (value) {
                                    },
                                    decoration:  InputDecoration(
                                      labelText: EduInfo[7],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(flex : 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child: TextField(
                                  enabled : false,
                                  controller:
                                  TextEditingController(text: STDInfoAca[index]['passed_year'].toString()),
                                  onChanged: (value) {
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[4],
                                  ),
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
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child: TextField(
                                  enabled : false,
                                  controller:
                                  TextEditingController(text: STDInfoAca[index]['grading_type']['identifier'].toString()),
                                  onChanged: (value) {
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[5],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child: TextField(
                                  enabled : false,
                                  controller:
                                  TextEditingController(text: STDInfoAca[index]['full_marks'].toString()),
                                  onChanged: (value) {
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[5],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 21,right: 21),
                                width: 250,
                                child: TextField(
                                  enabled : false,
                                  controller:
                                  TextEditingController(text: STDInfoAca[index]['obtained_marks'].toString()),
                                  onChanged: (value) {
                                  },
                                  decoration:  InputDecoration(
                                    labelText: EduInfo[6],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),SizedBox(height:6),
                        Row(mainAxisAlignment : MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                            style:ElevatedButton.styleFrom(backgroundColor: CupertinoColors.systemRed),
                            onPressed: () async {
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("AlertDialog"),
                                  content: Text("Sure to delete record ?"),
                                  actions: [
                                    ElevatedButton(
                                      child: Text("Yes"),
                                      onPressed:  () async {
                                        studentInfoWS std = studentInfoWS();
                                        await std.deleteInfo(STDInfoAca[index]);
                                        var updateData = await std.getAcaInfo();
                                        addAcaInfo(updateData);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text("No"),
                                      onPressed:  () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });

                            }, child: Text('Delete'),

                            ),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                List<Uint8List>? attch =  await at.getAttachmentList(STDInfoAca[index]) ;
                                List type = await at.getAttchTypeList(STDInfoAca[index]);
                                showAttach(context, type[0], attch![0]);
                              },
                              style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                              child:Text('Marksheet'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                List<Uint8List>? attch =  await at.getAttachmentList(STDInfoAca[index]) ;
                                List type = await at.getAttchTypeList(STDInfoAca[index]);
                                showAttach(context, type[1], attch![1]);
                              },
                              style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                              child:Text('Character'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                List<Uint8List>? attch =  await at.getAttachmentList(STDInfoAca[index]) ;
                                List type = await at.getAttchTypeList(STDInfoAca[index]);
                                if(attch!.length < 3 ){
                                  showSnack( 'EMPTY RECORD', Colors.red);
                                }else{
                                  showAttach(context, type[2], attch[2]);
                                }
                              },
                              style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                              child:Text('Others'),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(thickness: 2, color: Colors.black54,),
                        SizedBox(height: 5,),
                      ],
                    );
                  } )),
            ));
      case 1:
        return(Container(
            padding: EdgeInsets.only(left: 45 , right: 45 , top: 18 , bottom: 18),
            child: (ListView.builder(itemCount: STDInfoExp.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctxt, int index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(flex: 5,
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoExp[index]['OrgName'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ExpInfo[0],
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex : 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoExp[index]['Name'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ExpInfo[1],
                                ),
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
                            padding: EdgeInsets.only(left: 21,right: 21),
                            width: 250,
                            child: TextField(
                              enabled : false,
                              controller:
                              TextEditingController(text: STDInfoExp[index]['employment_type']['identifier'].toString()),
                              onChanged: (value) {
                              },
                              decoration:  InputDecoration(
                                labelText: ExpInfo[2],
                              ),
                            ),
                          ),
                        ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoExp[index]['DateFrom'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ExpInfo[3],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoExp[index]['DateTo'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ExpInfo[4],
                                ),
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
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoExp[index]['Supervisor_Name'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ExpInfo[5],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoExp[index]['Supervisor_Mobile'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ExpInfo[6],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoExp[index]['Supervisor_Email'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ExpInfo[7],
                                ),
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
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoExp[index]['Description'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ExpInfo[8],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(mainAxisAlignment : MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style:ElevatedButton.styleFrom(backgroundColor: CupertinoColors.systemRed),
                            onPressed: () async {
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("AlertDialog"),
                                  content: Text("Sure to delete record ?"),
                                  actions: [
                                    ElevatedButton(
                                      child: Text("Yes"),
                                      onPressed:  () async {
                                        studentInfoWS std = studentInfoWS();
                                        await std.deleteInfo(STDInfoExp[index]);
                                        var updateData = await std.getExpInfo();
                                        addExpInfo(updateData);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text("No"),
                                      onPressed:  () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });

                            }, child: Text('Delete'),

                          ),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              attachWS at = attachWS();
                              List<Uint8List>? attch =  await at.getAttachmentList(STDInfoExp[index]) ;
                              List type = await at.getAttchTypeList(STDInfoExp[index]);
                              showAttach(context, type[0], attch![0]);
                            },
                            style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                            child:Text('Attachment'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(thickness: 2, color: Colors.black54,),
                      SizedBox(height: 5,),
                    ],
                  );
                } ))));
      case 2:
        return(Container(
            padding: EdgeInsets.only(left: 45 , right: 45 , top: 18 , bottom: 18),
            child: (ListView.builder(itemCount: STDInfoPub.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoPub[index]['Name'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ResearchInfo[0],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoPub[index]['JournalName'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ResearchInfo[1],
                                ),
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
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoPub[index]['URL'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ResearchInfo[2],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 21,right: 21),
                              width: 250,
                              child: TextField(
                                enabled : false,
                                controller:
                                TextEditingController(text: STDInfoPub[index]['CalendarYear'].toString()),
                                onChanged: (value) {
                                },
                                decoration:  InputDecoration(
                                  labelText: ResearchInfo[3],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              attachWS at = attachWS();
                              Uint8List? attch = await at.getAttachment(STDInfoAca[index]);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => sdtInfoPdfPop(context , attch! ),);

                            },
                            style: ElevatedButton.styleFrom(primary: Color(0xFF7F7FD5)),
                            child:Text('Attached files of ${STDInfoPub[index]['JournalName']}'),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Divider(thickness: 2, color: Colors.black54,),
                      SizedBox(height: 5,),
                    ],
                  );
                } ))
        ));
      default :
        return Text('Empty');
    }
  }
  Widget sdtInfoPdfPop(BuildContext context  , Uint8List bytes ){
    return PdfDocumentLoader.openData(
      bytes,
      documentBuilder: (context, pdfDocument, pageCount) => Container(
        child: LayoutBuilder(
            builder: (context, constraints) => ListView.builder(
                itemCount: pageCount,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(12),
                    color: Colors.black12,
                    child: PdfPageView(
                      pdfDocument: pdfDocument,
                      pageNumber: index + 1,
                    )
                )
            )
        ),
      ),
    );
      // final _byteImage = Base64Decoder().convert(ApiConstants.base64);
      // Widget image = Image.memory(bytes,fit: BoxFit);
      // return Container(
      //   width: double.infinity,
      //   height: double.infinity,
      //   margin: EdgeInsets.all(36),
      //   padding: EdgeInsets.all(24),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       SizedBox(height: 22,),
      //       Row(mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           ElevatedButton(onPressed: (){
      //             Navigator.pop(context);
      //           }, child: Text('Close X')),
      //         ],
      //       ),
      //   Center(
      //       child: Container(
      //         child: ListView(
      //           shrinkWrap: true,
      //             physics: ClampingScrollPhysics(),
      //           children: [PdfDocumentLoader.openData(
      //             bytes,
      //             documentBuilder: (context, pdfDocument, pageCount) => LayoutBuilder(
      //                 builder: (context, constraints) => ListView.builder(
      //                     itemCount: pageCount,
      //                     physics: ClampingScrollPhysics(),
      //                     itemBuilder: (context, index) => Container(
      //                         margin: EdgeInsets.all(12),
      //                         padding: EdgeInsets.all(12),
      //                         color: Colors.black12,
      //                         child: PdfPageView(
      //                           pdfDocument: pdfDocument,
      //                           pageNumber: index + 1,
      //                         )
      //                     )
      //                 )
      //             ),
      //           )]),
      //         ),
      //       )
      //     ],
      //   ),);
  }
  Widget studentInfo(BuildContext context , int index ){
    return StatefulBuilder(
        builder:(BuildContext context ,  StateSetter setState){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children :[
              const SizedBox(height:6,),
              stdInfoSubBox(context ,index ),
            ]
          );
        }
    );
  }
  Widget locationDDTemp(BuildContext context , bool ac){
    if(DDCBPlocationTemp.isEmpty ){
      if(ac == false){
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height:12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width:15),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Temporary',
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
                  const SizedBox(height:8,)
                ],
              );}
        );
      }else{
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height:12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width:15),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Temporary',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Province',style: TextStyle(fontSize: 9, decoration: TextDecoration.none , color: CupertinoColors.systemGrey),),
                              DropdownButton<String>(
                                isExpanded: true,
                                hint: Text('Province : ',style: TextStyle(fontSize: 9, decoration: TextDecoration.none),),
                                items:province.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    enabled: ac,
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: selProvTem,
                                onChanged: (value) async {
                                  locationWS loc = locationWS();
                                  List<dynamic> tempDis = (await loc.getDistrict( provinceID[value]))!;
                                  List<dynamic> tempLocG = (await loc.getLocalGov(districtID[tempDis[0]['Name'].toString()]))!;
                                  setState(()  {
                                    selProvTem  = value!;
                                    localgovtem = [];
                                    districttem = [];
                                    for(var i = 0 ; i< tempDis.length ;i ++){
                                      if(!districttem.contains(tempDis[i]['Name'])){
                                        districttem.add(tempDis[i]['Name'].toString());
                                      }}
                                    for(var i = 0 ; i< tempLocG.length ;i ++){
                                      if(!localgovtem.contains(tempLocG[i]['Name'].toString())){
                                        localgovtem.add(tempLocG[i]['Name'].toString());}}
                                    selLocGovTem = localgovtem.first;
                                    selDisTem = districttem.first;
                                  });
                                  Map<dynamic,dynamic>data = {
                                    "Name": '$selLocGovTem-$selWardTem $selToleTem',
                                    "n_province_ID": {
                                      "propertyLabel": "Province",
                                      "id": provinceID[selProvTem],
                                      "identifier": selProvTem,
                                      "model-name": "n_province"
                                    },
                                    "n_district_ID": {
                                      "propertyLabel": "District",
                                      "id": districtID[selDisTem],
                                      "identifier": selDisTem,
                                      "model-name": "n_district"
                                    },
                                    "n_locgov_ID": {
                                      "propertyLabel": "Local Government",
                                      "id": localgovID[selLocGovTem],
                                      "identifier": selLocGovTem,
                                      "model-name": "n_locgov"
                                    },
                                    "ward_no": selWardTem,
                                    "tole_name": selToleTem,
                                    "model-name": "c_bpartner_location"
                                  };
                                  DDCBPlocationTemp = [];
                                  DDCBPlocationTemp.add(data);
                                  // print('Temp');
                                  // print(DDCBPlocationTemp);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 3,
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('District',style: TextStyle(fontSize: 9, decoration: TextDecoration.none, color: CupertinoColors.systemGrey),),
                                DropdownButton<String>(isExpanded: true,
                                  hint: Text('District : '),
                                  items:districttem.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      enabled: ac,
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: selDisTem,
                                  onChanged: (value) async {
                                    locationWS loc = locationWS();
                                    List<dynamic> tempLocG = (await loc.getLocalGov(districtID[value]))!;
                                    setState(()  {
                                      selDisTem = value!;
                                      localgovtem = [];
                                      for(var i = 0 ; i< tempLocG.length ;i ++){
                                        if(!localgovtem.contains(tempLocG[i]['Name'].toString())){
                                          localgovtem.add(tempLocG[i]['Name'].toString());}}
                                      selLocGovTem = localgovtem.first;
                                    });
                                    Map<dynamic,dynamic>data = {
                                      "Name": '$selLocGovTem-$selWardTem $selToleTem',
                                      "n_province_ID": {
                                        "propertyLabel": "Province",
                                        "id": provinceID[selProvTem],
                                        "identifier": selProvTem,
                                        "model-name": "n_province"
                                      },
                                      "n_district_ID": {
                                        "propertyLabel": "District",
                                        "id": districtID[selDisTem],
                                        "identifier": selDisTem,
                                        "model-name": "n_district"
                                      },
                                      "n_locgov_ID": {
                                        "propertyLabel": "Local Government",
                                        "id": localgovID[selLocGovTem],
                                        "identifier": selLocGovTem,
                                        "model-name": "n_locgov"
                                      },
                                      "ward_no": selWardTem,
                                      "tole_name": selToleTem,
                                      "model-name": "c_bpartner_location"
                                    };
                                    DDCBPlocationTemp = [];
                                    DDCBPlocationTemp.add(data);
                                  },
                                ),
                              ],
                            ),
                          )),
                      Expanded(flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Local Gov',style: TextStyle(fontSize: 9, decoration: TextDecoration.none, color: CupertinoColors.systemGrey),),
                              DropdownButton<String>(isExpanded: true,
                                hint: Text('Local Gov : '),
                                items:localgovtem.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    enabled: ac,
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: selLocGovTem,
                                onChanged: (value)  {
                                  DDCBPlocationTemp[0]['n_locgov_ID']['identifier'] = value;
                                  DDCBPlocationTemp[0]['n_locgov_ID']['id'] = localgovID[value];
                                  setState(()  {
                                    selLocGovTem = value!;
                                  });
                                  Map<dynamic,dynamic>data = {
                                    "Name": '$selLocGovTem-$selWardTem $selToleTem',
                                    "n_province_ID": {
                                      "propertyLabel": "Province",
                                      "id": provinceID[selProvTem],
                                      "identifier": selProvTem,
                                      "model-name": "n_province"
                                    },
                                    "n_district_ID": {
                                      "propertyLabel": "District",
                                      "id": districtID[selDisTem],
                                      "identifier": selDisTem,
                                      "model-name": "n_district"
                                    },
                                    "n_locgov_ID": {
                                      "propertyLabel": "Local Government",
                                      "id": localgovID[selLocGovTem],
                                      "identifier": selLocGovTem,
                                      "model-name": "n_locgov"
                                    },
                                    "ward_no": selWardTem,
                                    "tole_name": selToleTem,
                                    "model-name": "c_bpartner_location"
                                  };
                                  DDCBPlocationTemp = [];
                                  DDCBPlocationTemp.add(data);
                                  // print('Temp locgov');
                                  // print(DDCBPlocationTemp);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              enabled: ac,
                              controller:
                              TextEditingController(text: selWardTem),
                              onChanged: (value) {
                                selWardTem = value;
                                Map<dynamic,dynamic>data = {
                                  "Name": '$selLocGovTem-$selWardTem $selToleTem',
                                  "n_province_ID": {
                                    "propertyLabel": "Province",
                                    "id": provinceID[selProvTem],
                                    "identifier": selProvTem,
                                    "model-name": "n_province"
                                  },
                                  "n_district_ID": {
                                    "propertyLabel": "District",
                                    "id": districtID[selDisTem],
                                    "identifier": selDisTem,
                                    "model-name": "n_district"
                                  },
                                  "n_locgov_ID": {
                                    "propertyLabel": "Local Government",
                                    "id": localgovID[selLocGovTem],
                                    "identifier": selLocGovTem,
                                    "model-name": "n_locgov"
                                  },
                                  "ward_no": selWardTem,
                                  "tole_name": selToleTem,
                                  "model-name": "c_bpartner_location"
                                };
                                DDCBPlocationTemp = [];
                                DDCBPlocationTemp.add(data);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Ward',
                                suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                              ),
                            ),
                          )),
                      Expanded(flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              enabled: ac,
                              controller:
                              TextEditingController(text: selToleTem),
                              onChanged: (value) {
                                selToleTem = value;
                                Map<dynamic,dynamic>data = {
                                  "Name": '$selLocGovTem-$selWardTem $selToleTem',
                                  "n_province_ID": {
                                    "propertyLabel": "Province",
                                    "id": provinceID[selProvTem],
                                    "identifier": selProvTem,
                                    "model-name": "n_province"
                                  },
                                  "n_district_ID": {
                                    "propertyLabel": "District",
                                    "id": districtID[selDisTem],
                                    "identifier": selDisTem,
                                    "model-name": "n_district"
                                  },
                                  "n_locgov_ID": {
                                    "propertyLabel": "Local Government",
                                    "id": localgovID[selLocGovTem],
                                    "identifier": selLocGovTem,
                                    "model-name": "n_locgov"
                                  },
                                  "ward_no": selWardTem,
                                  "tole_name": selToleTem,
                                  "model-name": "c_bpartner_location"
                                };
                                DDCBPlocationTemp = [];
                                DDCBPlocationTemp.add(data);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Tole',
                                suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height:8,)
                ],
              );}
        );
      }
    }else{
      return StatefulBuilder(
          builder:(BuildContext context, StateSetter setState){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height:12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width:15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Temporary',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Province',style: TextStyle(fontSize: 9, decoration: TextDecoration.none , color: CupertinoColors.systemGrey),),
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: Text('Province : ',style: TextStyle(fontSize: 9, decoration: TextDecoration.none),),
                              items:province.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  enabled: ac,
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: selProvTem,
                              onChanged: (value) async {
                                locationWS loc = locationWS();
                                List<dynamic> tempDis = (await loc.getDistrict( provinceID[value]))!;
                                List<dynamic> tempLocG = (await loc.getLocalGov(districtID[tempDis[0]['Name'].toString()]))!;
                                DDCBPlocationTemp[0]['n_province_ID']['identifier'] = value;
                                DDCBPlocationTemp[0]['n_province_ID']['id'] = provinceID[value];
                                setState(()  {
                                  selProvTem  = value!;
                                  localgovtem = [];
                                  districttem = [];
                                  for(var i = 0 ; i< tempDis.length ;i ++){
                                    if(!districttem.contains(tempDis[i]['Name'])){
                                      districttem.add(tempDis[i]['Name'].toString());
                                    }}
                                  for(var i = 0 ; i< tempLocG.length ;i ++){
                                    if(!localgovtem.contains(tempLocG[i]['Name'].toString())){
                                      localgovtem.add(tempLocG[i]['Name'].toString());}}
                                  selLocGovTem = localgovtem.first;
                                  selDisTem = districttem.first;
                                  DDCBPlocationTemp[0]['n_district_ID']['identifier'] = selDisTem;
                                  DDCBPlocationTemp[0]['n_district_ID']['id'] = districtID[selDisTem];
                                  DDCBPlocationTemp[0]['n_locgov_ID']['identifier'] = selLocGovTem;
                                  DDCBPlocationTemp[0]['n_locgov_ID']['id'] = localgovID[selLocGovTem];
                                });
                                // print('Temp');
                                // print(DDCBPlocationTemp);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 3,
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('District',style: TextStyle(fontSize: 9, decoration: TextDecoration.none, color: CupertinoColors.systemGrey),),
                              DropdownButton<String>(isExpanded: true,
                                hint: Text('District : '),
                                items:districttem.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    enabled: ac,
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: selDisTem,
                                onChanged: (value) async {
                                  locationWS loc = locationWS();
                                  List<dynamic> tempLocG = (await loc.getLocalGov(districtID[value]))!;
                                  DDCBPlocationTemp[0]['n_district_ID']['identifier'] = value;
                                  DDCBPlocationTemp[0]['n_district_ID']['id'] = districtID[value];
                                  setState(()  {
                                    selDisTem = value!;
                                    localgovtem = [];
                                    for(var i = 0 ; i< tempLocG.length ;i ++){
                                      if(!localgovtem.contains(tempLocG[i]['Name'].toString())){
                                        localgovtem.add(tempLocG[i]['Name'].toString());}}
                                    selLocGovTem = localgovtem.first;
                                    DDCBPlocationTemp[0]['n_locgov_ID']['identifier'] = selLocGovTem;
                                    DDCBPlocationTemp[0]['n_locgov_ID']['id'] = localgovID[selLocGovTem];
                                  });
                                },
                              ),
                            ],
                          ),
                        )),
                    Expanded(flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Local Gov',style: TextStyle(fontSize: 9, decoration: TextDecoration.none, color: CupertinoColors.systemGrey),),
                            DropdownButton<String>(isExpanded: true,
                              hint: Text('Local Gov : '),
                              items:localgovtem.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  enabled: ac,
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: selLocGovTem,
                              onChanged: (value)  {
                                DDCBPlocationTemp[0]['n_locgov_ID']['identifier'] = value;
                                DDCBPlocationTemp[0]['n_locgov_ID']['id'] = localgovID[value];
                                setState(()  {
                                  selLocGovTem = value!;
                                });
                                // print('Temp locgov');
                                // print(DDCBPlocationTemp);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: ac,
                            controller:
                            TextEditingController(text: selWardTem),
                            onChanged: (value) {
                              DDCBPlocationTemp[0]['ward_no'] =  value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Ward',
                              suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                            ),
                          ),
                        )),
                    Expanded(flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: ac,
                            controller:
                            TextEditingController(text: selToleTem),
                            onChanged: (value) {
                              DDCBPlocationTemp[0]['tole_name'] = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Tole',
                              suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height:8,)
              ],
            );}
      );
    }

  }
  Widget locationDDPerm(BuildContext context , bool ac){
    if(DDCBPlocation.isEmpty){
      if(ac == false){
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                  const SizedBox(height:8,)
                ],
              );}
        );
      }
      else{
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height:6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width:15),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Permanent',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Province',style: TextStyle(fontSize: 9, decoration: TextDecoration.none , color: CupertinoColors.systemGrey),),
                              DropdownButton<String>(
                                isExpanded: true,
                                hint: Text('Province : ',style: TextStyle(fontSize: 9, decoration: TextDecoration.none),),
                                items:province.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    enabled: ac,
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: selProv,
                                onChanged: (value) async {
                                  locationWS loc = locationWS();
                                  List<dynamic> tempDis = (await loc.getDistrict( provinceID[value]))!;
                                  List<dynamic> tempLocG = (await loc.getLocalGov(districtID[tempDis[0]['Name'].toString()]))!;
                                  setState(()  {
                                    selProv  = value!;
                                    localgov = [];
                                    district = [];
                                    for(var i = 0 ; i< tempDis.length ;i ++){
                                      if(!district.contains(tempDis[i]['Name'])){
                                        district.add(tempDis[i]['Name'].toString());
                                      }}
                                    for(var i = 0 ; i< tempLocG.length ;i ++){
                                      if(!localgov.contains(tempLocG[i]['Name'].toString())){
                                        localgov.add(tempLocG[i]['Name'].toString());}}
                                    selLocGov = localgov.first;
                                    selDis = district.first;
                                  });
                                  Map<dynamic,dynamic>data = {
                                    "Name": '$selLocGov-$selWard $selTole',
                                    "n_province_ID": {
                                      "propertyLabel": "Province",
                                      "id": provinceID[value],
                                      "identifier": value,
                                      "model-name": "n_province"
                                    },
                                    "n_district_ID": {
                                      "propertyLabel": "District",
                                      "id": districtID[selDis],
                                      "identifier": selDis,
                                      "model-name": "n_district"
                                    },
                                    "n_locgov_ID": {
                                      "propertyLabel": "Local Government",
                                      "id": localgovID[selLocGov],
                                      "identifier": selLocGov,
                                      "model-name": "n_locgov"
                                    },
                                    "ward_no": selWard,
                                    "tole_name": selTole,
                                    "model-name": "c_bpartner_location"
                                  };
                                  DDCBPlocation = [];
                                  DDCBPlocation.add(data);
                                  // print('permannent');
                                  // print(DDCBPlocation);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 3,
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text('District',style: TextStyle(fontSize: 9, decoration: TextDecoration.none, color: CupertinoColors.systemGrey),),
                                DropdownButton<String>(isExpanded: true,
                                  hint: Text('District : '),
                                  items:district.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      enabled: ac,
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: selDis,
                                  onChanged: (value) async {
                                    locationWS loc = locationWS();
                                    List<dynamic> tempLocG = (await loc.getLocalGov(districtID[value]))!;
                                    setState(()  {
                                      selDis = value!;
                                      localgov = [];
                                      for(var i = 0 ; i< tempLocG.length ;i ++){
                                        if(!localgov.contains(tempLocG[i]['Name'].toString())){
                                          localgov.add(tempLocG[i]['Name'].toString());}}
                                      selLocGov = localgov.first;

                                    });
                                    Map<dynamic,dynamic>data = {
                                      "Name": '$selLocGov-$selWard $selTole',
                                      "n_province_ID": {
                                        "propertyLabel": "Province",
                                        "id": provinceID[selProv],
                                        "identifier": selProv,
                                        "model-name": "n_province"
                                      },
                                      "n_district_ID": {
                                        "propertyLabel": "District",
                                        "id": districtID[selDis],
                                        "identifier": selDis,
                                        "model-name": "n_district"
                                      },
                                      "n_locgov_ID": {
                                        "propertyLabel": "Local Government",
                                        "id": localgovID[selLocGov],
                                        "identifier": selLocGov,
                                        "model-name": "n_locgov"
                                      },
                                      "ward_no": selWard,
                                      "tole_name": selTole,
                                      "model-name": "c_bpartner_location"
                                    };
                                    DDCBPlocation = [];
                                    DDCBPlocation.add(data);
                                  },
                                ),
                              ],
                            ),
                          )),
                      Expanded(flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Local Gov',style: TextStyle(fontSize: 9, decoration: TextDecoration.none, color: CupertinoColors.systemGrey),),
                              DropdownButton<String>(isExpanded: true,
                                hint: Text('Local Gov : '),
                                items:localgov.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    enabled: ac,
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: selLocGov,
                                onChanged: (value)  {
                                  setState(()  {
                                    selLocGov = value!;
                                  });
                                  Map<dynamic,dynamic>data = {
                                    "Name": '$selLocGov-$selWard $selTole',
                                    "n_province_ID": {
                                      "propertyLabel": "Province",
                                      "id": provinceID[selProv],
                                      "identifier": selProv,
                                      "model-name": "n_province"
                                    },
                                    "n_district_ID": {
                                      "propertyLabel": "District",
                                      "id": districtID[selDis],
                                      "identifier": selDis,
                                      "model-name": "n_district"
                                    },
                                    "n_locgov_ID": {
                                      "propertyLabel": "Local Government",
                                      "id": localgovID[selLocGov],
                                      "identifier": selLocGov,
                                      "model-name": "n_locgov"
                                    },
                                    "ward_no": selWard,
                                    "tole_name": selTole,
                                    "model-name": "c_bpartner_location"
                                  };
                                  DDCBPlocation = [];
                                  DDCBPlocation.add(data);
                                  // print('permannent locgov');
                                  // print(DDCBPlocation);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              enabled: ac,
                              controller:
                              TextEditingController(text: selWard),
                              onChanged: (value) {
                                selWard = value;
                                Map<dynamic,dynamic>data = {
                                  "Name": '$selLocGov-$selWard $selTole',
                                  "n_province_ID": {
                                    "propertyLabel": "Province",
                                    "id": provinceID[selProv],
                                    "identifier": selProv,
                                    "model-name": "n_province"
                                  },
                                  "n_district_ID": {
                                    "propertyLabel": "District",
                                    "id": districtID[selDis],
                                    "identifier": selDis,
                                    "model-name": "n_district"
                                  },
                                  "n_locgov_ID": {
                                    "propertyLabel": "Local Government",
                                    "id": localgovID[selLocGov],
                                    "identifier": selLocGov,
                                    "model-name": "n_locgov"
                                  },
                                  "ward_no": selWard,
                                  "tole_name": selTole,
                                  "model-name": "c_bpartner_location"
                                };
                                DDCBPlocation = [];
                                DDCBPlocation.add(data);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Ward',
                                suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                              ),
                            ),
                          )),
                      Expanded(flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              enabled: ac,
                              controller:
                              TextEditingController(text: selTole),
                              onChanged: (value) {
                                selTole = value;
                                Map<dynamic,dynamic>data = {
                                  "Name": '$selLocGov-$selWard $selTole',
                                  "n_province_ID": {
                                    "propertyLabel": "Province",
                                    "id": provinceID[selProv],
                                    "identifier": selProv,
                                    "model-name": "n_province"
                                  },
                                  "n_district_ID": {
                                    "propertyLabel": "District",
                                    "id": districtID[selDis],
                                    "identifier": selDis,
                                    "model-name": "n_district"
                                  },
                                  "n_locgov_ID": {
                                    "propertyLabel": "Local Government",
                                    "id": localgovID[selLocGov],
                                    "identifier": selLocGov,
                                    "model-name": "n_locgov"
                                  },
                                  "ward_no": selWard,
                                  "tole_name": selTole,
                                  "model-name": "c_bpartner_location"
                                };
                                DDCBPlocation = [];
                                DDCBPlocation.add(data);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Tole',
                                suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              );}
        );
      }
    }else{
      return StatefulBuilder(
          builder:(BuildContext context, StateSetter setState){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height:6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width:15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Permanent',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Province',style: TextStyle(fontSize: 9, decoration: TextDecoration.none , color: CupertinoColors.systemGrey),),
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: Text('Province : ',style: TextStyle(fontSize: 9, decoration: TextDecoration.none),),
                              items:province.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  enabled: ac,
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: selProv,
                              onChanged: (value) async {
                                locationWS loc = locationWS();
                                List<dynamic> tempDis = (await loc.getDistrict( provinceID[value]))!;
                                List<dynamic> tempLocG = (await loc.getLocalGov(districtID[tempDis[0]['Name'].toString()]))!;
                                DDCBPlocation[0]['n_province_ID']['identifier'] = value;
                                DDCBPlocation[0]['n_province_ID']['id'] = provinceID[value];
                                setState(()  {
                                  selProv  = value!;
                                  localgov = [];
                                  district = [];
                                  for(var i = 0 ; i< tempDis.length ;i ++){
                                    if(!district.contains(tempDis[i]['Name'])){
                                      district.add(tempDis[i]['Name'].toString());
                                    }}
                                  for(var i = 0 ; i< tempLocG.length ;i ++){
                                    if(!localgov.contains(tempLocG[i]['Name'].toString())){
                                      localgov.add(tempLocG[i]['Name'].toString());}}
                                  selLocGov = localgov.first;
                                  selDis = district.first;
                                  DDCBPlocation[0]['n_district_ID']['identifier'] = selDis;
                                  DDCBPlocation[0]['n_district_ID']['id'] = districtID[selDis];
                                  DDCBPlocation[0]['n_locgov_ID']['identifier'] = selLocGov;
                                  DDCBPlocation[0]['n_locgov_ID']['id'] = localgovID[selLocGov];
                                });
                                // print('permannent');
                                // print(DDCBPlocation);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 3,
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('District',style: TextStyle(fontSize: 9, decoration: TextDecoration.none, color: CupertinoColors.systemGrey),),
                              DropdownButton<String>(isExpanded: true,
                                hint: Text('District : '),
                                items:district.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    enabled: ac,
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: selDis,
                                onChanged: (value) async {
                                  locationWS loc = locationWS();
                                  List<dynamic> tempLocG = (await loc.getLocalGov(districtID[value]))!;
                                  DDCBPlocation[0]['n_district_ID']['identifier'] = value;
                                  DDCBPlocation[0]['n_district_ID']['id'] = districtID[value];
                                  setState(()  {
                                    selDis = value!;
                                    localgov = [];
                                    for(var i = 0 ; i< tempLocG.length ;i ++){
                                      if(!localgov.contains(tempLocG[i]['Name'].toString())){
                                        localgov.add(tempLocG[i]['Name'].toString());}}
                                    selLocGov = localgov.first;
                                    DDCBPlocation[0]['n_locgov_ID']['identifier'] = selLocGov;
                                    DDCBPlocation[0]['n_locgov_ID']['id'] = localgovID[selLocGov];
                                  });
                                },
                              ),
                            ],
                          ),
                        )),
                    Expanded(flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('Local Gov',style: TextStyle(fontSize: 9, decoration: TextDecoration.none, color: CupertinoColors.systemGrey),),
                            DropdownButton<String>(isExpanded: true,
                              hint: Text('Local Gov : '),
                              items:localgov.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  enabled: ac,
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: selLocGov,
                              onChanged: (value)  {
                                DDCBPlocation[0]['n_locgov_ID']['identifier'] = value;
                                DDCBPlocation[0]['n_locgov_ID']['id'] = localgovID[value];
                                setState(()  {
                                  selLocGov = value!;
                                });
                                // print('permannent locgov');
                                // print(DDCBPlocation);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: ac,
                            controller:
                            TextEditingController(text: selWard),
                            onChanged: (value) {
                              DDCBPlocation[0]['ward_no'] = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Ward',
                              suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                            ),
                          ),
                        )),
                    Expanded(flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: ac,
                            controller:
                            TextEditingController(text: selTole),
                            onChanged: (value) {
                              DDCBPlocation[0]['tole_name'] = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Tole',
                              suffixIcon: Icon(Icons.my_location_rounded, size: 25,),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            );}
      );
    }
  }
  Widget ImageView(BuildContext context , Uint8List bytes ){
    // final _byteImage = Base64Decoder().convert(ApiConstants.base64);
    // Widget image = Image.memory(bytes,fit: BoxFit);
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(36),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 22,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Close X')),
              ],
            ),
            SizedBox(height: 22,),
            // Padding(padding: EdgeInsets.all(18) , child: Text(fileNAme),),
            SizedBox(height: 750,
            width: 600 ,child: Image.memory(bytes,fit: BoxFit.contain,)),
            SizedBox(height: 22,),
          ],
        ),],
      ),);
  }

  Widget CheckBoxOptCom(BuildContext context , String type, int sInd , int fInd , int fee , setFee){
    if(type == 'Compulsary'){
    return Checkbox(value: true, onChanged: null);}
    else {
      return StatefulBuilder(
          builder: (context,setState) => Checkbox(value: check,
          onChanged:(bool? value){
        setState(() {
          check = value!;
          if(value){
          fee = fee + (CourseOpenInfoDetailed[fInd][sInd]['RATE_PER_CREDIT_HOUR'] as int);}
          else{
            fee = fee - (CourseOpenInfoDetailed[fInd][sInd]['RATE_PER_CREDIT_HOUR'] as int);}
          setFee(fee);
          this.setState(() {
          });
        });
          // if(value == false){
          //   super.setState(() {
          //     fee = fee - (CourseOpenInfoDetailed[fInd][sInd]['RATE_PER_CREDIT_HOUR'] as int);
          //     this.check = value!;
          //   });
          // }
          // else{
          //   super.setState(() {
          //     fee = fee + (CourseOpenInfoDetailed[fInd][sInd]['RATE_PER_CREDIT_HOUR'] as int);
          //     this.check = value!;
          //   });
          // }
        })
      );
    }
  }
  Widget applyORapplied(String id , int index , int flex , int sel,[BuildContext? ctx]){
    String btnname = '';
    if(sel == 0 && sel == 1){
      btnname = 'Register';
    }
    else if(sel == 8 || sel == 7 || sel == 4 || sel == 3 || sel == 10) {
      btnname = 'View';
    }
    else{
      btnname = 'Apply';
    }
    if(idOfRegCourse.contains(id) && sel == 0){
      return ContCustomColor(100, 40, 'Registered', Colors.white,Color(0xFF5F5FA7),flex);
    }
    else if(nouRegList[0]['C_BPartner_ID']['id'] == bPartData[0]['id'] && sel == 9){
      return ContCustomColor(100, 40, 'Applied', Colors.white,Color(0xFF5F5FA7),flex);
    }
    else if(idOfScholarshipApp.contains(id) && sel == 2){
      return ContCustomColor(100, 40, 'Applied', Colors.white,Color(0xFF5F5FA7),flex);
    }
    else if(sel == 6 && idOfEntApp.contains(id)){
      return ContCustomColor(100, 40, 'Applied', Colors.white,Color(0xFF5F5FA7),flex);
    }
    else if(sel == 5 && idOfAdmissionCourse.contains(id)){
      return ContCustomColor(100, 40, 'Registered', Colors.white,Color(0xFF5F5FA7),flex);
    }
    else if(sel == 10 && !(id == 'Voucher')){
      return ContCustom(100, 40,'---', Colors.black,flex);
    }
    else{
      return Expanded(
        flex: flex,
        key: UniqueKey(),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ElevatedButton(
            child:Text(btnname),
            onPressed: () async {
              switch(sel){
                case 0 :
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>courseRegPop(context , index) ,);
                  break;
                case 1 :
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => examPop(context , index) ,);
                  break;
                case 4 :
                  await getAppScholarFromOpenId(ScholarAppInfo[index]['n_scholarship_open_ID']['id']);
                  showDialog(
                  context: context,
                  builder: (BuildContext context) => scholarshipAppPop(context , index) ,);
                  break;
                case 2:
                  // await getAppScholarFromOpenId(scholarshipOpen[index]['id']);
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) => scholarshipAppPop(context , index) ,);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => scholarshipPop(context , index) ,);
                  break;
                case 7:
                  CourseRegInfo ci = CourseRegInfo();
                  creditHour = await ci.getCreditHour(examAppDet[index]);
                  print(creditHour);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ExamAppPop(context , index) ,);
                  break;
                case 6:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => entrancePop(context , index) ,);
                  break;
                case 3:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => admissionAppPop(context , index) ,);
                  break;
                case 5:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => admissionOpenPop(context , index) ,);
                  break;
                case 8:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => courseAppPop(context , index) ,);
                  break;
                case 9:
                  print('isStudent \n ${bPartData[0]['isStudent']}\n');
                  if(bPartData[0]['isStudent'] == true){
                    await nouRegWS.nouRegis(dataRegCourseInfo[0]);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>  secondStepPay(context, 500, 3),);
                  }
                  else{
                    showSnackwithCtx(ctx!, 'You have to be student to Register !!', Colors.red);
                  }
                  break;
                case 10:
                  attachWS ats = attachWS();
                  // int tid = paymentDatas[index]['id'];
                  // int aid = paymentDatas[index]['AD_Attachment_ID'];
                  Uint8List? byte = await ats.getAttachment(paymentDatas[index]);
                  String? type = await ats.AttchType(paymentDatas[index]);
                  // List attach = await ats.getAttachFromId(aid);
                  if(type == 'application/pdf'){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => sdtInfoPdfPop(context , byte! ),);
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ImageView(context , byte! ),);}
              }
            },
            style: ElevatedButton.styleFrom(primary:Colors.blueAccent.withOpacity(.66), fixedSize: const Size(96, 37) ),
          ),
        ),
      );
    }
  }
  int selectedValue = 0;

  ///Course
  Widget CourseOpen(){
    return Container(
    height: double.infinity,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: ListView(
      children: [Column(
        children: [
          const SizedBox(height: 32,),
          Padding(
            padding: const EdgeInsets.only(left: 33, right: 33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContCustomColor(100, 40, 'Year', Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(120, 40, 'Intake',  Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(200, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),6),
                ContCustomColor(200, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),6),
                ContCustomColor(200, 40, 'Subject',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(200, 40, 'Upto Date',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(200, 40, 'Sem',  Colors.white,Color(0xFF5F5FA7),2),
                Expanded(
                  flex: 3,
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
          ListView.builder(
              shrinkWrap: true,
              key: UniqueKey(),
              itemCount: CourseOpenInfo.length,
              itemBuilder:(BuildContext ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustom(100, 40, CourseOpenInfo[index]['n_aca_year_ID']['identifier'], Colors.black,2),
                      ContCustom(120, 40, CourseOpenInfo[index]['n_intake_ID']['identifier'], Colors.black,2),
                      ContCustom(200, 40, CourseOpenInfo[index]['n_faculty_ID']['identifier'].toString().substring(11), Colors.black,6),
                      ContCustom(200, 40, CourseOpenInfo[index]['n_program_ID']['identifier'], Colors.black,6),
                      ContCustom(200, 40, CourseOpenInfo[index]['n_subject_ID']['identifier'], Colors.black,4),
                      ContCustom(200, 40, CourseOpenInfo[index]['DateTo'], Colors.black,4),
                      ContCustom(200, 40, CourseOpenInfo[index]['n_sem_year_ID']['identifier'], Colors.black,2),
                      applyORapplied(CourseOpenInfo[index]['id'].toString(), index , 3 , 0),
                    ],
                  ),
                );
              } ),
          SizedBox(height: 21,),

        ],
      )],
    ),
  );}
  Widget courseRegPop( BuildContext context ,int ind ){
    void setFee(int Fee){
      setState(() {
        print("inside setstate");
        print(fee);
        this.fee = Fee;
        print(fee);
      });
    }
    if(fee == 0) {
      for (var i = 0; i < CourseOpenInfoDetailed[ind].length; i++) {
        fee =
        (fee + CourseOpenInfoDetailed[ind][i]['RATE_PER_CREDIT_HOUR']) as int;
      }
    }
    int? totalFee = CourseOpenInfo[ind]['practicalfee']+CourseOpenInfo[ind]['admissionfee']+CourseOpenInfo[ind]['libraryfee']+fee;
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
                  itemCount: CourseOpenInfoDetailed[ind].length,
                  itemBuilder:(BuildContext ctx, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CheckBoxOptCom(context,CourseOpenInfoDetailed[ind][index]['course_type']['identifier'].toString() , index , ind , fee , setFee),
                        ContCustom(
                            80, 40, (index+1).toString(),
                            Colors.black,2),
                        ContCustom(
                            240, 40, CourseOpenInfoDetailed[ind][index]['Name'].toString(),
                            Colors.black,10),
                        ContCustom(
                            120, 40, CourseOpenInfoDetailed[ind][index]['course_type']['identifier'].toString(),
                            Colors.black,7),
                        ContCustom(
                            100, 40, CourseOpenInfoDetailed[ind][index]['CREDIT_HOUR'].toString(),
                            Colors.black,3),
                        ContCustom(
                            140, 40, CourseOpenInfoDetailed[ind][index]['RATE_PER_CREDIT_HOUR'].toString(),
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
                        ContCustomColor(100, 40, CourseOpenInfo[ind]['libraryfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Admission Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, CourseOpenInfo[ind]['admissionfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Practical Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, CourseOpenInfo[ind]['practicalfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Divider(thickness: 4,),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Total Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, 'Rs - $totalFee.00', Colors.black,Colors.white),
                      ],
                    ),
                  ],),
                ],),
              SizedBox(height: 6,),
              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Click Below for Payment and Registration',style: TextStyle(
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
                          // creg.postCourseEnrollandReg(CourseOpenInfo);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => secondStepPay(context , totalFee , 0 ),);
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
  Widget CourseApp(){
    return Container(
    height: double.infinity,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: ListView(
      children: [Column(
        children: [
          const SizedBox(height: 32,),
          Padding(
            padding: const EdgeInsets.only(left: 33, right: 33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContCustomColor(100, 40, 'Year', Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(120, 40, 'Intake',  Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(200, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),6),
                ContCustomColor(200, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),6),
                ContCustomColor(200, 40, 'Subject',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(200, 40, 'Date',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(200, 40, 'Type',  Colors.white,Color(0xFF5F5FA7),3),
                ContCustomColor(200, 40, 'Sem',  Colors.white,Color(0xFF5F5FA7),2),
                Expanded(
                  flex: 3,
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
          ListView.builder(
              shrinkWrap: true,
              key: UniqueKey(),
              itemCount: CourseRegApp.length,
              itemBuilder:(BuildContext ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustom(100, 40, CourseRegApp[index]['n_aca_year_ID']['identifier'], Colors.black,2),
                      ContCustom(120, 40, CourseRegApp[index]['n_intake_ID']['identifier'], Colors.black,2),
                      ContCustom(200, 40, CourseRegApp[index]['n_faculty_ID']['identifier'].toString().substring(11), Colors.black,6),
                      ContCustom(200, 40, CourseRegApp[index]['n_program_ID']['identifier'], Colors.black,6),
                      ContCustom(200, 40, CourseRegApp[index]['n_subject_ID']['identifier'], Colors.black,4),
                      ContCustom(200, 40, CourseRegApp[index]['Created'].toString().substring(0,10), Colors.black,4),
                      ContCustom(200, 40, CourseRegApp[index]['regtype']['identifier'], Colors.black,3),
                      ContCustom(200, 40, CourseRegApp[index]['n_sem_year_ID']['identifier'], Colors.black,2),
                      applyORapplied(CourseRegApp[index]['id'].toString(), index , 3 , 8),
                    ],
                  ),
                );
              } ),
          SizedBox(height: 21,),

        ],
      ),
      ],),
  );}
  Widget courseAppPop( BuildContext context ,int ind ){
    int feeInc = CourseRegApp[ind]['semyearfee']+CourseRegApp[ind]['library_fee']+CourseRegApp[ind]['admissionfee']+CourseRegApp[ind]['pracfee'];
    int feePaid = CourseRegApp[ind]['semyearfee_paid'];
    int rem = feeInc - feePaid;
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
              Padding(
                padding: const EdgeInsets.only(top : 9,left: 33, right: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContCustomColor(50, 40, 'SN.', Colors.white,Color(0xFF5F5FA7),2),
                    ContCustomColor(240, 40, 'Name of Course',  Colors.white,Color(0xFF5F5FA7),10),
                    ContCustomColor(120, 40, 'Type',  Colors.white,Color(0xFF5F5FA7),7),
                    ContCustomColor(100, 40, 'Credit',  Colors.white,Color(0xFF5F5FA7),3),
                    ContCustomColor(140, 40, 'Total Fees(NRs)',  Colors.white,Color(0xFF5F5FA7),5),
                  ],
                ),
              ),
              SizedBox(height: 6,),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: CourseRegAppDet[ind].length,
                  itemBuilder:(BuildContext ctx, int index) {
                    return Padding(
                      padding: const  EdgeInsets.only(left: 33, right: 33),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ContCustom(
                              80, 40, (index+1).toString(),
                              Colors.black,2),
                          ContCustom(
                              240, 40, CourseRegAppDet[ind][index]['Name'].toString(),
                              Colors.black,10),
                          ContCustom(
                              120, 40, CourseRegAppDet[ind][index]['course_type']['identifier'].toString(),
                              Colors.black,7),
                          ContCustom(
                              100, 40, CourseRegAppDet[ind][index]['CREDIT_HOUR'].toString(),
                              Colors.black,3),
                          ContCustom(
                              140, 40, CourseRegAppDet[ind][index]['RATE_PER_CREDIT_HOUR'].toString(),
                              Colors.black,5),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 9,),
              Padding(
                padding: const EdgeInsets.only(right: 24,left: 24),
                child:Divider(thickness: 4,),
              ),
              SizedBox(height: 6,),
              ListView(padding: EdgeInsets.only(right: 24,left: 24),
                shrinkWrap: true,
                children: [Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Tuition Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, CourseRegApp[ind]['semyearfee'].toString(), Colors.black,Colors.grey.withOpacity(.33)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Library Fee',Colors.black,Colors.white),
                        ContCustomColor(100, 40, CourseRegApp[ind]['library_fee'].toString(),  Colors.black,Colors.grey.withOpacity(.33)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Admission Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, CourseRegApp[ind]['admissionfee'].toString(), Colors.black,Colors.grey.withOpacity(.33)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Practical Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, CourseRegApp[ind]['pracfee'].toString(),  Colors.black,Colors.grey.withOpacity(.33)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Total Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, 'Rs - $feeInc.00',  Colors.black,Colors.grey.withOpacity(.33)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Total Paid', Colors.black,Colors.white),
                        ContCustomColor(100, 40, 'Rs - $feePaid.00', Colors.black,Colors.grey.withOpacity(.33)),
                      ],
                    ),
                    Divider(thickness: 4,),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Remaining', Colors.black,Colors.white),
                        ContCustomColor(100, 40, 'Rs - $rem.00',  Colors.white,Color(0xFF5F5FA7)),
                      ],
                    ),
                  ],),
                ],),
              SizedBox(height: 6,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: rem ==0 ? Text(''): ElevatedButton(
                      child:Text('Make payment'),
                      onPressed: () {
                        // CourseRegInfo creg = CourseRegInfo();
                        // creg.postCourseEnrollandReg(CourseOpenInfo);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => secondStepPay(context , rem , 0 ),);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.81)),
                    ),
                  ),
                  SizedBox(width : 12),
                  ElevatedButton(
                    child:Text('Back'),
                    onPressed: () {
                      // CourseRegInfo creg = CourseRegInfo();
                      // creg.postCourseEnrollandReg(dataEntInfoApp);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.72)),
                  ),
                ],
              ),              // Row(mainAxisAlignment: MainAxisAlignment.center,
              //   children: [Text('FEE STRUCTURE:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)],),
              // SizedBox(height: 12,),
              // ListView(padding: EdgeInsets.only(right: 24,left: 24),
              //   shrinkWrap: true,
              //   children: [Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Row(
              //         children: [
              //           ContCustomColor(100, 40, 'Tuition Fee', Colors.black,Colors.white),
              //           ContCustomColor(100, 40, fee.toString(), Colors.white,Colors.black.withOpacity(.77)),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           ContCustomColor(100, 40, 'Library Fee',Colors.black,Colors.white),
              //           ContCustomColor(100, 40, CourseOpenInfo[ind]['libraryfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           ContCustomColor(100, 40, 'Admission Fee', Colors.black,Colors.white),
              //           ContCustomColor(100, 40, CourseOpenInfo[ind]['admissionfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           ContCustomColor(100, 40, 'Practical Fee', Colors.black,Colors.white),
              //           ContCustomColor(100, 40, CourseOpenInfo[ind]['practicalfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
              //         ],
              //       ),
              //       Divider(thickness: 4,),
              //       Row(
              //         children: [
              //           ContCustomColor(100, 40, 'Total Fee', Colors.black,Colors.white),
              //           ContCustomColor(100, 40, 'Rs - $totalFee.00', Colors.black,Colors.white),
              //         ],
              //       ),
              //     ],),
              //   ],),
              // SizedBox(height: 6,),
              // Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Text('Click Below for Payment and Registration',style: TextStyle(
              //       fontSize: 15,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xFF5F5FA7).withOpacity(.87),
              //     ),),
              //     SizedBox(height: 8,),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         ElevatedButton(
              //           child:Text('Make payment'),
              //           onPressed: () {
              //             // CourseRegInfo creg = CourseRegInfo();
              //             // creg.postCourseEnrollandReg(CourseOpenInfo);
              //             showDialog(
              //               context: context,
              //               builder: (BuildContext context) => secondStepPay(context , totalFee , 0 ),);
              //           },
              //           style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.81)),
              //         ),
              //         SizedBox(width: 15,),
              //         ElevatedButton(
              //           child:Text('Back'),
              //           onPressed: () {
              //             // CourseRegInfo creg = CourseRegInfo();
              //             // creg.postCourseEnrollandReg(dataEntInfoApp);
              //             Navigator.pop(context);
              //           },
              //           style: ElevatedButton.styleFrom(primary: Colors.black.withOpacity(.72)),
              //         ),
              //       ],
              //     ),
              //
              //   ],),
            ],
          ),],
        ),),
    );

  }

  ///Admission
  Widget AdmissionOpen(){
    return Container(
    height: double.infinity,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: ListView(
      children: [Column(
        children: [
          const SizedBox(height: 32,),
          Padding(
            padding: const EdgeInsets.only(left: 33, right: 33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContCustomColor(100, 40, 'Year', Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(120, 40, 'Intake',  Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(200, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),6),
                ContCustomColor(200, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),6),
                ContCustomColor(200, 40, 'Subject',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(200, 40, 'Upto Date',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(200, 40, 'Sem',  Colors.white,Color(0xFF5F5FA7),2),
                Expanded(
                  flex: 3,
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
          ListView.builder(
              shrinkWrap: true,
              key: UniqueKey(),
              itemCount: admissonOpen.length,
              itemBuilder:(BuildContext ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustom(100, 40, admissonOpen[index]['n_aca_year_ID']['identifier'], Colors.black,2),
                      ContCustom(120, 40, admissonOpen[index]['n_intake_ID']['identifier'], Colors.black,2),
                      ContCustom(200, 40, admissonOpen[index]['n_faculty_ID']['identifier'].toString().substring(11), Colors.black,6),
                      ContCustom(200, 40, admissonOpen[index]['n_program_ID']['identifier'], Colors.black,6),
                      ContCustom(200, 40, admissonOpen[index]['n_subject_ID']['identifier'], Colors.black,4),
                      ContCustom(200, 40, admissonOpen[index]['DateTo'], Colors.black,4),
                      ContCustom(200, 40, admissonOpen[index]['n_sem_year_ID']['identifier'], Colors.black,2),
                      applyORapplied(admissonOpen[index]['id'].toString(), index , 3 , 5),
                    ],
                  ),
                );
              } ),
          SizedBox(height: 21,),

        ],
      )],
    ),
  );}
  Widget admissionOpenPop( BuildContext context ,int ind ){
    void setFee(int Fee){
      setState(() {
        print("inside setstate");
        print(fee);
        this.fee = Fee;
        print(fee);
      });
    }
    if(fee == 0) {
      for (var i = 0; i < admissonOpenDet[ind].length; i++) {
        fee =
        (fee + admissonOpenDet[ind][i]['RATE_PER_CREDIT_HOUR']) as int;
      }
    }
    int? totalFee = admissonOpen[ind]['practicalfee']+admissonOpen[ind]['admissionfee']+admissonOpen[ind]['libraryfee']+fee;
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
                  itemCount: admissonOpenDet[ind].length,
                  itemBuilder:(BuildContext ctx, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CheckBoxOptCom(context,admissonOpenDet[ind][index]['course_type']['identifier'].toString() , index , ind , fee , setFee),
                        ContCustom(
                            80, 40, (index+1).toString(),
                            Colors.black,2),
                        ContCustom(
                            240, 40, admissonOpenDet[ind][index]['Name'].toString(),
                            Colors.black,10),
                        ContCustom(
                            120, 40, admissonOpenDet[ind][index]['course_type']['identifier'].toString(),
                            Colors.black,7),
                        ContCustom(
                            100, 40, admissonOpenDet[ind][index]['CREDIT_HOUR'].toString(),
                            Colors.black,3),
                        ContCustom(
                            140, 40, admissonOpenDet[ind][index]['RATE_PER_CREDIT_HOUR'].toString(),
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
                        ContCustomColor(100, 40, admissonOpen[ind]['libraryfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Admission Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, admissonOpen[ind]['admissionfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Practical Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, admissonOpen[ind]['practicalfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Divider(thickness: 4,),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Total Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, 'Rs - $totalFee.00', Colors.black,Colors.white),
                      ],
                    ),
                  ],),
                ],),
              SizedBox(height: 6,),
              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Click Below for Payment and Registration',style: TextStyle(
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
                          // creg.postCourseEnrollandReg(CourseOpenInfo);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => secondStepPay(context , totalFee , 0 ),);
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
  Widget AdmissionApp(){
    return Container(
    height: double.infinity,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: ListView(
      children: [Column(
        children: [
          const SizedBox(height: 32,),
          Padding(
            padding: const EdgeInsets.only(left: 33, right: 33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContCustomColor(100, 40, 'Year', Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(120, 40, 'Intake',  Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(200, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),6),
                ContCustomColor(200, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),6),
                ContCustomColor(200, 40, 'Subject',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(200, 40, 'Date',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(200, 40, 'Type',  Colors.white,Color(0xFF5F5FA7),3),
                ContCustomColor(200, 40, 'Sem',  Colors.white,Color(0xFF5F5FA7),2),
                Expanded(
                  flex: 3,
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
          ListView.builder(
              shrinkWrap: true,
              key: UniqueKey(),
              itemCount: admissonApp.length,
              itemBuilder:(BuildContext ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustom(100, 40, admissonApp[index]['n_aca_year_ID']['identifier'], Colors.black,2),
                      ContCustom(120, 40, admissonApp[index]['n_intake_ID']['identifier'], Colors.black,2),
                      ContCustom(200, 40, admissonApp[index]['n_faculty_ID']['identifier'].toString().substring(11), Colors.black,6),
                      ContCustom(200, 40, admissonApp[index]['n_program_ID']['identifier'], Colors.black,6),
                      ContCustom(200, 40, admissonApp[index]['n_subject_ID']['identifier'], Colors.black,4),
                      ContCustom(200, 40, admissonApp[index]['Created'].toString().substring(0,10), Colors.black,4),
                      ContCustom(200, 40, admissonApp[index]['regtype']['identifier'], Colors.black,3),
                      ContCustom(200, 40, admissonApp[index]['n_sem_year_ID']['identifier'], Colors.black,2),
                      applyORapplied(admissonApp[index]['id'].toString(), index , 3 , 3),
                    ],
                  ),
                );
              } ),
          SizedBox(height: 21,),

        ],
      ),
      ],),
  );}
  Widget admissionAppPop( BuildContext context ,int ind ){
    int feeInc = admissonApp[ind]['semyearfee']+admissonApp[ind]['library_fee']+admissonApp[ind]['admissionfee']+admissonApp[ind]['pracfee'];
    int feePaid = admissonApp[ind]['semyearfee_paid'];
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
              Center(child :Text('Course Regsiatrations Infos'),),
              Padding(
                padding: const EdgeInsets.only(top : 9,left: 33, right: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContCustomColor(50, 40, ' SN.', Colors.white,Color(0xFF5F5FA7),2),
                    ContCustomColor(240, 40, 'Name of Course',  Colors.white,Color(0xFF5F5FA7),10),
                    ContCustomColor(120, 40, 'Type',  Colors.white,Color(0xFF5F5FA7),7),
                    ContCustomColor(100, 40, 'Credit',  Colors.white,Color(0xFF5F5FA7),3),
                    ContCustomColor(140, 40, 'Total Fees(NRs)',  Colors.white,Color(0xFF5F5FA7),5),
                  ],
                ),
              ),
              SizedBox(height: 6,),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: admissonAppDet[ind].length,
                  itemBuilder:(BuildContext ctx, int index) {
                    return Padding(
                      padding: const  EdgeInsets.only(left: 33, right: 33),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ContCustom(
                              80, 40, (index+1).toString(),
                              Colors.black,2),
                          ContCustom(
                              240, 40, admissonAppDet[ind][index]['Name'].toString(),
                              Colors.black,10),
                          ContCustom(
                              120, 40, admissonAppDet[ind][index]['course_type']['identifier'].toString(),
                              Colors.black,7),
                          ContCustom(
                              100, 40, admissonAppDet[ind][index]['CREDIT_HOUR'].toString(),
                              Colors.black,3),
                          ContCustom(
                              140, 40, admissonAppDet[ind][index]['RATE_PER_CREDIT_HOUR'].toString(),
                              Colors.black,5),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 9,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('FEE HISTORY:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)],),
              Padding(
                padding: const EdgeInsets.only(right: 24,left: 24),
                child: Row(
                  children: [
                    Expanded(child: SizedBox()),
                    ContCustomColor(100, 40, 'Fee', Colors.white,Color(0xFF5F5FA7)),
                    ContCustomColor(100, 40, 'Fee Paid',Colors.white,Color(0xFF5F5FA7)),
                  ],
                ),
              ),
              SizedBox(height: 6,),
              ListView(padding: EdgeInsets.only(right: 24,left: 24),
                shrinkWrap: true,
                children: [Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Tuition Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, admissonApp[ind]['semyearfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                        ContCustomColor(100, 40, admissonApp[ind]['semyearfee_paid'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Library Fee',Colors.black,Colors.white),
                        ContCustomColor(100, 40, admissonApp[ind]['library_fee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                        ContCustomColor(100, 40, admissonApp[ind]['library_fee_paid'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Admission Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, admissonApp[ind]['admissionfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                        ContCustomColor(100, 40, admissonApp[ind]['admissionfee_paid'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Practical Fee', Colors.black,Colors.white),
                        ContCustomColor(100, 40, admissonApp[ind]['pracfee'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                        ContCustomColor(100, 40, admissonApp[ind]['pracfee_paid'].toString(), Colors.white,Colors.black.withOpacity(.77)),
                      ],
                    ),
                    Divider(thickness: 4,),
                    Row(
                      children: [
                        ContCustomColor(100, 40, 'Total', Colors.black,Colors.white),
                        ContCustomColor(100, 40, 'Rs - $feeInc.00', Colors.black,Colors.white),
                        ContCustomColor(100, 40, 'Rs - $feePaid.00', Colors.black,Colors.white),
                      ],
                    ),
                  ],),
                ],),
              SizedBox(height: 6,),
              ElevatedButton(
                child:Text('Back'),
                onPressed: () {
                  // CourseRegInfo creg = CourseRegInfo();
                  // creg.postCourseEnrollandReg(dataEntInfoApp);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.72)),
              ),
            ],
          ),],
        ),),
    );

  }

  ///Exam
  Widget ExamOpen(){
    return Container(
    height: double.infinity,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
      child: ListView(
        children: [Column(
          children: [
            const SizedBox(height: 18,),
          Padding(
            padding: const EdgeInsets.only(left: 33, right: 33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContCustomColor(50, 40, ' SN.', Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(240, 40, 'Exam',  Colors.white,Color(0xFF5F5FA7),4),
                ContCustomColor(100, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),10),
                ContCustomColor(120, 40, 'Subject',  Colors.white,Color(0xFF5F5FA7),7),
                ContCustomColor(100, 40, 'Sem',  Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(100, 40, 'Type',  Colors.white,Color(0xFF5F5FA7),3),
                ContCustomColor(100, 40, 'Date-Upto',  Colors.white,Color(0xFF5F5FA7),5),
                Expanded(
                  flex: 4,
                  child: Container(
                    width: 100,
                    height :40 ,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.33),
                      borderRadius: BorderRadius.circular(3),),
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(4),
                    child: const Center(child: Text('Apply',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
                  ),
                ),],
            ),
          ),
          SizedBox(height: 6,),
          ListView.builder(
              shrinkWrap: true,
              itemCount: examOpen[0].length,
              itemBuilder:(BuildContext ctx, int index) {
                return Padding(
                  padding: const  EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustom(
                          80, 40, (index+1).toString(),
                          Colors.black,2),
                      ContCustom(
                          240, 40, examOpen[0][index]['n_exam_master_ID']['identifier'].toString(),
                          Colors.black,4),
                      ContCustom(200, 40, examOpen[0][index]['n_program_ID']['identifier'], Colors.black,10),
                      ContCustom(200, 40, examOpen[0][index]['n_subject_ID']['identifier'], Colors.black,7),
                      ContCustom(200, 40, examOpen[0][index]['n_sem_year_ID']['identifier'], Colors.black,2),
                      ContCustom(
                          100, 40, examOpen[0][index]['examtype']['identifier'].toString(),
                          Colors.black,3),
                      ContCustom(100, 40, examOpen[0][index]['apply_uptolate'].toString().substring(0,9),
                          Colors.black,5),
                      applyORapplied(examOpen[0][index]['id'].toString(), index , 4 , 1),


                    ],
                  ),
                );
              }),
        ],
      ),
      ],),
  );}
  Widget examPop(BuildContext context , int i ){
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
              Text('Exam Registartions: ',style: TextStyle(color: Colors.black , fontSize: 30 ,fontWeight: FontWeight.bold ),),
            ],),
          SizedBox(height: 18,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('Academic Year : ${examOpen[0][i]['n_aca_year_ID']['identifier'].toString()}      Intake : ${examOpen[0][i]['n_intake_ID']['identifier'].toString()}  ',style: TextStyle(color: Colors.black , fontSize: 24),),
              ],),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('Semester : ${examOpen[0][i]['n_sem_year_ID']['identifier'].toString()}      Exam-Type : ${examOpen[0][i]['examtype']['identifier'].toString()}  ',style: TextStyle(color: Colors.black , fontSize: 24),),
              ],),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('Faculty : ${ examOpen[0][i]['n_faculty_ID']['identifier'].toString()}',style: TextStyle(color: Colors.black , fontSize: 24),),
              ],),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('Program : ${examOpen[0][i]['n_program_ID']['identifier'].toString()}',style: TextStyle(color: Colors.black , fontSize: 24),),
              ],),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('Subject : ${examOpen[0][i]['n_subject_ID']['identifier']} ',style: TextStyle(color: Colors.black , fontSize: 24),),
              ],),
              SizedBox(height: 23,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('Exam fee to be paid : ${examOpen[0][i]['examfee']} ',style: TextStyle(color: Colors.black , fontSize: 24),),
              ],),
              SizedBox(height: 12,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('Apply UpTo Date: ${examOpen[0][i]['apply_uptolate'].toString().substring(0,9)} ',style: TextStyle(color: Colors.black , fontSize: 24),),
              ],),
              SizedBox(height: 18,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text('Please Continue for Payment ! OR Cancel for reselection  ',style: TextStyle(color: Colors.grey , fontSize: 25,fontWeight: FontWeight.bold),),
              ],),
              SizedBox(height: 18,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Padding(
                  padding: const EdgeInsets.only(left :18 , right: 18),
                  child: ElevatedButton(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left :18 , right: 18),
                  child: ElevatedButton(
                    child:Text('Pay ->'),
                    onPressed: () {
                      int fee = 0 ;
                      DateTime nowd = DateTime.parse(formatter.format(now));
                      DateTime appDt = DateTime.parse(examOpen[0]['apply_upto']);
                      if(appDt.compareTo(nowd) < 0){
                        fee = examOpen[0][i]['examfee'];
                      }else{
                        fee = examOpen[0][i]['examfee'] + examOpen[0][i]['latefee'];
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => secondStepPay(context , fee ,2),);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.66)),
                  ),
                ),
              ],),
            ],
          ),
        ],
      ),
    );
  }
  Widget ExamApp(){
    return Container (
    height: double.infinity,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: ListView(
      children: [Column(
        children: [
          const SizedBox(height: 18,),
          Padding(
            padding: const EdgeInsets.only(left: 33, right: 33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContCustomColor(50, 40, ' SN.', Colors.white,Color(0xFF5F5FA7),2),
                ContCustomColor(240, 40, 'Exam',  Colors.white,Color(0xFF5F5FA7),5),
                ContCustomColor(120, 40, 'Center',  Colors.white,Color(0xFF5F5FA7),7),
                ContCustomColor(100, 40, 'Date ',  Colors.white,Color(0xFF5F5FA7),7),
                ContCustomColor(100, 40, 'Fee(Rs). ',  Colors.white,Color(0xFF5F5FA7),4),
                Expanded(
                  flex: 4,
                  child: Container(
                    width: 100,
                    height :40 ,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.33),
                      borderRadius: BorderRadius.circular(3),),
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(4),
                    child: const Center(child: Text('View',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
                  ),
                ),],
            ),
          ),
          SizedBox(height: 6,),
          ListView.builder(
              shrinkWrap: true,
              itemCount: examApp.length,
              itemBuilder:(BuildContext ctx, int index) {
                String dtt = examApp[index]['CompletedDate'].toString();
                if(dtt == 'null'){dtt = '----';}
                return Padding(
                  padding: const  EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustom(
                          80, 40, (index+1).toString(),
                          Colors.black,2),
                      ContCustom(
                          240, 40, examApp[index]['n_exam_master_ID']['identifier'].toString(),
                          Colors.black,5),
                      ContCustom(200, 40, examApp[index]['n_exam_center_ID']['identifier'].toString(), Colors.black,7),
                      ContCustom(200, 40, dtt, Colors.black,7),
                      ContCustom(200, 40, 'Rs.${examApp[index]['EXAM_FEE']}.00', Colors.black,4),
                      applyORapplied(examApp[index]['id'].toString(), index , 4 , 7),
                    ],
                  ),
                );
              }),
        ],
      ),
      ],),
  );}
  Widget ExamAppPop( BuildContext context ,int ind ){
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
              Center(child :Text('Exams Applied Infos',style:TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              )),),
              SizedBox(height: 18,),
              Padding(
                padding: const EdgeInsets.only(top : 9,left: 33, right: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContCustomColor(50, 40, ' SN.', Colors.white,Color(0xFF5F5FA7),2),
                    ContCustomColor(240, 40, 'Name of Course',  Colors.white,Color(0xFF5F5FA7),10),
                    ContCustomColor(120, 40, 'Exam Type',  Colors.white,Color(0xFF5F5FA7),7),
                    ContCustomColor(100, 40, 'Credit',  Colors.white,Color(0xFF5F5FA7),3),
                  ],
                ),
              ),
              SizedBox(height: 6,),

              ListView.builder(
                  shrinkWrap: true,
                  itemCount: examAppDet[ind].length,
                  itemBuilder:(BuildContext ctx, int index) {
                    String name = examAppDet[ind][index]['n_course_ID']['identifier'].toString();
                    print(name);
                    return Padding(
                      padding: const  EdgeInsets.only(left: 33, right: 33),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ContCustom(
                              80, 40, (index+1).toString(),
                              Colors.black,2),
                          ContCustom(
                              240, 40, name.substring(name.indexOf('_')+1,name.length),
                              Colors.black,10),
                          ContCustom(
                              120, 40, examAppDet[ind][index]['examtype']['identifier'].toString(),
                              Colors.black,7),
                          ContCustom(
                              100, 40, '${creditHour[index].toString()}.0',
                              Colors.black,3),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 9,),
              ElevatedButton(
                child:Text('Back'),
                onPressed: () {
                  // CourseRegInfo creg = CourseRegInfo();
                  // creg.postCourseEnrollandReg(dataEntInfoApp);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.72)),
              ),
            ],
          ),],
        ),),
    );

  }

  //Scholarship
  Widget SchoarshipApp(){
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

        SizedBox(height: 32,),
        Padding(
          padding: const EdgeInsets.only(left: 33, right: 33),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContCustomColor(50, 40, ' SN.', Colors.white,Color(0xFF5F5FA7),2),
              ContCustomColor(120, 40, 'Name',  Colors.white,Color(0xFF5F5FA7),7),
              ContCustomColor(100, 40, 'Sem',  Colors.white,Color(0xFF5F5FA7),4),
              ContCustomColor(100, 40, 'Status',  Colors.white,Color(0xFF5F5FA7),8),
              ContCustomColor(100, 40, 'Date-App',  Colors.white,Color(0xFF5F5FA7),5),
              ContCustomColor(100, 40, 'Print',  Colors.black,Colors.grey.withOpacity(.33),5),
              Expanded(
                flex: 3,
                child: Container(
                  width: 100,
                  height :40 ,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.33),
                    borderRadius: BorderRadius.circular(3),),
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(4),
                  child: const Center(child: Text('Apply',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
                ),
              ),],
          ),
        ),
        SizedBox(height: 6,),
        ListView.builder(
            shrinkWrap: true,
            itemCount: ScholarAppInfo.length,
            itemBuilder:(BuildContext ctx, int index) {
              return Padding(
                padding: const  EdgeInsets.only(left: 33, right: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContCustom(
                        80, 40, (index+1).toString(),
                        Colors.black,2),
                    ContCustom(200, 40, ScholarAppInfo[index]['n_scholarship_open_ID']['identifier'].toString().substring(11), Colors.black,7),
                    ContCustom(200, 40, ScholarAppInfo[index]['n_sem_year_ID']['identifier'], Colors.black,4),
                    ContCustom(200, 40, ScholarAppInfo[index]['DocStatus']['identifier'], Colors.black,8),
                    ContCustom(100, 40, ScholarAppInfo[index]['Created'].toString().substring(0,9),
                        Colors.black,5),
                    Expanded(
                      flex : 5,
                      child: Padding(padding: EdgeInsets.all(3),
                        child: ElevatedButton(
                            onPressed: () async {
                              // //Load the existing PDF document.
                              // PdfDocument document =
                              // PdfDocument(inputBytes: base64Decode(entranceForm[index]['exportFile'].toString()));
                              // final List<int> bytes = await document.save();
                              // document.dispose();
                              final blob = html.Blob([base64Decode(scholarshipAppForm[index]['exportFile'].toString())], 'application/pdf');
                              final url = html.Url.createObjectUrlFromBlob(blob);
                              final anchor = html.document.createElement('a') as html.AnchorElement
                                ..href = url
                                ..style.display = 'none'
                                ..download = '${scholarshipAppForm[index]['exportFileName']}';
                              html.document.body?.children.add(anchor);
                              anchor.click();
                            },
                            style: ElevatedButton.styleFrom(primary:Colors.blueAccent.withOpacity(.66),fixedSize: const Size(96, 37) ),
                            child: Center(
                                child: Text(''
                                    'PRINT',
                                  style: TextStyle(color:
                                  Colors.white,fontWeight: FontWeight.bold),))),
                      ),
                    ),
                    applyORapplied(ScholarAppInfo[index]['id'].toString(), index , 3 , 4),


                  ],
                ),
              );
            }),
      ],
    ),
    );}
  Widget scholarshipAppPop(BuildContext context , int index)  {
    String schCat = '\n\n';
    // List<dynamic> dataToAttach = [];
    // dataofScholarAppIDforAttach.entries.map((e) => dataToAttach.add({e.key: e.value})).toList();

    if(dataofScholarAppIDforAttach['scholarship_hardworking'] == true){schCat = '$schCat Hardworking \n\n';}
    if(dataofScholarAppIDforAttach['scholarship_female'] == true){schCat = '$schCat Female Quota \n\n';}
    if(dataofScholarAppIDforAttach['scholarship_poverty'] == true){schCat = '$schCat Financial Promotion \n\n';}
    if(dataofScholarAppIDforAttach['scholarship_other'] == true){schCat = '$schCat Other \n\n';}
    return StatefulBuilder(builder: (context,setState) =>Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 18,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Application Of Scholarship Info: ',style: TextStyle(color: Colors.black , fontSize: 27 ,fontWeight: FontWeight.bold),),
              ],),
            SizedBox(height: 18,),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Text('Status:  Applied ',style: TextStyle(color: Colors.black , fontSize: 24),),
            ],),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Text('Applied Category : $schCat',style: TextStyle(color: Colors.black , fontSize: 18),),
            ],),
            SizedBox(height: 18,),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
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
              SizedBox(width: 21,),
              ElevatedButton(
                onPressed: () async {
                  switch(isSchAppAttachEmpty){
                    case 0 :
                      showAttach(context, schAttType, AttachmentsScholar);
                      break;
                    case 1 :
                      await _pickFile(nameCode);
                      setState(() {
                        if (kDebugMode) {
                          print(nameCode[0]);
                        }
                        if(nameCode.isNotEmpty){
                          uploaded = 1;
                        }
                      });
                      break;
                  }

                },
                style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.66)),
                child:Text(isSchAppAttachEmpty == 0 ?'Attached files :' : 'Upload Attachment:'),
              ),SizedBox(width: 12,),
              SizedBox(
                  child:isSchAppAttachEmpty == 0 ? ElevatedButton(onPressed: () async {
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("AlertDialog"),
                        content: Text("Are you sure to delete attachment?"),
                        actions: [
                          ElevatedButton(
                            child: Text("Yes"),
                            onPressed:  () async{
                              attachWS att = attachWS();
                              await att.deleteAttachment(dataofScholarAppIDforAttach);
                              // Validate returns true if the form is valid, or false otherwise.
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              showSnack('Deleted Data', Colors.redAccent);
                            },
                          ),
                          ElevatedButton(
                            child: Text("No"),
                            onPressed:  () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
                  }, child: Text('Delete -'),style: ElevatedButton.styleFrom(primary: Colors.red.withOpacity(.66)),) : Text(''))
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text(
                            uploaded == 0 ?'' : nameCode[0]),
                      ),
                      SizedBox(
                        child: uploaded == 0 ? Text('') : ElevatedButton(
                          child: Text('X-cancel',style: TextStyle(color: Colors.white),),
                          onPressed: (){
                            setState((){
                              nameCode =[];
                              uploaded = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(primary:Colors.red.withOpacity(0.5)),
                        ),
                      ),
                      SizedBox(
                          child: uploaded == 0 ? Text('') : ElevatedButton(
                              child: Text('Upload',style: TextStyle(color: Colors.white),),
                              onPressed: ()  async {
                                showDialog(context: context, builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text("AlertDialog"),
                                    content: Text("Are you sure to upload attachment?"),
                                    actions: [
                                      ElevatedButton(
                                        child: Text("Yes"),
                                        onPressed:  () async {
                                          attachWS att = attachWS();
                                          await att.uploadAttachment(ScholarAppInfo, nameCode[0], nameCode[1]);
                                          setState((){
                                            nameCode =[];
                                            uploaded = 0;
                                            this.setState(() {
                                            });
                                          });
                                          // Validate returns true if the form is valid, or false otherwise.
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          showSnack('Uploaded Data', Colors.greenAccent);
                                        },
                                      ),
                                      ElevatedButton(
                                          child: Text("No"),
                                          onPressed:  () {
                                            Navigator.of(context).pop();
                                          }
                                      ),
                                    ],
                                  );});})

                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),);
  }
  Widget SchoarshipOpen(){
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
      SizedBox(height: 32,),
      Padding(
        padding: const EdgeInsets.only(left: 33, right: 33),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContCustomColor(50, 40, ' SN.', Colors.white,Color(0xFF5F5FA7),2),
            ContCustomColor(120, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),7),
            ContCustomColor(100, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),10),
            ContCustomColor(100, 40, 'Name',  Colors.white,Color(0xFF5F5FA7),8),
            ContCustomColor(100, 40, 'Date-Upto',  Colors.white,Color(0xFF5F5FA7),5),
            Expanded(
              flex: 3,
              child: Container(
                width: 100,
                height :40 ,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.33),
                  borderRadius: BorderRadius.circular(3),),
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(4),
                child: const Center(child: Text('Apply',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
              ),
            ),],
        ),
      ),
      SizedBox(height: 6,),
      ListView.builder(
          shrinkWrap: true,
          itemCount: scholarshipOpen.length,
          itemBuilder:(BuildContext ctx, int index) {
            return Padding(
              padding: const  EdgeInsets.only(left: 33, right: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContCustom(
                      80, 40, (index+1).toString(),
                      Colors.black,2),
                  ContCustom(200, 40, scholarshipOpen[index]['n_faculty_ID']['identifier'].toString().substring(11), Colors.black,7),
                  ContCustom(200, 40, scholarshipOpen[index]['n_program_ID']['identifier'], Colors.black,10),
                  ContCustom(200, 40, scholarshipOpen[index]['Name'], Colors.black,8),
                  ContCustom(100, 40, scholarshipOpen[index]['apply_to'].toString().substring(0,9),
                      Colors.black,5),
                  applyORapplied(scholarshipOpen[index]['id'].toString(), index , 3 , 2),


                ],
              ),
            );
          }),
    ],
  ),
  );}
  Widget scholarshipPop(BuildContext context , int scOpenInd ){
    return StatefulBuilder(
      builder: (context,setState) =>Scaffold(
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
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Application for Scholarship : ',style: TextStyle(color: Colors.black , fontSize: 27 ,fontWeight: FontWeight.bold),),
                ],),
              SizedBox(height: 18,),
              Center(child:
              Text('${scholarshipOpen[scOpenInd]['Name']}'),),
              SizedBox(height: 21,),
              Center(child: Text("Select your Scholarship type :"),),
              SizedBox(height: 21,),
              Padding(
                padding: const EdgeInsets.only(left : 222 , right: 156),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.only(left : 57 , right : 57),
                          shrinkWrap: true,
                          itemCount: scholarshipTypes.length,
                          itemBuilder:(BuildContext ctx, int index) {
                            return CheckboxListTile(
                              title: Text(scholarshipTypes[index]),
                              value: selScholarship[index],
                              onChanged: (value){
                                setState(() {
                                  selScholarship[index] = value ;
                                });
                              },
                            );
                          }
                      ),]
                ),
              ),
              SizedBox(height: 33,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Upload your supporting document : ',style: TextStyle(fontWeight: FontWeight.bold),)],),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Select image for single file , pdf for multiple files ',style: TextStyle(fontWeight: FontWeight.w200),)],),
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
                            await _pickFile(nameCode);
                            setState(() {
                              print(nameCode[0]);
                              if(nameCode.isNotEmpty){
                                uploaded = 1;
                              }
                            });
                          },
                          child: const Text(
                              'Attachment :'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Text(
                              uploaded == 0 ?'' : nameCode[0]),
                        ),
                        SizedBox(
                          child: uploaded == 0 ? Text('') : ElevatedButton(
                            child: Text('X-cancel',style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              setState((){
                                nameCode =[];
                                uploaded = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(primary:Colors.red.withOpacity(0.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Back'),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(primary:Colors.black45),
                  ),
                  SizedBox(width : 45),
                  ElevatedButton(
                    child: Text('Apply',style: TextStyle(fontWeight: FontWeight.bold),),
                    onPressed: () async {
                      print('sel val - \n $selScholarship');
                      print(!selScholarship.contains(true));
                      if(!selScholarship.contains(true)){showSnackwithCtx(context,'Select at least one category', Colors.redAccent);}
                      else if(nameCode.isEmpty){showSnackwithCtx(context,'Please Upload Attachment !', CupertinoColors.systemRed);}
                      else{
                        scholarInfo scin = scholarInfo();
                        List? screg = await scin.postScholarship(scholarshipOpen , scOpenInd ,selScholarship );
                        attachWS attach = attachWS();
                        // int? schregtableID = await attach.getTableID('n_scholarship_reg');
                        // attach.uploadAttachment(schregtableID!, scregID!, 'zip', nameCode[1].substring(1,nameCode[1].length-1));
                        await attach.uploadAttachment(screg!, nameCode[0], nameCode[1]);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary:Colors.green.withOpacity(.66)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),);
  }

  //NOU
  Widget NOUApp(){
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
        SizedBox(height: 32,),
        Padding(
          padding: const EdgeInsets.only(left: 33, right: 33),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContCustomColor(50, 40, 'SN.', Colors.white,Color(0xFF5F5FA7),2),
              ContCustomColor(50, 40, 'Year', Colors.white,Color(0xFF5F5FA7),4),
              ContCustomColor(120, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),7),
              ContCustomColor(100, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),10),
              ContCustomColor(100, 40, 'Status',  Colors.white,Color(0xFF5F5FA7),6),
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: nouRegList[0]['regrollno'] !=null ?
                   Container(
                    width: 100,
                    height :40 ,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.33),
                      borderRadius: BorderRadius.circular(3),),
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(4),
                    child: const Center(child: Text('Apply',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
                  ):SizedBox(),
                ),
              ),],
          ),
        ),
        SizedBox(height: 6,),
        ListView.builder(
            shrinkWrap: true,
            itemCount: nouRegList.length,
            itemBuilder:(BuildContext ctx, int index) {
              String aca = nouRegList[index]['n_aca_year_ID']['identifier'] +' '+ nouRegList[index]['n_intake_ID']['identifier'];
              return Padding(
                padding: const  EdgeInsets.only(left: 33, right: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ContCustom(
                        80, 40, (index+1).toString(), Colors.black,2),
                    ContCustom(200, 40, aca, Colors.black,4),
                    ContCustom(200, 40, nouRegList[index]['n_faculty_ID']['identifier'].toString().substring(11), Colors.black,7),
                    ContCustom(200, 40, nouRegList[index]['n_program_ID']['identifier'], Colors.black,10),
                    ContCustom(200, 40, nouRegList[index]['DocStatus']['identifier'], Colors.black,6),
                    Expanded(
                      flex : 3,
                      child: SizedBox(
                        child: nouRegList[0]['regrollno'] !=null ? Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                showSnack('Payment Process', Colors.purpleAccent);
                                // //Load the existing PDF document.
                                // PdfDocument document =
                                // PdfDocument(inputBytes: base64Decode(entranceForm[index]['exportFile'].toString()));
                                // final List<int> bytes = await document.save();
                                // document.dispose();
                                // final blob = html.Blob([base64Decode(scholarshipAppForm[index]['exportFile'].toString())], 'application/pdf');
                                // final url = html.Url.createObjectUrlFromBlob(blob);
                                // final anchor = html.document.createElement('a') as html.AnchorElement
                                //   ..href = url
                                //   ..style.display = 'none'
                                //   ..download = '${scholarshipAppForm[index]['exportFileName']}';
                                // html.document.body?.children.add(anchor);
                                // anchor.click();
                              },
                              style: ElevatedButton.styleFrom(primary:Colors.blueAccent.withOpacity(.66),fixedSize: const Size(96, 37) ),
                              child: Center(
                                  child: Text(''
                                      'PRINT',
                                    style: TextStyle(color:
                                    Colors.white,fontWeight: FontWeight.bold),))),
                        ) : SizedBox(),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    ),
    );}
  Widget NOUOpen(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ), child:
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 32,),
        Padding(
          padding: const EdgeInsets.only(left: 33, right: 33),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContCustomColor(50, 40, ' SN.', Colors.white,Color(0xFF5F5FA7),2),
              ContCustomColor(120, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),7),
              ContCustomColor(100, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),10),
              ContCustomColor(100, 40, 'Year',  Colors.white,Color(0xFF5F5FA7),8),
              ContCustomColor(100, 40, 'Date-Upto',  Colors.white,Color(0xFF5F5FA7),5),
              Expanded(
                flex: 3,
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
              itemCount: dataRegCourseInfo.length,
              itemBuilder:(BuildContext ctx, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustom(
                          80, 40, (index+1).toString(),
                          Colors.black,2),
                      ContCustom(200, 40, dataRegCourseInfo[index]['n_faculty_ID']['identifier'].toString(), Colors.black,7),
                      ContCustom(200, 40, dataRegCourseInfo[index]['n_program_ID']['identifier'], Colors.black,10),
                      ContCustom(200, 40, dataRegCourseInfo[index]['n_aca_year_ID']['identifier'], Colors.black,8),
                      ContCustom(100, 40, dataRegCourseInfo[index]['Created'].toString().substring(0,10),
                          Colors.black,5),
                      applyORapplied(dataRegCourseInfo[index]['id'].toString(), index , 3 , 9 ,  ctx),
                    ],
                  ),
                );
              } ),
        ),

      ],
    ),
    );}

  //Entrance
  Widget EntranceOpen(){
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

        SizedBox(height: 15,),
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
                      applyORapplied( dataEntInfo[index]['id'].toString(), index , 2 , 6),
                    ],
                  );
                } ),
          ),
        ),
        SizedBox(height: 21,),

      ],
    ),
  );}
  Widget entrancePop(BuildContext context , int i ){
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(left:66 , right : 66 , top:66 , bottom: 150),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView(
        children: [
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 18,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Your details of Selection ',style: TextStyle(color: Colors.black , fontSize: 27 ,fontWeight: FontWeight.bold),),
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
                  Text('Entrance fee to be paid : ${dataEntInfo[i]['examfee']} ',style: TextStyle(color: Colors.black , fontSize: 24),),
                ],),
                SizedBox(height: 12,),

                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Text('Late Fee : ${dataEntInfo[i]['latefee']} ',style: TextStyle(color: Colors.black , fontSize: 21),),
                ],),
                SizedBox(height: 57,),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Text('Please Continue for Payment ! OR Cancel for reselection  ',style: TextStyle(color: Colors.grey , fontSize: 25,fontWeight: FontWeight.bold),),
                ],),
                SizedBox(height: 18,),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Padding(
                    padding: const EdgeInsets.only(left :18 , right: 18),
                    child: ElevatedButton(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left :18 , right: 18),
                    child: ElevatedButton(
                      child:Text('Pay ->'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => secondStepPay(context , dataEntInfo[i]['fee'],1),);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.green.withOpacity(.66)),
                    ),
                  ),
                ],),
              ],
            ),
          ],
        ),]
      ),
    );
  }
  Widget EntranceApp(BuildContext context){
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20, right: 24, left: 24,top: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ), child:
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 32,),
        Padding(
          padding: const EdgeInsets.only(left: 33, right: 33),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContCustomColor(100, 40, 'Year', Colors.white,Color(0xFF5F5FA7),2),
              ContCustomColor(120, 40, 'Intake',  Colors.white,Color(0xFF5F5FA7),2),
              ContCustomColor(200, 40, 'Faculty',  Colors.white,Color(0xFF5F5FA7),5),
              ContCustomColor(200, 40, 'Program',  Colors.white,Color(0xFF5F5FA7),5),
              ContCustomColor(200, 40, 'Subject',  Colors.white,Color(0xFF5F5FA7),4),
              ContCustomColor(200, 40, 'Status',  Colors.white,Color(0xFF5F5FA7),3),
              ContCustomColor(200, 40, 'Remarks',  Colors.white,Color(0xFF5F5FA7),4),
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
                  child: const Center(child: Text('Card',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
                ),
              ),
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
                  child: const Center(child: Text('Form',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
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
                String fac = dataEntInfoApp[index]['n_faculty_ID']['identifier'];
                String f = fac.substring(11);
                String cmt = dataEntInfoApp[index]['Comments'].toString();
                if(cmt == 'null' ){ cmt = '------';}
                return Padding(
                  padding: const EdgeInsets.only(left: 33, right: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ContCustom(100, 40, dataEntInfoApp[index]['n_aca_year_ID']['identifier'], Colors.black,2),
                      ContCustom(120, 40, dataEntInfoApp[index]['n_intake_ID']['identifier'], Colors.black,2),
                      ContCustom(200, 40, f, Colors.black,5),
                      ContCustom(200, 40, dataEntInfoApp[index]['n_program_ID']['identifier'], Colors.black,5),
                      ContCustom(200, 40, dataEntInfoApp[index]['n_subject_ID']['identifier'], Colors.black,4),
                      ContCustom(200, 40, dataEntInfoApp[index]['DocStatus']['identifier'], Colors.black,3),
                      ContCustom(200, 40, cmt, Colors.black,4),
                      Expanded(
                        flex : 2,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                // //Load the existing PDF document.
                                // PdfDocument document =
                                // PdfDocument(inputBytes: base64Decode(entranceForm[index]['exportFile'].toString()));
                                // final List<int> bytes = await document.save();
                                // document.dispose();
                                final blob = html.Blob([base64Decode(entranceExamCard[index]['exportFile'].toString())], 'application/pdf');
                                final url = html.Url.createObjectUrlFromBlob(blob);
                                final anchor = html.document.createElement('a') as html.AnchorElement
                                  ..href = url
                                  ..style.display = 'none'
                                  ..download = '${entranceExamCard[index]['exportFileName']}';
                                html.document.body?.children.add(anchor);
                                anchor.click();
                              },
                              style: ElevatedButton.styleFrom(primary:Colors.green.withOpacity(.66),fixedSize: const Size(96, 37) ),
                              child: Center(
                                  child: Text(''
                                      'PRINT',
                                    style: TextStyle(color:
                                    Colors.white,fontWeight: FontWeight.bold),))),
                        ),
                      ),
                      Expanded(
                        flex : 2,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                // //Load the existing PDF document.
                                // PdfDocument document =
                                // PdfDocument(inputBytes: base64Decode(entranceForm[index]['exportFile'].toString()));
                                // final List<int> bytes = await document.save();
                                // document.dispose();
                                final blob = html.Blob([base64Decode(entranceForm[index]['exportFile'].toString())], 'application/pdf');
                                final url = html.Url.createObjectUrlFromBlob(blob);
                                final anchor = html.document.createElement('a') as html.AnchorElement
                                  ..href = url
                                  ..style.display = 'none'
                                  ..download = '${entranceForm[index]['exportFileName']}';
                                html.document.body?.children.add(anchor);
                                anchor.click();
                              },
                              style: ElevatedButton.styleFrom(primary:Colors.green.withOpacity(.66), fixedSize: const Size(96, 37) ),
                              child: Center(
                                  child: Text(''
                                      'PRINT',
                                    style: TextStyle(color:
                                    Colors.white,fontWeight: FontWeight.bold),))),
                        ),
                      ),
                    ],
                  ),
                );
              } ),
        ),

      ],
    ),
    );
  }
  int acaDelst = 0 ;
  String imageNew = '' ;
  int img = 0 ;
  void setDeletedState(int i){
    switch (i) {
      case 0 :
        setState(() {
          acaDelst = 0 ;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    String imgDP = widget.dpImg ;
    bool ac = act == 0 ? false : true;
    final theme = Theme.of(context);
    double w = double.infinity;
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          final pageTitle = _getTitleByIndex(widget.controller.selectedIndex);
          switch (widget.controller.selectedIndex) {
            case 0:
              return FutureBuilder(
                initialData: true,
                future:  _cbpLocationData,
                builder: (ctx,snapshot){
                  // Checking if future is resolved or not
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                      // if we got our data
                    } else
                    if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      return Form(
                        key: _formKey ,
                        child: MaterialApp(title: 'Student Portal',
                          home: Container(
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
                                  ]
                              ),

                            ),
                            child: ListView(
                              children:[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 8,),
                                    const Text('STUDENT INFO',style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 30,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    // const SizedBox(height: 12,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 12,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          child: act == 1 ?Text("",) : ElevatedButton(
                                            onPressed: () {
                                              showDialog(context: context, builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: Text("AlertDialog"),
                                                  content: Text("Would you like to make changes in your infos?"),
                                                  actions: [
                                                    ElevatedButton(
                                                      child: Text("Yes"),
                                                      onPressed:  () {
                                                        // Validate returns true if the form is valid, or false otherwise.
                                                        if (_formKey.currentState!.validate()) {
                                                          // If the form is valid, display a snackbar. In the real world,
                                                          // you'd often call a server or save the information in a database.
                                                          showSnack('Processing Data', Colors.purpleAccent);
                                                        }
                                                        setState(() {
                                                          act = 1;
                                                        });
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: Text("No"),
                                                      onPressed:  () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                            },
                                            child: const Text('Edit'),
                                            style: ElevatedButton.styleFrom(primary:Colors.purple.withOpacity(.66) ),
                                          ),
                                        ),
                                        const SizedBox(width: 12,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          child: act == 0 ? Text('') : ElevatedButton(
                                            onPressed: () {
                                              showDialog(context: context, builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: Text("AlertDialog"),
                                                  content: Text("Sure to save these changes in your infos?"),
                                                  actions: [
                                                    ElevatedButton(
                                                      child: Text("Yes"),
                                                      onPressed:  () async {
                                                          if (_formKey.currentState!.validate()) {
                                                        showSnack('Saving Data', Colors.lightGreenAccent);
                                                        bPartnerWS bp = bPartnerWS();
                                                        await bp.updateCBPData(bPartData);
                                                        await bp.updateBpartLocationTemp(DDCBPlocationTemp);
                                                        await bp.updateBpartLocationPer(DDCBPlocation);
                                                        await runLocWS();
                                                        await getCBLocation();
                                                        // print(DDCBPlocation);
                                                        // print(DDCBPlocationTemp);
                                                        Navigator.of(context).pop();
                                                        setState(() {
                                                          act = 0;

                                                        });

                                                        showSnack('Data Saved Successfully', Colors.lightGreenAccent);
                                                     }else{Navigator.of(context).pop();
                                                          showSnack('Invalid Data', Colors.redAccent);} },
                                                    ),
                                                    ElevatedButton(
                                                      child: Text("No"),
                                                      onPressed:  () async{
                                                        await runLocWS();
                                                        await getCBLocation();
                                                        setState(() {
                                                          act = 0;

                                                        });
                                                        Navigator.of(context).pop();
                                                        showSnack('Data back to Initials', Colors.lightGreenAccent);
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                            },
                                            child: const Text('Save'),
                                            style: ElevatedButton.styleFrom(primary:Colors.green ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ExpansionTile(
                                      maintainState: true,
                                      initiallyExpanded: true,
                                      collapsedTextColor: Colors.white,
                                      title :  const Text(
                                        'General Information',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      children: [Container(
                                        // padding: EdgeInsets.only(left: 21,right: 21,bottom: 21),
                                        height: 500,
                                        width: double.infinity,
                                        // margin: const EdgeInsets.only(
                                        //     bottom: 21, right: 10, left: 10,top: 9),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 21,right: 21 , top : 21),
                                                      width: w,
                                                      child: TextFormField(
                                                        validator:ValidationBuilder().minLength(1,'*Required').maxLength(50,'Long Expression').build() ,
                                                        enabled: ac,
                                                        controller: TextEditingController(text: bPartData[0]['Name'].toString()),
                                                        onChanged: (value) {
                                                            bPartData[0]['Name'] = value;
                                                        },
                                                        decoration: const InputDecoration(
                                                          labelText: 'Full Name',
                                                          suffixIcon: Icon(Icons.perm_identity_outlined, size: 25,),
                                                        ),
                                                      ),
                                                    ),//Name
                                                    Container(
                                                      width: w,
                                                      padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                      child: TextFormField(
                                                        validator:ValidationBuilder().email('Enter Valid Email').build() ,
                                                        enabled: ac,
                                                        controller:
                                                        TextEditingController(text: bPartData[0]['EMail'].toString()),
                                                        onChanged: (value) {
                                                          bPartData[0]['EMail'] = value;
                                                        },
                                                        decoration: const InputDecoration(
                                                          labelText: 'Email Address/Username',
                                                          hintText: 'mail@mail.com',
                                                          suffixIcon: const Icon(Icons.mail, size: 25,),
                                                        ),
                                                      ),
                                                    ),//Email
                                                    Container(
                                                      padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                      width: w,
                                                      child: TextFormField(
                                                        onTap: () async {
                                                          DateTime? pickedDate = await showDatePicker(
                                                              context: context, initialDate: DateTime.now(),
                                                              firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                                              lastDate: DateTime(2101)
                                                          );

                                                          if(pickedDate != null ){
                                                            // print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                            // print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                                            //you can implement different kind of Date Format here according to your requirement

                                                            setState(() {
                                                              dateinput.text = formattedDate; //set output date to TextField value.
                                                            });
                                                          }else{
                                                            print("Date is not selected");
                                                          }
                                                        },
                                                        enabled: ac,
                                                        controller:
                                                        dateinput,
                                                        onChanged: (value) {
                                                          bPartData[0]['dob_ad'] = value;
                                                        },
                                                        decoration: const InputDecoration(
                                                          labelText: 'DOB(AD)',
                                                          hintText: 'DD-MM-YY',
                                                          suffixIcon: const Icon(Icons.calendar_month, size: 25,),
                                                        ),
                                                      ),
                                                    ),//dateAD
                                                    Container(
                                                      width: w,
                                                      padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                      child: TextFormField(
                                                        validator:ValidationBuilder().minLength(1,'*Require').maxLength(50,'Long Expression').build() ,
                                                        enabled: ac,
                                                        controller:
                                                        TextEditingController(text: bPartData[0]['grand_father_name'].toString()),
                                                        onChanged: (value) {
                                                          bPartData[0]['grand_father_name'] = value;
                                                        },
                                                        decoration: const InputDecoration(
                                                          labelText: 'Grand Father\'s Name',
                                                          suffixIcon: const Icon(Icons.person, size: 25,),
                                                        ),
                                                      ),
                                                    ),///Grandfather
                                                    Container(
                                                      padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                      width: w,
                                                      child: TextFormField(
                                                        validator:ValidationBuilder().minLength(1,'*Require').maxLength(50,'Long Expression').build() ,
                                                        enabled: ac,
                                                        controller:
                                                        TextEditingController(text: bPartData[0]['religion'].toString()),
                                                        onChanged: (value) {
                                                          bPartData[0]['religion'] = value;
                                                        },
                                                        decoration: const InputDecoration(
                                                          labelText: 'Religion.',
                                                        ),
                                                      ),
                                                    ),//Religion
                                                    Container(
                                                      width: w,
                                                      padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                      child: TextFormField(
                                                        validator:ValidationBuilder().minLength(10,'*Require').maxLength(10,'Long Expression').build() ,
                                                        enabled: ac,
                                                        controller:
                                                        TextEditingController(text: bPartData[0]['Phone'].toString()),
                                                        onChanged: (value) {
                                                          bPartData[0]['Phone'] = value;
                                                        },
                                                        decoration: const InputDecoration(
                                                          labelText: 'Phone',
                                                          suffixIcon: Icon(Icons.phone, size: 25,),
                                                        ),
                                                      ),
                                                    ),//Phone
                                                    Container(
                                                      padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                      width: w,
                                                      child: TextFormField(
                                                        enabled: false,
                                                        controller:
                                                        TextEditingController(text: bPartData[0]['dob_bs'].toString()),
                                                        onChanged: (value) {
                                                          bPartData[0]['dob_bs'] = value;
                                                        },
                                                        decoration: const InputDecoration(
                                                          labelText: 'DOB(BS)',
                                                          hintText: 'DD-MM-YY',
                                                          suffixIcon: const Icon(Icons.calendar_month, size: 25,),
                                                        ),
                                                      ),
                                                    ),//dateBS
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child:Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                    width: w,
                                                    child: TextFormField(
                                                      enabled: false,
                                                      controller:
                                                      TextEditingController(text: 'नबिना कोइराला'),
                                                      onChanged: (value) {
                                                        bPartData[0]['name_nepali'] = value;
                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: 'पुरा नाम(नेपालिमा)',
                                                        suffixIcon: Icon(Icons.perm_identity_outlined, size: 25,),
                                                      ),
                                                    ),
                                                  ),//NepName
                                                  Container(
                                                    padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                    width: w,
                                                    child: TextField(
                                                      enabled: false,
                                                      controller:
                                                      TextEditingController(text:  bPartData[0]['gender']['identifier'].toString().toUpperCase()),
                                                      onChanged: (value) {

                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: 'Gender',
                                                        suffixIcon: Icon(Icons.perm_identity_outlined, size: 25,),
                                                      ),
                                                    ),
                                                  ),//gender
                                                  Container(
                                                    width: w,
                                                    padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                    child: TextFormField(
                                                      validator:ValidationBuilder().minLength(1,'*Require').maxLength(50,'Long Expression').build() ,
                                                      enabled: ac,
                                                      controller:
                                                      TextEditingController(text: bPartData[0]['father_name'].toString()),
                                                      onChanged: (value) {
                                                        bPartData[0]['father_name'] = value;
                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: 'Father\'s Name',
                                                        suffixIcon: Icon(Icons.people, size: 25,),
                                                      ),
                                                    ),
                                                  ),//father
                                                  Container(
                                                    width: w,
                                                    padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                    child: TextFormField(
                                                      validator:ValidationBuilder().minLength(1,'*Require').maxLength(50,'Long Expression').build() ,
                                                      enabled: ac,
                                                      controller:
                                                      TextEditingController(text: bPartData[0]['grand_mother_name'].toString()),
                                                      onChanged: (value) {bPartData[0]['grand_mother_name'] = value;},
                                                      decoration: const InputDecoration(
                                                        labelText: 'Grand Mother\'s Name',
                                                        suffixIcon: const Icon(Icons.people, size: 25,),
                                                      ),
                                                    ),
                                                  ),//GrandMother
                                                  Container(
                                                    width: w,
                                                    padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                    child: TextFormField(
                                                      validator:ValidationBuilder().minLength(1,'*Require').maxLength(50,'Long Expression').build() ,
                                                      enabled: ac,
                                                      controller:
                                                      TextEditingController(text: bPartData[0]['cast_ethinicity'].toString()),
                                                      onChanged: (value) {
                                                        bPartData[0]['cast_ethinicity'] = value;
                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: 'Cast Ethnicity',
                                                        suffixIcon: Icon(Icons.star, size: 25,),
                                                      ),
                                                    ),
                                                  ),//Cast
                                                  Container(
                                                    width: w,
                                                    padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                    child: TextFormField(
                                                      validator:ValidationBuilder().minLength(1,'*Require').maxLength(50,'Long Expression').build() ,
                                                      enabled: ac,
                                                      controller:
                                                      TextEditingController(text: bPartData[0]['mother_name'].toString()),
                                                      onChanged: (value) {
                                                        bPartData[0]['mother_name'] = value;
                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: 'Mother\'s Name',
                                                        suffixIcon: Icon(Icons.people, size: 25,),
                                                      ),
                                                    ),
                                                  ),//mother
                                                  Container(
                                                    padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                    width: w,
                                                    child: TextFormField(
                                                      validator:ValidationBuilder().minLength(1,'*Required').maxLength(50,'Long Expression').build() ,
                                                      enabled: ac,
                                                      controller:
                                                      TextEditingController(text: bPartData[0]['nationality'].toString()),
                                                      onChanged: (value) {
                                                        bPartData[0]['nationality'] = value;
                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: 'Nationality',
                                                      ),
                                                    ),
                                                  ),//Nationality
                                                ],
                                              ),),
                                              Expanded(
                                                child:Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 21,right: 21,bottom: 21 , top :21),
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'Student\'s Photo',
                                                          style: TextStyle(
                                                            decoration : TextDecoration.none,
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height : 6),
                                                        Container(
                                                          child: imgDP == 'null' ? Image.asset('assets/images/noimage.jpeg',height: 210,width: 240,) :
                                                          Image.memory(base64Decode(imgDP),height: 210,width: 240,),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(imgDP == 'null' ? 'Upload your Photo' : 'Please, Select Actions' ,
                                                              style: TextStyle(
                                                                decoration : TextDecoration.none,
                                                                fontSize: 18,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            SizedBox(height: 12,),
                                                            SizedBox(
                                                              child :
                                                              imgDP == 'null' ?
                                                              ElevatedButton(
                                                                  onPressed: () async {
                                                                    await _pickDP(DPImage);
                                                                    showDialog(context: context, builder: (BuildContext context){
                                                                      return AlertDialog(
                                                                        title: Text("AlertDialog"),
                                                                        content: Text("Are you sure to upload your Photo ?"),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                            child: Text("Yes"),
                                                                            onPressed:  ()async {
                                                                              bPartnerWS bp = bPartnerWS();
                                                                              await bp.updateDP(DPImage[1] , DPImage[0]);

                                                                              setState(() {
                                                                                widget.updatecallBack(DPImage[1]);
                                                                              });
                                                                              DPImage = [];
                                                                              // Validate returns true if the form is valid, or false otherwise.
                                                                              showSnack('Processing Data', Colors.purpleAccent);
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          ElevatedButton(
                                                                            child: Text("No"),
                                                                            onPressed:  () {
                                                                              DPImage = [];
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          )
                                                                        ],
                                                                      );
                                                                    });
                                                                  },
                                                                  style: ElevatedButton.styleFrom(primary:Colors.blueAccent.withOpacity(.66),fixedSize: const Size(96, 37) ),
                                                                  child: Text(
                                                                    'Upload',
                                                                    style: TextStyle(color:
                                                                    Colors.white,fontWeight: FontWeight.bold),)) :
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(12.0),
                                                                  child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: ElevatedButton(
                                                                              onPressed: () async {
                                                                                showDialog(context: context, builder: (BuildContext context){
                                                                                  return AlertDialog(
                                                                                    title: Text("AlertDialog"),
                                                                                    content: Text("Are you sure to download your Photo ?"),
                                                                                    actions: [
                                                                                      ElevatedButton(
                                                                                        child: Text("Yes"),
                                                                                        onPressed:  () {
                                                                                          final blob = html.Blob([base64Decode(widget.dpImg)], 'image/img');
                                                                                          final url = html.Url.createObjectUrlFromBlob(blob);
                                                                                          final anchor = html.document.createElement('a') as html.AnchorElement
                                                                                            ..href = url
                                                                                            ..style.display = 'none'
                                                                                            ..download = '${bPartDatatem[0]['Name']}.png';
                                                                                          html.document.body?.children.add(anchor);
                                                                                          anchor.click();
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                      ElevatedButton(
                                                                                        child: Text("No"),
                                                                                        onPressed:  () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      )
                                                                                    ],
                                                                                  );
                                                                                });
                                                                              },
                                                                              style: ElevatedButton.styleFrom(primary:Colors.blueAccent.withOpacity(.66),fixedSize: const Size(96, 37) ),
                                                                              child: Center(
                                                                                  child: Text(''
                                                                                      'Download',
                                                                                    style: TextStyle(color:
                                                                                    Colors.white,fontWeight: FontWeight.bold),))),
                                                                        ),
                                                                        SizedBox(width : 6),
                                                                        Expanded(
                                                                            child:ElevatedButton(
                                                                                                onPressed:()async {
                                                                                                  await _pickDP(DPImage);
                                                                                                  showDialog(context: context, builder: (BuildContext context){
                                                                                                    return AlertDialog(
                                                                                                      title: Text("AlertDialog"),
                                                                                                      content: Text("Are you sure to change your Photo ?"),
                                                                                                      actions: [
                                                                                                        ElevatedButton(
                                                                                                          child: Text("Yes"),
                                                                                                          onPressed:  ()async {
                                                                                                            bPartnerWS bp = bPartnerWS();
                                                                                                            await bp.updateDP(DPImage[1], DPImage[0]);
                                                                                                            widget.updatecallBack(DPImage[1]);
                                                                                                            setState(() {
                                                                                                            });
                                                                                                            DPImage = [];
                                                                                                            // Validate returns true if the form is valid, or false otherwise.
                                                                                                            showSnack('Processing Data', Colors.purpleAccent);
                                                                                                            Navigator.of(context).pop();

                                                                                                          },
                                                                                                        ),
                                                                                                        ElevatedButton(
                                                                                                          child: Text("No"),
                                                                                                          onPressed:  () {
                                                                                                            DPImage = [];
                                                                                                            Navigator.of(context).pop();
                                                                                                          },
                                                                                                        )
                                                                                                      ],
                                                                                                    );
                                                                                                  });},
                                                                                                style: ElevatedButton.styleFrom(primary:Colors.redAccent.withOpacity(.45),fixedSize: const Size(96, 37) ),
                                                                                                child: Center(
                                                                                                    child: Text(''
                                                                                                        'Replace',
                                                                                                      style: TextStyle(color:
                                                                                                      Colors.white,fontWeight: FontWeight.bold),)),
                                                                                              ),),
                                                                      ]
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 21,right: 21 , top : 12),
                                                    width: w,
                                                    child: TextFormField(
                                                      validator:ValidationBuilder().minLength(1,'*Required').maxLength(50,'Long Expression').build() ,
                                                      enabled: ac,
                                                      controller:
                                                      TextEditingController(text: bPartData[0]['maritial_status'].toString()),
                                                      onChanged: (value) {
                                                        bPartData[0]['maritial_status'] = value;
                                                      },
                                                      decoration: const InputDecoration(
                                                        labelText: 'Maritial Status',
                                                      ),
                                                    ),
                                                  ),//Marraige
                                                ],
                                              ),),
                                            ],
                                          ),
                                        ],),
                                      ),],
                                    ),//General Info
                                    Divider(thickness: 2,color: Colors.white,),
                                    ExpansionTile(
                                      maintainState: true,
                                      initiallyExpanded: false,
                                      collapsedTextColor: Colors.white,
                                      title: Text(
                                        'Address Infromation',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      children: [Container(
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            locationDDTemp(context, ac),
                                            locationDDPerm(context, ac),
                                          ],
                                        ),
                                      ),],
                                    ),//Location Info
                                    Divider(thickness: 2,color: Colors.white,),
                                  ],
                                ),
                              ],),),
                        ),
                      );
                    }
                  }
                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ); //Student Info
            case 1:
              return MaterialApp(title: 'Academics',
                home: Container(
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
                          Text('Academics'.toUpperCase(),style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),),
                          const SizedBox(height: 12,),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child :  ElevatedButton(
                                        onPressed: (){
                                          setState(() {
                                            acaDelst = acaDelst == 1 ? 0 : 1 ;
                                          });
                                          showDialog(
                                            context: this.context,
                                            builder: (context) => addAcaRecordPop(context  , addAcaInfo) ,);
                                        },
                                        child: Text('Add Record +'),),)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Container(
                            padding: EdgeInsets.only(left: 21,right: 21,top: 12,bottom: 12),
                            width: double.infinity,
                            margin:  const EdgeInsets.only( bottom: 21, right: 10, left: 10 , top: 9 ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                            ),
                            child:STDInfoAca.isEmpty  ? Center(child : Padding(padding: EdgeInsets.all(9) , child : Text('No Record Found .'))) : studentInfo(context , 0  ),
                          ),//Academics
                          Divider(thickness: 2,color: Colors.white,),
                        ],
                      ),
                    ],),),
              ); //Academics
            case 2:
              return MaterialApp(title: 'Experience',
                home: Container(
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
                          Text('Experience'.toUpperCase(),style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),),
                          const SizedBox(height: 12,),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child :  ElevatedButton(
                                      onPressed: (){
                                        showDialog(
                                          context: this.context,
                                          builder: (context) => addExpRecordPop(context  , addExpInfo) ,);
                                      },
                                      child: Text('Add Record +'),
                                    ),),
                                  // Visibility(visible: STDInfoAca.isEmpty ? false : true,
                                  //   child: Visibility(
                                  //     visible: acaDelst == 0 ? true : false ,
                                  //     child: SizedBox(
                                  //       child :  ElevatedButton(
                                  //           onPressed: (){
                                  //             setState(() {
                                  //               acaDelst = acaDelst == 0 ? 1 : 0;
                                  //             });
                                  //             },
                                  //           style: ElevatedButton.styleFrom(backgroundColor: Color(
                                  //               0xABFF0000)),
                                  //           child: Text('Delete Record -'),
                                  //       ),),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Container(
                            padding: EdgeInsets.only(left: 21,right: 21,top: 12,bottom: 12),
                            width: double.infinity,
                            margin:  const EdgeInsets.only( bottom: 21, right: 10, left: 10 , top: 9 ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:STDInfoExp.isEmpty  ? Center(child : Padding(padding: EdgeInsets.all(9) , child : Text('No Record Found .'))) : studentInfo(context , 1  ),
                          ),//Academics
                          Divider(thickness: 2,color: Colors.white,),
                        ],
                      ),
                    ],),),
              ); //Experience
            case 3:
              return MaterialApp(title: 'Publications',
                home: Container(
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
                          Text('Publications'.toUpperCase(),style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),),
                          const SizedBox(height: 12,),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child :  ElevatedButton(
                                      onPressed: (){
                                        showDialog(
                                          context: this.context,
                                          builder: (context) => addExpRecordPop(context  , addExpInfo) ,);
                                      },
                                      child: Text('Add Record +'),
                                    ),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Container(
                            padding: EdgeInsets.only(left: 21,right: 21,top: 12,bottom: 12),
                            width: double.infinity,
                            margin:  const EdgeInsets.only( bottom: 21, right: 10, left: 10 , top: 9 ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:STDInfoExp.isEmpty  ? Center(child : Padding(padding: EdgeInsets.all(9) , child : Text('No Record Found .'))) : studentInfo(context , 1  ),
                          ),//Academics
                          Divider(thickness: 2,color: Colors.white,),
                        ],
                      ),
                    ],),),
              );//Publications
            case 4:
              return Material(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10, right: 12, left: 12,top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),),
                    child: Column(
                      children: [
                        Align(alignment : Alignment.topCenter,
                          child: Column(
                            children: [
                              SizedBox(child:selectedValue==0 ?
                                Column(
                                children : [
                                  const SizedBox(height: 9,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ENTRANCE DASHBOARD',
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
                                  Text('Open Entrance',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),)
                                ],
                              ),
                            ]) :
                                Column(children : [
                              const SizedBox(height: 9,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ENTRANCE DASHBOARD',
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
                                  Text('Entrace Applied ',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),)
                                ],
                              ),]),),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left:66 , right: 66),
                                child: CupertinoSegmentedControl<int>(
                                  children: Entrancechildren,
                                  onValueChanged: (value) {
                                    selectedValue = value;
                                    setState(() {});
                                  },
                                  selectedColor: Color(0xFF464667),
                                  unselectedColor: CupertinoColors.white,
                                  borderColor: CupertinoColors.inactiveGray,
                                  pressedColor: Color(0xFF5F5FA7).withOpacity(0.6),
                                  groupValue: selectedValue,
                                  padding: EdgeInsets.all(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(color: Colors.grey.withOpacity(0.1),
                          height: MediaQuery.of(context).size.height - 192,
                          width: double.infinity,
                          child:selectedValue==0 ? EntranceOpen() : EntranceApp(context),
                        )
                      ],
                    ),
                  ));// Entrance
            case 5:
              return Material(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10, right: 12, left: 12,top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              SizedBox(child:selectedValue==0 ?Column(children : [  const SizedBox(height: 9,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('NOU Registration DASHBOARD',
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
                                    Text('Open NOU Registartion',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),)
                                  ],
                                ),
                              ]) :
                              Column(children : [
                                const SizedBox(height: 9,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('NOU Registration DASHBOARD',
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
                                    Text('Applied NOU forms  ',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),)
                                  ],
                                ),]),),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left:66 , right: 66),
                                child: CupertinoSegmentedControl<int>(
                                  children: NOUregchildren,
                                  onValueChanged: (value) {
                                    selectedValue = value;
                                    setState(() {});
                                  },
                                  selectedColor: Color(0xFF464667),
                                  unselectedColor: CupertinoColors.white,
                                  borderColor: CupertinoColors.inactiveGray,
                                  pressedColor: Color(0xFF5F5FA7).withOpacity(0.6),
                                  groupValue: selectedValue,
                                  padding: EdgeInsets.all(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(color: Colors.grey.withOpacity(0.1),
                          height: MediaQuery.of(context).size.height - 192,
                          width: double.infinity,
                          child:selectedValue==0 ? NOUOpen() : NOUApp(),
                        )
                      ],
                    ),
                  ));//NOU Registration
            case 6:
              return Material(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10, right: 12, left: 12,top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),),
                    child: Column(
                      children: [
                        Align(alignment : Alignment.topCenter,
                          child: Column(
                            children: [SizedBox(child:selectedValue==0 ?Column(children : [  const SizedBox(height: 9,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ADMISSION DASHBOARD',
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
                                  Text('Open Admission',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),)
                                ],
                              ),
                            ]) :
                            Column(children : [
                              const SizedBox(height: 9,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ADMISSION DASHBOARD',
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
                                  Text('Admission Applied ',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),)
                                ],
                              ),]),),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left:66 , right: 66),
                                child: CupertinoSegmentedControl<int>(
                                  children: Asmissionchildren,
                                  onValueChanged: (value) {
                                    selectedValue = value;
                                    setState(() {});
                                  },
                                  selectedColor: Color(0xFF464667),
                                  unselectedColor: CupertinoColors.white,
                                  borderColor: CupertinoColors.inactiveGray,
                                  pressedColor: Color(0xFF5F5FA7).withOpacity(0.6),
                                  groupValue: selectedValue,
                                  padding: EdgeInsets.all(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(color: Colors.grey.withOpacity(0.1),
                          height: MediaQuery.of(context).size.height-192,
                          width: double.infinity,
                          child:selectedValue==0 ? AdmissionOpen() : AdmissionApp(),
                        )
                      ],
                    ),
                  ));//Admission
            case 7:
              return Material(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10, right: 12, left: 12,top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),),
                    child: Column(
                      children: [
                        Align(alignment : Alignment.topCenter,
                          child: Column(
                            children: [
                              SizedBox(child:selectedValue==0 ?Column(children : [  const SizedBox(height: 9,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('COURSE Info DASHBOARD',
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
                                    Text('Open Course',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),)
                                  ],
                                ),
                              ]) :
                              Column(children : [
                                const SizedBox(height: 9,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('COURSE Info DASHBOARD',
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
                                    Text('Course Applied ',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),)
                                  ],
                                ),]),),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left:66 , right: 66),
                                child: CupertinoSegmentedControl<int>(
                                  children: Coursechildren,
                                  onValueChanged: (value) {
                                    selectedValue = value;
                                    setState(() {});
                                  },
                                  selectedColor: Color(0xFF464667),
                                  unselectedColor: CupertinoColors.white,
                                  borderColor: CupertinoColors.inactiveGray,
                                  pressedColor: Color(0xFF5F5FA7).withOpacity(0.6),
                                  groupValue: selectedValue,
                                  padding: EdgeInsets.all(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(color: Colors.grey.withOpacity(0.1),
                          height: MediaQuery.of(context).size.height-192,
                          width: double.infinity,
                          child:selectedValue==0 ? CourseOpen() : CourseApp(),
                        )
                      ],
                    ),
                  ));//Course
            case 8:
              return Material(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10, right: 12, left: 12,top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),),
                    child: Column(
                      children: [
                        Align(alignment : Alignment.topCenter,
                          child: Column(
                            children: [
                              SizedBox(child:selectedValue==0 ?Column(children : [  const SizedBox(height: 9,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('EXAM Info DASHBOARD',
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
                                    Text('Open Exam',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),)
                                  ],
                                ),
                              ]) :
                              Column(children : [
                                const SizedBox(height: 9,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('EXAM Info DASHBOARD',
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
                                    Text('Exam Applied ',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),)
                                  ],
                                ),]),),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left:66 , right: 66),
                                child: CupertinoSegmentedControl<int>(
                                  children: Examchildren,
                                  onValueChanged: (value) {
                                    selectedValue = value;
                                    setState(() {});
                                  },
                                  selectedColor: Color(0xFF464667),
                                  unselectedColor: CupertinoColors.white,
                                  borderColor: CupertinoColors.inactiveGray,
                                  pressedColor: Color(0xFF5F5FA7).withOpacity(0.6),
                                  groupValue: selectedValue,
                                  padding: EdgeInsets.all(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(color: Colors.grey.withOpacity(0.1),
                          height: MediaQuery.of(context).size.height-192,
                          width: double.infinity,
                          child:selectedValue==0 ? ExamOpen() : ExamApp(),
                        )
                      ],
                    ),
                  )); // Exam
            case 9:
              return Material(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10, right: 12, left: 12,top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),),
                    child: Column(
                      children: [
                        Align(alignment : Alignment.topCenter,
                          child: Column(
                            children: [
                              SizedBox(child:selectedValue==0 ?Column(children : [  const SizedBox(height: 9,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('SCHOLARSHIP DASHBOARD',
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
                                    Text('Open Scholarship',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),)
                                  ],
                                ),
                              ]) :
                              Column(children : [
                                const SizedBox(height: 9,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('SCHOLARSHIP DASHBOARD',
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
                                    Text('Scholarship Applied ',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),)
                                  ],
                                ),]),),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left:66 , right: 66),
                                child: CupertinoSegmentedControl<int>(
                                  children: Scholarshipchildren,
                                  onValueChanged: (value) {
                                    selectedValue = value;
                                    setState(() {});
                                  },
                                  selectedColor: Color(0xFF464667),
                                  unselectedColor: CupertinoColors.white,
                                  borderColor: CupertinoColors.inactiveGray,
                                  pressedColor: Color(0xFF5F5FA7).withOpacity(0.6),
                                  groupValue: selectedValue,
                                  padding: EdgeInsets.all(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(color: Colors.grey.withOpacity(0.1),
                          height: MediaQuery.of(context).size.height-192,
                          width: double.infinity,
                          child:selectedValue==0 ? SchoarshipOpen() : SchoarshipApp(),
                        )
                      ],
                    ),
                  ));//Scholarship
            case 10:
              return Material(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.54),),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      margin: const EdgeInsets.all(15),
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
                            Text('TRANSACTIONS INFO DASHBOARD',
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
                            Text('Your Transaction History',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children : [
                            Padding(padding: EdgeInsets.all(12),
                            child : ElevatedButton(
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => addPayPop(context  ),);
                              },
                              child: Text('Make New Payment'),
                              style: ElevatedButton.styleFrom(backgroundColor: CupertinoColors.activeGreen.withOpacity(.66)),
                            )),
                          ]
                        ),
                        SizedBox(height: 32,),
                        Padding(
                          padding: const EdgeInsets.only(left: 33, right: 33),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ContCustomColor(50, 40, 'SN.', Colors.white,Color(0xFF5F5FA7),2),
                              ContCustomColor(120, 40, 'Transaction Id',  Colors.white,Color(0xFF5F5FA7),7),
                              ContCustomColor(120, 40, 'Fee Payment',  Colors.white,Color(0xFF5F5FA7),6),
                              ContCustomColor(100, 40, 'Type',  Colors.white,Color(0xFF5F5FA7),4),
                              ContCustomColor(100, 40, 'Amount',  Colors.white,Color(0xFF5F5FA7),4),
                              ContCustomColor(100, 40, 'Remarks',  Colors.white,Color(0xFF5F5FA7),7),
                              ContCustomColor(100, 40, 'Date',  Colors.white,Color(0xFF5F5FA7),4),
                              ContCustomColor(100, 40, 'Status',  Colors.black,Colors.grey.withOpacity(.33),3),
                              ContCustomColor(100, 40, 'Attachment',  Colors.white,Color(0xFF5F5FA7),4),
                             ],
                          ),
                        ),
                        SizedBox(height: 6,),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: paymentDatas.length,
                            itemBuilder:(BuildContext ctx, int index) {
                              int lenofDoc = paymentDatas[index]['C_DocType_ID']['identifier'].toString().length;
                              String feeType = paymentDatas[index]['C_DocType_ID']['identifier'].toString().substring(0,lenofDoc-3);
                              String payType = paymentDatas[index]['TenderType']['identifier'].toString();
                              String tId = paymentDatas[index]['Orig_TrxID'].toString();
                              if(tId == 'null'){tId = '---';}
                              if(payType == 'Online NPS Payment'){payType = 'Online';}
                              if(payType == 'GIBL Branch Deposit'){payType = 'Offline';}
                              if(payType == 'Attachment Upload/Other'){payType = 'Voucher';}
                              return Padding(
                                padding: const  EdgeInsets.only(left: 33, right: 33),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ContCustom(80, 40, (index+1).toString(), Colors.black,2),
                                    ContCustom(200, 40, tId, Colors.black,7),
                                    ContCustom(200, 40, feeType, Colors.black,6),
                                    ContCustom(200, 40, payType, Colors.black,4),
                                    ContCustom(200, 40, paymentDatas[index]['PayAmt'].toString(), Colors.black,4),
                                    ContCustom(200, 40, paymentDatas[index]['Description'].toString(), Colors.black,7),
                                    ContCustom(100, 40, paymentDatas[index]['DateAcct'].toString(), Colors.black,4),
                                    ContCustom(100, 40, paymentDatas[index]['DocStatus']['identifier'].toString(), Colors.black,3),
                                    applyORapplied(payType, index , 4 , 10),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                    ),
                  ));//Transactions Dashboard
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
      return 'Student Info';
    case 1:
      return 'Course Register';
    case 2:
      return 'Exam';
    case 3:
      return 'Scholarships';
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

