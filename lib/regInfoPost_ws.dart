import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;
import 'constants.dart';

class regInfopost {
  static void RegPost(String name , String fatherName , String dobAd , String phone, String email) async{
    String Bearer = await GetStorage().read('FinalToken').toString();
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/c_bpartner');
    print('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/models/c_bpartner');
    print('CBaprt');
    print(Bearer);

    final msg = jsonEncode({
      "name": name,
      "father_name": fatherName,
      "dob_ad": dobAd,
      "phone": phone,
      "eMail": email
    });

    print(jsonEncode({
      "name": name,
      "father_name": fatherName,
      "dob_ad": dobAd,
      "phone": phone,
      "eMail": email
    }));
    var response  = await http.post(
      url,
      headers: <String, String>{
        'Access-Control_Allow_Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },
      body: msg,
    );
    print(response.statusCode);
    if(response.statusCode == 201) {
      print('Suuceess 1 post');
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/c_bpartner?filter=name=\'$name\'');
      var responseF = await http.get(url,
        headers: <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },);
      print(responseF.statusCode);
      if (responseF.statusCode == 200) {
        print('Sucess 2 get');
        var json = jsonDecode(responseF.body);
        int cbp_id = json[0]['id'] as int;
        int ad_id = await GetStorage().read('ad_user_id') as int;
        print(ad_id);
        print('ad id $ad_id');
        print('cbp_id $cbp_id');
        var urlT = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/ad_user/$ad_id');
        Map<String, dynamic> c_bpart = {
          "C_BPartner_ID": {
            "propertyLabel": "Business Partner",
            "id": cbp_id,
            "identifier": "NOUTADMIN",
            "model-name": "c_bpartner"
          },
        };
        final msg = jsonEncode(c_bpart);
        print(msg);

        var responseS = await http.put(
          urlT,
          headers: <String, String>{
            'Access-Control-Allow_Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },
          body: msg,
        );
        print(responseS.statusCode);
        print(responseS.body);
        if (responseS.statusCode == 200) {
          print('Success 3 put');
        }
        else {
          print('fail 3');
        }
    }
      else{
        print('fail 2');
      }
    }
    else{
  print('fail 1');
  }
    }
  }