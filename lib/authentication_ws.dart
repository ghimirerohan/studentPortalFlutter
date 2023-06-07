import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart' ;
import 'package:http/http.dart' as http ;
import 'constants.dart';
import 'first_auth_model.dart';
import 'second_auth_model.dart';
import 'ad_user_ws.dart';

class login_ws {
   static Future<void> second_token(String id , String pass , BuildContext ctx) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/auth/tokens');
    final msg = jsonEncode({
      "userName": id,
      "password": pass
    });
    var responsef;
    try {
      responsef = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*'
        },
        body: msg,
      );
    }
    catch (error){
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(duration: Duration(seconds: 3),
            content: Text('Server Error : $error',
              style: TextStyle(
                  color: Colors.redAccent),)),
      );

    }
    GetStorage().write('LoginStatus', responsef.statusCode);
    if (responsef.statusCode == 200) {
      first_auth_model jsonFinal = first_auth_model.fromJson(jsonDecode(responsef.body));
      String tokenFirst = jsonFinal.token.toString();
      String authorization = 'Bearer $tokenFirst';

      var url = Uri.parse(
          '${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/auth/tokens');
      final msg = jsonEncode({
        "clientId": "1000000",
        "roleId": "1000006",
        "organizationId": "1000000",
        "warehouseId": "0"
      });
      var response = await http.put(
        url,
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
        body: msg,
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        // ignore: unused_local_variable
        var json = second_auth_model.fromJson(jsonDecode(response.body));
        String Token = json.token.toString();
        String secondToken = 'Bearer $Token';
        GetStorage().write('FinalToken', secondToken);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to 2nd load Token');
      }
    }
    // else {
    //   throw Exception('Failed to load 1st Token');
    // }
  }
}

