import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class repProsWS{

  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;

  Future<List?> getEntranceFrom(List EntRegData) async {
    List<dynamic> Data = [];
    for(var i = 0 ; i < EntRegData.length ; i ++){
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/processes/entrance_form');
      final msg = jsonEncode({
        "C_BPartner_ID": { "id": CBpartnerID },
        "n_entrance_reg_id": EntRegData[i]['id'],
        "report-type" : "PDF"
      });
      var response  = await http.post(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'Authorization': Bearer,
          },
          body: msg);
      if(response.statusCode == 200){
        Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
        Data.add(DataColl);
      }
    }
    return Data;
  }
  Future<List?> getEntranceExamCard(List EntRegData) async {
    List<dynamic> Data = [];
    for(var i = 0 ; i < EntRegData.length ; i ++){
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/processes/entrance_examination_admission_card');
      final msg = jsonEncode({
        "C_BPartner_ID": EntRegData[i]['C_BPartner_ID']['id'],
        "n_entrance_open_ID": EntRegData[i]['n_entrance_open_ID']['id'],
        "report-type" : "PDF"
      });
      var response  = await http.post(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'Authorization': Bearer,
          },
          body: msg);
      if(response.statusCode == 200){
        Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
        Data.add(DataColl);
      }
    }
    return Data;
  }
  Future<List?> getScholarshipAppPrint(List EntRegData) async {
    List<dynamic> Data = [];
    for(var i = 0 ; i < EntRegData.length ; i ++){
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/processes/scholarship_application_print');
      final msg = jsonEncode({
        "n_scholarship_reg_ID": EntRegData[i]['id'],
        "report-type" : "PDF"
      });
      var response  = await http.post(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'Authorization': Bearer,
          },
          body: msg);
      if(response.statusCode == 200){
        Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
        Data.add(DataColl);
      }
      else{
        print(response.body);
        throw('error in scholarship form print ');
      }
    }
    return Data;
  }
}