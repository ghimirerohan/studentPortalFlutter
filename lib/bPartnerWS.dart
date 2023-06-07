import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class bPartnerWS {
  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String CBpartnerName = GetStorage().read('bPartnerName');
  String CBimg = GetStorage().read('bPartnerimg').toString();
  // int enrollId = GetStorage().read('enrollId');

  Future<String?> getImage() async{
    print(CBpartnerID);
    Map<dynamic, dynamic> DataCollAppScholarshipInfoAddMap = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/c_bpartner/$CBpartnerID');
    var response = await http.get(url,
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if (response.statusCode == 200) {
      final jsonst = "[" + response.body + "]";
      List<dynamic> DataCollAppScholarshipInfo = jsonDecode(jsonst);
      print('inside getimage');
      return DataCollAppScholarshipInfo[0]['Logo_ID']['data'].toString();
      // DataCollAppScholarshipInfoAddMap = jsonDecode(response.body);
      // List<dynamic> DataCollAppScholarshipInfo = DataCollAppScholarshipInfoAddMap['records'];
      // print(DataCollAppScholarshipInfo[0]['Logo_ID']['data'].toString());
      // return DataCollAppScholarshipInfo[0]['Logo_ID']['data'].toString();
    }
    else {
      return null;
    }
  }


  Future<void> updateDP(String base64 , String name) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/c_bpartner/$CBpartnerID');
    final msg= jsonEncode({
    "Logo_ID": {
      "name" : name,
      "imageurl" : name,
      "propertyLabel": "Logo",
      "data" : base64,
      "model-name": "ad_image"
    }
    });
    var response = await http.put(url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },body: msg);
  }

  Future<void> updateCBPData(List<dynamic> Data) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/c_bpartner/${Data[0]['id']}');
    final msg = jsonEncode({
      "Name": "${Data[0]['Name']}",
      "EMail": "${Data[0]['EMail']}",
      "Phone": "${Data[0]['Phone']}",
      "dob_ad": "${Data[0]['dob_ad']}",
      "dob_bs": "${Data[0]['dob_bs']}",
      "father_name": "${Data[0]['father_name']}",
      "mother_name": "${Data[0]['mother_name']}",
      "name_nepali": "${Data[0]['name_nepali']}",
      "cast_ethinicity": "${Data[0]['cast_ethinicity']}",
      "religion": "${Data[0]['religion']}",
      "nationality": "${Data[0]['nationality']}",
      "maritial_status": "${Data[0]['maritial_status']}",
      "model-name": "${Data[0]['model-name']}",
    });
    if (kDebugMode) {
      print(msg);
    }
    var response = await http.put(url,
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },body: msg);
    if (kDebugMode) {
      print(response.body);
    }
}

    Future<List?> getBparData() async {
    if (kDebugMode) {
      print(CBpartnerID);
    }
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/c_bpartner/$CBpartnerID');
      var response = await http.get(url,
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },);
      if (response.statusCode == 200) {
        final jsonst = "[" + response.body + "]";
        List<dynamic> DataCollAppScholarshipInfo = jsonDecode(jsonst);
        return DataCollAppScholarshipInfo;
      }
      else {
        return null;
      }
    }
    Future<List?> getBpartLocationPer() async {
      Map<dynamic, dynamic> DataCollAppScholarshipInfoAddMap = {};
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/c_bpartner_location?\$filter= C_BPartner_ID eq $CBpartnerID and location_type eq \'Permanent\'');
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
      else {
        throw Exception('Failed to load resources ');
      }
    }
    Future<List?> getBpartLocationTemp() async {
      Map<dynamic, dynamic> DataCollAppScholarshipInfoAddMap = {};
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/c_bpartner_location?\$filter=C_BPartner_ID eq $CBpartnerID and location_type eq \'Temporary\'');
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
      else {
        throw Exception('Failed to load resources ');
      }
    }

  Future<void> updateBpartLocationPer(List<dynamic> Data) async {
    if(Data[0]['id'] == null){
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/c_bpartner_location');
      String Namee = Data[0]['n_locgov_ID']['identifier']+'-'+Data[0]['ward_no']+' '+Data[0]['tole_name'];
      final msg = jsonEncode({
        "C_BPartner_ID": {
          "propertyLabel": "Business Partner",
          "id": CBpartnerID,
          "identifier": CBpartnerName,
          "model-name": "c_bpartner"
        },
        "Name": Namee,
        "n_province_ID": {
          "propertyLabel": "Province",
          "id": Data[0]['n_province_ID']['id'],
          "identifier": Data[0]['n_province_ID']['identifier'],
          "model-name": "n_province"
        },
        "n_district_ID": {
          "propertyLabel": "District",
          "id": Data[0]['n_district_ID']['id'],
          "identifier": Data[0]['n_district_ID']['identifier'],
          "model-name": "n_district"
        },
        "n_locgov_ID": {
          "propertyLabel": "Local Government",
          "id": Data[0]['n_locgov_ID']['id'],
          "identifier": Data[0]['n_locgov_ID']['identifier'],
          "model-name": "n_locgov"
        },
        "ward_no": Data[0]['ward_no'],
        "tole_name": Data[0]['tole_name'],
        "location_type": {
          "propertyLabel": "Location Type",
          "id": "Permanent",
          "identifier": "Permanent",
          "model-name": "ad_ref_list"
        },
        "model-name": "c_bpartner_location"
      });
      var response = await http.post(url,
          headers: <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },body: msg);
      print('new post loc_per ${response.body}');
    }
    else{
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/c_bpartner_location/${Data[0]['id']}');
      String Namee = Data[0]['n_locgov_ID']['identifier']+'-'+Data[0]['ward_no']+' '+Data[0]['tole_name'];
      final msg = jsonEncode({
        "Name": Namee,
        "n_province_ID": {
          "propertyLabel": "Province",
          "id": Data[0]['n_province_ID']['id'],
          "identifier": Data[0]['n_province_ID']['identifier'],
          "model-name": "n_province"
        },
        "n_district_ID": {
          "propertyLabel": "District",
          "id": Data[0]['n_district_ID']['id'],
          "identifier": Data[0]['n_district_ID']['identifier'],
          "model-name": "n_district"
        },
        "n_locgov_ID": {
          "propertyLabel": "Local Government",
          "id": Data[0]['n_locgov_ID']['id'],
          "identifier": Data[0]['n_locgov_ID']['identifier'],
          "model-name": "n_locgov"
        },
        "ward_no": Data[0]['ward_no'],
        "tole_name": Data[0]['tole_name'],
        "model-name": "c_bpartner_location"
      });
      var response = await http.put(url,
          headers: <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },body: msg);
    }

  }
  Future<void> updateBpartLocationTemp(List<dynamic> Data) async {
    if(Data[0]['id'] == null){
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/c_bpartner_location');
      String Namee = Data[0]['n_locgov_ID']['identifier']+'-'+Data[0]['ward_no']+' '+Data[0]['tole_name'];
      final msg = jsonEncode({
        "C_BPartner_ID": {
          "propertyLabel": "Business Partner",
          "id": CBpartnerID,
          "identifier": CBpartnerName,
          "model-name": "c_bpartner"
        },
        "Name": Namee,
        "n_province_ID": {
          "propertyLabel": "Province",
          "id": Data[0]['n_province_ID']['id'],
          "identifier": Data[0]['n_province_ID']['identifier'],
          "model-name": "n_province"
        },
        "n_district_ID": {
          "propertyLabel": "District",
          "id": Data[0]['n_district_ID']['id'],
          "identifier": Data[0]['n_district_ID']['identifier'],
          "model-name": "n_district"
        },
        "n_locgov_ID": {
          "propertyLabel": "Local Government",
          "id": Data[0]['n_locgov_ID']['id'],
          "identifier": Data[0]['n_locgov_ID']['identifier'],
          "model-name": "n_locgov"
        },
        "ward_no": Data[0]['ward_no'],
        "tole_name": Data[0]['tole_name'],
        "location_type": {
          "propertyLabel": "Location Type",
          "id": "Temporary",
          "identifier": "Temporary",
          "model-name": "ad_ref_list"
        },
        "model-name": "c_bpartner_location"
      });
      var response = await http.post(url,
          headers: <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },body: msg);
      print('new post loc_tem ${response.body}');
    }
    else{
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/c_bpartner_location/${Data[0]['id']}');
      String Namee = Data[0]['n_locgov_ID']['identifier']+'-'+Data[0]['ward_no']+' '+Data[0]['tole_name'];
      final msg = jsonEncode({
        "Name": Namee,
        "n_province_ID": {
          "propertyLabel": "Province",
          "id": Data[0]['n_province_ID']['id'],
          "identifier": Data[0]['n_province_ID']['identifier'],
          "model-name": "n_province"
        },
        "n_district_ID": {
          "propertyLabel": "District",
          "id": Data[0]['n_district_ID']['id'],
          "identifier": Data[0]['n_district_ID']['identifier'],
          "model-name": "n_district"
        },
        "n_locgov_ID": {
          "propertyLabel": "Local Government",
          "id": Data[0]['n_locgov_ID']['id'],
          "identifier": Data[0]['n_locgov_ID']['identifier'],
          "model-name": "n_locgov"
        },
        "ward_no": Data[0]['ward_no'],
        "tole_name": Data[0]['tole_name'],
        "model-name": "c_bpartner_location"
      });
      var response = await http.put(url,
          headers: <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },body: msg);
    }

  }

  }
