import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import 'constants.dart';

class CourseRegInfo{

  CourseRegInfo()  {
    Eid = updateEnrollId();
  }
  late Future<int> Eid ;
  List<dynamic> DataColl =[];
  List<dynamic> DataCollApp =[];
  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String CBpartnerName = GetStorage().read('bPartnerName');

  Future<int> updateEnrollId() async {
    print(CBpartnerID);
    List<dynamic> DataCollEnroll = [];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_program_enroll?\$filter=C_BPartner_ID eq $CBpartnerID');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);

    if(response.statusCode == 200);{
      print('Success data retrieval for updating enrollId ');
      Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
      DataCollEnroll = DataColl['records'];
      GetStorage().write('enrollId',DataCollEnroll[0]['id']);
      return DataCollEnroll[0]['id'];
    }
  }
  Future<List<dynamic>> getCourseRegList()async{
    int enrollId = GetStorage().read('enrollId');
    if (kDebugMode) {
      print(enrollId);
    }
    List<dynamic> DataCollAppCourseInfo = [];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_program_enroll/$enrollId');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);

    if(response.statusCode == 200){
      print('Success data retrieval of registered course through program enrollment');
      // Map<dynamic,dynamic> Data = jsonDecode(response.body) ;
      var json = "["+response.body+"]";
      DataCollAppCourseInfo = jsonDecode(json);
      return DataCollAppCourseInfo;
    }
    else{
      print(response.body);
      throw('Server error - program enroll');
    }
  }
  Future<List<dynamic>> getAppCourseRegList()async{
    Map<dynamic,dynamic> DataCollAppCourseInfoMap = {};
    int enrollId = GetStorage().read('enrollId');
    if (kDebugMode) {
      print(enrollId);
    }
    List<dynamic> DataCollAppCourseInfo = [];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_program_creg?\$filter=n_program_enroll_ID eq $enrollId and n_sem_year_ID ge 1000001');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);

    if(response.statusCode == 200){
      print('Success data retrieval of registered course through program enrollment');
      // Map<dynamic,dynamic> Data = jsonDecode(response.body) ;
      DataCollAppCourseInfoMap = jsonDecode(response.body);
      DataCollAppCourseInfo.add(DataCollAppCourseInfoMap['records']);
      return DataCollAppCourseInfo[0];
    }
    else{
      throw('Server error course registration');
    }
  }
  Future<List<dynamic>> getAdmissionRegList()async{
    Map<dynamic,dynamic> DataCollAppCourseInfoMap = {};
    int enrollId = GetStorage().read('enrollId');
    if (kDebugMode) {
      print(enrollId);
    }
    List<dynamic> DataCollAppCourseInfo = [];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_program_creg?\$filter=n_program_enroll_ID eq $enrollId and n_sem_year_ID eq 1000000');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);

    if(response.statusCode == 200){
      print('Success data retrieval of registered course through program enrollment 1st sem Admission');
      DataCollAppCourseInfoMap = jsonDecode(response.body);
      DataCollAppCourseInfo.add(DataCollAppCourseInfoMap['records']);
      return DataCollAppCourseInfo[0];
    }
    else{
      throw('Server error Admission registration');
    }
  }
  Future<List<int>> getCreditHour(List<dynamic> Data) async {
    Map<dynamic,dynamic> DataCollAppCourseInfoMap = {};
    List<int> CreditHours = [];
    for(int  i = 0 ; i < Data.length ; i ++) {
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/n_course/${Data[i]['n_course_ID']['id']}');
      var response = await http.get(url,
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },);

      if (response.statusCode == 200);
      {
        final jsonst = "[" + response.body + "]";
        List<dynamic> DataCollAppScholarshipInfo = jsonDecode(jsonst);
        CreditHours.add(DataCollAppScholarshipInfo[0]['CREDIT_HOUR']);
      }
    }
    return CreditHours;
    }
  Future<List<dynamic>> getCourseInfoList(List<dynamic> dataEntInfoApp)async{
    Map<dynamic,dynamic> DataCollAppCourseInfoMap = {};
    List<dynamic> DataCollAppCourseInfo = [];
        for(int  i = 0 ; i < dataEntInfoApp.length ; i ++){
          var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
              .baseUrl}/api/v1/models/n_course?\$filter=n_sem_year_ID eq ${dataEntInfoApp[i]['n_sem_year_ID']['id']} and '
              'n_level_ID eq ${dataEntInfoApp[i]['n_level_ID']['id']} and n_faculty_ID eq ${dataEntInfoApp[i]['n_faculty_ID']['id']}'
              ' and n_program_ID eq ${dataEntInfoApp[i]['n_program_ID']['id']} and n_subject_ID eq ${dataEntInfoApp[i]['n_subject_ID']['id']}');
          var response  = await http.get(url,
            headers:  <String, String>{
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json',
              'Authorization': Bearer,
            },);

          if(response.statusCode == 200);{
            // if (kDebugMode) {
            //   print('Success data retrieval registered course info through n course ');
            // }
            // print(url);
            DataCollAppCourseInfoMap = jsonDecode(response.body);
            DataCollAppCourseInfo.add(DataCollAppCourseInfoMap['records']);
            // if (kDebugMode) {
            //   print(DataCollAppCourseInfo);
            }

        }
        // print(DataCollAppCourseInfo);
    return DataCollAppCourseInfo;
    }
  Future<List<dynamic>> getOpenAdmission(List<dynamic> dataEntInfoApp)async{
    Map<dynamic,dynamic> DataCollAppCourseInfoAddMap = {};
    // print('filter='
    //     'n_level_ID eq ${dataEntInfoApp[0]['n_level_ID']['id']} and n_faculty_ID eq ${dataEntInfoApp[0]['n_faculty_ID']['id']}'
    //     ' and n_program_ID eq ${dataEntInfoApp[0]['n_program_ID']['id']} and n_subject_ID eq ${dataEntInfoApp[0]['n_subject_ID']['id']}'
    //     ' and n_intake_ID eq ${dataEntInfoApp[0]['n_intake_ID']['id']} and n_aca_year_ID eq ${dataEntInfoApp[0]['n_aca_year_ID']['id']}');
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_program_cregopen?\$filter='
        'n_level_ID eq ${dataEntInfoApp[0]['n_level_ID']['id']} and n_faculty_ID eq ${dataEntInfoApp[0]['n_faculty_ID']['id']}'
        ' and n_program_ID eq ${dataEntInfoApp[0]['n_program_ID']['id']} and n_subject_ID eq ${dataEntInfoApp[0]['n_subject_ID']['id']}'
        ' and n_intake_ID eq ${dataEntInfoApp[0]['n_intake_ID']['id']} and n_aca_year_ID eq ${dataEntInfoApp[0]['n_aca_year_ID']['id']} '
        'and n_sem_year_ID eq 1000000');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200);{

      DataCollAppCourseInfoAddMap = jsonDecode(response.body);
      List<dynamic> DataCollAppCourseInfoAdd = DataCollAppCourseInfoAddMap['records'];
      return DataCollAppCourseInfoAdd;
    }
  }
  Future<List<dynamic>> getOpenCreg(List<dynamic> dataEntInfoApp)async{
    Map<dynamic,dynamic> DataCollAppCourseInfoAddMap = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_program_cregopen?\$filter='
        'n_level_ID eq ${dataEntInfoApp[0]['n_level_ID']['id']} and n_faculty_ID eq ${dataEntInfoApp[0]['n_faculty_ID']['id']}'
        ' and n_program_ID eq ${dataEntInfoApp[0]['n_program_ID']['id']} and n_subject_ID eq ${dataEntInfoApp[0]['n_subject_ID']['id']}'
        ' and n_intake_ID eq ${dataEntInfoApp[0]['n_intake_ID']['id']} and n_aca_year_ID eq ${dataEntInfoApp[0]['n_aca_year_ID']['id']} '
        'and DateFrom le \'2022-12-26\' and DateTo ge \'2022-12-26\' and n_sem_year_ID ge 1000001');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200);{

      DataCollAppCourseInfoAddMap = jsonDecode(response.body);
      List<dynamic> DataCollAppCourseInfoAdd = DataCollAppCourseInfoAddMap['records'];
      return DataCollAppCourseInfoAdd;
    }
  }
  Future<void> postCourseEnrollandReg( List<dynamic> Data)async{
    int entId = GetStorage().read('n_entrance_reg_id');
    int ad_id  = GetStorage().read('ad_user_id');
    String ad_name = GetStorage().read('ad_user_name');
    int index = 0;
    Map<dynamic,dynamic> DataCollAppCourseInfoAddMap = {};
    // print(Data);
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_program_enroll');

    final msg = jsonEncode({
      "AD_User_ID": {
        "propertyLabel": "User/Contact",
        "id": ad_id,
        "identifier": ad_name,
        "model-name": "ad_user"
      },
      "C_BPartner_ID": {
        "propertyLabel": "Business Partner",
        "id": CBpartnerID,
        "identifier": CBpartnerName,
        "model-name": "c_bpartner"
      },
      "docStatus": {
        "propertyLabel": "Document Status",
        "id": "DR",
        "identifier": "Drafted",
        "model-name": "ad_ref_list"
      },
      "C_DocType_ID": {
        "propertyLabel": "Document Type",
        "id": 1000047,
        "identifier": "NOU Registration",
        "model-name": "c_doctype"
      },
      "C_DocTypeTarget_ID": {
        "propertyLabel": "Target Document Type",
        "id": 1000047,
        "identifier": "NOU Registration",
        "model-name": "c_doctype"
      },
      "n_aca_year_ID":
      Data[index]['n_aca_year_ID'],
      "n_intake_ID":
      Data[index]['n_intake_ID'],
      "n_faculty_ID":
      Data[index]['n_faculty_ID'],
      "n_level_ID":
      Data[index]['n_level_ID'],
      "n_program_ID":
      Data[index]['n_program_ID'],
      "n_subject_ID":
      Data[index]['n_subject_ID'],
      "n_sem_year_ID" :
      Data[index]['n_sem_year_ID'],
      "n_entrance_reg_ID": {
        "propertyLabel": "Entrance Detail",
        "id": entId,
        "identifier": "$entId",
        "model-name": "n_entrance_reg"
      },
      "model-name": "n_program_enroll"
    });
    var response  = await http.post(url,
        headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Accept':'application/json',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
        body: msg
    );
    // print(response.statusCode);
    // print(msg);
    if(response.statusCode == 500){
      if (kDebugMode) {
        print('Success enrollment  ! Now regis');
      }
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/n_program_enroll?\$filter=n_entrance_reg_ID eq $entId');
      var responseF  = await http.get(url,
        headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
      );
      if(responseF.statusCode == 200){
        DataCollAppCourseInfoAddMap = jsonDecode(responseF.body);
        List<dynamic> Result = DataCollAppCourseInfoAddMap['records'];
        int enrollId = Result[0]['id'];
        print(enrollId);
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_program_creg');

        final msg = jsonEncode({
          "AD_User_ID": {
            "propertyLabel": "User/Contact",
            "id": ad_id,
            "identifier": ad_name,
            "model-name": "ad_user"
          },
          "docStatus": {
            "propertyLabel": "Document Status",
            "id": "DR",
            "identifier": "Drafted",
            "model-name": "ad_ref_list"
        },
          "C_DocType_ID": {
            "propertyLabel": "Document Type",
            "id": 1000048,
            "identifier": "Course Registration",
            "model-name": "c_doctype"
        },
          "C_DocTypeTarget_ID": {
              "propertyLabel": "Target Document Type",
              "id": 1000048,
              "identifier": "Course Registration",
              "model-name": "c_doctype"
            },
          "regtype": {
            "propertyLabel": "regtype",
            "id": "REG",
            "identifier": "Regular",
            "model-name": "ad_ref_list"
          },
          "n_aca_year_ID":
          Data[index]['n_aca_year_ID'],
          "n_intake_ID":
          Data[index]['n_intake_ID'],
          "n_faculty_ID":
          Data[index]['n_faculty_ID'],
          "n_level_ID":
          Data[index]['n_level_ID'],
          "n_program_ID":
          Data[index]['n_program_ID'],
          "n_subject_ID":
          Data[index]['n_subject_ID'],
          "n_sem_year_ID":
          Data[index]['n_sem_year_ID'],
          "n_program_enroll_ID": {
            "propertyLabel": "Student Information",
            "id": enrollId,
            "identifier": "$enrollId",
            "model-name": "n_program_enroll"
          },
          "model-name": "n_program_creg"

        });
        var responseS  = await http.post(url,
            headers:  <String, String>{
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json',
              'Authorization': Bearer,
            },
            body: msg
        );
        print(responseS.statusCode);
        print(msg);
        if(responseS.statusCode == 500){
          print('Success Course Registration');
        }
      }
    }
  }

}