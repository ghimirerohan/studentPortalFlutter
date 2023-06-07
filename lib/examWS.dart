import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class ExamRegInfo{

  List<dynamic> DataColl =[];
  List<dynamic> DataCollApp =[];
  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String CBpartnerName = GetStorage().read('bPartnerName');
  int enrollId = GetStorage().read('enrollId');

  Future<List<dynamic>> getExamRegList()async{
    List<dynamic> DataCollAppCourseInfo = [];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_program_creg?\$filter=C_BPartner_ID eq $CBpartnerID');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control_Allow_Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);

    if(response.statusCode == 200);{
      print('Success data retrieval course info after pass ');
      DataCollAppCourseInfo = jsonDecode(response.body);
      return DataCollAppCourseInfo;
    }
  }


  Future<List<dynamic>> getExamInfoList(List<dynamic> dataEntInfoApp)async{
    Map<dynamic,dynamic> DataCollAppCourseInfoMap = {};
    List<dynamic> DataCollAppCourseInfo = [];
    for(int  i = 0 ; i <= dataEntInfoApp.length-1 ; i ++){
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/n_exam_open?\$filter=n_sem_year_ID eq ${dataEntInfoApp[i]['n_sem_year_ID']['id']} and '
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

  Future<List<dynamic>> getExamAppDet(List<dynamic> Data)async{
    Map<dynamic,dynamic> DataCollAppCourseInfoMap = {};
    List<dynamic> DataCollAppCourseInfo = [];
    for(var i = 0 ; i < Data.length ; i++){
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/n_exam_regdetails?\$filter=n_exam_reg_ID eq ${Data[i]['id']}');
      var response  = await http.get(url,
        headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },);
      if(response.statusCode == 200);{
        DataCollAppCourseInfoMap = jsonDecode(response.body);
        DataCollAppCourseInfo.add(DataCollAppCourseInfoMap['records']);
      }
    }
   return DataCollAppCourseInfo;
  }

  Future<List<dynamic>> getExamApp()async{
    Map<dynamic,dynamic> DataCollAppCourseInfoMap = {};
    List<dynamic> DataCollAppCourseInfo = [];
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/n_exam_reg?\$filter=n_program_enroll_ID eq $enrollId');
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
    // print(DataCollAppCourseInfo);
    return DataCollAppCourseInfo[0];
  }

  void postExam()async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_exam_reg');
    final msg  = jsonEncode({
      "DocStatus": {
        "propertyLabel": "Document Status",
        "id": "DR",
        "identifier": "Drafted",
        "model-name": "ad_ref_list"
      },
      "Processed": false,
      "C_DocType_ID": {
        "propertyLabel": "Document Type",
        "id": 1000049,
        "identifier": "Exam Registration",
        "model-name": "c_doctype"
      },
      "C_DocTypeTarget_ID": {
        "propertyLabel": "Target Document Type",
        "id": 1000049,
        "identifier": "Exam Registration",
        "model-name": "c_doctype"
      },
      "IsApproved": false,
      "n_program_enroll_ID": {
        "propertyLabel": "Program Enrollment",
        "id": 1000220,
        "identifier": "75111001",
        "model-name": "n_program_enroll"
      },
      "n_exam_master_ID": {
        "propertyLabel": "Exam Master",
        "id": 1000000,
        "identifier": "2074 Winter",
        "model-name": "n_exam_master"
      },
      "urollno": "75111001",
      "n_exam_center_ID": {
        "propertyLabel": "Exam Center",
        "id": 1000001,
        "identifier": "Lalitpur",
        "model-name": "n_exam_center"
      },
      "erollno": "7511111009",
      "erollsn": "9",
      "IsActive": true,
      "Created": "2022-09-22T08:27:57Z",
      "CreatedBy": {
        "propertyLabel": "Created By",
        "id": 1000000,
        "identifier": "sistechnicaladmin",
        "model-name": "ad_user"
      },
      "Updated": "2023-01-11T17:04:15Z",
      "UpdatedBy": {
        "propertyLabel": "Updated By",
        "id": 1000000,
        "identifier": "sistechnicaladmin",
        "model-name": "ad_user"
      },
      "showresult": false,
      "n_exam_open_ID": {
        "propertyLabel": "Exam Open",
        "id": 1000000,
        "identifier": "2074 Winter MPLIM 1 SEM-Regular/2074 Winter",
        "model-name": "n_exam_open"
      },
      "totalfee": 1000,
      "feepaid": 0,
      "model-name": "n_exam_reg"
    });
    var response  = await http.post(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },
    body: msg);
  }
}





