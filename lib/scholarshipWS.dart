import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class scholarInfo{
  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String CBpartnerName = GetStorage().read('bPartnerName');
  int enrollId = GetStorage().read('enrollId');

  Future<List<dynamic>> getscholarListApp()async{
    Map<dynamic,dynamic> DataCollAppScholarshipInfoAddMap = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_scholarship_reg?\$filter= n_program_enroll_ID eq $enrollId');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      DataCollAppScholarshipInfoAddMap = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataCollAppScholarshipInfoAddMap['records'];
      return DataCollAppScholarshipInfo;
    }
    else{
      print(response.body);
      throw('Error in scholar reg get by enroll id');
    }
  }


  Future<List<dynamic>> getscholarList(List<dynamic> dataEntInfoApp)async{
    Map<dynamic,dynamic> DataCollAppScholarshipInfoAddMap = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_scholarship_open?\$filter= n_sem_year_ID eq ${dataEntInfoApp[0]['n_sem_year_ID']['id']} and '
        'n_level_ID eq ${dataEntInfoApp[0]['n_level_ID']['id']} and n_faculty_ID eq ${dataEntInfoApp[0]['n_faculty_ID']['id']}'
        ' and n_program_ID eq ${dataEntInfoApp[0]['n_program_ID']['id']} and n_subject_ID eq ${dataEntInfoApp[0]['n_subject_ID']['id']}'
        ' and n_intake_ID eq ${dataEntInfoApp[0]['n_intake_ID']['id']} and n_aca_year_ID eq ${dataEntInfoApp[0]['n_aca_year_ID']['id']}');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      DataCollAppScholarshipInfoAddMap = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataCollAppScholarshipInfoAddMap['records'];
      return DataCollAppScholarshipInfo;
    }
    else{
      print(response.body);
      throw('Error in Scholarship open ');
    }
  }

  Future<List?>postScholarship(List<dynamic> Data , int index , List<dynamic> sctype) async{
    Map<dynamic,dynamic> DataCollAppScholarshipInfoAddMap = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_scholarship_reg');
    final msg = jsonEncode({
      "C_BPartner_ID": {
        "propertyLabel": "Business Partner",
        "id": CBpartnerID,
        "identifier": CBpartnerName,
        "model-name": "c_bpartner"
      },
      "C_DocType_ID": {
        "propertyLabel": "Document Type",
        "id": 1000052,
        "identifier": "Admission and Semester Fee",
        "model-name": "c_doctype"
      },"C_DocTypeTarget_ID": {
        "propertyLabel": "Target Document Type",
        "id": 1000052,
        "identifier": "Admission and Semester Fee",
        "model-name": "c_doctype"
      },
      "n_scholarship_open_ID": {
        "propertyLabel": "Scholarship Open",
        "id": Data[index]['id'],
        "identifier": "${Data[index]['Name']}",
        "model-name": "n_scholarship_open"
      },
      "n_program_enroll_ID": {
        "propertyLabel": "Program Enrollment",
        "id": enrollId,
        "identifier": enrollId.toString(),
        "model-name": "n_program_enroll"
      },
      "n_sem_year_ID": Data[index]['n_sem_year_ID'],
      "Status": {
        "propertyLabel": "Status",
        "id": "PG",
        "identifier": "Pending",
        "model-name": "ad_ref_list"
      },
      "eligible": false,
      "scholarship_hardworking": sctype[0],
      "scholarship_female": sctype[1],
      "scholarship_poverty": sctype[2],
      "scholarship_other": sctype[3],
      "IsActive": true,
      "model-name": "n_scholarship_reg"
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
    if(response.statusCode == 500) {
      if (kDebugMode) {
        print('Success register of scholarship !');
      }
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/n_scholarship_reg?\$filter=C_BPartner_ID eq $CBpartnerID and n_scholarship_open_ID eq ${Data[index]['id']}');
      var response  = await http.get(url,
        headers:  <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },);
      DataCollAppScholarshipInfoAddMap = jsonDecode(response.body);
      List<dynamic> Result = DataCollAppScholarshipInfoAddMap['records'];
      return Result;
    }
      else {
        return null;
      }
  }


//   n_sem_year_id eq ${dataEntInfoApp[0]['n_sem_year_id']['id']} and '
// 'n_level_ID eq ${dataEntInfoApp[0]['n_level_ID']['id']} and n_faculty_ID eq ${dataEntInfoApp[0]['n_faculty_ID']['id']}'
// ' and n_program_ID eq ${dataEntInfoApp[0]['n_program_ID']['id']} and n_subject_ID eq ${dataEntInfoApp[0]['n_subject_ID']['id']}'
// ' and n_intake_ID eq ${dataEntInfoApp[0]['n_intake_ID']['id']} and n_aca_year_ID eq ${dataEntInfoApp[0]['n_aca_year_ID']['id']}

}