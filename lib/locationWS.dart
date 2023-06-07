import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class locationWS{

  String Bearer = GetStorage().read('FinalToken').toString();
  // int CBpartnerID = GetStorage().read('bPartnerID') as int;
  // String CBpartnerName = GetStorage().read('bPartnerName');
  // int enrollId = GetStorage().read('enrollId');

  Future<List?> getProvince() async {
    Map<dynamic,dynamic> DataColl = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_province');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      DataColl = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataColl['records'];
      return DataCollAppScholarshipInfo;
    }
    else{
      return null;
    }
  }

  Future<List?> getDistrict(int ProvinceID) async {
    Map<dynamic,dynamic> DataColl = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_district?\$filter=n_province_ID eq $ProvinceID');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      DataColl = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataColl['records'];
      return DataCollAppScholarshipInfo;
    }
    else{
      return null;
    }
  }

  Future<List?> getLocalGov(int districtID) async {
    Map<dynamic,dynamic> DataColl = {};
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_locgov?\$filter=n_district_ID eq $districtID');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      DataColl = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataColl['records'];
      return DataCollAppScholarshipInfo;
    }
    else{
      return null;
    }
  }

}