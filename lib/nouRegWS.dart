import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class nouRegWS {

  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String Bearer = GetStorage().read('FinalToken').toString();

  Future<List> getNouReg()async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/n_noureg?\$filter=C_BPartner_ID eq $CBpartnerID');
    var response  = await http.get(url,
        headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Accept':'application/json',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
    );
    if(response.statusCode == 200){
      Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
      List<dynamic>Data = DataColl['records'];
      return Data;
    }
    else{
      throw('Error in NOU Registartion :');
    }
  }
  static Future<void> nouRegis(Map<dynamic,dynamic> data) async {
    String Bearer = GetStorage().read('FinalToken').toString();
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/n_noureg');
    final msg = jsonEncode({
      "C_BPartner_ID": data['C_BPartner_ID'],
      "feepaid": "3000",
      "IsApproved": false,
      "Processed": false,
      "DocStatus": {
        "propertyLabel": "Document Status",
        "id": "DR",
        "identifier": "Drafted",
        "model-name": "ad_ref_list"
      },
      "n_faculty_ID": data['n_faculty_ID'],
      "n_level_ID": data['n_level_ID'],
      "n_program_ID": data['n_program_ID'],
      "n_subject_ID": data['n_subject_ID'],
      "n_aca_year_ID": data['n_aca_year_ID'],
      "n_intake_ID": data['n_intake_ID'],
      "model-name": "n_noureg"
    });
    print(msg);
    var response  = await http.post(url,
        headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Accept':'application/json',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
        body: msg
    );
    print(response.body);

  }

}