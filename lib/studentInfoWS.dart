import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class studentInfoWS {
  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String CBpartnerName = GetStorage().read('bPartnerName');

  Future<void> deleteInfo(var data)async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/${data['model-name']}/${data['id']}');
    var response = await http.delete(url,
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
    );
    print(response.body);
  }

  Future<List<dynamic>?> getAcaInfo() async {
    Map<dynamic, dynamic> DataCollAppScholarshipInfoAddMap = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_bpaca_info?\$filter=C_BPartner_ID eq $CBpartnerID');
    var response = await http.get(url,
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if (response.statusCode == 200) {
      DataCollAppScholarshipInfoAddMap = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataCollAppScholarshipInfoAddMap['records'];
      return DataCollAppScholarshipInfo;
    }
    else {return null;}
  }

  Future<void> UploadAcaInfo(int eduLevel , List<String> eduInfo , int mksel) async {
    Map<dynamic, dynamic> DataCollAppScholarshipInfoAddMap = {};
    var markingInfo = [{"propertyLabel": "Grading Type",
      "id": "P",
      "identifier": "Percentage",
      "model-name": "ad_ref_list"},
      {"propertyLabel": "Grading Type",
        "id": "P",
        "identifier": "Percentage",
        "model-name": "ad_ref_list"}];
    var levelsInfo = [{
      "propertyLabel": "Search Key",
      "id": "1slc",
      "identifier": "SLC",
      "model-name": "ad_ref_list"
    },{
      "propertyLabel": "Search Key",
      "id": "2plus_two",
      "identifier": "Plus Two/Intermediate",
      "model-name": "ad_ref_list"
    },{
      "propertyLabel": "Search Key",
      "id": "3bachelor",
      "identifier": "Bachelor",
      "model-name": "ad_ref_list"
    },{
      "propertyLabel": "Search Key",
      "id": "4master",
      "identifier": "Master",
      "model-name": "ad_ref_list"
    },{
      "propertyLabel": "Search Key",
      "id": "5mphil",
      "identifier": "MPhil",
      "model-name": "ad_ref_list"
    },{
      "propertyLabel": "Search Key",
      "id": "6phd",
      "identifier": "Ph.D.",
      "model-name": "ad_ref_list"
    },];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_bpaca_info');
    final msg = jsonEncode({
      "C_BPartner_ID": {
        "propertyLabel": "Student/Staff/BP",
        "id": CBpartnerID,
        "identifier": CBpartnerName,
        "model-name": "c_bpartner"
      },
      "Value":levelsInfo[eduLevel],
      "Name": eduInfo[1],
      "Description": eduInfo[7],
      "uni_board": eduInfo[2],
      "grading_type": markingInfo[mksel],
      "institute": eduInfo[3],
      "obtained_marks": eduInfo[6],
      "full_marks": eduInfo[5],
      "passed_year": eduInfo[4],
      "model-name": "n_bpaca_info"
    });
    print(msg);
    var response = await http.post(url,
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },
      body: msg
    );
    if (response.statusCode == 200 || response.statusCode == 500) {
      print(response.body);
    }

  }

  Future<void> UploadExpInfo( List<String> expInfo , int typsel) async {
    Map<dynamic, dynamic> DataCollAppScholarshipInfoAddMap = {};
    var typSelInfo = [ {
      "propertyLabel": "Employment Type",
      "id": "temporary",
      "identifier": "Temporary",
      "model-name": "ad_ref_list"
    },
      {
        "propertyLabel": "Employment Type",
        "id": "permanent",
        "identifier": "Permanent",
        "model-name": "ad_ref_list"
      }];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_bpexp_info');
    final msg = jsonEncode({
      "C_BPartner_ID": {
        "propertyLabel": "Student/Staff/BP",
        "id": CBpartnerID,
        "identifier": CBpartnerName,
        "model-name": "c_bpartner"
      },
      "Name": expInfo[1],
      "employment_type": typSelInfo[typsel],
      "OrgName": expInfo[0],
      "DateFrom": expInfo[3],
      "DateTo": expInfo[4],
      "Supervisor_Name": expInfo[5],
      "Supervisor_Mobile": expInfo[6],
      "Supervisor_Email": expInfo[7],
      "Description": expInfo[8],
      "model-name": "n_bpexp_info"
    });
    print(msg);
    var response = await http.post(url,
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
        body: msg
    );
    if (response.statusCode == 200 || response.statusCode == 500) {
      print(response.body);
    }

  }

  Future<List<dynamic>?> getExpInfo() async {
    Map<dynamic, dynamic> DataCollAppScholarshipInfoAddMap = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_bpexp_info?\$filter=C_BPartner_ID eq $CBpartnerID');
    var response = await http.get(url,
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if (response.statusCode == 200) {
      DataCollAppScholarshipInfoAddMap = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataCollAppScholarshipInfoAddMap['records'];
      return DataCollAppScholarshipInfo;
    }
    else {return null;}
  }

  Future<List<dynamic>?> getPubInfo() async {
    Map<dynamic, dynamic> DataCollAppScholarshipInfoAddMap = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_bppublication_info?\$filter=C_BPartner_ID eq $CBpartnerID');
    var response = await http.get(url,
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if (response.statusCode == 200) {
      DataCollAppScholarshipInfoAddMap = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataCollAppScholarshipInfoAddMap['records'];
      return DataCollAppScholarshipInfo;
    }
    else {return null;}
  }
  }