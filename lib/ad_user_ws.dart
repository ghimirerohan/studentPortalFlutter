import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';



class ad_user_ws {

  static Future<void> check_reg() async {
    String authorization =  GetStorage().read('FinalToken').toString();
    String name = GetStorage().read('id').toString();
      var url = Uri.parse(
          '${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/ad_user?\$filter=EMail eq \'$name\'');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('ad_user _id from model : ');
        }
        GetStorage().write('ad_user_id', json['records'][0]['id'] as int);
        GetStorage().write('ad_user_name', json['records'][0]['Name'].toString());
        if(json['records'][0]['C_BPartner_ID'] != null) {
          var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
              .baseUrl}/api/v1/models/c_bpartner/${json['records'][0]['C_BPartner_ID']['id']}');
          var response = await http.get
            (url,
            headers: <String, String>{
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json',
              'Authorization': authorization,
            },);
          if (response.statusCode == 200) {

            final jsonst = "[" + response.body + "]";
            var json = jsonDecode(jsonst);
            if (json[0]['Logo_ID'] != null) {
              GetStorage().write(
                  'bPartnerimg', json[0]['Logo_ID']['data'].toString());
            }else{GetStorage().write(
                'bPartnerimg', 'null');}
            GetStorage().write('reg_st', 1);
            GetStorage().write('bPartnerID', json[0]['id'] as int);
            GetStorage().write('bPartnerName', json[0]['Name'].toString());
            GetStorage().write(
                'bPartnerNepName', json[0]['name_nepali'].toString());
            GetStorage().write('bPartnerEmail', json[0]['EMail'].toString());
            GetStorage().write('bPartnerPhone', json[0]['Phone'].toString());
            GetStorage().write(
                'bPartnerfname', json[0]['father_name'].toString());
            GetStorage().write(
                'bPartnermname', json[0]['mother_name'].toString());
            GetStorage().write(
                'bPartnergfname', json[0]['grand_father_name'].toString());
            GetStorage().write(
                'bPartnergmname', json[0]['grand_mother_name'].toString());
            GetStorage().write(
                'bPartnercast', json[0]['cast_ethinicity'].toString());
            GetStorage().write(
                'bPartnerreligion', json[0]['religion'].toString());
            GetStorage().write(
                'bPartnernationality', json[0]['nationality'].toString());
            GetStorage().write(
                'bPartnermarry', json[0]['maritial_status'].toString());
            GetStorage().write('bPartnerdob', json[0]['dob_ad'].toString());
            GetStorage().write('bPartnerdobbs', json[0]['dob_bs'].toString());

            if (kDebugMode) {
              print(GetStorage().read('reg_st'));
            }
          }
          else {
            throw Exception('Failed to load resources for CBpartner with Response : ${response.body}');
          }
        }
        else{
        GetStorage().write('reg_st', 0);}
      }
      else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load resources for AD users :');
      }
  }
}
